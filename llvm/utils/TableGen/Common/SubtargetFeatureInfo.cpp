//===- SubtargetFeatureInfo.cpp - Helpers for subtarget features ----------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "SubtargetFeatureInfo.h"
#include "Types.h"
#include "llvm/Config/llvm-config.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"

#define DEBUG_TYPE "subtarget-feature-info"

using namespace llvm;

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
LLVM_DUMP_METHOD void SubtargetFeatureInfo::dump() const {
  errs() << getEnumName() << " " << Index << "\n" << *TheDef;
}
#endif

SubtargetFeaturesInfoVec
SubtargetFeatureInfo::getAll(const RecordKeeper &Records) {
  SubtargetFeaturesInfoVec SubtargetFeatures;
  for (const Record *Pred : Records.getAllDerivedDefinitions("Predicate")) {
    // Ignore predicates that are not intended for the assembler.
    //
    // The "AssemblerMatcherPredicate" string should be promoted to an argument
    // if we re-use the machinery for non-assembler purposes in future.
    if (!Pred->getValueAsBit("AssemblerMatcherPredicate"))
      continue;

    if (Pred->getName().empty())
      PrintFatalError(Pred->getLoc(), "Predicate has no name!");

    // Ignore always true predicates.
    if (Pred->getValueAsString("CondString").empty())
      continue;

    SubtargetFeatures.emplace_back(
        Pred, SubtargetFeatureInfo(Pred, SubtargetFeatures.size()));
  }
  return SubtargetFeatures;
}

void SubtargetFeatureInfo::emitSubtargetFeatureBitEnumeration(
    const SubtargetFeatureInfoMap &SubtargetFeatures, raw_ostream &OS,
    const std::map<std::string, unsigned> *HwModes) {
  OS << "// Bits for subtarget features that participate in "
     << "instruction matching.\n";
  unsigned Size = SubtargetFeatures.size();
  if (HwModes)
    Size += HwModes->size();

  OS << "enum SubtargetFeatureBits : " << getMinimalTypeForRange(Size)
     << " {\n";
  for (const auto &SF : SubtargetFeatures) {
    const SubtargetFeatureInfo &SFI = SF.second;
    OS << "  " << SFI.getEnumBitName() << " = " << SFI.Index << ",\n";
  }

  if (HwModes) {
    unsigned Offset = SubtargetFeatures.size();
    for (const auto &M : *HwModes) {
      OS << "  Feature_HwMode" << M.second << "Bit = " << (M.second + Offset)
         << ",\n";
    }
  }

  OS << "};\n\n";
}

void SubtargetFeatureInfo::emitNameTable(
    SubtargetFeatureInfoMap &SubtargetFeatures, raw_ostream &OS) {
  // Need to sort the name table so that lookup by the log of the enum value
  // gives the proper name. More specifically, for a feature of value 1<<n,
  // SubtargetFeatureNames[n] should be the name of the feature.
  uint64_t IndexUB = 0;
  for (const auto &SF : SubtargetFeatures)
    if (IndexUB <= SF.second.Index)
      IndexUB = SF.second.Index + 1;

  std::vector<std::string> Names;
  if (IndexUB > 0)
    Names.resize(IndexUB);
  for (const auto &SF : SubtargetFeatures)
    Names[SF.second.Index] = SF.second.getEnumName();

  OS << "static const char *SubtargetFeatureNames[] = {\n";
  for (uint64_t I = 0; I < IndexUB; ++I)
    OS << "  \"" << Names[I] << "\",\n";

  // A small number of targets have no predicates. Null terminate the array to
  // avoid a zero-length array.
  OS << "  nullptr\n"
     << "};\n\n";
}

void SubtargetFeatureInfo::emitComputeAvailableFeatures(
    StringRef TargetName, StringRef ClassName, StringRef FuncName,
    const SubtargetFeatureInfoMap &SubtargetFeatures, raw_ostream &OS,
    StringRef ExtraParams, const std::map<std::string, unsigned> *HwModes) {
  OS << "PredicateBitset " << ClassName << "::\n"
     << FuncName << "(const " << TargetName << "Subtarget *Subtarget";
  if (!ExtraParams.empty())
    OS << ", " << ExtraParams;
  OS << ") const {\n";
  OS << "  PredicateBitset Features{};\n";
  for (const auto &SF : SubtargetFeatures) {
    const SubtargetFeatureInfo &SFI = SF.second;
    StringRef CondStr = SFI.TheDef->getValueAsString("CondString");
    assert(!CondStr.empty() && "true predicate should have been filtered");

    OS << "  if (" << CondStr << ")\n";
    OS << "    Features.set(" << SFI.getEnumBitName() << ");\n";
  }

  if (HwModes) {
    for (const auto &M : *HwModes) {
      OS << "  if (" << M.first << ")\n";
      OS << "    Features.set(Feature_HwMode" << M.second << "Bit);\n";
    }
  }

  OS << "  return Features;\n";
  OS << "}\n\n";
}

