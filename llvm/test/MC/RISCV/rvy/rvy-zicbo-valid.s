// RUN: llvm-mc --triple=riscv32 --mattr=+zicbom,+zicboz,+zicbop,+experimental-y --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+zicbom,+zicboz,+zicbop,+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump --no-print-imm-hex -d -r - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-OBJ,CHECK-CAP-OBJ %s
// RUN: llvm-mc --triple=riscv64 --mattr=+zicbom,+zicboz,+zicbop,+experimental-y --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+zicbom,+zicboz,+zicbop,+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump --no-print-imm-hex -d -r - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-OBJ,CHECK-CAP-OBJ %s

// RUN: llvm-mc --triple=riscv32 --mattr=+zicbom,+zicboz,+zicbop,+experimental-zyhybrid --defsym=INT_MODE=1 --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-INT-ASM-AND-OBJ %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+zicbom,+zicboz,+zicbop,+experimental-zyhybrid --defsym=INT_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump --no-print-imm-hex -d -r - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-OBJ,CHECK-INT-OBJ,CHECK-INT-ASM-AND-OBJ %s
// RUN: llvm-mc --triple=riscv64 --mattr=+zicbom,+zicboz,+zicbop,+experimental-zyhybrid --defsym=INT_MODE=1 --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-INT-ASM-AND-OBJ %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+zicbom,+zicboz,+zicbop,+experimental-zyhybrid --defsym=INT_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump --no-print-imm-hex -d -r - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-OBJ,CHECK-INT-OBJ,CHECK-INT-ASM-AND-OBJ %s

///
/// Zicbom instructions:
///

// CHECK-ASM-AND-OBJ: cbo.clean (t0)
// CHECK-ASM-SAME: # encoding: [0x0f,0xa0,0x12,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_CLEAN{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X5>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>>
cbo.clean (t0)

// CHECK-ASM-AND-OBJ: cbo.clean (t0)
// CHECK-ASM-SAME: # encoding: [0x0f,0xa0,0x12,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_CLEAN{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X5>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>>
cbo.clean 0(t0)

// CHECK-ASM-AND-OBJ: cbo.flush (t1)
// CHECK-ASM-SAME: # encoding: [0x0f,0x20,0x23,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_FLUSH{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X6>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X6_Y>>
cbo.flush (t1)

// CHECK-ASM-AND-OBJ: cbo.flush (t1)
// CHECK-ASM-SAME: # encoding: [0x0f,0x20,0x23,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_FLUSH{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X6>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X6_Y>>
cbo.flush 0(t1)

// CHECK-ASM-AND-OBJ: cbo.inval (t2)
// CHECK-ASM-SAME: # encoding: [0x0f,0xa0,0x03,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_INVAL{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X7>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X7_Y>>
cbo.inval (t2)

// CHECK-ASM-AND-OBJ: cbo.inval (t2)
// CHECK-ASM-SAME: # encoding: [0x0f,0xa0,0x03,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_INVAL{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X7>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X7_Y>>
cbo.inval 0(t2)

///
/// Zicboz instructions:
///

// CHECK-ASM-AND-OBJ: cbo.zero (t0)
// CHECK-ASM-SAME: # encoding: [0x0f,0xa0,0x42,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_ZERO{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X5>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>>
cbo.zero (t0)

// CHECK-ASM-AND-OBJ: cbo.zero (t0)
// CHECK-ASM-SAME: # encoding: [0x0f,0xa0,0x42,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] CBO_ZERO{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X5>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>>
cbo.zero 0(t0)

///
/// Zicbop instructions:
///

// CHECK-ASM-AND-OBJ: prefetch.i -2048(t0)
// CHECK-ASM-SAME: # encoding: [0x13,0xe0,0x02,0x80]
// CHECK-ASM-NEXT: # <MCInst #[[#]] PREFETCH_I{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:-2048>>
prefetch.i -2048(t0)

// CHECK-ASM-AND-OBJ: prefetch.i 2016(t0)
// CHECK-ASM-SAME: # encoding: [0x13,0xe0,0x02,0x7e]
// CHECK-ASM-NEXT: # <MCInst #[[#]] PREFETCH_I{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X5>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X5_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:2016>>
prefetch.i 2016(t0)

// CHECK-ASM-AND-OBJ: prefetch.r -2048(t1)
// CHECK-ASM-SAME: # encoding: [0x13,0x60,0x13,0x80]
// CHECK-ASM-NEXT: # <MCInst #[[#]] PREFETCH_R{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X6>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X6_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:-2048>>
prefetch.r -0x800(t1)

// CHECK-ASM-AND-OBJ: prefetch.r 2016(t1)
// CHECK-ASM-SAME: # encoding: [0x13,0x60,0x13,0x7e]
// CHECK-ASM-NEXT: # <MCInst #[[#]] PREFETCH_R{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X6>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X6_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:2016>>
prefetch.r 0x7e0(t1)

// CHECK-ASM-AND-OBJ: prefetch.w -2048(t2)
// CHECK-ASM-SAME: # encoding: [0x13,0xe0,0x33,0x80]
// CHECK-ASM-NEXT: # <MCInst #[[#]] PREFETCH_W{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X7>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X7_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:-2048>>
prefetch.w -2048(t2)

// CHECK-ASM-AND-OBJ: prefetch.w 2016(t2)
// CHECK-ASM-SAME: # encoding: [0x13,0xe0,0x33,0x7e]
// CHECK-ASM-NEXT: # <MCInst #[[#]] PREFETCH_W{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X7>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X7_Y>
// CHECK-ASM-NEXT: #  <MCOperand Imm:2016>>
prefetch.w 2016(t2)

///
/// Ensure ori with non-zero rs1 disassembles as prefetch.* in both modes,
/// while ori with rs1=x0 only disassembles as prefetch.* in RVI pointer mode
/// (since rs1=x0 is reserved for capability base pointers in RVY mode):
///

// CHECK-ASM: ori zero, t0, -2048
// CHECK-OBJ: prefetch.i -2048(t0)
// CHECK-ASM-SAME: # encoding: [0x13,0xe0,0x02,0x80]
ori x0, t0, -2048

// CHECK-ASM: ori zero, zero, -2048
// CHECK-INT-OBJ: prefetch.i -2048(zero)
// CHECK-CAP-OBJ: 80006013 <unknown>
// CHECK-ASM-SAME: # encoding: [0x13,0x60,0x00,0x80]
ori x0, x0, -2048

///
/// In RVI pointer mode (Zyhybrid), x0 is a valid base register:
///
.ifdef INT_MODE
// CHECK-INT-ASM-AND-OBJ: cbo.clean (zero)
// CHECK-INT-SAME: # encoding: [0x0f,0x20,0x10,0x00]
// CHECK-INT-NEXT: # <MCInst #[[#]] CBO_CLEAN{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X0>>
cbo.clean (zero)

// CHECK-INT-ASM-AND-OBJ: cbo.zero (zero)
// CHECK-INT-SAME: # encoding: [0x0f,0x20,0x40,0x00]
// CHECK-INT-NEXT: # <MCInst #[[#]] CBO_ZERO{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X0>>
cbo.zero (zero)

// CHECK-INT-ASM-AND-OBJ: prefetch.i 0(zero)
// CHECK-INT-SAME: # encoding: [0x13,0x60,0x00,0x00]
// CHECK-INT-NEXT: # <MCInst #[[#]] PREFETCH_I{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:X0>
// CHECK-INT-NEXT: #  <MCOperand Imm:0>>
prefetch.i 0(zero)
.endif
