# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+cap-mode,+a -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+cap-mode,+a < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+a -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+a -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+cap-mode,+zalrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zalrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+cap-mode,+zalrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+zalrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zalrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+zalrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s

# CHECK: lr.w t0, (t1)
# CHECK-ASM-SAME: encoding: [0xaf,0x22,0x03,0x10]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6_Y>>
lr.w t0, (t1)
# CHECK-NEXT: lr.w.aq t1, (t2)
# CHECK-ASM-SAME: encoding: [0x2f,0xa3,0x03,0x14]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
lr.w.aq t1, (t2)
# CHECK-NEXT: lr.w.rl t2, (t3)
# CHECK-ASM-SAME: encoding: [0xaf,0x23,0x0e,0x12]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28_Y>>
lr.w.rl t2, (t3)
# CHECK-NEXT: lr.w.aqrl t3, (t4)
# CHECK-ASM-SAME: encoding: [0x2f,0xae,0x0e,0x16]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29_Y>>
lr.w.aqrl t3, (t4)
#
# CHECK-NEXT: sc.w t6, t5, (t4)
# CHECK-ASM-SAME: encoding: [0xaf,0xaf,0xee,0x19]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X31>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29_Y>>
sc.w t6, t5, (t4)
# CHECK-NEXT: sc.w.aq t5, t4, (t3)
# CHECK-ASM-SAME: encoding: [0x2f,0x2f,0xde,0x1d]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28_Y>>
sc.w.aq t5, t4, (t3)
# CHECK-NEXT: sc.w.rl t4, t3, (t2)
# CHECK-ASM-SAME: encoding: [0xaf,0xae,0xc3,0x1b]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
sc.w.rl t4, t3, (t2)
# CHECK-NEXT: sc.w.aqrl t3, t2, (t1)
# CHECK-ASM-SAME: encoding: [0x2f,0x2e,0x73,0x1e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6_Y>>
sc.w.aqrl t3, t2, (t1)
