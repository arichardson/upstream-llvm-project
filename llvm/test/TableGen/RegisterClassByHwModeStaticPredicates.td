// RUN: not llvm-tblgen -gen-asm-matcher -I %p/../../include -I %S %s -o /dev/null 2>&1 | FileCheck %s
include "Common/RegisterByHwModeCommon.td"

/// Ideally we would be able to allow the following code since the
/// predicates statically resolve to the correct register class, but since this
/// is non-trivial, check that we get a sensible-ish error instead.
// The Predicate here means it always uses XRegs, so X0 should actually be fine.
let Predicates = [UseXRegForPtr] in
def MY_TEST_PTR_ALIAS_X : InstAlias<"test_ptr $src", (TEST_PTRREG X0, PtrRC:$src)>;
// CHECK: [[#@LINE-1]]:5: error: cannot resolve HwMode for PtrRC
// CHECK: RegisterByHwModeCommon.td:50:5: note: PtrRC defined here
let Predicates = [UseYRegForPtr] in
def MY_TEST_PTR_ALIAS_Y : InstAlias<"test_ptr $src", (TEST_PTRREG Y0, PtrRC:$src)>;

def MyTargetISA : InstrInfo;
def MyTarget : Target { let InstructionSet = MyTargetISA; }
