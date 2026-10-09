// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+zba --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+zba --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefix=CHECK
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+zba --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+zba --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefix=CHECK
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-zyhybrid,+zba --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-zyhybrid,+zba --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefix=CHECK
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid,+zba --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid,+zba --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefix=CHECK

sh1add t0, t1, t2
// CHECK: sh1add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xb3,0x22,0x73,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH1ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>
sh2add t0, t1, t2
// CHECK: sh2add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xb3,0x42,0x73,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH2ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>
sh3add t0, t1, t2
// CHECK: sh3add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xb3,0x62,0x73,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH3ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>

ysh1add t0, t1, t2
// CHECK: ysh1add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x0a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH1ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh2add t0, t1, t2
// CHECK: ysh2add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x1a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH2ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh3add t0, t1, t2
// CHECK: ysh3add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x2a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH3ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh1add a0, zero, a1
// CHECK: ysh1add	a0, zero, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xb0,0x0a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH1ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11_Y>>
ysh2add a0, a1, zero
// CHECK: ysh2add	a0, a1, zero
// CHECK-ASM-SAME: # encoding: [0x7b,0x85,0x05,0x1a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH2ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0_Y>>
ysh3add zero, a0, a1
// CHECK: ysh3add	zero, a0, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x00,0xb5,0x2a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH3ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11_Y>>
