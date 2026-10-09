# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+zalasr -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-Y,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+zalasr --defsym=RV64=1 -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-Y,CHECK-ASM-RV64,CHECK-ASM-RV64Y,CHECK,CHECK-RV64 %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+zalasr < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+zalasr -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+zalasr --defsym=RV64=1 < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+zalasr -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK,CHECK-RV64 %s
# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-zyhybrid,+zalasr -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-HYBRID,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-zyhybrid,+zalasr --defsym=RV64=1 -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-HYBRID,CHECK-ASM-RV64,CHECK-ASM-RV64HYBRID,CHECK,CHECK-RV64 %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-zyhybrid,+zalasr < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+zalasr -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-zyhybrid,+zalasr --defsym=RV64=1 < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+zalasr -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK,CHECK-RV64 %s

# CHECK: lb.aq t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x03,0x05,0x34]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LB_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
lb.aq t1, 0(a0)
# CHECK-NEXT: lh.aq t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x13,0x05,0x34]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LH_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
lh.aq t1, 0(a0)
# CHECK-NEXT: lw.aq t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x23,0x05,0x34]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LW_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
lw.aq t1, (a0)
# CHECK-NEXT: lb.aqrl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x03,0x05,0x36]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LB_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
lb.aqrl t1, 0(a0)
# CHECK-NEXT: lh.aqrl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x13,0x05,0x36]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LH_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
lh.aqrl t1, (a0)
# CHECK-NEXT: lw.aqrl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x23,0x05,0x36]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LW_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
lw.aqrl t1, (a0)
# CHECK-NEXT: sb.rl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x00,0x65,0x3a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SB_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
sb.rl t1, (a0)
# CHECK-NEXT: sh.rl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x10,0x65,0x3a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SH_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
sh.rl t1, 0(a0)
# CHECK-NEXT: sw.rl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x20,0x65,0x3a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SW_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
sw.rl t1, (a0)
# CHECK-NEXT: sb.aqrl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x00,0x65,0x3e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SB_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
sb.aqrl t1, (a0)
# CHECK-NEXT: sh.aqrl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x10,0x65,0x3e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SH_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
sh.aqrl t1, 0(a0)
# CHECK-NEXT: sw.aqrl t1, (a0)
# CHECK-ASM-SAME: encoding: [0x2f,0x20,0x65,0x3e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SW_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X10>>
sw.aqrl t1, 0(a0)
.ifdef RV64
# CHECK-RV64-NEXT: ld.aq t1, (a0)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0x33,0x05,0x34]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] LD_AQ{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X10>>
ld.aq t1, (a0)
# CHECK-RV64-NEXT: ld.aqrl t1, (a0)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0x33,0x05,0x36]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] LD_AQRL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X10>>
ld.aqrl t1, 0(a0)
# CHECK-RV64-NEXT: sd.rl t1, (a0)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0x30,0x65,0x3a]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] SD_RL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X10>>
sd.rl t1, 0(a0)
# CHECK-RV64-NEXT: sd.aqrl t1, (a0)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0x30,0x65,0x3e]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] SD_AQRL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X6>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X10_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X10>>
sd.aqrl t1, (a0)
.endif