// If ParenIfBinOp is true, print a surrounding () if Val uses && or ||.
static bool emitFeaturesAux(StringRef TargetName, const Init &Val,
                            bool ParenIfBinOp, raw_ostream &OS) {
  if (auto *D = dyn_cast<DefInit>(&Val)) {
    if (!D->getDef()->isSubClassOf("SubtargetFeature"))
      return true;
    OS << "FB[" << TargetName << "::" << D->getAsString() << "]";
    return false;
  }
  if (auto *D = dyn_cast<DagInit>(&Val)) {
    auto *Op = dyn_cast<DefInit>(D->getOperator());
    if (!Op)
      return true;
    StringRef OpName = Op->getDef()->getName();
    if (OpName == "not" && D->getNumArgs() == 1) {
      OS << '!';
      return emitFeaturesAux(TargetName, *D->getArg(0), true, OS);
    }
    if ((OpName == "any_of" || OpName == "all_of") && D->getNumArgs() > 0) {
      bool Paren = D->getNumArgs() > 1 && std::exchange(ParenIfBinOp, true);
      if (Paren)
        OS << '(';
      ListSeparator LS(OpName == "any_of" ? " || " : " && ");
      for (auto *Arg : D->getArgs()) {
        OS << LS;
        if (emitFeaturesAux(TargetName, *Arg, ParenIfBinOp, OS))
          return true;
      }
      if (Paren)
        OS << ')';
      return false;
    }
  }
  return true;
}

void SubtargetFeatureInfo::emitPredicateCheck(
    raw_ostream &OS, ArrayRef<const Record *> Predicates) {
  ListSeparator LS(" && ");
  for (const Record *R : Predicates) {
    StringRef CondString = R->getValueAsString("CondString");
    if (CondString.empty())
      continue;
    OS << LS << '(' << CondString << ')';
  }
}

void SubtargetFeatureInfo::emitMCPredicateCheck(
    raw_ostream &OS, StringRef TargetName,
    ArrayRef<const Record *> Predicates) {
  auto MCPredicates = make_filter_range(Predicates, [](const Record *R) {
    return R->getValueAsBit("AssemblerMatcherPredicate");
  });

  if (MCPredicates.empty()) {
    OS << "false";
    return;
  }

  ListSeparator LS(" && ");
  bool ParenIfBinOp = range_size(MCPredicates) > 1;
  for (const Record *R : MCPredicates) {
    OS << LS;
    if (emitFeaturesAux(TargetName, *R->getValueAsDag("AssemblerCondDag"),
                        ParenIfBinOp, OS))
      PrintFatalError(R, "Invalid AssemblerCondDag!");
  }
}

void SubtargetFeatureInfo::emitComputeAssemblerAvailableFeatures(
    StringRef TargetName, StringRef ClassName, StringRef FuncName,
    SubtargetFeatureInfoMap &SubtargetFeatures, raw_ostream &OS) {
  OS << "FeatureBitset ";
  if (!ClassName.empty())
    OS << TargetName << ClassName << "::\n";
  OS << FuncName << "(const FeatureBitset &FB) ";
  if (!ClassName.empty())
    OS << "const ";
  OS << "{\n";
  OS << "  FeatureBitset Features;\n";
  for (const SubtargetFeatureInfo &SFI : make_second_range(SubtargetFeatures)) {
    const Record *Def = SFI.TheDef;

    OS << "  if (";
    if (emitFeaturesAux(TargetName, *Def->getValueAsDag("AssemblerCondDag"),
                        /*ParenIfBinOp=*/false, OS))
      PrintFatalError(Def, "Invalid AssemblerCondDag!");

    OS << ")\n";
    OS << "    Features.set(" << SFI.getEnumBitName() << ");\n";
  }
  OS << "  return Features;\n";
  OS << "}\n\n";
}

struct CNFFormula {
  std::vector<std::set<SubtargetFeatureLiteral>> Clauses;

  bool empty() const { return Clauses.empty(); }

