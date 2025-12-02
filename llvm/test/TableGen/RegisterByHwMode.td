// RUNs: llvm-tblgen --gen-asm-matcher -I %p/../../include -I %S %s -o - | FileCheck --check-prefix=ASMMATCHER %s
// RUN: llvm-tblgen --gen-pseudo-lowering -I %p/../../include -I %S %s -o -
// RUN: llvm-tblgen --gen-asm-writer -I %p/../../include -I %S %s -o -
// RUN: llvm-tblgen --gen-subtarget -I %p/../../include -I %S %s -o -
// RUN: llvm-tblgen --gen-disassembler -I %p/../../include -I %S %s -o -
// RUN: llvm-tblgen --gen-dag-isel -I %p/../../include -I %S %s -o -
// RUN: llvm-tblgen --gen-global-isel -I %p/../../include -I %S %s -o -
// RUN: false


// RUN: llvm-tblgen --gen-subtarget -I %p/../../include %s -o - 2>&1 | FileCheck %s --check-prefix=SUBTARGET
// RUN: false
// RUN: llvm-tblgen -gen-asm-matcher -I %p/../../include %s -o - | FileCheck -check-prefix=ASMMATCHER %s
// RUN: llvm-tblgen -gen-instr-info -I %p/../../include %s -o - | FileCheck -check-prefix=INSTRINFO %s
// RUN: llvm-tblgen -gen-asm-matcher -I %p/../../include %s -o - | FileCheck -check-prefix=ASMMATCHER %s
// RUN: llvm-tblgen -gen-disassembler -I %p/../../include %s -o - | FileCheck -check-prefix=DISASM %s
// RUN: llvm-tblgen -gen-dag-isel -I %p/../../include %s -o - | FileCheck -check-prefix=ISEL-SDAG %s
// RUN: llvm-tblgen -gen-global-isel -I %p/../../include %s -o - | FileCheck -check-prefix=ISEL-GISEL %s


// SUBTARGET-LABEL:  enum class MyTargetHwModeBits : unsigned {
// SUBTARGET-NEXT:    DefaultMode = 0,
// SUBTARGET-NEXT:    XPtr64 = (1 << 0),
// SUBTARGET-NEXT:    YPtr32 = (1 << 1),
// SUBTARGET-NEXT:    YPtr64 = (1 << 2),
// SUBTARGET-NEXT:
// SUBTARGET-NEXT:    LLVM_MARK_AS_BITMASK_ENUM(/*LargestValue=*/YPtr64),
// SUBTARGET-NEXT:  };
// SUBTARGET-NEXT:  unsigned getHwModeSet() const override;
// SUBTARGET-NEXT:  unsigned getHwMode(enum HwModeType type = HwMode_Default) const override;

// SUBTARGET-LABEL: unsigned TestTargetGenSubtargetInfo::getHwModeSet() const {
// SUBTARGET{LITERAL}:[[maybe_unused]] const auto *Subtarget =
// SUBTARGET-NEXT:        static_cast<const TestTargetSubtarget *>(this);
// SUBTARGET-NEXT:    // Collect HwModes and store them as a bit set.
// SUBTARGET-NEXT:    unsigned Modes = 0;
// SUBTARGET-NEXT:  if ((Subtarget->is64Bit()) && (!Subtarget->useYRegForPtr())) Modes |= (1 << 0);
// SUBTARGET-NEXT:  if ((!Subtarget->is64Bit()) && (Subtarget->useYRegForPtr())) Modes |= (1 << 1);
// SUBTARGET-NEXT:  if ((Subtarget->is64Bit()) && (Subtarget->useYRegForPtr())) Modes |= (1 << 2);
// SUBTARGET-NEXT:  return Modes;
// SUBTARGET-NEXT:  }

