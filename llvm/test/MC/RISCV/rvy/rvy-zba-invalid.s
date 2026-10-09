// RUN: not llvm-mc --triple riscv32 --mattr=+experimental-y,+zba --defsym=RV32=1 <%s 2>&1 \
// RUN:   | FileCheck %s --check-prefixes=CHECK,CHECK-RV32 --implicit-check-not=error:
// RUN: not llvm-mc --triple riscv64 --mattr=+experimental-y,+zba <%s 2>&1 \
// RUN:   | FileCheck %s --check-prefixes=CHECK --implicit-check-not=error:
// RUN: not llvm-mc --triple riscv64 --mattr=+experimental-y --defsym=NO_ZBA=1 <%s 2>&1 \
// RUN:   | FileCheck %s --check-prefixes=CHECK-NO-ZBA --implicit-check-not=error:
// RUN: not llvm-mc --triple riscv64 --mattr=+zba --defsym=NO_Y=1 <%s 2>&1 \
// RUN:   | FileCheck %s --check-prefixes=CHECK-NO-Y --implicit-check-not=error:

.ifndef NO_ZBA
.ifndef NO_Y
/// Too few operands
ysh1add t0, t1
// CHECK: :[[#@LINE-1]]:15: error: too few operands for instruction
ysh2add t0, t1
// CHECK: :[[#@LINE-1]]:15: error: too few operands for instruction
ysh3add t0, t1
// CHECK: :[[#@LINE-1]]:15: error: too few operands for instruction

/// Invalid operand types
ysh1add f0, t1, t2
// CHECK: :[[#@LINE-1]]:9: error: register must be a GPR
ysh1add t0, f0, t2
// CHECK: :[[#@LINE-1]]:13: error: register must be a GPR
ysh1add t0, t1, f0
// CHECK: :[[#@LINE-1]]:17: error: register must be a GPR
ysh2add t0, t1, 1
// CHECK: :[[#@LINE-1]]:17: error: register must be a GPR

/// There is no yadd.uw or yslli.uw in RVY
yadd.uw t0, t1, t2
// CHECK: :[[#@LINE-1]]:1: error: unrecognized instruction mnemonic
yslli.uw t0, t1, 0
// CHECK: :[[#@LINE-1]]:1: error: unrecognized instruction mnemonic
.endif
.endif

.ifdef RV32
/// RV64-only instructions
ysh4add t0, t1, t2
// CHECK-RV32: :[[#@LINE-1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
ysh1add.uw t0, t1, t2
// CHECK-RV32: :[[#@LINE-1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
ysh2add.uw t0, t1, t2
// CHECK-RV32: :[[#@LINE-1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
ysh3add.uw t0, t1, t2
// CHECK-RV32: :[[#@LINE-1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
ysh4add.uw t0, t1, t2
// CHECK-RV32: :[[#@LINE-1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
.endif

.ifdef NO_ZBA
ysh1add t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh2add t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh3add t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh4add t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh1add.uw t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh2add.uw t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh3add.uw t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
ysh4add.uw t0, t1, t2
// CHECK-NO-ZBA: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zba' (Address Generation Instructions){{$}}
.endif

.ifdef NO_Y
ysh1add t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh2add t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh3add t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh4add t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh1add.uw t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh2add.uw t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh3add.uw t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
ysh4add.uw t0, t1, t2
// CHECK-NO-Y: :[[#@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
.endif