  void addAnd(const CNFFormula &Other) {
    Clauses.insert(Clauses.end(), Other.Clauses.begin(), Other.Clauses.end());
  }

  void addOr(const CNFFormula &Other) {
    if (Clauses.empty()) {
      Clauses = Other.Clauses;
      return;
    }
    if (Other.Clauses.empty())
      return;

    std::vector<std::set<SubtargetFeatureLiteral>> Result;
    for (const auto &C1 : Clauses) {
      for (const auto &C2 : Other.Clauses) {
        std::set<SubtargetFeatureLiteral> Combined = C1;
        Combined.insert(C2.begin(), C2.end());
        Result.push_back(std::move(Combined));
      }
    }
    Clauses = std::move(Result);
  }

  void negate() {
    if (Clauses.empty())
      return;

    CNFFormula Result;
    for (const auto &Clause : Clauses) {
      CNFFormula NegatedClause;
      for (const auto &Lit : Clause) {
        std::set<SubtargetFeatureLiteral> NegatedLitClause = {{Lit.Feature, !Lit.IsNot}};
        NegatedClause.Clauses.push_back(std::move(NegatedLitClause));
      }
      Result.addOr(NegatedClause);
    }
    Clauses = std::move(Result.Clauses);
  }
};

static CNFFormula parseAssemblerCondDag(const Init *I, const Record *Rec) {
  CNFFormula F;
  if (auto *DI = dyn_cast<DefInit>(I)) {
    if (!DI->getDef()->isSubClassOf("SubtargetFeature"))
      PrintFatalError(Rec->getLoc(), "Invalid AssemblerCondDag: argument is not a SubtargetFeature!");
    F.Clauses.push_back({{DI->getDef()->getName(), false}});
    return F;
  }

  if (auto *Dag = dyn_cast<DagInit>(I)) {
    auto *Op = dyn_cast<DefInit>(Dag->getOperator());
    if (!Op)
      PrintFatalError(Rec->getLoc(), "Invalid AssemblerCondDag: operator is not a def!");
    StringRef OpName = Op->getDef()->getName();

    if (OpName == "not" && Dag->getNumArgs() == 1) {
      F = parseAssemblerCondDag(Dag->getArg(0), Rec);
      F.negate();
      return F;
    }

    if ((OpName == "any_of" || OpName == "all_of") && Dag->getNumArgs() > 0) {
      bool IsOr = OpName == "any_of";
      for (auto *Arg : Dag->getArgs()) {
        CNFFormula ArgF = parseAssemblerCondDag(Arg, Rec);
        if (IsOr)
          F.addOr(ArgF);
        else
          F.addAnd(ArgF);
      }
      return F;
    }

    PrintFatalError(Rec->getLoc(), "Invalid AssemblerCondDag: unsupported operator '" + OpName + "'!");
  }

  PrintFatalError(Rec->getLoc(), "Invalid AssemblerCondDag: unexpected initializer!");
}

void llvm::getRequiredFeatures(
    std::set<SubtargetFeatureLiteral> &FeaturesSet,
    std::set<std::set<SubtargetFeatureLiteral>> &AnyOfFeatureSets,
    ArrayRef<const Record *> ReqPredicates) {
  for (const Record *R : ReqPredicates) {
    const RecordVal *V = R->getValue("AssemblerCondDag");
    if (!V || !V->getValue() || !isa<DagInit>(V->getValue())) {
      if (R->getValue("CondString")) {
        StringRef Cond = R->getValueAsString("CondString");
        if (!Cond.empty()) {
          FeaturesSet.insert({R->getName(), false});
        }
      }
      continue;
    }
    const DagInit *D = cast<DagInit>(V->getValue());
    std::string CombineType = D->getOperator()->getAsString();
    if (CombineType != "any_of" && CombineType != "all_of" && CombineType != "not")
      PrintFatalError(R->getLoc(), "Invalid AssemblerCondDag!");
    if (CombineType == "not" && D->getNumArgs() != 1)
      PrintFatalError(R->getLoc(), "Invalid AssemblerCondDag!");
    if (CombineType != "not" && D->getNumArgs() == 0)
      PrintFatalError(R->getLoc(), "Invalid AssemblerCondDag!");

    CNFFormula F = parseAssemblerCondDag(D, R);
    for (auto &Clause : F.Clauses) {
      if (Clause.empty())
        continue;
      if (Clause.size() == 1) {
        FeaturesSet.insert(*Clause.begin());
      } else {
        AnyOfFeatureSets.insert(std::move(Clause));
      }
    }
  }
}
