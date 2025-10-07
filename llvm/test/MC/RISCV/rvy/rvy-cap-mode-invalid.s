# RUN: not llvm-mc --triple riscv32 --mattr=+experimental-y,+cap-mode <%s 2>&1 \
# RUN:     | FileCheck %s --check-prefixes=CHECK,CHECK-32 '--implicit-check-not=error:'
# RUN: not llvm-mc --triple riscv64 --mattr=+experimental-y,+cap-mode <%s 2>&1 \
# RUN:     | FileCheck %s --check-prefixes=CHECK,CHECK-64 '--implicit-check-not=error:'

# TODO: support expanding these pseudos
lw a0, sym
ld a0, sym
# CHECK-32: [[#@LINE-1]]:1: error: instruction requires the following: 'Zilsd' (Load/Store pair instructions)
ly a0, sym
# CHECK: [[#@LINE-1]]:8: error: operand must be a symbol with %lo/%pcrel_lo/%tprel_lo specifier or an integer in the range [-2048, 2047]

.data
sym:
.4byte 0
