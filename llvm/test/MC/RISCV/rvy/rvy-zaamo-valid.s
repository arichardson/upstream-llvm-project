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
# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-y,+cap-mode,+zaamo -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zaamo -M no-aliases --show-encoding --show-inst \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-y,+cap-mode,+zaamo < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+zaamo -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-y,+cap-mode,+zaamo < %s \
# RUN:     | llvm-objdump --mattr=+experimental-y,+cap-mode,+zaamo -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK %s

# CHECK: amoswap.w a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0x14,0x08]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.w a4, ra, (s0)
# CHECK-NEXT: amoadd.w a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xa5,0xc6,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.w a1, a2, (a3)
# CHECK-NEXT: amoxor.w a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x26,0xd7,0x20]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.w a2, a3, (a4)
# CHECK-NEXT: amoand.w a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xa6,0xe7,0x60]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.w a3, a4, (a5)
# CHECK-NEXT: amoor.w a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0xf8,0x40]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.w a4, a5, (a6)
# CHECK-NEXT: amomin.w a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xa7,0x08,0x81]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.w a5, a6, (a7)
# CHECK-NEXT: amomax.w s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xab,0x6a,0xa1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.w s7, s6, (s5)
# CHECK-NEXT: amominu.w s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x2b,0x5a,0xc1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.w s6, s5, (s4)
# CHECK-NEXT: amomaxu.w s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xaa,0x49,0xe1]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_W{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.w s5, s4, (s3)
#
# CHECK-NEXT: amoswap.w.aq a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0x14,0x0c]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.w.aq a4, ra, (s0)
# CHECK-NEXT: amoadd.w.aq a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xa5,0xc6,0x04]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.w.aq a1, a2, (a3)
# CHECK-NEXT: amoxor.w.aq a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x26,0xd7,0x24]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.w.aq a2, a3, (a4)
# CHECK-NEXT: amoand.w.aq a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xa6,0xe7,0x64]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.w.aq a3, a4, (a5)
# CHECK-NEXT: amoor.w.aq a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0xf8,0x44]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.w.aq a4, a5, (a6)
# CHECK-NEXT: amomin.w.aq a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xa7,0x08,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.w.aq a5, a6, (a7)
# CHECK-NEXT: amomax.w.aq s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xab,0x6a,0xa5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.w.aq s7, s6, (s5)
# CHECK-NEXT: amominu.w.aq s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x2b,0x5a,0xc5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.w.aq s6, s5, (s4)
# CHECK-NEXT: amomaxu.w.aq s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xaa,0x49,0xe5]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_W_AQ{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.w.aq s5, s4, (s3)
#
# CHECK-NEXT: amoswap.w.rl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0x14,0x0a]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.w.rl a4, ra, (s0)
# CHECK-NEXT: amoadd.w.rl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xa5,0xc6,0x02]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.w.rl a1, a2, (a3)
# CHECK-NEXT: amoxor.w.rl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x26,0xd7,0x22]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.w.rl a2, a3, (a4)
# CHECK-NEXT: amoand.w.rl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xa6,0xe7,0x62]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.w.rl a3, a4, (a5)
# CHECK-NEXT: amoor.w.rl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0xf8,0x42]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.w.rl a4, a5, (a6)
# CHECK-NEXT: amomin.w.rl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xa7,0x08,0x83]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.w.rl a5, a6, (a7)
# CHECK-NEXT: amomax.w.rl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xab,0x6a,0xa3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.w.rl s7, s6, (s5)
# CHECK-NEXT: amominu.w.rl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x2b,0x5a,0xc3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.w.rl s6, s5, (s4)
# CHECK-NEXT: amomaxu.w.rl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xaa,0x49,0xe3]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_W_RL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.w.rl s5, s4, (s3)
#
# CHECK-NEXT: amoswap.w.aqrl a4, ra, (s0)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0x14,0x0e]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOSWAP_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X1>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X8_Y>>
amoswap.w.aqrl a4, ra, (s0)
# CHECK-NEXT: amoadd.w.aqrl a1, a2, (a3)
# CHECK-ASM-SAME: encoding: [0xaf,0xa5,0xc6,0x06]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOADD_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13_Y>>
amoadd.w.aqrl a1, a2, (a3)
# CHECK-NEXT: amoxor.w.aqrl a2, a3, (a4)
# CHECK-ASM-SAME: encoding: [0x2f,0x26,0xd7,0x26]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOXOR_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14_Y>>
amoxor.w.aqrl a2, a3, (a4)
# CHECK-NEXT: amoand.w.aqrl a3, a4, (a5)
# CHECK-ASM-SAME: encoding: [0xaf,0xa6,0xe7,0x66]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOAND_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X13>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15_Y>>
amoand.w.aqrl a3, a4, (a5)
# CHECK-NEXT: amoor.w.aqrl a4, a5, (a6)
# CHECK-ASM-SAME: encoding: [0x2f,0x27,0xf8,0x46]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOOR_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X14>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16_Y>>
amoor.w.aqrl a4, a5, (a6)
# CHECK-NEXT: amomin.w.aqrl a5, a6, (a7)
# CHECK-ASM-SAME: encoding: [0xaf,0xa7,0x08,0x87]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMIN_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X15>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X16>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X17_Y>>
amomin.w.aqrl a5, a6, (a7)
# CHECK-NEXT: amomax.w.aqrl s7, s6, (s5)
# CHECK-ASM-SAME: encoding: [0xaf,0xab,0x6a,0xa7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAX_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X23>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21_Y>>
amomax.w.aqrl s7, s6, (s5)
# CHECK-NEXT: amominu.w.aqrl s6, s5, (s4)
# CHECK-ASM-SAME: encoding: [0x2f,0x2b,0x5a,0xc7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMINU_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X22>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20_Y>>
amominu.w.aqrl s6, s5, (s4)
# CHECK-NEXT: amomaxu.w.aqrl s5, s4, (s3)
# CHECK-ASM-SAME: encoding: [0xaf,0xaa,0x49,0xe7]
# CHECK-ASM-NEXT: # <MCInst #[[#]] AMOMAXU_W_AQRL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X21>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X20>
# CHECK-ASM-NEXT: #  <MCOperand Reg:X19_Y>>
amomaxu.w.aqrl s5, s4, (s3)