// INSTRINFO: { MyTarget::XRegsRegClassID, 0, MCOI::OPERAND_REGISTER, 0 },
// INSTRINFO: { MyTarget::XRegs_EvenRegClassID, 0, MCOI::OPERAND_REGISTER, 0 },
// INSTRINFO: { MyTarget::YRegs_EvenIfRequired, 0|(1<<MCOI::LookupRegClassByHwMode), MCOI::OPERAND_REGISTER, 0 },
// INSTRINFO: { MyTarget::XRegs_EvenIfRequired, 0|(1<<MCOI::LookupRegClassByHwMode), MCOI::OPERAND_REGISTER, 0 },
// INSTRINFO: { MyTarget::XRegs_EvenIfRequired, 0|(1<<MCOI::LookupRegClassByHwMode), MCOI::OPERAND_REGISTER, 0 }, { MyTarget::MyPtrRC, 0|(1<<MCOI::LookupRegClassByHwMode), MCOI::OPERAND_REGISTER, 0 },
// INSTRINFO: { MyTarget::YRegs_EvenIfRequired, 0|(1<<MCOI::LookupRegClassByHwMode), MCOI::OPERAND_REGISTER, 0 }, { MyTarget::XRegs_EvenIfRequired, 0|(1<<MCOI::LookupRegClassByHwMode), MCOI::OPERAND_REGISTER, 0 },

// INSTRINFO: extern const int16_t MyTargetRegClassByHwModeTables[4][3] = {
// INSTRINFO-NEXT:  { // DefaultMode
// INSTRINFO-NEXT:    MyTarget::PtrRegs32RegClassID,
// INSTRINFO-NEXT:    MyTarget::XRegsRegClassID,
// INSTRINFO-NEXT:    MyTarget::YRegsRegClassID,
// INSTRINFO-NEXT:  },
// INSTRINFO-NEXT:  { // EvenMode
// INSTRINFO-NEXT:    -1, // Missing mode entry
// INSTRINFO-NEXT:    MyTarget::XRegs_EvenRegClassID,
// INSTRINFO-NEXT:    MyTarget::YRegs_EvenRegClassID,
// INSTRINFO-NEXT:  },
// INSTRINFO-NEXT:  { // OddMode
// INSTRINFO-NEXT:    -1, // Missing mode entry
// INSTRINFO-NEXT:    MyTarget::XRegs_OddRegClassID,
// INSTRINFO-NEXT:    -1, // Missing mode entry
// INSTRINFO-NEXT:  },
// INSTRINFO-NEXT:  { // Ptr64
// INSTRINFO-NEXT:    MyTarget::PtrRegs64RegClassID,
// INSTRINFO-NEXT:    -1, // Missing mode entry
// INSTRINFO-NEXT:    -1, // Missing mode entry
// INSTRINFO-NEXT:  },
// INSTRINFO-NEXT: };

// INSTRINFO: static inline void InitMyTargetMCInstrInfo(
// INSTRINFO-NEXT: II->InitMCInstrInfo(MyTargetDescs.Insts, MyTargetInstrNameIndices, MyTargetInstrNameData, nullptr, nullptr, {{[0-9]+}}, &MyTargetRegClassByHwModeTables[0][0], 3);

// FIXME:   static const AliasPatternCond Conds[] = { is broken

// ASMMATCHER-LABEL: enum InstructionConversionKind {
// ASMMATCHER-NEXT:    Convert__regModeCountReg__Reg1_0,
// ASMMATCHER-NEXT:    Convert__regNullReg__RegByHwMode_PtrRC1_0,
// ASMMATCHER-NEXT:    Convert__regX0__Reg1_0,
// ASMMATCHER-NEXT:    Convert__regY0__Reg1_0,
// ASMMATCHER-NEXT:    Convert__RegByHwMode_PtrRC1_0__RegByHwMode_PtrRC1_1,
// ASMMATCHER-NEXT:    Convert__Reg1_0__Reg1_1,
// ASMMATCHER-NEXT:    CVT_NUM_SIGNATURES
// ASMMATCHER-NEXT:  };

