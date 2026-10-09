# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+experimental-zabhlrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-Y,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+experimental-zabhlrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-Y,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+experimental-zabhlrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+experimental-zabhlrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+experimental-zabhlrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+experimental-zabhlrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-zyhybrid,+experimental-zabhlrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-HYBRID,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-zyhybrid,+experimental-zabhlrsc -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-HYBRID,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-zyhybrid,+experimental-zabhlrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+experimental-zabhlrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-zyhybrid,+experimental-zabhlrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+experimental-zabhlrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s

# CHECK: lr.b t0, (t1)
# CHECK-ASM-SAME: encoding: [0xaf,0x02,0x03,0x10]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X6_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X6>>
lr.b t0, (t1)
# CHECK-NEXT: lr.b.aq t1, (t2)
# CHECK-ASM-SAME: encoding: [0x2f,0x83,0x03,0x14]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X7_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X7>>
lr.b.aq t1, (t2)
# CHECK-NEXT: lr.b.rl t2, (t3)
# CHECK-ASM-SAME: encoding: [0xaf,0x03,0x0e,0x12]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X28_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X28>>
lr.b.rl t2, (t3)
# CHECK-NEXT: lr.b.aqrl t3, (t4)
# CHECK-ASM-SAME: encoding: [0x2f,0x8e,0x0e,0x16]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X29_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X29>>
lr.b.aqrl t3, (t4)
#
# CHECK-NEXT: sc.b t6, t5, (t4)
# CHECK-ASM-SAME: encoding: [0xaf,0x8f,0xee,0x19]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X31>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X29_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X29>>
sc.b t6, t5, (t4)
# CHECK-NEXT: sc.b.aq t5, t4, (t3)
# CHECK-ASM-SAME: encoding: [0x2f,0x0f,0xde,0x1d]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X28_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X28>>
sc.b.aq t5, t4, (t3)
# CHECK-NEXT: sc.b.rl t4, t3, (t2)
# CHECK-ASM-SAME: encoding: [0xaf,0x8e,0xc3,0x1b]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X7_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X7>>
sc.b.rl t4, t3, (t2)
# CHECK-NEXT: sc.b.aqrl t3, t2, (t1)
# CHECK-ASM-SAME: encoding: [0x2f,0x0e,0x73,0x1e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X6_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X6>>
sc.b.aqrl t3, t2, (t1)
#
# CHECK-NEXT: lr.h t0, (t1)
# CHECK-ASM-SAME: encoding: [0xaf,0x12,0x03,0x10]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X5>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X6_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X6>>
lr.h t0, (t1)
# CHECK-NEXT: lr.h.aq t1, (t2)
# CHECK-ASM-SAME: encoding: [0x2f,0x93,0x03,0x14]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X7_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X7>>
lr.h.aq t1, (t2)
# CHECK-NEXT: lr.h.rl t2, (t3)
# CHECK-ASM-SAME: encoding: [0xaf,0x13,0x0e,0x12]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X28_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X28>>
lr.h.rl t2, (t3)
# CHECK-NEXT: lr.h.aqrl t3, (t4)
# CHECK-ASM-SAME: encoding: [0x2f,0x9e,0x0e,0x16]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LR_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X29_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X29>>
lr.h.aqrl t3, (t4)
#
# CHECK-NEXT: sc.h t6, t5, (t4)
# CHECK-ASM-SAME: encoding: [0xaf,0x9f,0xee,0x19]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X31>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X29_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X29>>
sc.h t6, t5, (t4)
# CHECK-NEXT: sc.h.aq t5, t4, (t3)
# CHECK-ASM-SAME: encoding: [0x2f,0x1f,0xde,0x1d]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X30>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X28_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X28>>
sc.h.aq t5, t4, (t3)
# CHECK-NEXT: sc.h.rl t4, t3, (t2)
# CHECK-ASM-SAME: encoding: [0xaf,0x9e,0xc3,0x1b]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X29>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X7_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X7>>
sc.h.rl t4, t3, (t2)
# CHECK-NEXT: sc.h.aqrl t3, t2, (t1)
# CHECK-ASM-SAME: encoding: [0x2f,0x1e,0x73,0x1e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SC_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X28>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X7>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X6_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X6>>
sc.h.aqrl t3, t2, (t1)
