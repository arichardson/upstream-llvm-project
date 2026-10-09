// RUN: llvm-mc --triple=riscv32 --mattr=+zca,+experimental-y --defsym=CAP_MODE=1 --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP,CHECK-CAP-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+zca,+experimental-y --defsym=CAP_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+zca,+experimental-y --defsym=CAP_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP-ALIAS %s

// RUN: llvm-mc --triple=riscv64 --mattr=+zca,+experimental-y --defsym=CAP_MODE=1 --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP,CHECK-CAP-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+zca,+experimental-y --defsym=CAP_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+zca,+experimental-y --defsym=CAP_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP-ALIAS %s

// RUN: llvm-mc --triple=riscv32 --mattr=+zca,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INT,CHECK-INT-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+zca,+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-INT %s

// RUN: llvm-mc --triple=riscv64 --mattr=+zca,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INT,CHECK-INT-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+zca,+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-INT %s

///
/// In RVY capability pointer mode, ymv compresses to c.ymv (for non-zero
/// registers), while integer moves (addi rd, rs1, 0 / add rd, x0, rs2) must
/// not compress because they clear capability metadata and tag.
///

// CHECK-CAP: c.ymv a1, a0
// CHECK-CAP-ALIAS: ymv a1, a0
// CHECK-CAP-ASM-SAME: # encoding: [0xaa,0x85]
// CHECK-CAP-ASM-NEXT: # <MCInst #[[#]] C_YMV{{$}}
// CHECK-CAP-ASM-NEXT: #  <MCOperand Reg:X11_Y>
// CHECK-CAP-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
// CHECK-INT: ymv a1, a0
// CHECK-INT-ASM-SAME: # encoding: [0xfb,0x05,0x05,0x06]
// CHECK-INT-ASM-NEXT: # <MCInst #[[#]] YMV{{$}}
// CHECK-INT-ASM-NEXT: #  <MCOperand Reg:X11_Y>
// CHECK-INT-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
ymv a1, a0

// CHECK-CAP: ymv a1, zero
// CHECK-CAP-ALIAS: ymv a1, zero
// CHECK-CAP-ASM-SAME: # encoding: [0xfb,0x05,0x00,0x06]
// CHECK-INT: ymv a1, zero
// CHECK-INT-ASM-SAME: # encoding: [0xfb,0x05,0x00,0x06]
ymv a1, zero

// CHECK-CAP: ymv zero, a0
// CHECK-CAP-ALIAS: ymv zero, a0
// CHECK-CAP-ASM-SAME: # encoding: [0x7b,0x00,0x05,0x06]
// CHECK-INT: ymv zero, a0
// CHECK-INT-ASM-SAME: # encoding: [0x7b,0x00,0x05,0x06]
ymv zero, a0

// CHECK-CAP: addi a1, a0, 0
// CHECK-CAP-ALIAS: mv a1, a0
// CHECK-CAP-ASM-SAME: # encoding: [0x93,0x05,0x05,0x00]
// CHECK-CAP-ASM-NEXT: # <MCInst #[[#]] ADDI{{$}}
// CHECK-INT: c.mv a1, a0
// CHECK-INT-ASM-SAME: # encoding: [0xaa,0x85]
// CHECK-INT-ASM-NEXT: # <MCInst #[[#]] C_MV{{$}}
// CHECK-INT-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-INT-ASM-NEXT: #  <MCOperand Reg:X10>>
addi a1, a0, 0

// CHECK-CAP: add a1, zero, a0
// CHECK-CAP-ALIAS: add a1, zero, a0
// CHECK-CAP-ASM-SAME: # encoding: [0xb3,0x05,0xa0,0x00]
// CHECK-CAP-ASM-NEXT: # <MCInst #[[#]] ADD{{$}}
// CHECK-INT: c.mv a1, a0
// CHECK-INT-ASM-SAME: # encoding: [0xaa,0x85]
// CHECK-INT-ASM-NEXT: # <MCInst #[[#]] C_MV{{$}}
add a1, zero, a0

// CHECK-CAP: add a1, a0, zero
// CHECK-CAP-ALIAS: add a1, a0, zero
// CHECK-CAP-ASM-SAME: # encoding: [0xb3,0x05,0x05,0x00]
// CHECK-CAP-ASM-NEXT: # <MCInst #[[#]] ADD{{$}}
// CHECK-INT: c.mv a1, a0
// CHECK-INT-ASM-SAME: # encoding: [0xaa,0x85]
// CHECK-INT-ASM-NEXT: # <MCInst #[[#]] C_MV{{$}}
add a1, a0, zero

.ifdef CAP_MODE
// CHECK-CAP: c.ymv a2, a0
// CHECK-CAP-ALIAS: ymv a2, a0
// CHECK-CAP-ASM-SAME: # encoding: [0x2a,0x86]
// CHECK-CAP-ASM-NEXT: # <MCInst #[[#]] C_YMV{{$}}
// CHECK-CAP-ASM-NEXT: #  <MCOperand Reg:X12_Y>
// CHECK-CAP-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
c.ymv a2, a0
.else
// CHECK-INT: c.mv a2, a0
// CHECK-INT-ASM-SAME: # encoding: [0x2a,0x86]
// CHECK-INT-ASM-NEXT: # <MCInst #[[#]] C_MV{{$}}
// CHECK-INT-ASM-NEXT: #  <MCOperand Reg:X12>
// CHECK-INT-ASM-NEXT: #  <MCOperand Reg:X10>>
c.mv a2, a0
.endif