// ASMMATCHER-LABEL: static const uint8_t ConversionTable[CVT_NUM_SIGNATURES][5] = {
// ASMMATCHER-NEXT:    // Convert__regModeCountReg__Reg1_0
// ASMMATCHER-NEXT:    { CVT_regModeCountReg, 0, CVT_95_Reg, 1, CVT_Done },
// ASMMATCHER-NEXT:    // Convert__regNullReg__RegByHwMode_PtrRC1_0
// ASMMATCHER-NEXT:    { CVT_regNullReg, 0, CVT_95_addRegOperands, 1, CVT_Done },
// ASMMATCHER-NEXT:    // Convert__regX0__Reg1_0
// ASMMATCHER-NEXT:    { CVT_regX0, 0, CVT_95_Reg, 1, CVT_Done },
// ASMMATCHER-NEXT:    // Convert__regY0__Reg1_0
// ASMMATCHER-NEXT:    { CVT_regY0, 0, CVT_95_Reg, 1, CVT_Done },
// ASMMATCHER-NEXT:    // Convert__RegByHwMode_PtrRC1_0__RegByHwMode_PtrRC1_1
// ASMMATCHER-NEXT:    { CVT_95_addRegOperands, 1, CVT_95_addRegOperands, 2, CVT_Done },
// ASMMATCHER-NEXT:    // Convert__Reg1_0__Reg1_1
// ASMMATCHER-NEXT:    { CVT_95_Reg, 1, CVT_95_Reg, 2, CVT_Done },
// ASMMATCHER-NEXT:  };

// ASMMATCHER-LABEL: convertToMCInst(unsigned Kind, MCInst &Inst, unsigned Opcode,
// ASMMATCHER-LABEL:  case CVT_regModeCountReg: {
// ASMMATCHER-NEXT:     static constexpr MCRegister RegByHwModeMatchTable[4] = {
// ASMMATCHER-NEXT:       MyTarget::X0, // DefaultMode
// ASMMATCHER-NEXT:       MyTarget::X1, // XPtr64
// ASMMATCHER-NEXT:       MyTarget::X2, // YPtr32
// ASMMATCHER-NEXT:       MyTarget::X3, // YPtr64
// ASMMATCHER-NEXT:     },
// ASMMATCHER-NEXT:     const unsigned HwMode = STI.getHwMode(MCSubtargetInfo::HwMode_RegInfo);      const MCRegister Reg = RegByHwModeMatchTable[HwMode];
// ASMMATCHER-NEXT:     assert(Reg.isValid() && "Incomplete RegByHwModeTable not handled yet");
// ASMMATCHER-NEXT:     Inst.addOperand(MCOperand::createReg(Reg));
// ASMMATCHER-NEXT:     break;
// ASMMATCHER-NEXT:   }
// ASMMATCHER-NEXT:   case CVT_95_Reg:
// ASMMATCHER-NEXT:     static_cast<MyTargetOperand &>(*Operands[OpIdx]).addRegOperands(Inst, 1);
// ASMMATCHER-NEXT:     break;
// ASMMATCHER-NEXT:   case CVT_regNullReg: {
// ASMMATCHER-NEXT:     static constexpr MCRegister RegByHwModeMatchTable[4] = {
// ASMMATCHER-NEXT:       MyTarget::X0, // DefaultMode
// ASMMATCHER-NEXT:       MyTarget::X0, // XPtr64
// ASMMATCHER-NEXT:       MyTarget::Y0, // YPtr32
// ASMMATCHER-NEXT:       MyTarget::Y0, // YPtr64
// ASMMATCHER-NEXT:     },
// ASMMATCHER-NEXT:     const unsigned HwMode = STI.getHwMode(MCSubtargetInfo::HwMode_RegInfo);      const MCRegister Reg = RegByHwModeMatchTable[HwMode];
// ASMMATCHER-NEXT:     assert(Reg.isValid() && "Incomplete RegByHwModeTable not handled yet");
// ASMMATCHER-NEXT:     Inst.addOperand(MCOperand::createReg(Reg));
// ASMMATCHER-NEXT:     break;
// ASMMATCHER-NEXT:   }
// ASMMATCHER-NEXT:   case CVT_95_addRegOperands:
// ASMMATCHER-NEXT:     static_cast<MyTargetOperand &>(*Operands[OpIdx]).addRegOperands(Inst, 1);
// ASMMATCHER-NEXT:     break;
// ASMMATCHER-NEXT:   case CVT_regX0:
// ASMMATCHER-NEXT:     Inst.addOperand(MCOperand::createReg(MyTarget::X0));
// ASMMATCHER-NEXT:     break;
// ASMMATCHER-NEXT:   case CVT_regY0:
// ASMMATCHER-NEXT:     Inst.addOperand(MCOperand::createReg(MyTarget::Y0));
// ASMMATCHER-NEXT:     break;
// ASMMATCHER-NEXT:   }

