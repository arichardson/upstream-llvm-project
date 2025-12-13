# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+a -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zalrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zalrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+zalrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
#
# RUN: not llvm-mc -triple riscv32 -mattr=+experimental-y,+cap-mode,+a < %s 2>&1 \
# RUN:     | FileCheck -check-prefix=CHECK-RV32 %s
# RUN: not llvm-mc -triple riscv32 -mattr=+experimental-y,+cap-mode,+zalrsc < %s 2>&1 \
# RUN:     | FileCheck -check-prefix=CHECK-RV32 %s

# CHECK: lr.d t0, (t1)
# CHECK-ASM-SAME: encoding: [0xaf,0x32,0x03,0x10]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_D
# CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
lr.d t0, (t1)
# CHECK-NEXT: lr.d.aq t1, (t2)
# CHECK-ASM-SAME: encoding: [0x2f,0xb3,0x03,0x14]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_D_AQ
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
lr.d.aq t1, (t2)
# CHECK-NEXT: lr.d.rl t2, (t3)
# CHECK-ASM-SAME: encoding: [0xaf,0x33,0x0e,0x12]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_D_RL
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
lr.d.rl t2, (t3)
# CHECK-NEXT: lr.d.aqrl t3, (t4)
# CHECK-ASM-SAME: encoding: [0x2f,0xbe,0x0e,0x16]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_D_AQRL
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
lr.d.aqrl t3, (t4)
#
# CHECK-NEXT: sc.d t6, t5, (t4)
# CHECK-ASM-SAME: encoding: [0xaf,0xbf,0xee,0x19]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_D
# CHECK-ASM-NEXT: #  <MCOperand Reg:X31>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
sc.d t6, t5, (t4)
# CHECK-NEXT: sc.d.aq t5, t4, (t3)
# CHECK-ASM-SAME: encoding: [0x2f,0x3f,0xde,0x1d]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_D_AQ
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
sc.d.aq t5, t4, (t3)
# CHECK-NEXT: sc.d.rl t4, t3, (t2)
# CHECK-ASM-SAME: encoding: [0xaf,0xbe,0xc3,0x1b]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_D_RL
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
sc.d.rl t4, t3, (t2)
# CHECK-NEXT: sc.d.aqrl t3, t2, (t1)
# CHECK-ASM-SAME: encoding: [0x2f,0x3e,0x73,0x1e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_D_AQRL
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set
sc.d.aqrl t3, t2, (t1)
