// RUN: llvm-mc --triple=riscv32 --mattr=+m,+zba,+zbb,+zcb,+experimental-y --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+m,+zba,+zbb,+zcb,+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ %s
// RUN: llvm-mc --triple=riscv32 --mattr=+m,+zba,+zbb,+zcb,+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+m,+zba,+zbb,+zcb,+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ %s

// RUN: llvm-mc --triple=riscv64 --mattr=+m,+zba,+zbb,+zcb,+experimental-y --defsym=RV64=1 --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP,CHECK-64-ASM-AND-OBJ,CHECK-64-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+m,+zba,+zbb,+zcb,+experimental-y --defsym=RV64=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-64-ASM-AND-OBJ %s
// RUN: llvm-mc --triple=riscv64 --mattr=+m,+zba,+zbb,+zcb,+experimental-zyhybrid --defsym=RV64=1 --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-64-ASM-AND-OBJ,CHECK-64-ASM %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+m,+zba,+zbb,+zcb,+experimental-zyhybrid --defsym=RV64=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-64-ASM-AND-OBJ %s

///
/// Zcb bit manipulation and multiplication instructions:
///

// CHECK-ASM-AND-OBJ: c.zext.b s0
// CHECK-ASM-SAME: # encoding: [0x61,0x9c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_ZEXT_B{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>>
c.zext.b s0

// CHECK-ASM-AND-OBJ: c.sext.b s0
// CHECK-ASM-SAME: # encoding: [0x65,0x9c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_SEXT_B{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>>
c.sext.b s0

// CHECK-ASM-AND-OBJ: c.zext.h s0
// CHECK-ASM-SAME: # encoding: [0x69,0x9c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_ZEXT_H{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>>
c.zext.h s0

// CHECK-ASM-AND-OBJ: c.sext.h s0
// CHECK-ASM-SAME: # encoding: [0x6d,0x9c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_SEXT_H{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>>
c.sext.h s0

// CHECK-ASM-AND-OBJ: c.not s0
// CHECK-ASM-SAME: # encoding: [0x75,0x9c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_NOT{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>>
c.not s0

// CHECK-ASM-AND-OBJ: c.mul s0, s1
// CHECK-ASM-SAME: # encoding: [0x45,0x9c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_MUL{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X9>>
c.mul s0, s1

///
/// Zcb loads and stores with omitted zero offset:
///

// CHECK-ASM-AND-OBJ: c.lbu s0, 0(s1)
// CHECK-ASM-SAME: # encoding: [0x80,0x80]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_LBU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X9>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X9_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
c.lbu s0, (s1)

// CHECK-ASM-AND-OBJ: c.lhu s0, 0(s1)
// CHECK-ASM-SAME: # encoding: [0x80,0x84]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_LHU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X9>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X9_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
c.lhu s0, (s1)

// CHECK-ASM-AND-OBJ: c.lh s0, 0(s1)
// CHECK-ASM-SAME: # encoding: [0xc0,0x84]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_LH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X9>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X9_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
c.lh s0, (s1)

// CHECK-ASM-AND-OBJ: c.sb s0, 0(s1)
// CHECK-ASM-SAME: # encoding: [0x80,0x88]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_SB{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X9>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X9_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
c.sb s0, (s1)

// CHECK-ASM-AND-OBJ: c.sh s0, 0(s1)
// CHECK-ASM-SAME: # encoding: [0x80,0x8c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] C_SH{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X9>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X9_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
c.sh s0, (s1)

///
/// Zcb compression patterns:
///

// CHECK-ASM-AND-OBJ: c.mul s0, s1
// CHECK-ASM-SAME: # encoding: [0x45,0x9c]
mul s0, s1, s0

// CHECK-ASM-AND-OBJ: c.mul s0, s1
// CHECK-ASM-SAME: # encoding: [0x45,0x9c]
mul s0, s0, s1

// CHECK-ASM-AND-OBJ: c.sext.b s0
// CHECK-ASM-SAME: # encoding: [0x65,0x9c]
sext.b s0, s0

// CHECK-ASM-AND-OBJ: c.sext.h s0
// CHECK-ASM-SAME: # encoding: [0x6d,0x9c]
sext.h s0, s0

// CHECK-ASM-AND-OBJ: c.zext.h s0
// CHECK-ASM-SAME: # encoding: [0x69,0x9c]
zext.h s0, s0

// CHECK-ASM-AND-OBJ: c.zext.b s0
// CHECK-ASM-SAME: # encoding: [0x61,0x9c]
andi s0, s0, 255

// CHECK-ASM-AND-OBJ: c.not s0
// CHECK-ASM-SAME: # encoding: [0x75,0x9c]
xori s0, s0, -1

.ifdef RV64
// CHECK-64-ASM-AND-OBJ: c.zext.w s0
// CHECK-64-ASM-SAME: # encoding: [0x71,0x9c]
// CHECK-64-ASM-NEXT: # <MCInst #[[#]] C_ZEXT_W{{$}}
// CHECK-64-ASM-NEXT: #  <MCOperand Reg:X8>
// CHECK-64-ASM-NEXT: #  <MCOperand Reg:X8>>
c.zext.w s0

// CHECK-64-ASM-AND-OBJ: c.zext.w s0
// CHECK-64-ASM-SAME: # encoding: [0x71,0x9c]
add.uw s0, s0, zero

// CHECK-64-ASM-AND-OBJ: c.zext.w s0
// CHECK-64-ASM-SAME: # encoding: [0x71,0x9c]
zext.w s0, s0
.endif
