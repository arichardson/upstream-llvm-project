/// For RVY, the loads and stores with the zero register as the base are reserved
/// since this is an always-trapping encoding that may be reused in the future:
/// - Check that the assembler rejects zero reg base for capmode but allows it in integral pointer mode.
/// - Check that the disassembler with +experimental-y decodes zero reg base as invalid instructions.
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-zyhybrid,+a,+zabha,+experimental-zabhlrsc,+h --show-encoding < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK %s
// RUN: not llvm-mc --triple=riscv32 --mattr=+experimental-y,+a,+zabha,+experimental-zabhlrsc,+h < %s 2>&1 \
// RUN:   |  FileCheck %s --check-prefixes=ERR-RVY --implicit-check-not=error:
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-zyhybrid,+a,+zabha,+experimental-zabhlrsc,+h -o %t.rv32i.o < %s
// RUN: llvm-objdump -M no-aliases --mattr=+experimental-zyhybrid,+a,+zabha,+experimental-zabhlrsc,+h -d --no-print-imm-hex %t.rv32i.o \
// RUN:   | FileCheck --check-prefixes=CHECK %s
// RUN: llvm-objdump -M no-aliases --mattr=+experimental-y,+a,+zabha,+experimental-zabhlrsc,+h -d --no-print-imm-hex %t.rv32i.o \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP-MODE-DISASM %s

// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid,+a,+zabha,+experimental-zabhlrsc,+h --show-encoding --defsym=RV64=1 < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-64,CHECK,CHECK-64 %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+experimental-y,+a,+zabha,+experimental-zabhlrsc,+h --defsym=RV64=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=ERR-RVY,ERR-RVY-64 --implicit-check-not=error: %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid,+a,+zabha,+experimental-zabhlrsc,+h --defsym=RV64=1 -o %t.rv64i.o < %s
// RUN: llvm-objdump -M no-aliases --mattr=+experimental-zyhybrid,+a,+zabha,+experimental-zabhlrsc,+h -d --no-print-imm-hex %t.rv64i.o \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-64 %s
// RUN: llvm-objdump -M no-aliases --mattr=+experimental-y,+a,+zabha,+experimental-zabhlrsc,+h -d --no-print-imm-hex %t.rv64i.o \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP-MODE-DISASM,CHECK-CAP-MODE-DISASM-64 %s

