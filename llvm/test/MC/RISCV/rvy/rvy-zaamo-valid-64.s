# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+a -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zaamo -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zaamo < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+zaamo -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefixes=CHECK %s
#
# RUN: not llvm-mc -triple riscv32 -mattr=+experimental-y,+cap-mode,+a < %s 2>&1 \
# RUN:     | FileCheck -check-prefix=CHECK-RV32 %s --implicit-check-not=error:
# RUN: not llvm-mc -triple riscv32 -mattr=+experimental-y,+cap-mode,+zaamo < %s 2>&1 \
# RUN:     | FileCheck -check-prefix=CHECK-RV32 %s --implicit-check-not=error:

# CHECK: amoadd.d a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xb5,0xc6,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
AMOADD.d a1, a2, (a3)
# CHECK-NEXT: amoxor.d a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x36,0xd7,0x20]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoxor.d a2, a3, (a4)
# CHECK-NEXT: amoand.d a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xb6,0xe7,0x60]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoand.d a3, a4, (a5)
# CHECK-NEXT: amoor.d a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0xf8,0x40]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoor.d a4, a5, (a6)
# CHECK-NEXT: amomin.d a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xb7,0x08,0x81]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomin.d a5, a6, (a7)
# CHECK-NEXT: amomax.d s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xbb,0x6a,0xa1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomax.d s7, s6, (s5)
# CHECK-NEXT: amominu.d s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x3b,0x5a,0xc1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amominu.d s6, s5, (s4)
# CHECK-NEXT: amomaxu.d s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xba,0x49,0xe1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_D{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomaxu.d s5, s4, (s3)
# CHECK-NEXT: amoswap.d.aq a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0x14,0x0c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoswap.d.aq a4, ra, (s0)
# CHECK-NEXT: amoadd.d.aq a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xb5,0xc6,0x04]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoadd.d.aq a1, a2, (a3)
# CHECK-NEXT: amoxor.d.aq a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x36,0xd7,0x24]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoxor.d.aq a2, a3, (a4)
# CHECK-NEXT: amoand.d.aq a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xb6,0xe7,0x64]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoand.d.aq a3, a4, (a5)
# CHECK-NEXT: amoor.d.aq a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0xf8,0x44]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoor.d.aq a4, a5, (a6)
# CHECK-NEXT: amomin.d.aq a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xb7,0x08,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomin.d.aq a5, a6, (a7)
# CHECK-NEXT: amomax.d.aq s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xbb,0x6a,0xa5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomax.d.aq s7, s6, (s5)
# CHECK-NEXT: amominu.d.aq s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x3b,0x5a,0xc5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amominu.d.aq s6, s5, (s4)
# CHECK-NEXT: amomaxu.d.aq s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xba,0x49,0xe5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_D_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomaxu.d.aq s5, s4, (s3)
# CHECK-NEXT: amoswap.d.rl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0x14,0x0a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoswap.d.rl a4, ra, (s0)
# CHECK-NEXT: amoadd.d.rl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xb5,0xc6,0x02]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoadd.d.rl a1, a2, (a3)
# CHECK-NEXT: amoxor.d.rl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x36,0xd7,0x22]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoxor.d.rl a2, a3, (a4)
# CHECK-NEXT: amoand.d.rl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xb6,0xe7,0x62]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoand.d.rl a3, a4, (a5)
# CHECK-NEXT: amoor.d.rl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0xf8,0x42]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoor.d.rl a4, a5, (a6)
# CHECK-NEXT: amomin.d.rl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xb7,0x08,0x83]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomin.d.rl a5, a6, (a7)
# CHECK-NEXT: amomax.d.rl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xbb,0x6a,0xa3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomax.d.rl s7, s6, (s5)
# CHECK-NEXT: amominu.d.rl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x3b,0x5a,0xc3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amominu.d.rl s6, s5, (s4)
# CHECK-NEXT: amomaxu.d.rl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xba,0x49,0xe3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_D_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomaxu.d.rl s5, s4, (s3)
# CHECK-NEXT: amoswap.d.aqrl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0x14,0x0e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoswap.d.aqrl a4, ra, (s0)
# CHECK-NEXT: amoadd.d.aqrl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xb5,0xc6,0x06]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoadd.d.aqrl a1, a2, (a3)
# CHECK-NEXT: amoxor.d.aqrl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x36,0xd7,0x26]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoxor.d.aqrl a2, a3, (a4)
# CHECK-NEXT: amoand.d.aqrl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xb6,0xe7,0x66]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoand.d.aqrl a3, a4, (a5)
# CHECK-NEXT: amoor.d.aqrl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x37,0xf8,0x46]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amoor.d.aqrl a4, a5, (a6)
# CHECK-NEXT: amomin.d.aqrl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xb7,0x08,0x87]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomin.d.aqrl a5, a6, (a7)
# CHECK-NEXT: amomax.d.aqrl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xbb,0x6a,0xa7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomax.d.aqrl s7, s6, (s5)
# CHECK-NEXT: amominu.d.aqrl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x3b,0x5a,0xc7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amominu.d.aqrl s6, s5, (s4)
# CHECK-NEXT: amomaxu.d.aqrl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xba,0x49,0xe7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_D_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
# CHECK-RV32: :[[@LINE+1]]:1: error: instruction requires the following: RV64I Base Instruction Set{{$}}
amomaxu.d.aqrl s5, s4, (s3)
