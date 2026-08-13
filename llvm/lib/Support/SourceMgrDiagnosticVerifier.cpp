//===- SourceMgrDiagnosticVerifier.cpp -----------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/SourceMgrDiagnosticVerifier.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

SourceMgrDiagnosticVerifier::SourceMgrDiagnosticVerifier(
    ArrayRef<std::string> prefixes, ArrayRef<std::string> commentPrefixes)
    : commentPrefixes(commentPrefixes.begin(), commentPrefixes.end()) {
  std::string prefixAlt;
  raw_string_ostream prefixOS(prefixAlt);
  for (size_t i = 0, e = prefixes.size(); i != e; ++i) {
    // An empty prefix would add an empty alternative to the regex below,
    // letting a bare '-error {{...}}' comment (with no prefix word at all)
    // match. Callers must not pass one.
    assert(!prefixes[i].empty() && "prefixes must be non-empty");
    if (i)
      prefixOS << '|';
    prefixOS << Regex::escape(prefixes[i]);
  }
  expected = Regex("(" + prefixAlt +
                    ")-(error|note|remark|warning)(-re)? "
                    "*(@([+-][0-9]+|above|below|unknown))? *{{(.*)}}$");
}

/// Given a diagnostic kind, return a human readable string for it.
static StringRef getDiagKindStr(SourceMgr::DiagKind kind) {
  switch (kind) {
  case SourceMgr::DK_Note:
    return "note";
  case SourceMgr::DK_Warning:
    return "warning";
  case SourceMgr::DK_Error:
    return "error";
  case SourceMgr::DK_Remark:
    return "remark";
  }
  llvm_unreachable("Unknown SourceMgr::DiagKind");
}

bool SourceMgrDiagnosticVerifier::ExpectedDiag::emitError(raw_ostream &os,
                                                           SourceMgr &mgr,
                                                           const Twine &msg
                                                           ) const {
  if (fileLoc.isValid()) {
    SMRange range(fileLoc, SMLoc::getFromPointer(fileLoc.getPointer() +
                                                  substring.size()));
    mgr.PrintMessage(os, fileLoc, SourceMgr::DK_Error, msg, range);
  } else {
    mgr.PrintMessage(os, fileLoc, SourceMgr::DK_Error, msg);
  }
  return false;
}

bool SourceMgrDiagnosticVerifier::ExpectedDiag::match(StringRef str) const {
  // If this isn't a regex diagnostic, we simply check if the string was
  // contained.
  if (substringRegex)
    return substringRegex->match(str);
  return str.contains(substring);
}

bool SourceMgrDiagnosticVerifier::ExpectedDiag::computeRegex(raw_ostream &os,
                                                              SourceMgr &mgr) {
  std::string regexStr;
  raw_string_ostream regexOS(regexStr);
  StringRef strToProcess = substring;
  while (!strToProcess.empty()) {
    // Find the next regex block.
    size_t regexIt = strToProcess.find("{{");
    if (regexIt == StringRef::npos) {
      regexOS << Regex::escape(strToProcess);
      break;
    }
    regexOS << Regex::escape(strToProcess.take_front(regexIt));
    strToProcess = strToProcess.drop_front(regexIt + 2);

    // Find the end of the regex block.
    size_t regexEndIt = strToProcess.find("}}");
    if (regexEndIt == StringRef::npos)
      return emitError(os, mgr, "found start of regex with no end '}}'");
    StringRef regexBlock = strToProcess.take_front(regexEndIt);

    // Validate that the regex is actually valid.
    std::string regexError;
    if (!Regex(regexBlock).isValid(regexError))
      return emitError(os, mgr, "invalid regex: " + regexError);

    regexOS << '(' << regexBlock << ')';
    strToProcess = strToProcess.drop_front(regexEndIt + 2);
  }
  substringRegex = Regex(regexStr);
  return true;
}

