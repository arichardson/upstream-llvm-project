# RUN: llvm-mc --triple=riscv32 --mattr=-experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-CAP %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=-experimental-y,+experimental-zyhybrid --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+experimental-zyhybrid --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s

# RUN: llvm-mc --triple=riscv64 --mattr=-experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-CAP %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=-experimental-y,+experimental-zyhybrid --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+experimental-zyhybrid --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s

## Both capability & normal RISC-V instruction use the same encoding, and the
## same MCInst as we rely on RegClassByHwMode to select the right base pointer.
## The only difference is that using register x0 as the base is illegal for RVY.

# CHECK: lb	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0x85,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lb a0, 0(a1)
# CHECK-NEXT: lbu	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xc5,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LBU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lbu a0, 0(a1)
# CHECK-NEXT: lh	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0x95,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lh a0, 0(a1)
# CHECK-NEXT: lhu	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xd5,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LHU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lhu a0, 0(a1)
# CHECK-NEXT: lw	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xa5,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lw a0, 0(a1)
# CHECK-NEXT: sb	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0x80,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sb a0, 0(a1)
# CHECK-NEXT: sh	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0x90,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sh a0, 0(a1)
# CHECK-NEXT: sw	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0xa0,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sw a0, 0(a1)
#
## Capability load & store
#
# CHECK-NEXT: ly	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x0f,0xc5,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
ly a0, 0(a1)
# CHECK-NEXT: sy	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0xc0,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sy a0, 0(a1)
#
## Pseudos loading from a symbol
#
# CHECK: .Lpcrel_hi0
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: lb a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi0
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: lb a0, %pcrel_lo(.Lpcrel_hi0)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x05,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi0), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi0)>>
lb a0, sym
# CHECK: .Lpcrel_hi1
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: lbu a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi1
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: lbu a0, %pcrel_lo(.Lpcrel_hi1)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x45,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi1), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LBU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi1)>>
lbu a0, sym
# CHECK: .Lpcrel_hi2
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: lh a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi2
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: lh a0, %pcrel_lo(.Lpcrel_hi2)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x15,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi2), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi2)>>
lh a0, sym
# CHECK: .Lpcrel_hi3
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: lhu a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi3
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: lhu a0, %pcrel_lo(.Lpcrel_hi3)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x55,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi3), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LHU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi3)>>
lhu a0, sym
# CHECK: .Lpcrel_hi4
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: lw a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi4
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: lw a0, %pcrel_lo(.Lpcrel_hi4)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x25,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi4), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi4)>>
lw a0, sym
# CHECK: .Lpcrel_hi5
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: ly a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi5
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: ly a0, %pcrel_lo(.Lpcrel_hi5)(a0)
# CHECK-ASM-SAME: # encoding: [0x0f,0x45,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi5), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi5)>>
ly a0, sym
# CHECK: .Lpcrel_hi6
# CHECK-OBJ-NEXT: auipc t0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: sb a0, 0(t0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi6
# CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: sb a0, %pcrel_lo(.Lpcrel_hi6)(t0)
# CHECK-ASM-SAME: # encoding: [0x23'A',0x80'A',0xa2'A',A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi6), kind: fixup_riscv_pcrel_lo12_s
# CHECK-ASM-NEXT: # <MCInst #[[#]] SB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi6)>>
sb a0, sym, t0
# CHECK: .Lpcrel_hi7
# CHECK-OBJ-NEXT: auipc t0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: sh a0, 0(t0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi7
# CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: sh a0, %pcrel_lo(.Lpcrel_hi7)(t0)
# CHECK-ASM-SAME: # encoding: [0x23'A',0x90'A',0xa2'A',A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi7), kind: fixup_riscv_pcrel_lo12_s
# CHECK-ASM-NEXT: # <MCInst #[[#]] SH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi7)>>
sh a0, sym, t0
# CHECK: .Lpcrel_hi8
# CHECK-OBJ-NEXT: auipc t0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: sw a0, 0(t0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi8
# CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: sw a0, %pcrel_lo(.Lpcrel_hi8)(t0)
# CHECK-ASM-SAME: # encoding: [0x23'A',0xa0'A',0xa2'A',A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi8), kind: fixup_riscv_pcrel_lo12_s
# CHECK-ASM-NEXT: # <MCInst #[[#]] SW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi8)>>
sw a0, sym, t0
# CHECK: .Lpcrel_hi9
# CHECK-OBJ-NEXT: auipc t0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: sy a0, 0(t0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi9
# CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: sy a0, %pcrel_lo(.Lpcrel_hi9)(t0)
# CHECK-ASM-SAME: # encoding: [0x23'A',0xc0'A',0xa2'A',A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi9), kind: fixup_riscv_pcrel_lo12_s
# CHECK-ASM-NEXT: # <MCInst #[[#]] SY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi9)>>
sy a0, sym, t0
