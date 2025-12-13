# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+cap-mode,+a,+zabha -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a,+zabha -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+cap-mode,+a,+zabha < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+a,+zabha -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+a,+zabha < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+a,+zabha -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s

# CHECK: amoswap.b a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0x14,0x08]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.b a4, ra, (s0)
# CHECK-NEXT: amoadd.b a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x85,0xc6,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.b a1, a2, (a3)
# CHECK-NEXT: amoxor.b a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x06,0xd7,0x20]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.b a2, a3, (a4)
# CHECK-NEXT: amoand.b a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x86,0xe7,0x60]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.b a3, a4, (a5)
# CHECK-NEXT: amoor.b a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0xf8,0x40]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.b a4, a5, (a6)
# CHECK-NEXT: amomin.b a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x87,0x08,0x81]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.b a5, a6, (a7)
# CHECK-NEXT: amomax.b s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x8b,0x6a,0xa1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.b s7, s6, (s5)
# CHECK-NEXT: amominu.b s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x0b,0x5a,0xc1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.b s6, s5, (s4)
# CHECK-NEXT: amomaxu.b s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x8a,0x49,0xe1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_B{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.b s5, s4, (s3)
#
# CHECK-NEXT: amoswap.b.aq a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0x14,0x0c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.b.aq a4, ra, (s0)
# CHECK-NEXT: amoadd.b.aq a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x85,0xc6,0x04]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.b.aq a1, a2, (a3)
# CHECK-NEXT: amoxor.b.aq a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x06,0xd7,0x24]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.b.aq a2, a3, (a4)
# CHECK-NEXT: amoand.b.aq a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x86,0xe7,0x64]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.b.aq a3, a4, (a5)
# CHECK-NEXT: amoor.b.aq a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0xf8,0x44]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.b.aq a4, a5, (a6)
# CHECK-NEXT: amomin.b.aq a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x87,0x08,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.b.aq a5, a6, (a7)
# CHECK-NEXT: amomax.b.aq s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x8b,0x6a,0xa5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.b.aq s7, s6, (s5)
# CHECK-NEXT: amominu.b.aq s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x0b,0x5a,0xc5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.b.aq s6, s5, (s4)
# CHECK-NEXT: amomaxu.b.aq s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x8a,0x49,0xe5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_B_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.b.aq s5, s4, (s3)
#
# CHECK-NEXT: amoswap.b.rl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0x14,0x0a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.b.rl a4, ra, (s0)
# CHECK-NEXT: amoadd.b.rl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x85,0xc6,0x02]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.b.rl a1, a2, (a3)
# CHECK-NEXT: amoxor.b.rl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x06,0xd7,0x22]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.b.rl a2, a3, (a4)
# CHECK-NEXT: amoand.b.rl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x86,0xe7,0x62]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.b.rl a3, a4, (a5)
# CHECK-NEXT: amoor.b.rl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0xf8,0x42]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.b.rl a4, a5, (a6)
# CHECK-NEXT: amomin.b.rl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x87,0x08,0x83]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.b.rl a5, a6, (a7)
# CHECK-NEXT: amomax.b.rl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x8b,0x6a,0xa3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.b.rl s7, s6, (s5)
# CHECK-NEXT: amominu.b.rl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x0b,0x5a,0xc3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.b.rl s6, s5, (s4)
# CHECK-NEXT: amomaxu.b.rl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x8a,0x49,0xe3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_B_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.b.rl s5, s4, (s3)
#
# CHECK-NEXT: amoswap.b.aqrl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0x14,0x0e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.b.aqrl a4, ra, (s0)
# CHECK-NEXT: amoadd.b.aqrl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x85,0xc6,0x06]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.b.aqrl a1, a2, (a3)
# CHECK-NEXT: amoxor.b.aqrl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x06,0xd7,0x26]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.b.aqrl a2, a3, (a4)
# CHECK-NEXT: amoand.b.aqrl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x86,0xe7,0x66]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.b.aqrl a3, a4, (a5)
# CHECK-NEXT: amoor.b.aqrl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x07,0xf8,0x46]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.b.aqrl a4, a5, (a6)
# CHECK-NEXT: amomin.b.aqrl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x87,0x08,0x87]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.b.aqrl a5, a6, (a7)
# CHECK-NEXT: amomax.b.aqrl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x8b,0x6a,0xa7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.b.aqrl s7, s6, (s5)
# CHECK-NEXT: amominu.b.aqrl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x0b,0x5a,0xc7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.b.aqrl s6, s5, (s4)
# CHECK-NEXT: amomaxu.b.aqrl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x8a,0x49,0xe7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_B_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.b.aqrl s5, s4, (s3)
#
# CHECK-NEXT: amoswap.h a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0x14,0x08]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.h a4, ra, (s0)
# CHECK-NEXT: amoadd.h a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x95,0xc6,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.h a1, a2, (a3)
# CHECK-NEXT: amoxor.h a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x16,0xd7,0x20]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.h a2, a3, (a4)
# CHECK-NEXT: amoand.h a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x96,0xe7,0x60]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.h a3, a4, (a5)
# CHECK-NEXT: amoor.h a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0xf8,0x40]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.h a4, a5, (a6)
# CHECK-NEXT: amomin.h a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x97,0x08,0x81]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.h a5, a6, (a7)
# CHECK-NEXT: amomax.h s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x9b,0x6a,0xa1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.h s7, s6, (s5)
# CHECK-NEXT: amominu.h s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x1b,0x5a,0xc1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.h s6, s5, (s4)
# CHECK-NEXT: amomaxu.h s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x9a,0x49,0xe1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_H{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.h s5, s4, (s3)
#
# CHECK-NEXT: amoswap.h.aq a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0x14,0x0c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.h.aq a4, ra, (s0)
# CHECK-NEXT: amoadd.h.aq a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x95,0xc6,0x04]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.h.aq a1, a2, (a3)
# CHECK-NEXT: amoxor.h.aq a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x16,0xd7,0x24]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.h.aq a2, a3, (a4)
# CHECK-NEXT: amoand.h.aq a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x96,0xe7,0x64]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.h.aq a3, a4, (a5)
# CHECK-NEXT: amoor.h.aq a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0xf8,0x44]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.h.aq a4, a5, (a6)
# CHECK-NEXT: amomin.h.aq a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x97,0x08,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.h.aq a5, a6, (a7)
# CHECK-NEXT: amomax.h.aq s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x9b,0x6a,0xa5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.h.aq s7, s6, (s5)
# CHECK-NEXT: amominu.h.aq s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x1b,0x5a,0xc5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.h.aq s6, s5, (s4)
# CHECK-NEXT: amomaxu.h.aq s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x9a,0x49,0xe5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_H_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.h.aq s5, s4, (s3)
#
# CHECK-NEXT: amoswap.h.rl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0x14,0x0a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.h.rl a4, ra, (s0)
# CHECK-NEXT: amoadd.h.rl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x95,0xc6,0x02]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.h.rl a1, a2, (a3)
# CHECK-NEXT: amoxor.h.rl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x16,0xd7,0x22]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.h.rl a2, a3, (a4)
# CHECK-NEXT: amoand.h.rl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x96,0xe7,0x62]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.h.rl a3, a4, (a5)
# CHECK-NEXT: amoor.h.rl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0xf8,0x42]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.h.rl a4, a5, (a6)
# CHECK-NEXT: amomin.h.rl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x97,0x08,0x83]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.h.rl a5, a6, (a7)
# CHECK-NEXT: amomax.h.rl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x9b,0x6a,0xa3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.h.rl s7, s6, (s5)
# CHECK-NEXT: amominu.h.rl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x1b,0x5a,0xc3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.h.rl s6, s5, (s4)
# CHECK-NEXT: amomaxu.h.rl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x9a,0x49,0xe3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_H_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.h.rl s5, s4, (s3)
#
# CHECK-NEXT: amoswap.h.aqrl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0x14,0x0e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.h.aqrl a4, ra, (s0)
# CHECK-NEXT: amoadd.h.aqrl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0x95,0xc6,0x06]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.h.aqrl a1, a2, (a3)
# CHECK-NEXT: amoxor.h.aqrl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x16,0xd7,0x26]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.h.aqrl a2, a3, (a4)
# CHECK-NEXT: amoand.h.aqrl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0x96,0xe7,0x66]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.h.aqrl a3, a4, (a5)
# CHECK-NEXT: amoor.h.aqrl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x17,0xf8,0x46]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.h.aqrl a4, a5, (a6)
# CHECK-NEXT: amomin.h.aqrl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0x97,0x08,0x87]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.h.aqrl a5, a6, (a7)
# CHECK-NEXT: amomax.h.aqrl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0x9b,0x6a,0xa7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.h.aqrl s7, s6, (s5)
# CHECK-NEXT: amominu.h.aqrl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x1b,0x5a,0xc7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.h.aqrl s6, s5, (s4)
# CHECK-NEXT: amomaxu.h.aqrl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0x9a,0x49,0xe7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_H_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.h.aqrl s5, s4, (s3)
