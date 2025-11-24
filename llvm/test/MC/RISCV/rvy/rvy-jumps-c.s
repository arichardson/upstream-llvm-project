# RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+c --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-RV32-ASM %s
# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+c --riscv-no-aliases --show-encoding --show-inst --defsym=RV64=1 < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+c < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+c -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-OBJ,CHECK-RV32-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+c --defsym=RV64=1 < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+c -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s

# CHECK: c.jr a0
# CHECK-ASM-SAME: # encoding: [0x02,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_JR{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
c.jr a0
# CHECK-NEXT: c.jalr a0
# CHECK-ASM-SAME: # encoding: [0x02,0x95]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_JALR{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
c.jalr a0
## Implicit compression: jalr ra, 0(a0) -> c.jalr a0
# CHECK-NEXT: c.jalr a0
# CHECK-ASM-SAME: # encoding: [0x02,0x95]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_JALR{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
jalr ra, 0(a0)
## Implicit compression: jalr zero, 0(a0) -> c.jr a0
# CHECK-NEXT: c.jr a0
# CHECK-ASM-SAME: # encoding: [0x02,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_JR{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
jalr zero, 0(a0)
# CHECK-ASM-NEXT: c.j -2048
# CHECK-ASM-SAME: # encoding: [0x01,0xb0]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_J{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Imm:-2048>>
# CHECK-OBJ-NEXT: c.j {{0x[f]+808}}
c.j -2048
## Implicit compression: jal zero, -2048 -> c.j -2048
# CHECK-ASM-NEXT: c.j -2048
# CHECK-ASM-SAME: # encoding: [0x01,0xb0]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_J{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Imm:-2048>>
# CHECK-OBJ-NEXT: c.j {{0x[f]+80a}}
jal zero, -2048
.ifndef RV64
# CHECK-RV32-ASM-NEXT: c.jal 2046
# CHECK-RV32-ASM-SAME: # encoding: [0xfd,0x2f]
# CHECK-RV32-ASM-NEXT: # <MCInst #[[#]] C_JAL{{$}}
# CHECK-RV32-ASM-NEXT: #  <MCOperand Imm:2046>>
# CHECK-RV32-OBJ-NEXT: c.jal 0x80a
c.jal 2046
## Implicit compression: jal ra, 2046 -> c.jal 2046
# CHECK-RV32-ASM-NEXT: c.jal 2046
# CHECK-RV32-ASM-SAME: # encoding: [0xfd,0x2f]
# CHECK-RV32-ASM-NEXT: # <MCInst #[[#]] C_JAL{{$}}
# CHECK-RV32-ASM-NEXT: #  <MCOperand Imm:2046>>
# CHECK-RV32-OBJ-NEXT: c.jal 0x80c
jal ra, 2046
.endif
