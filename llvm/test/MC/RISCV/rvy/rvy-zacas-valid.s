# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+a,+zabha,+zacas -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-Y,CHECK-ASM-RV32,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+a,+zabha,+zacas --defsym=RV64=1 -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-Y,CHECK-ASM-RV64,CHECK-ASM-RV64Y,CHECK,CHECK-RV64 %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+a,+zabha,+zacas < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+a,+zabha,+zacas -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+a,+zabha,+zacas --defsym=RV64=1 < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+a,+zabha,+zacas -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK,CHECK-RV64 %s
# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-zyhybrid,+a,+zabha,+zacas -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-HYBRID,CHECK-ASM-RV32,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-zyhybrid,+a,+zabha,+zacas --defsym=RV64=1 -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-HYBRID,CHECK-ASM-RV64,CHECK-ASM-RV64HYBRID,CHECK,CHECK-RV64 %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-zyhybrid,+a,+zabha,+zacas < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+a,+zabha,+zacas -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-zyhybrid,+a,+zabha,+zacas --defsym=RV64=1 < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zyhybrid,+a,+zabha,+zacas -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK,CHECK-RV64 %s

# CHECK: amocas.b a1, a3, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x85,0xd7,0x28]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.b a1, a3, (a5)
# CHECK-NEXT: amocas.b a1, a3, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x85,0xd7,0x28]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.b a1, a3, 0(a5)
# CHECK-NEXT: amocas.b.aq zero, zero, (a5)
# CHECK-ASM-SAME: encoding: [0x2f,0x80,0x07,0x2c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.b.aq zero, zero, (a5)
# CHECK-NEXT: amocas.b.rl zero, zero, (a5)
# CHECK-ASM-SAME: encoding: [0x2f,0x80,0x07,0x2a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.b.rl zero, zero, (a5)
# CHECK-NEXT: amocas.b.aqrl zero, zero, (a5)
# CHECK-ASM-SAME: encoding: [0x2f,0x80,0x07,0x2e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.b.aqrl zero, zero, (a5)
# CHECK-NEXT: amocas.h a0, a2, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0x95,0xc5,0x28]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.h a0, a2, (a1)
# CHECK-NEXT: amocas.h.aq zero, zero, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0x90,0x05,0x2c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.h.aq zero, zero, (a1)
# CHECK-NEXT: amocas.h.rl zero, zero, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0x90,0x05,0x2a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.h.rl zero, zero, (a1)
# CHECK-NEXT: amocas.h.aqrl zero, zero, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0x90,0x05,0x2e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.h.aqrl zero, zero, (a1)
# CHECK-NEXT: amocas.w a1, a3, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xa5,0xd7,0x28]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.w a1, a3, (a5)
# CHECK-NEXT: amocas.w.aq zero, zero, (a5)
# CHECK-ASM-SAME: encoding: [0x2f,0xa0,0x07,0x2c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.w.aq zero, zero, (a5)
# CHECK-NEXT: amocas.w.rl zero, zero, (a5)
# CHECK-ASM-SAME: encoding: [0x2f,0xa0,0x07,0x2a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.w.rl zero, zero, (a5)
# CHECK-NEXT: amocas.w.aqrl zero, zero, (a5)
# CHECK-ASM-SAME: encoding: [0x2f,0xa0,0x07,0x2e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOCAS_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X15>>
amocas.w.aqrl zero, zero, (a5)
# CHECK-NEXT: amocas.d a0, a2, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0xb5,0xc5,0x28]
# CHECK-ASM-RV32-NEXT: # <MCInst #[[#]] AMOCAS_D_RV32{{$}}
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X10_X11>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X10_X11>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X12_X13>
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_D_RV64{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X10>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X10>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.d a0, a2, (a1)
# CHECK-NEXT: amocas.d.aq zero, zero, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0xb0,0x05,0x2c]
# CHECK-ASM-RV32-NEXT: # <MCInst #[[#]] AMOCAS_D_RV32_AQ{{$}}
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_D_RV64_AQ{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.d.aq zero, zero, (a1)
# CHECK-NEXT: amocas.d.rl zero, zero, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0xb0,0x05,0x2a]
# CHECK-ASM-RV32-NEXT: # <MCInst #[[#]] AMOCAS_D_RV32_RL{{$}}
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_D_RV64_RL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.d.rl zero, zero, (a1)
# CHECK-NEXT: amocas.d.aqrl zero, zero, (a1)
# CHECK-ASM-SAME: encoding: [0x2f,0xb0,0x05,0x2e]
# CHECK-ASM-RV32-NEXT: # <MCInst #[[#]] AMOCAS_D_RV32_AQRL{{$}}
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV32-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_D_RV64_AQRL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0>
# CHECK-ASM-Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.d.aqrl zero, zero, (a1)
.ifdef RV64
# CHECK-RV64-NEXT: amocas.q a0, a2, (a1)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0xc5,0xc5,0x28]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_Q{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X10_X11>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X10_X11>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X12_X13>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.q a0, a2, (a1)
# CHECK-RV64-NEXT: amocas.q.aq zero, zero, (a1)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0xc0,0x05,0x2c]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_Q_AQ{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.q.aq zero, zero, (a1)
# CHECK-RV64-NEXT: amocas.q.rl zero, zero, (a1)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0xc0,0x05,0x2a]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_Q_RL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.q.rl zero, zero, (a1)
# CHECK-RV64-NEXT: amocas.q.aqrl zero, zero, (a1)
# CHECK-ASM-RV64-SAME: encoding: [0x2f,0xc0,0x05,0x2e]
# CHECK-ASM-RV64-NEXT: # <MCInst #[[#]] AMOCAS_Q_AQRL{{$}}
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64-NEXT: #  <MCOperand Reg:X0_Pair>
# CHECK-ASM-RV64Y-NEXT: #  <MCOperand Reg:X11_Y>>
# CHECK-ASM-RV64HYBRID-NEXT: #  <MCOperand Reg:X11>>
amocas.q.aqrl zero, zero, (a1)
.endif
