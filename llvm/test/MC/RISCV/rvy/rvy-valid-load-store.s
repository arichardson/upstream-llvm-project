// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+d,+q,+zfh --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-ASM-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+d,+q,+zfh --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s --check-prefixes=CHECK
// RUN: llvm-mc --triple=riscv32 --mattr=+xllvmrvyipm,+d,+q,+zfh --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-ASM-INT %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+xllvmrvyipm,+d,+q,+zfh --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s --check-prefixes=CHECK

// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+d,+q,+zfh --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-ASM-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+d,+q,+zfh --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s --check-prefixes=CHECK
// RUN: llvm-mc --triple=riscv64 --mattr=+xllvmrvyipm,+d,+q,+zfh --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-ASM-INT %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+xllvmrvyipm,+d,+q,+zfh --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d -r --no-print-imm-hex - | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s --check-prefixes=CHECK

/// Both capability & normal RISC-V instruction use the same encoding, and the
/// same MCInst as we rely on RegClassByHwMode to select the right base pointer.
/// The only difference is that using register x0 as the base is illegal for
/// RVY (see rvy-invalid-load-store.s).

lb a0, 0(a1)
// CHECK: lb	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x03,0x85,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST1:]] LB{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lbu a0, 0(a1)
// CHECK: lbu	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x03,0xc5,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST2:]] LBU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lh a0, 0(a1)
// CHECK: lh	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x03,0x95,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST3:]] LH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lhu a0, 0(a1)
// CHECK: lhu	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x03,0xd5,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST4:]] LHU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lw a0, 0(a1)
// CHECK: lw	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x03,0xa5,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST5:]] LW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sb a0, 0(a1)
// CHECK: sb	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x23,0x80,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST6:]] SB{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sh a0, 0(a1)
// CHECK: sh	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x23,0x90,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST7:]] SH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sw a0, 0(a1)
// CHECK: sw	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x23,0xa0,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST8:]] SW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>

//
/// Capability load & store
//
ly a0, 0(a1)
// CHECK: ly	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x7b,0x95,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST9:]] LY{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sy a0, 0(a1)
// CHECK: sy	a0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x7b,0xa0,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST10:]] SY{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>

//
/// Floating point load & store
//
flw fa0, 0(a1)
// CHECK: flw	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x07,0xa5,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST11:]] FLW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_F>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
fsw fa0, 0(a1)
// CHECK: fsw	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x27,0xa0,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST13:]] FSW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_F>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
fld fa0, 0(a1)
// CHECK: fld	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x07,0xb5,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST12:]] FLD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_D>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
fsd fa0, 0(a1)
// CHECK: fsd	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x27,0xb0,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST14:]] FSD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_D>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
flh fa0, 0(a1)
// CHECK: flh	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x07,0x95,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST15:]] FLH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_H>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
fsh fa0, 0(a1)
// CHECK: fsh	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x27,0x90,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST16:]] FSH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_H>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
flq fa0, 0(a1)
// CHECK: flq	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x07,0xc5,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST17:]] FLQ{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_Q>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
fsq fa0, 0(a1)
// CHECK: fsq	fa0, 0(a1)
// CHECK-ASM-SAME: # encoding: [0x27,0xc0,0xa5,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#MCINST18:]] FSQ{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_Q>
// CHECK-ASM-CAP: #  <MCOperand Reg:X11_Y>
// CHECK-ASM-INT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>