MutableArrayRef<SourceMgrDiagnosticVerifier::ExpectedDiag>
SourceMgrDiagnosticVerifier::computeExpectedDiags(raw_ostream &os,
                                                   SourceMgr &mgr,
                                                   const MemoryBuffer *buf) {
  // If the buffer is invalid, return an empty list.
  if (!buf)
    return {};
  // Idempotent: a buffer that's already been scanned is returned as-is,
  // rather than being rescanned and appending duplicate entries.
  if (auto maybeDiags = getExpectedDiags(buf->getBufferIdentifier()))
    return *maybeDiags;
  auto &expectedDiags = expectedDiagsPerFile[buf->getBufferIdentifier()];

  // The number of the last line that did not correlate to a designator.
  unsigned lastNonDesignatorLine = 0;

  // The indices of designators that apply to the next non designator line.
  SmallVector<unsigned, 1> designatorsForNextLine;

  // Scan the file for <prefix>-* designators.
  SmallVector<StringRef, 100> lines;
  buf->getBuffer().split(lines, '\n');
  for (unsigned lineNo = 0, e = lines.size(); lineNo < e; ++lineNo) {
    // If comment-scoping is enabled, only the text at or after the earliest
    // recognized comment prefix on the line is eligible to match, so a magic
    // string appearing outside of a comment (e.g. in an instruction operand)
    // is ignored.
    StringRef line = lines[lineNo].rtrim();
    if (!commentPrefixes.empty()) {
      size_t commentStart = StringRef::npos;
      for (StringRef prefix : commentPrefixes) {
        size_t pos = line.find(prefix);
        if (pos != StringRef::npos &&
            (commentStart == StringRef::npos || pos < commentStart))
          commentStart = pos;
      }
      line = commentStart == StringRef::npos ? StringRef()
                                              : line.substr(commentStart);
    }

    SmallVector<StringRef, 5> matches;
    if (!expected.match(line, &matches)) {
      // Check for designators that apply to this line.
      if (!designatorsForNextLine.empty()) {
        for (unsigned diagIndex : designatorsForNextLine)
          expectedDiags[diagIndex].lineNo = lineNo + 1;
        designatorsForNextLine.clear();
      }
      lastNonDesignatorLine = lineNo;
      continue;
    }

    // Point to the start of <prefix>-*.
    SMLoc expectedStart = SMLoc::getFromPointer(matches[0].data());

    SourceMgr::DiagKind kind;
    if (matches[2] == "error")
      kind = SourceMgr::DK_Error;
    else if (matches[2] == "warning")
      kind = SourceMgr::DK_Warning;
    else if (matches[2] == "remark")
      kind = SourceMgr::DK_Remark;
    else {
      assert(matches[2] == "note");
      kind = SourceMgr::DK_Note;
    }
    ExpectedDiag record(kind, lineNo + 1, expectedStart, matches[6]);

    // Check to see if this is a regex match, i.e. it includes the `-re`.
    if (!matches[3].empty() && !record.computeRegex(os, mgr)) {
      ok = false;
      continue;
    }

    StringRef offsetMatch = matches[4];
    if (!offsetMatch.empty()) {
      offsetMatch = offsetMatch.drop_front(1);

      // Get the integer value without the @ and +/- prefix.
      if (offsetMatch[0] == '+' || offsetMatch[0] == '-') {
        int offset;
        // The regex only ever captures decimal digits here, so parse as
        // decimal explicitly: a leading zero (e.g. '@+08') would otherwise
        // be mis-parsed as octal by getAsInteger's radix auto-detection
        // (and '08' isn't valid octal, so that already-broken corner case
        // would silently discard the offset instead of reporting an error).
        if (offsetMatch.drop_front().getAsInteger(10, offset)) {
          ok = false;
          record.emitError(os, mgr, "invalid line offset '" + offsetMatch + "'");
          continue;
        }

        if (offsetMatch.front() == '+') {
          record.lineNo += offset;
        } else if (static_cast<unsigned>(offset) >= record.lineNo) {
          // Line numbers are 1-based, so an offset that would take lineNo to
          // 0 or below is out of range.
          ok = false;
          record.emitError(os, mgr, "line offset '" + offsetMatch +
                                        "' is before the start of the file");
          continue;
        } else {
          record.lineNo -= offset;
        }
      } else if (offsetMatch.consume_front("unknown")) {
        // This is matching unknown locations.
        record.fileLoc = SMLoc();
        expectedUnknownLocDiags.emplace_back(std::move(record));
        continue;
      } else if (offsetMatch.consume_front("above")) {
        // If the designator applies 'above' we add it to the last non
        // designator line.
        record.lineNo = lastNonDesignatorLine + 1;
      } else {
        // Otherwise, this is a 'below' designator and applies to the next
        // non-designator line.
        assert(offsetMatch.consume_front("below"));
        designatorsForNextLine.push_back(expectedDiags.size());

        // Set the line number to the last in the case that this designator
        // ends up dangling.
        record.lineNo = e;
      }
    }
    expectedDiags.emplace_back(std::move(record));
  }
  return expectedDiags;
}

