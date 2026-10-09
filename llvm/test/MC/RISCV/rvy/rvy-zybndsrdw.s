// RUN: split-file %s %t
// RUN: llvm-mc %t/valid.s -triple=riscv32 -mattr=+experimental-y,+experimental-zybndsrdw -M no-aliases --show-encoding --show-inst \
// RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %t/valid.s
// RUN: llvm-mc %t/valid.s -triple=riscv64 -mattr=+experimental-y,+experimental-zybndsrdw -M no-aliases --show-encoding --show-inst \
// RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %t/valid.s
// RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+experimental-zybndsrdw < %t/valid.s \
// RUN:     | llvm-objdump --mattr=+experimental-y,+experimental-zybndsrdw -M no-aliases -d -r - \
// RUN:     | FileCheck --check-prefix=CHECK %t/valid.s
// RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+experimental-zybndsrdw < %t/valid.s \
// RUN:     | llvm-objdump --mattr=+experimental-y,+experimental-zybndsrdw -M no-aliases -d -r - \
// RUN:     | FileCheck --check-prefix=CHECK %t/valid.s
// RUN: llvm-mc %t/valid.s -triple=riscv32 -mattr=+experimental-zyhybrid,+experimental-zybndsrdw -M no-aliases --show-encoding --show-inst \
// RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %t/valid.s
// RUN: llvm-mc %t/valid.s -triple=riscv64 -mattr=+experimental-zyhybrid,+experimental-zybndsrdw -M no-aliases --show-encoding --show-inst \
// RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %t/valid.s
// RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-zyhybrid,+experimental-zybndsrdw < %t/valid.s \
// RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+experimental-zybndsrdw -M no-aliases -d -r - \
// RUN:     | FileCheck --check-prefix=CHECK %t/valid.s
// RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-zyhybrid,+experimental-zybndsrdw < %t/valid.s \
// RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+experimental-zybndsrdw -M no-aliases -d -r - \
// RUN:     | FileCheck --check-prefix=CHECK %t/valid.s
// RUN: not llvm-mc %t/valid.s -triple=riscv32 -mattr=+experimental-y 2>&1 \
// RUN:     | FileCheck --check-prefix=CHECK-NO-EXT %t/valid.s --implicit-check-not=error:
// RUN: not llvm-mc %t/valid.s -triple=riscv64 -mattr=+experimental-zyhybrid 2>&1 \
// RUN:     | FileCheck --check-prefix=CHECK-NO-EXT %t/valid.s --implicit-check-not=error:
// RUN: not llvm-mc %t/invalid.s -triple=riscv64 -mattr=+experimental-y,+experimental-zybndsrdw 2>&1 \
// RUN:     | FileCheck --check-prefix=CHECK-INVALID %t/invalid.s --implicit-check-not=error:

//--- valid.s
// CHECK: ybndsrdw a0, a1, a2
// CHECK-ASM-SAME: encoding: [0x7b,0x85,0xc5,0x66]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YBNDSRDW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X12>>
// CHECK-NO-EXT: :[[@LINE+1]]:1: error: instruction requires the following: 'Zybndsrdw' (CHERI Bounding to Representable Lengths){{$}}
ybndsrdw a0, a1, a2
// CHECK-NEXT: ybndsrdw zero, zero, zero
// CHECK-ASM-SAME: encoding: [0x7b,0x00,0x00,0x66]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YBNDSRDW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0>>
// CHECK-NO-EXT: :[[@LINE+1]]:1: error: instruction requires the following: 'Zybndsrdw' (CHERI Bounding to Representable Lengths){{$}}
ybndsrdw zero, zero, zero

//--- invalid.s
// CHECK-INVALID: :[[@LINE+1]]:18: error: register must be a GPR
ybndsrdw a0, a1, 16
// CHECK-INVALID: :[[@LINE+1]]:16: error: too few operands for instruction
ybndsrdw a0, a1
