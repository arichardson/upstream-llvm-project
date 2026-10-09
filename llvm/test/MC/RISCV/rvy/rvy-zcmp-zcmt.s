// RUN: split-file %s %t
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+zcmp,+zcmt --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP,CHECK-SLOT64-ASM-AND-OBJ,CHECK-SLOT64-ASM
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+zcmp,+zcmt --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-SLOT64-ASM-AND-OBJ
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-zyhybrid,+zcmp,+zcmt --defsym=HYBRID_INT32=1 --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-SLOT32-ASM-AND-OBJ,CHECK-SLOT32-ASM
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-zyhybrid,+zcmp,+zcmt --defsym=HYBRID_INT32=1 --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-SLOT32-ASM-AND-OBJ
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid,+zcmp,+zcmt --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-SLOT64-ASM-AND-OBJ,CHECK-SLOT64-ASM
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid,+zcmp,+zcmt --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-SLOT64-ASM-AND-OBJ

// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental,+experimental-y,+experimental-zyhybrid,+zce %t/mode-switch.s -o %t/mode-switch.o
// RUN: llvm-objdump -M no-aliases -d --no-print-imm-hex --show-all-symbols %t/mode-switch.o \
// RUN:   | FileCheck %t/mode-switch.s

// RUN: not llvm-mc --triple=riscv32 --mattr=+experimental,+experimental-y,+experimental-zyhybrid,+zce %t/invalid.s 2>&1 \
// RUN:   | FileCheck %t/invalid.s --implicit-check-not=error:

//--- valid.s
///
/// Zcmp paired moves use YGPR in RV32Y capability mode and GPR in RVI mode:
///

// CHECK-ASM-AND-OBJ: cm.mvsa01 s1, s0
// CHECK-ASM-SAME: # encoding: [0xa2,0xac]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CM_MVSA01{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X9>
// CHECK-INT-NEXT: #  <MCOperand Reg:X8>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X9_Y>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X8_Y>>
cm.mvsa01 s1, s0

// CHECK-ASM-AND-OBJ: cm.mva01s s7, s2
// CHECK-ASM-SAME: # encoding: [0xea,0xaf]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CM_MVA01S{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X23>
// CHECK-INT-NEXT: #  <MCOperand Reg:X18>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X23_Y>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X18_Y>>
cm.mva01s s7, s2

///
/// Zcmp push/pop uses 8-byte capability stack slots on RV32Y (matching RV64I),
/// and 4-byte stack slots on RV32I:
///

.ifdef HYBRID_INT32
// CHECK-SLOT32-ASM-AND-OBJ: cm.push {ra, s0-s1}, -16
// CHECK-SLOT32-ASM-SAME: # encoding: [0x62,0xb8]
// CHECK-SLOT32-ASM-NEXT: # <MCInst #[[#]] CM_PUSH{{$}}
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:6>
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:0>>
cm.push {ra, s0-s1}, -16

// CHECK-SLOT32-ASM-AND-OBJ: cm.pop {ra, s0-s1}, 16
// CHECK-SLOT32-ASM-SAME: # encoding: [0x62,0xba]
// CHECK-SLOT32-ASM-NEXT: # <MCInst #[[#]] CM_POP{{$}}
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:6>
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:0>>
cm.pop {ra, s0-s1}, 16

// CHECK-SLOT32-ASM-AND-OBJ: cm.popret {ra, s0-s11}, 64
// CHECK-SLOT32-ASM-SAME: # encoding: [0xf2,0xbe]
// CHECK-SLOT32-ASM-NEXT: # <MCInst #[[#]] CM_POPRET{{$}}
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:15>
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:0>>
cm.popret {ra, s0-s11}, 64

// CHECK-SLOT32-ASM-AND-OBJ: cm.popretz {ra, s0-s11}, 64
// CHECK-SLOT32-ASM-SAME: # encoding: [0xf2,0xbc]
// CHECK-SLOT32-ASM-NEXT: # <MCInst #[[#]] CM_POPRETZ{{$}}
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:15>
// CHECK-SLOT32-ASM-NEXT: #  <MCOperand Imm:0>>
cm.popretz {ra, s0-s11}, 64
.else
// CHECK-SLOT64-ASM-AND-OBJ: cm.push {ra, s0-s1}, -32
// CHECK-SLOT64-ASM-SAME: # encoding: [0x62,0xb8]
// CHECK-SLOT64-ASM-NEXT: # <MCInst #[[#]] CM_PUSH{{$}}
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:6>
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:0>>
cm.push {ra, s0-s1}, -32

