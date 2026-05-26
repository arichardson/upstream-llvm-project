# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --triple=riscv64 --mattr=-experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-CAP %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=-experimental-y,+experimental-zyhybrid < %s \
# RUN:   | llvm-objdump --mattr=-experimental-y,+experimental-zyhybrid -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s

## Both capability & normal RISC-V instruction use the same encoding, and the
## same MCInst as we rely on RegClassByHwMode to select the right base pointer.
## The only difference is that using register x0 as the base is illegal for RVY.

# CHECK:	lwu	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xe5,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LWU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
lwu a0, 0(a1)
# CHECK-NEXT:	ld	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xb5,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LD{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
ld a0, 0(a1)
# CHECK-NEXT:	sd	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0xb0,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SD{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
sd a0, 0(a1)


# CHECK: .Lpcrel_hi0
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: lwu a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi0
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: lwu a0, %pcrel_lo(.Lpcrel_hi0)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x65,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi0), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LWU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi0)>>
lwu a0, sym

# CHECK: .Lpcrel_hi1
# CHECK-OBJ-NEXT: auipc a0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: ld a0, 0(a0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_I .Lpcrel_hi1
# CHECK-ASM-NEXT: auipc a0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x17,0bAAAA0101,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: ld a0, %pcrel_lo(.Lpcrel_hi1)(a0)
# CHECK-ASM-SAME: # encoding: [0x03,0x35,0bAAAA0101,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi1), kind: fixup_riscv_pcrel_lo12_i
# CHECK-ASM-NEXT: # <MCInst #[[#]] LD{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi1)>>
ld a0, sym

# CHECK: .Lpcrel_hi2
# CHECK-OBJ-NEXT: auipc t0, 0
# CHECK-OBJ-NEXT: R_RISCV_PCREL_HI20 sym
# CHECK-OBJ-NEXT: sd a0, 0(t0)
# CHECK-OBJ-NEXT: R_RISCV_PCREL_LO12_S .Lpcrel_hi2
# CHECK-ASM-NEXT: auipc t0, %pcrel_hi(sym)
# CHECK-ASM-SAME: # encoding: [0x97,0bAAAA0010,A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_hi(sym), kind: fixup_riscv_pcrel_hi20
# CHECK-ASM-NEXT: # <MCInst #[[#]] AUIPC{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_hi(sym)>>
# CHECK-ASM-NEXT: sd a0, %pcrel_lo(.Lpcrel_hi2)(t0)
# CHECK-ASM-SAME: # encoding: [0x23'A',0xb0'A',0xa2'A',A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: %pcrel_lo(.Lpcrel_hi2), kind: fixup_riscv_pcrel_lo12_s
# CHECK-ASM-NEXT: # <MCInst #[[#]] SD{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X5>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
# CHECK-ASM-NEXT: #  <MCOperand Expr:%pcrel_lo(.Lpcrel_hi2)>>
sd a0, sym, t0