std::optional<MutableArrayRef<SourceMgrDiagnosticVerifier::ExpectedDiag>>
SourceMgrDiagnosticVerifier::getExpectedDiags(StringRef bufName) {
  auto expectedDiags = expectedDiagsPerFile.find(bufName);
  if (expectedDiags != expectedDiagsPerFile.end())
    return MutableArrayRef<ExpectedDiag>(expectedDiags->second);
  return std::nullopt;
}

SourceMgrDiagnosticVerifier::MatchResult SourceMgrDiagnosticVerifier::process(
    raw_ostream &os, SourceMgr &mgr, SourceMgr::DiagKind kind, bool hasLoc,
    const MemoryBuffer *buf, unsigned lineNo, StringRef message,
    bool reportUnexpected) {
  MutableArrayRef<ExpectedDiag> diags;
  if (hasLoc) {
    // If the buffer couldn't be resolved, `diags` stays empty: a diagnostic
    // with a location in an unknown file can never match anything.
    if (buf)
      diags = computeExpectedDiags(os, mgr, buf);
  } else {
    diags = expectedUnknownLocDiags;
  }

  // Search for a matching expected diagnostic.
  // If we find something that is close then emit a more specific error.
  ExpectedDiag *nearMiss = nullptr;

  // If this was an expected error, remember that we saw it and return.
  for (auto &e : diags) {
    // File line must match (unless it's an unknown location).
    if (hasLoc && e.lineNo != lineNo)
      continue;
    if (e.match(message)) {
      if (e.kind == kind) {
        e.matched = true;
        return MatchResult::Matched;
      }

      // If this only differs based on the diagnostic kind, then consider it
      // to be a near miss.
      nearMiss = &e;
    }
  }

  if (!reportUnexpected)
    return MatchResult::Ignored;

  ok = false;

  // Otherwise, emit an error for the near miss.
  if (nearMiss) {
    mgr.PrintMessage(os, nearMiss->fileLoc, SourceMgr::DK_Error,
                      "'" + getDiagKindStr(kind) +
                          "' diagnostic emitted when expecting a '" +
                          getDiagKindStr(nearMiss->kind) + "'");
    return MatchResult::NearMiss;
  }
  return MatchResult::Unexpected;
}

bool SourceMgrDiagnosticVerifier::verify(raw_ostream &os, SourceMgr &mgr) {
  // Scan any buffers that process() never had a reason to look at (e.g. an
  // included file where the diagnostic its 'expected-*' comment names never
  // actually fired): otherwise that expectation would never be recorded, and
  // so never reported as missing below, letting verification silently
  // pass when it shouldn't. computeExpectedDiags is idempotent, so
  // re-scanning an already-known buffer here is harmless.
  for (unsigned i = 0, e = mgr.getNumBuffers(); i != e; ++i)
    (void)computeExpectedDiags(os, mgr, mgr.getMemoryBuffer(i + 1));

  // Verify that all expected errors were seen.
  auto checkExpectedDiags = [&](ExpectedDiag &diag) {
    if (!diag.matched) {
      diag.emitError(os, mgr,
                      "expected " + getDiagKindStr(diag.kind) + " \"" +
                          diag.substring + "\" was not produced");
      ok = false;
    }
  };
  for (auto &expectedDiagsPair : expectedDiagsPerFile)
    for (auto &diag : expectedDiagsPair.second)
      checkExpectedDiags(diag);
  for (auto &diag : expectedUnknownLocDiags)
    checkExpectedDiags(diag);
  expectedDiagsPerFile.clear();
  return ok;
}
