# RUN: llvm-mc --triple=riscv32 --mattr=+c,+zcb,+experimental-y --defsym=RVY=1 --riscv-no-aliases --show-encoding --show-inst < %s
# RUN: llvm-mc --triple=riscv32 --mattr=+c,+zcb,-experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --triple=riscv32 --mattr=+c,+zcb,+experimental-y --defsym=RVY=1 --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP,CHECK-CAP-32 %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+c,+zcb,-experimental-y,+experimental-zyhybrid --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefixes=CHECK-ASM-AND-OBJ
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+c,+zcb,+experimental-y --defsym=RVY=1 --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-CAP-OBJ

# RUN: llvm-mc --triple=riscv64 --mattr=+c,+zcb,-experimental-y,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --triple=riscv64 --mattr=+c,+zcb,+experimental-y --defsym=RVY=1 --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP,CHECK-CAP-64 %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+c,+zcb,-experimental-y,+experimental-zyhybrid --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefixes=CHECK-ASM-AND-OBJ
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+c,+zcb,+experimental-y --defsym=RVY=1 --riscv-add-build-attributes < %s \
# RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - | FileCheck %s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-CAP-OBJ

# CHECK-ASM-AND-OBJ: c.lbu	a0, 1(a1)
# CHECK-ASM-SAME: # encoding: [0xc8,0x81]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LBU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:1>>
c.lbu a0, 1(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lh	a0, 2(a1)
# CHECK-ASM-SAME: # encoding: [0xe8,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:2>>
c.lh a0, 2(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lhu	a0, 2(a1)
# CHECK-ASM-SAME: # encoding: [0xa8,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LHU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:2>>
c.lhu a0, 2(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lw	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x88,0x49]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
c.lw a0, 16(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.sb	a0, 1(a1)
# CHECK-ASM-SAME: # encoding: [0xc8,0x89]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:1>>
c.sb a0, 1(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.sh	a0, 2(a1)
# CHECK-ASM-SAME: # encoding: [0xa8,0x8d]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:2>>
c.sh a0, 2(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.sw	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x88,0xc9]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
c.sw a0, 16(a1)
#
## Compressed Capability load & store (only in RVY mode)
#
.ifdef RVY
# CHECK-CAP-NEXT: c.ly	a0, 16(a1)
# CHECK-CAP-32-SAME: # encoding: [0x88,0x69]
# CHECK-CAP-64-SAME: # encoding: [0x88,0x29]
# CHECK-CAP-32-NEXT: # <MCInst #[[#]] C_LY_RV32{{$}}
# CHECK-CAP-64-NEXT: # <MCInst #[[#]] C_LY_RV64{{$}}
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-CAP-NEXT: #  <MCOperand Imm:16>>
# CHECK-CAP-OBJ-NEXT: c.ly	a0, 16(a1)
c.ly a0, 16(a1)
# CHECK-CAP-NEXT: c.sy	a0, 16(a1)
# CHECK-CAP-32-SAME: # encoding: [0x88,0xe9]
# CHECK-CAP-64-SAME: # encoding: [0x88,0xa9]
# CHECK-CAP-32-NEXT: # <MCInst #[[#]] C_SY_RV32{{$}}
# CHECK-CAP-64-NEXT: # <MCInst #[[#]] C_SY_RV64{{$}}
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-CAP-NEXT: #  <MCOperand Imm:16>>
# CHECK-CAP-OBJ-NEXT: c.sy	a0, 16(a1)
c.sy a0, 16(a1)
# CHECK-CAP-NEXT: c.lysp a0, 16(sp)
# CHECK-CAP-32-SAME: # encoding: [0x42,0x65]
# CHECK-CAP-64-SAME: # encoding: [0x42,0x25]
# CHECK-CAP-32-NEXT: # <MCInst #[[#]] C_LYSP_RV32{{$}}
# CHECK-CAP-64-NEXT: # <MCInst #[[#]] C_LYSP_RV64{{$}}
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X2_Y>
# CHECK-CAP-NEXT: #  <MCOperand Imm:16>>
# CHECK-CAP-OBJ-NEXT: c.lysp	a0, 16(sp)
c.lysp a0, 16(sp)
# CHECK-CAP-NEXT: c.sysp a0, 16(sp)
# CHECK-CAP-32-SAME: # encoding: [0x2a,0xe8]
# CHECK-CAP-64-SAME: # encoding: [0x2a,0xa8]
# CHECK-CAP-32-NEXT: # <MCInst #[[#]] C_SYSP_RV32{{$}}
# CHECK-CAP-64-NEXT: # <MCInst #[[#]] C_SYSP_RV64{{$}}
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X2_Y>
# CHECK-CAP-NEXT: #  <MCOperand Imm:16>>
# CHECK-CAP-OBJ-NEXT: c.sysp	a0, 16(sp)
c.sysp a0, 16(sp)
.endif

##
## Check that the compress patterns work as expected:
##

## There is no c.lbu, so the first one should not be compressed:
# CHECK-ASM-AND-OBJ: lb	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0x85,0x05,0x01]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
lb a0, 16(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lbu	a0, 1(a1)
# CHECK-ASM-SAME: # encoding: [0xc8,0x81]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LBU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:1>>
lbu a0, 1(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lh	a0, 2(a1)
# CHECK-ASM-SAME: # encoding: [0xe8,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:2>>
lh a0, 2(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lhu	a0, 2(a1)
# CHECK-ASM-SAME: # encoding: [0xa8,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LHU{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:2>>
lhu a0, 2(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.lw	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x88,0x49]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
lw a0, 16(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.sb	a0, 1(a1)
# CHECK-ASM-SAME: # encoding: [0xc8,0x89]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SB{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:1>>
sb a0, 1(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.sh	a0, 2(a1)
# CHECK-ASM-SAME: # encoding: [0xa8,0x8d]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SH{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:2>>
sh a0, 2(a1)
# CHECK-ASM-AND-OBJ-NEXT: c.sw	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x88,0xc9]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SW{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
sw a0, 16(a1)
#
## Capability load & store
#
# CHECK-ASM-AND-OBJ-NEXT: ly	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x0f,0xc5,0x05,0x01]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
ly a0, 16(a1)
# CHECK-ASM-AND-OBJ-NEXT: sy	a0, 16(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0xc8,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
sy a0, 16(a1)
#
## Test c.l*sp/c.s*sp compress patters (the *y ones only compress in RVY mode):
#
# CHECK-ASM-AND-OBJ-NEXT: c.lwsp	a0, 16(sp)
# CHECK-ASM-SAME: # encoding: [0x42,0x45]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_LWSP{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X2>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X2_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
lw a0, 16(sp)
# CHECK-ASM-AND-OBJ-NEXT: c.swsp	a0, 16(sp)
# CHECK-ASM-SAME: # encoding: [0x2a,0xc8]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_SWSP{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
# CHECK-INT-NEXT: #  <MCOperand Reg:X2>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X2_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
sw a0, 16(sp)
# CHECK-ASM-AND-OBJ-NEXT: ly	a0, 16(sp)
# CHECK-ASM-SAME: # encoding: [0x0f,0x45,0x01,0x01]
# CHECK-ASM-NEXT: # <MCInst #[[#]] LY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X2>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X2_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
ly a0, 16(sp)
# CHECK-ASM-AND-OBJ-NEXT: sy	a0, 16(sp)
# CHECK-ASM-SAME: # encoding: [0x23,0x48,0xa1,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] SY{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X2>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X2_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:16>>
sy a0, 16(sp)


# TODO: Test the pseudo expansions using AUIPC:
# lb a0, sym
# lbu a0, sym
# lh a0, sym
# lhu a0, sym
# lw a0, sym
# ly a0, sym
#
# sb a0, sym, t0
# sh a0, sym, t0
# sw a0, sym, t0
# sy a0, sym, t0
