// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+zba --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+zba --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefix=CHECK
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid,+zba --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid,+zba --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefix=CHECK

slli.uw t0, t1, 0
// CHECK: slli.uw	t0, t1, 0
// CHECK-ASM-SAME: # encoding: [0x9b,0x12,0x03,0x08]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SLLI_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
add.uw t0, t1, t2
// CHECK: add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xbb,0x02,0x73,0x08]
// CHECK-ASM-NEXT: # <MCInst #[[#]] ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>
zext.w t0, t1
// CHECK: add.uw	t0, t1, zero
// CHECK-ASM-SAME: # encoding: [0xbb,0x02,0x03,0x08]
// CHECK-ASM-NEXT: # <MCInst #[[#]] ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0>>
sh1add.uw t0, t1, t2
// CHECK: sh1add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xbb,0x22,0x73,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH1ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>
sh2add.uw t0, t1, t2
// CHECK: sh2add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xbb,0x42,0x73,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH2ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>
sh3add.uw t0, t1, t2
// CHECK: sh3add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xbb,0x62,0x73,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH3ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7>>

ysh4add t0, t1, t2
// CHECK: ysh4add	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x3a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH4ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh1add.uw t0, t1, t2
// CHECK: ysh1add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x4a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH1ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh2add.uw t0, t1, t2
// CHECK: ysh2add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x5a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH2ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh3add.uw t0, t1, t2
// CHECK: ysh3add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x6a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH3ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh4add.uw t0, t1, t2
// CHECK: ysh4add.uw	t0, t1, t2
// CHECK-ASM-SAME: # encoding: [0xfb,0x02,0x73,0x7a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH4ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
ysh4add a0, zero, a1
// CHECK: ysh4add	a0, zero, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xb0,0x3a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH4ADD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11_Y>>
ysh1add.uw a0, zero, a1
// CHECK: ysh1add.uw	a0, zero, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x05,0xb0,0x4a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH1ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11_Y>>
ysh2add.uw a0, a1, zero
// CHECK: ysh2add.uw	a0, a1, zero
// CHECK-ASM-SAME: # encoding: [0x7b,0x85,0x05,0x5a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH2ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0_Y>>
ysh3add.uw zero, a0, a1
// CHECK: ysh3add.uw	zero, a0, a1
// CHECK-ASM-SAME: # encoding: [0x7b,0x00,0xb5,0x6a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH3ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11_Y>>
ysh4add.uw a0, a1, a2
// CHECK: ysh4add.uw	a0, a1, a2
// CHECK-ASM-SAME: # encoding: [0x7b,0x85,0xc5,0x7a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] YSH4ADD_UW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X12_Y>>