//
/// Pseudos loading from a symbol
//
// CHECK: .Lpcrel_hi0
// CHECK-OBJ-NEXT: auipc a0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: lb a0, 0(a0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi0
// CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: lb a0, %pcrel_lo(.Lpcrel_hi0)(a0)
// CHECK-ASM-SAME: # encoding: [0x03,0x05,0bAAAA0101,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi0), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] LB{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi0)>>
lb a0, sym
// CHECK: .Lpcrel_hi1
// CHECK-OBJ-NEXT: auipc a0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: lbu a0, 0(a0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi1
// CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: lbu a0, %pcrel_lo(.Lpcrel_hi1)(a0)
// CHECK-ASM-SAME: # encoding: [0x03,0x45,0bAAAA0101,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi1), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] LBU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi1)>>
lbu a0, sym
// CHECK: .Lpcrel_hi2
// CHECK-OBJ-NEXT: auipc a0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: lh a0, 0(a0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi2
// CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: lh a0, %pcrel_lo(.Lpcrel_hi2)(a0)
// CHECK-ASM-SAME: # encoding: [0x03,0x15,0bAAAA0101,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi2), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] LH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi2)>>
lh a0, sym
// CHECK: .Lpcrel_hi3
// CHECK-OBJ-NEXT: auipc a0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: lhu a0, 0(a0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi3
// CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: lhu a0, %pcrel_lo(.Lpcrel_hi3)(a0)
// CHECK-ASM-SAME: # encoding: [0x03,0x55,0bAAAA0101,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi3), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] LHU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi3)>>
lhu a0, sym
// CHECK: .Lpcrel_hi4
// CHECK-OBJ-NEXT: auipc a0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: lw a0, 0(a0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi4
// CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: lw a0, %pcrel_lo(.Lpcrel_hi4)(a0)
// CHECK-ASM-SAME: # encoding: [0x03,0x25,0bAAAA0101,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi4), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] LW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi4)>>
lw a0, sym
// CHECK: .Lpcrel_hi5
// CHECK-OBJ-NEXT: auipc a0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: ly a0, 0(a0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi5
// CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: ly a0, %pcrel_lo(.Lpcrel_hi5)(a0)
// CHECK-ASM-SAME: # encoding: [0x7b,0x15,0bAAAA0101,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi5), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] LY{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi5)>>
ly a0, sym
// CHECK: .Lpcrel_hi6
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: sb a0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi6
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: sb a0, %pcrel_lo(.Lpcrel_hi6)(t0)
// CHECK-ASM-SAME: # encoding: [0x23'A',0x80'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi6), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] SB{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi6)>>
sb a0, sym, t0
// CHECK: .Lpcrel_hi7
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: sh a0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi7
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: sh a0, %pcrel_lo(.Lpcrel_hi7)(t0)
// CHECK-ASM-SAME: # encoding: [0x23'A',0x90'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi7), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] SH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi7)>>
sh a0, sym, t0
// CHECK: .Lpcrel_hi8
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: sw a0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi8
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: sw a0, %pcrel_lo(.Lpcrel_hi8)(t0)
// CHECK-ASM-SAME: # encoding: [0x23'A',0xa0'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi8), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] SW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi8)>>
sw a0, sym, t0
// CHECK: .Lpcrel_hi9
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: sy a0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi9
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: sy a0, %pcrel_lo(.Lpcrel_hi9)(t0)
// CHECK-ASM-SAME: # encoding: [0x7b'A',0xa0'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi9), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] SY{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi9)>>
sy a0, sym, t0
//
// CHECK: .Lpcrel_hi10
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: flw fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi10
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: flw fa0, %pcrel_lo(.Lpcrel_hi10)(t0)
// CHECK-ASM-SAME: # encoding: [0x07,0xa5,0bAAAA0010,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi10), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] FLW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_F>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi10)>>
flw fa0, sym, t0
// CHECK: .Lpcrel_hi11
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: fld fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi11
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: fld fa0, %pcrel_lo(.Lpcrel_hi11)(t0)
// CHECK-ASM-SAME: # encoding: [0x07,0xb5,0bAAAA0010,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi11), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] FLD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_D>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi11)>>
fld fa0, sym, t0
// CHECK: .Lpcrel_hi12
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: flh fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi12
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: flh fa0, %pcrel_lo(.Lpcrel_hi12)(t0)
// CHECK-ASM-SAME: # encoding: [0x07,0x95,0bAAAA0010,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi12), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] FLH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_H>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi12)>>
flh fa0, sym, t0
// CHECK: .Lpcrel_hi13
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: flq fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi13
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: flq fa0, %pcrel_lo(.Lpcrel_hi13)(t0)
// CHECK-ASM-SAME: # encoding: [0x07,0xc5,0bAAAA0010,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi13), kind: fixup_riscv_pcrel_lo12_i
// CHECK-ASM-NEXT: # <MCInst #[[#]] FLQ{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_Q>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi13)>>
flq fa0, sym, t0

// CHECK: .Lpcrel_hi14
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: fsw fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi14
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: fsw fa0, %pcrel_lo(.Lpcrel_hi14)(t0)
// CHECK-ASM-SAME: # encoding: [0x27'A',0xa0'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi14), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] FSW{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_F>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi14)>>
fsw fa0, sym, t0
// CHECK: .Lpcrel_hi15
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: fsd fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi15
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: fsd fa0, %pcrel_lo(.Lpcrel_hi15)(t0)
// CHECK-ASM-SAME: # encoding: [0x27'A',0xb0'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi15), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] FSD{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_D>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi15)>>
fsd fa0, sym, t0
// CHECK: .Lpcrel_hi16
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: fsh fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi16
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: fsh fa0, %pcrel_lo(.Lpcrel_hi16)(t0)
// CHECK-ASM-SAME: # encoding: [0x27'A',0x90'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi16), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] FSH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_H>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi16)>>
fsh fa0, sym, t0
// CHECK: .Lpcrel_hi17
// CHECK-OBJ-NEXT: auipc t0, 0
// CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
// CHECK-OBJ-NEXT: fsq fa0, 0(t0)
// CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi17
// CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
// CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
// CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
// CHECK-ASM-NEXT: fsq fa0, %pcrel_lo(.Lpcrel_hi17)(t0)
// CHECK-ASM-SAME: # encoding: [0x27'A',0xc0'A',0xa2'A',A]
// CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi17), kind: fixup_riscv_pcrel_lo12_s
// CHECK-ASM-NEXT: # <MCInst #[[#]] FSQ{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:F10_Q>
// CHECK-ASM-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-ASM-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi17)>>
fsq fa0, sym, t0