// CHECK: lb	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x03,0x05,0x00,0x01]
// CHECK-CAP-MODE-DISASM: 01000503 <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
lb a0, 16(zero)
// CHECK-NEXT: sb	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x23,0x08,0xa0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00a00823 <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
sb a0, 16(zero)
// CHECK-NEXT: lbu	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x03,0x45,0x00,0x01]
// CHECK-CAP-MODE-DISASM-NEXT: 01004503 <unknown>
// ERR-RVY: :[[#@LINE+1]]:12: error: register must be a GPR excluding zero (x0)
lbu a0, 16(zero)
// CHECK-NEXT: lh	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x03,0x15,0x00,0x01]
// CHECK-CAP-MODE-DISASM-NEXT: 01001503 <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
lh a0, 16(zero)
// CHECK-NEXT: sh	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x23,0x18,0xa0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00a01823 <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
sh a0, 16(zero)
// CHECK-NEXT: lhu	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x03,0x55,0x00,0x01]
// CHECK-CAP-MODE-DISASM-NEXT: 01005503 <unknown>
// ERR-RVY: :[[#@LINE+1]]:12: error: register must be a GPR excluding zero (x0)
lhu a0, 16(zero)
// CHECK-NEXT: lw	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x03,0x25,0x00,0x01]
// CHECK-CAP-MODE-DISASM-NEXT: 01002503 <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
lw a0, 16(zero)
// CHECK-NEXT: sw	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x23,0x28,0xa0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00a02823 <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
sw a0, 16(zero)
// CHECK-NEXT: lw	a0, 0(zero)
// CHECK-ASM-SAME: # encoding: [0x03,0x25,0x00,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00002503 <unknown>
// ERR-RVY: :[[#@LINE+1]]:9: error: register must be a GPR excluding zero (x0)
lw a0, (zero)
// CHECK-NEXT: sw	a0, 0(zero)
// CHECK-ASM-SAME: # encoding: [0x23,0x20,0xa0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00a02023 <unknown>
// ERR-RVY: :[[#@LINE+1]]:9: error: register must be a GPR excluding zero (x0)
sw a0, (zero)
.ifdef RV64
// CHECK-64: lwu	a0, 16(zero)
// CHECK-ASM-64-SAME: # encoding: [0x03,0x65,0x00,0x01]
// CHECK-CAP-MODE-DISASM-64-NEXT: 01006503 <unknown>
// ERR-RVY-64: :[[#@LINE+1]]:12: error: register must be a GPR excluding zero (x0)
lwu a0, 16(zero)
// CHECK-64: ld	a0, 16(zero)
// CHECK-ASM-64-SAME: # encoding:  [0x03,0x35,0x00,0x01]
// CHECK-CAP-MODE-DISASM-64-NEXT: 01003503 <unknown>
// ERR-RVY-64: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
ld a0, 16(zero)
// CHECK-64: sd	a0, 16(zero)
// CHECK-ASM-64-SAME: # encoding: [0x23,0x38,0xa0,0x00]
// CHECK-CAP-MODE-DISASM-64-NEXT: 00a03823 <unknown>
// ERR-RVY-64: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
sd a0, 16(zero)
.endif
// CHECK-NEXT: ly	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x7b,0x15,0x00,0x01]
// CHECK-CAP-MODE-DISASM-NEXT: 0100157b <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
ly a0, 16(zero)
// CHECK-NEXT: sy	a0, 16(zero)
// CHECK-ASM-SAME: # encoding: [0x7b,0x28,0xa0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00a0287b <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: register must be a GPR excluding zero (x0)
sy a0, 16(zero)
// CHECK-NEXT: lr.w	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x25,0x00,0x10]
// CHECK-CAP-MODE-DISASM-NEXT: 1000252f <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
lr.w a0, (zero)
// CHECK-NEXT: sc.w	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x25,0xb0,0x18]
// CHECK-CAP-MODE-DISASM-NEXT: 18b0252f <unknown>
// ERR-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
sc.w a0, a1, (zero)
// CHECK-NEXT: amoadd.w	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x25,0xb0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00b0252f <unknown>
// ERR-RVY: :[[#@LINE+1]]:19: error: operand must be a GPR with optional zero immediate
amoadd.w a0, a1, (zero)
// CHECK-NEXT: lr.y	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x7b,0x35,0x00,0x10]
// CHECK-CAP-MODE-DISASM-NEXT: 1000357b <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
lr.y a0, (zero)
// CHECK-NEXT: sc.y	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x7b,0x35,0xb0,0x18]
// CHECK-CAP-MODE-DISASM-NEXT: 18b0357b <unknown>
// ERR-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
sc.y a0, a1, (zero)
// CHECK-NEXT: amoswap.y	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x7b,0x35,0xb0,0x08]
// CHECK-CAP-MODE-DISASM-NEXT: 08b0357b <unknown>
// ERR-RVY: :[[#@LINE+1]]:20: error: operand must be a GPR with optional zero immediate
amoswap.y a0, a1, (zero)
// CHECK-NEXT: amoadd.b	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x05,0xb0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00b0052f <unknown>
// ERR-RVY: :[[#@LINE+1]]:19: error: operand must be a GPR with optional zero immediate
amoadd.b a0, a1, (zero)
// CHECK-NEXT: amoadd.h	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x15,0xb0,0x00]
// CHECK-CAP-MODE-DISASM-NEXT: 00b0152f <unknown>
// ERR-RVY: :[[#@LINE+1]]:19: error: operand must be a GPR with optional zero immediate
amoadd.h a0, a1, (zero)
// CHECK-NEXT: lr.b	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x05,0x00,0x10]
// CHECK-CAP-MODE-DISASM-NEXT: 1000052f <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
lr.b a0, (zero)
// CHECK-NEXT: sc.b	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x05,0xb0,0x18]
// CHECK-CAP-MODE-DISASM-NEXT: 18b0052f <unknown>
// ERR-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
sc.b a0, a1, (zero)
// CHECK-NEXT: lr.h	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x15,0x00,0x10]
// CHECK-CAP-MODE-DISASM-NEXT: 1000152f <unknown>
// ERR-RVY: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
lr.h a0, (zero)
// CHECK-NEXT: sc.h	a0, a1, (zero)
// CHECK-ASM-SAME: # encoding: [0x2f,0x15,0xb0,0x18]
// CHECK-CAP-MODE-DISASM-NEXT: 18b0152f <unknown>
// ERR-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
sc.h a0, a1, (zero)
// CHECK-NEXT: hlv.b	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x73,0x45,0x00,0x60]
// CHECK-CAP-MODE-DISASM-NEXT: 60004573 <unknown>
// ERR-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
hlv.b a0, (zero)
// CHECK-NEXT: hsv.b	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x73,0x40,0xa0,0x62]
// CHECK-CAP-MODE-DISASM-NEXT: 62a04073 <unknown>
// ERR-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
hsv.b a0, (zero)
// CHECK-NEXT: hlv.y	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x73,0x45,0x00,0x70]
// CHECK-CAP-MODE-DISASM-NEXT: 70004573 <unknown>
// ERR-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
hlv.y a0, (zero)
// CHECK-NEXT: hsv.y	a0, (zero)
// CHECK-ASM-SAME: # encoding: [0x73,0x40,0xa0,0x72]
// CHECK-CAP-MODE-DISASM-NEXT: 72a04073 <unknown>
// ERR-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
hsv.y a0, (zero)
.ifdef RV64
// CHECK-64: lr.d	a0, (zero)
// CHECK-ASM-64-SAME: # encoding: [0x2f,0x35,0x00,0x10]
// CHECK-CAP-MODE-DISASM-64-NEXT: 1000352f <unknown>
// ERR-RVY-64: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
lr.d a0, (zero)
// CHECK-64: sc.d	a0, a1, (zero)
// CHECK-ASM-64-SAME: # encoding: [0x2f,0x35,0xb0,0x18]
// CHECK-CAP-MODE-DISASM-64-NEXT: 18b0352f <unknown>
// ERR-RVY-64: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
sc.d a0, a1, (zero)
// CHECK-64: amoadd.d	a0, a1, (zero)
// CHECK-ASM-64-SAME: # encoding: [0x2f,0x35,0xb0,0x00]
// CHECK-CAP-MODE-DISASM-64-NEXT: 00b0352f <unknown>
// ERR-RVY-64: :[[#@LINE+1]]:19: error: operand must be a GPR with optional zero immediate
amoadd.d a0, a1, (zero)
.endif