// ASMMATCHER-LABEL: enum MatchClassKind {
// ASMMATCHER-NEXT:    InvalidMatchClass = 0,
// ASMMATCHER-NEXT:    OptionalMatchClass = 1,
// ASMMATCHER-NEXT:    MCK_LAST_TOKEN = OptionalMatchClass,
// ASMMATCHER-NEXT:    MCK_XRegs, // register class 'XRegs'
// ASMMATCHER-NEXT:    MCK_YRegs, // register class 'YRegs'
// ASMMATCHER-NEXT:    MCK_LAST_REGISTER = MCK_YRegs,
// ASMMATCHER-NEXT:    MCK_RegByHwMode_PtrRC, // register class by hwmode
// ASMMATCHER-NEXT:    MCK_LAST_REGCLASS_BY_HWMODE = MCK_RegByHwMode_PtrRC,
// ASMMATCHER-NEXT:    MCK_Imm, // user defined class 'ImmAsmOperand'
// ASMMATCHER-NEXT:    NumMatchClassKinds
// ASMMATCHER-NEXT:  };


// ASMMATCHER-LABEL: static const MatchEntry MatchTable0[] = {
// ASMMATCHER-NEXT:    /* mode_count */, MyTarget::TEST_XREG, Convert__regModeCountReg__Reg1_0, AMFBS_None, { MCK_XRegs }, },
// ASMMATCHER-NEXT:    /* t */, MyTarget::TEST_PTRREG, Convert__regNullReg__RegByHwMode_PtrRC1_0, AMFBS_None, { MCK_RegByHwMode_PtrRC }, },
// ASMMATCHER-NEXT:    /* t_x */, MyTarget::TEST_XREG, Convert__regX0__Reg1_0, AMFBS_None, { MCK_XRegs }, },
// ASMMATCHER-NEXT:    /* t_y */, MyTarget::TEST_YREG, Convert__regY0__Reg1_0, AMFBS_None, { MCK_YRegs }, },
// ASMMATCHER-NEXT:    /* test_alias */, MyTarget::TEST_PTRREG, Convert__RegByHwMode_PtrRC1_0__RegByHwMode_PtrRC1_1, AMFBS_None, { MCK_RegByHwMode_PtrRC, MCK_RegByHwMode_PtrRC }, },
// ASMMATCHER-NEXT:    /* test_ptr */, MyTarget::TEST_PTRREG, Convert__RegByHwMode_PtrRC1_0__RegByHwMode_PtrRC1_1, AMFBS_None, { MCK_RegByHwMode_PtrRC, MCK_RegByHwMode_PtrRC }, },
// ASMMATCHER-NEXT:    /* test_x */, MyTarget::TEST_XREG, Convert__Reg1_0__Reg1_1, AMFBS_None, { MCK_XRegs, MCK_XRegs }, },
// ASMMATCHER-NEXT:    /* test_y */, MyTarget::TEST_YREG, Convert__Reg1_0__Reg1_1, AMFBS_None, { MCK_YRegs, MCK_YRegs }, },
// ASMMATCHER-NEXT:  };

// DISASM{LITERAL}: [[maybe_unused]]
// DISASM-NEXT: static DecodeStatus DecodeMyPtrRCRegClassByHwMode(MCInst &Inst, unsigned Imm, uint64_t Addr, const MCDisassembler *Decoder) {
// DISASM-NEXT:   switch (Decoder->getSubtargetInfo().getHwMode(MCSubtargetInfo::HwMode_RegInfo)) {
// DISASM-NEXT:   case 0: // DefaultMode
// DISASM-NEXT:     return DecodePtrRegs32RegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:   case 3: // Ptr64
// DISASM-NEXT:     return DecodePtrRegs64RegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:   default:
// DISASM-NEXT:     llvm_unreachable("no decoder for hwmode");
// DISASM-NEXT:   }
// DISASM-NEXT: }