// CHECK-SLOT64-ASM-AND-OBJ: cm.pop {ra, s0-s1}, 32
// CHECK-SLOT64-ASM-SAME: # encoding: [0x62,0xba]
// CHECK-SLOT64-ASM-NEXT: # <MCInst #[[#]] CM_POP{{$}}
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:6>
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:0>>
cm.pop {ra, s0-s1}, 32

// CHECK-SLOT64-ASM-AND-OBJ: cm.popret {ra, s0-s11}, 112
// CHECK-SLOT64-ASM-SAME: # encoding: [0xf2,0xbe]
// CHECK-SLOT64-ASM-NEXT: # <MCInst #[[#]] CM_POPRET{{$}}
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:15>
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:0>>
cm.popret {ra, s0-s11}, 112

// CHECK-SLOT64-ASM-AND-OBJ: cm.popretz {ra, s0-s11}, 112
// CHECK-SLOT64-ASM-SAME: # encoding: [0xf2,0xbc]
// CHECK-SLOT64-ASM-NEXT: # <MCInst #[[#]] CM_POPRETZ{{$}}
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:15>
// CHECK-SLOT64-ASM-NEXT: #  <MCOperand Imm:0>>
cm.popretz {ra, s0-s11}, 112
.endif

///
/// Zcmt table jumps:
///

// CHECK-ASM-AND-OBJ: cm.jt 1
// CHECK-ASM-SAME: # encoding: [0x06,0xa0]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CM_JT{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Imm:1>>
cm.jt 1

// CHECK-ASM-AND-OBJ: cm.jalt 32
// CHECK-ASM-SAME: # encoding: [0x82,0xa0]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CM_JALT{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Imm:32>>
cm.jalt 32

//--- mode-switch.s
/// On RV32 with Zyhybrid, switching between capability and integral pointer
/// modes changes the stack_adj_base used for assembling and disassembling
/// cm.push/cm.pop/cm.popret/cm.popretz.
// CHECK-LABEL: <$xrv32y0p910_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    b862 cm.push {ra, s0-s1}, -32
// CHECK-NEXT:    bef2 cm.popret {ra, s0-s11}, 112
// CHECK-NEXT:    ymodeswi
cm.push {ra, s0-s1}, -32
cm.popret {ra, s0-s11}, 112
ymodeswi

// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    b862 cm.push {ra, s0-s1}, -16
// CHECK-NEXT:    bef2 cm.popret {ra, s0-s11}, 64
// CHECK-NEXT:    ymodeswy
cm.push {ra, s0-s1}, -16
cm.popret {ra, s0-s11}, 64
ymodeswy

// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    ba62 cm.pop {ra, s0-s1}, 32
// CHECK-NEXT:    bcf2 cm.popretz {ra, s0-s11}, 112
cm.pop {ra, s0-s1}, 32
cm.popretz {ra, s0-s11}, 112

//--- invalid.s
/// In RV32Y capability mode, 3 registers require 24 bytes -> stack_adj_base=32.
cm.push {ra, s0-s1}, -16
// CHECK: :[[#@LINE-1]]:22: error: stack adjustment for register list must be a multiple of 16 bytes in the range [-80, -32]
cm.pop {ra, s0-s1}, 16
// CHECK: :[[#@LINE-1]]:21: error: stack adjustment for register list must be a multiple of 16 bytes in the range [32, 80]

/// Switching to RV32I mode changes stack_adj_base for 3 registers to 16.
ymodeswi
cm.push {ra, s0-s1}, -16
cm.pop {ra, s0-s1}, 16
cm.push {ra, s0-s1}, -80
// CHECK: :[[#@LINE-1]]:22: error: stack adjustment for register list must be a multiple of 16 bytes in the range [-64, -16]
cm.pop {ra, s0-s1}, 80
// CHECK: :[[#@LINE-1]]:21: error: stack adjustment for register list must be a multiple of 16 bytes in the range [16, 64]

/// Switching back to RV32Y capability mode restores stack_adj_base=32.
ymodeswy
cm.push {ra, s0-s1}, -80
cm.pop {ra, s0-s1}, 80
cm.push {ra, s0-s1}, -16
// CHECK: :[[#@LINE-1]]:22: error: stack adjustment for register list must be a multiple of 16 bytes in the range [-80, -32]
