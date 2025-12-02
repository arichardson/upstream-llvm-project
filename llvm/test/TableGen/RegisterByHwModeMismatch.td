// RUN: rm -rf %t && split-file --leading-lines %s %t
// RUN: not llvm-tblgen -gen-asm-matcher -I %t -I %p/../../include -I %S \
// RUN:    %t/bad-regclass.td -o /dev/null 2>&1 | FileCheck %s --check-prefix=BAD-REGCLASS
// RUN: not llvm-tblgen -gen-asm-matcher -I %t -I %p/../../include -I %S \
// RUN:    %t/bad-regclass-by-mode.td -o /dev/null 2>&1 | FileCheck %s --check-prefix=BAD-REGCLASS-BY-MODE
// RUN: not llvm-tblgen -gen-asm-matcher -I %t -I %p/../../include -I %S \
// RUN:    %t/bad-not-regclass.td -o /dev/null 2>&1 | FileCheck %s --check-prefix=BAD-NOT-VALID-REGCLASS

//--- bad-regclass.td
include "Common/RegisterByHwModeCommon.td"
def BadReg : RegisterByHwMode<XRegs, [XPtr32, XPtr64, YPtr32, YPtr64], [X0, X0, X0, Y0]>;
// BAD-REGCLASS: [[#@LINE-1]]:5: error: Register Y0 for HwMode YPtr64 is not a member of register class XRegs

// Need to define an instruction that uses BadReg to get the diagnostic
def : InstAlias<"test $src", (TEST_XREG BadReg, XRegs:$src)>;
def MyTargetISA : InstrInfo;
def MyTarget : Target { let InstructionSet = MyTargetISA; }


//--- bad-regclass-by-mode.td
include "Common/RegisterByHwModeCommon.td"
def BadReg : RegisterByHwMode<PtrRC, [XPtr32, XPtr64, YPtr32, YPtr64], [X0, X0, X0, X0]>;
// BAD-REGCLASS-BY-MODE: [[#@LINE-1]]:5: error: Register X0 for HwMode YPtr32 is not a member of register class YRegs

// Need to define an instruction that uses BadReg to get the diagnostic
def : InstAlias<"test $src", (TEST_PTRREG BadReg, PtrRegOperand:$src)>;
def MyTargetISA : InstrInfo;
def MyTarget : Target { let InstructionSet = MyTargetISA; }


//--- bad-not-regclass.td
include "Common/RegisterByHwModeCommon.td"
def FakeRegClass : RegisterClassLike;
def BadReg : RegisterByHwMode<FakeRegClass, [XPtr32, XPtr64, YPtr32, YPtr64], [X0, X0, X0, X0]>;
// BAD-NOT-VALID-REGCLASS: [[#@LINE-1]]:5: error: Register X0 for HwMode YPtr32 is not a member of register class YRegs
// BAD-NOT-VALID-REGCLASS: [[#@LINE-3]]:5: note: FakeRegClass defined here

// Need to define an instruction that uses BadReg to get the diagnostic
def : InstAlias<"test $src", (TEST_XREG BadReg, XRegs:$src)>;
def MyTargetISA : InstrInfo;
def MyTarget : Target { let InstructionSet = MyTargetISA; }