// DISASM{LITERAL}: [[maybe_unused]]
// DISASM-NEXT: static DecodeStatus DecodeXRegs_EvenIfRequiredRegClassByHwMode(MCInst &Inst, unsigned Imm, uint64_t Addr, const MCDisassembler *Decoder) {
// DISASM-NEXT:  switch (Decoder->getSubtargetInfo().getHwMode(MCSubtargetInfo::HwMode_RegInfo)) {
// DISASM-NEXT:  case 0: // DefaultMode
// DISASM-NEXT:    return DecodeXRegsRegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:  case 1: // EvenMode
// DISASM-NEXT:    return DecodeXRegs_EvenRegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:  case 2: // OddMode
// DISASM-NEXT:    return DecodeXRegs_OddRegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:  default:
// DISASM-NEXT:    llvm_unreachable("no decoder for hwmode");
// DISASM-NEXT:  }
// DISASM-NEXT:}
// DISASM-EMPTY:
// DISASM{LITERAL}: [[maybe_unused]]
// DISASM-NEXT: static DecodeStatus DecodeYRegs_EvenIfRequiredRegClassByHwMode(MCInst &Inst, unsigned Imm, uint64_t Addr, const MCDisassembler *Decoder) {
// DISASM-NEXT:  switch (Decoder->getSubtargetInfo().getHwMode(MCSubtargetInfo::HwMode_RegInfo)) {
// DISASM-NEXT:  case 0: // DefaultMode
// DISASM-NEXT:    return DecodeYRegsRegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:  case 1: // EvenMode
// DISASM-NEXT:    return DecodeYRegs_EvenRegisterClass(Inst, Imm, Addr, Decoder);
// DISASM-NEXT:  default:
// DISASM-NEXT:    llvm_unreachable("no decoder for hwmode");
// DISASM-NEXT:  }
// DISASM-NEXT:}

// DISASM: static DecodeStatus decodeToMCInst(
// DISASM:   switch (Idx) {
// DISASM: case 0:
// DISASM: if (!Check(S, DecodeYRegs_EvenIfRequiredRegClassByHwMode(MI, tmp, Address, Decoder))) { return MCDisassembler::Fail; }
// DISASM: if (!Check(S, DecodeXRegs_EvenIfRequiredRegClassByHwMode(MI, tmp, Address, Decoder))) { return MCDisassembler::Fail; }

// DISASM: case 1:
// DISASM: if (!Check(S, DecodeXRegs_EvenIfRequiredRegClassByHwMode(MI, tmp, Address, Decoder))) { return MCDisassembler::Fail; }

// DISASM: case 2:
// DISASM: if (!Check(S, DecodeXRegs_EvenRegisterClass(MI, tmp, Address, Decoder))) { return MCDisassembler::Fail; }
// DISASM: case 3:
// DISASM: if (!Check(S, DecodeXRegsRegisterClass(MI, tmp, Address, Decoder))) { return MCDisassembler::Fail; }

// DISASM: case 4:
// DISASM: if (!Check(S, YEvenIfRequiredCustomDecoder(MI, tmp, Address, Decoder))) { return MCDisassembler::Fail; }

include "Common/RegisterByHwModeCommon.td"

// Define more restrictive subset classes to check that those are handled.
def EvenXRegs : RegisterClass<"MyTarget", [XLenVT], 32, (add X0, X2)> {
  let RegInfos = XLenRI;  // Needed to determine size of registers
}
def EvenYRegs : RegisterClass<"MyTarget", [YLenVT], 64, (add Y0, Y2)> {
  let RegInfos = YLenRI;  // Needed to determine size of registers
}
def EvenPtrRC : RegClassByHwMode<[XPtr32,    XPtr64,    YPtr32,    YPtr64],
                                 [EvenXRegs, EvenXRegs, EvenYRegs, EvenYRegs]>;

