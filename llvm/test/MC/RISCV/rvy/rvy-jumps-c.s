# RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+cap-mode,+c --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+cap-mode,+c --riscv-no-aliases --show-encoding --show-inst --defsym=RV64=1 < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+cap-mode,+c < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+cap-mode,+c -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+cap-mode,+c - < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+cap-mode,+c -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck %s

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
# Implicit compression: jalr ra, 0(a0) -> c.jalr a0
# CHECK-NEXT: c.jalr a0
# CHECK-ASM-SAME: # encoding: [0x02,0x95]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_JALR{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
jalr ra, 0(a0)
# Implicit compression: jalr zero, 0(a0) -> c.jr a0
# CHECK-NEXT: c.jr a0
# CHECK-ASM-SAME: # encoding: [0x02,0x85]
# CHECK-ASM-NEXT: # <MCInst #[[#]] C_JR{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>>
jalr zero, 0(a0)
