# RUN: not llvm-mc -triple=riscv32 < %s 2>&1 | FileCheck %s --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv64 < %s 2>&1 | FileCheck %s --implicit-check-not=error:
## See rvi-pseudos-invalid.s

lga x1, 1234
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %pcrel_hi(1234)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %pcrel_lo(1234)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %pcrel_hi(foo)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %pcrel_lo(foo)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %hi(1234)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %lo(1234)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %hi(foo)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name
lga x1, %lo(foo)
# CHECK: :[[#@LINE-1]]:9: error: operand must be a bare symbol name

sw a2, %hi(a_symbol), a3
# CHECK: :[[#@LINE-1]]:8: error: operand must be a symbol with %lo/%pcrel_lo/%tprel_lo specifier or an integer in the range [-2048, 2047]
sw a2, %lo(a_symbol), a3
# CHECK: :[[#@LINE-1]]:23: error: invalid operand for instruction
sw a2, %lo(a_symbol)(a4), a3
# CHECK: :[[#@LINE-1]]:27: error: invalid operand for instruction

# Too few operands must be rejected
sw a2, a_symbol
# CHECK: :[[#@LINE-1]]:1: error: too few operands for instruction

# Zero register as the temporary for the store pseudo is also illegal
# since that would result in the auipc result being ignored.
sw a2, a_symbol, x0
# CHECK: :[[#@LINE-1]]:18: error: register must be a GPR excluding zero (x0)