def MY_TEST_ALIAS : InstAlias<"test_alias $dst, $src", (TEST_PTRREG PtrRC:$dst, PtrRC:$src)>;
def MY_TEST_ALIAS_EVEN : InstAlias<"test_alias.even $dst, $src", (TEST_PTRREG EvenPtrRC:$dst, EvenPtrRC:$src)>;
def MY_T_X : InstAlias<"t_x $src", (TEST_XREG X0, XRegs:$src)>;
def MY_T_X_EVEN : InstAlias<"t_x.even $src", (TEST_XREG X0, XRegs:$src)>;
def MY_T_Y : InstAlias<"t_y $src", (TEST_YREG Y0, YRegs:$src)>;
def MY_T_Y_EVEN : InstAlias<"t_y.even $src", (TEST_YREG Y0, YRegs:$src)>;
// Use a zero register that varies depend on the HWMode:
def NullReg : RegisterByHwMode<PtrRC, [XPtr32, XPtr64, YPtr32, YPtr64],
                                      [X0,     X0,     Y0,     Y0]>;
def MY_T_PTR : InstAlias<"t $src", (TEST_PTRREG NullReg, PtrRC:$src)>;
def MY_T_PTR_EVEN : InstAlias<"t.even $src", (TEST_PTRREG NullReg, EvenPtrRC:$src)>;

// Add another test where the register number varies, but the regclass doesn't
def ModeCountReg : RegisterByHwMode<XRegs, [XPtr32, XPtr64, YPtr32, YPtr64],
                                           [X0,     X1,     X2,     X3]>;
def TEST_MODE_COUNT : InstAlias<"mode_count $src", (TEST_XREG ModeCountReg, XRegs:$src)>;

/// Include a test for -gen-pseudo-lowering:
class Pseudo<dag outs, dag ins> : TestInstruction {
  let OutOperandList = outs;
  let InOperandList = ins;
  let isPseudo = 1;
  let isCodeGenOnly = 1;
}
def PseudoXMatchingClass : Pseudo<(outs), (ins XRegs:$rs1)>,
    PseudoInstExpansion<(TEST_XREG X0, XRegs:$rs1)>;
def PseudoXSubsetClass : Pseudo<(outs), (ins EvenXRegs:$rs1)>,
    PseudoInstExpansion<(TEST_XREG X0, XRegs:$rs1)>;
def PseudoPtrMatchingClass : Pseudo<(outs), (ins PtrRC:$rs1)>,
    PseudoInstExpansion<(TEST_PTRREG NullReg, PtrRegOperand:$rs1)>;
def PseudoPtrSubsetClass : Pseudo<(outs), (ins EvenPtrRC:$rs1)>,
    PseudoInstExpansion<(TEST_PTRREG NullReg, PtrRegOperand:$rs1)>;

// Test 2 different cases directly in the instruction
// def MY_LOAD_X : TestInstruction {
//   let OutOperandList = (outs XRegs:$dst);
//   let InOperandList = (ins PtrRC:$src);
//   let AsmString = "my_load_x $dst, $src";
//   let opcode = 4;
// }
//
// // Test 2 different cases wrapped by RegisterOperand
// def MY_LOAD_PTR : TestInstruction {
//   let OutOperandList = (outs RegisterOperand<PtrRC>:$dst);
//   let InOperandList = (ins PtrRegOperand:$src);
//   let AsmString = "my_load_ptr $dst, $src";
//   let opcode = 5;
// }
// Direct RegClassByHwMode usage
// def : Pat<
//   (store XRegs_EvenIfRequired:$val, MyPtrRC:$src),
//   (MY_STORE $val, XRegs_EvenIfRequired:$src)
// >;
//
// // Wrapped in RegisterOperand
// def : Pat<
//   (i64 (load PtrRegOperand:$src)),
//   (MY_LOAD $src)
// >;

def MyTargetISA : InstrInfo;
def MyTarget : Target { let InstructionSet = MyTargetISA; }
