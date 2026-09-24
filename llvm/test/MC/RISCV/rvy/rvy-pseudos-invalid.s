## In RVY capability mode we should get the same diagnostics as in rvi-pseudos-invalid.s
# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-y < %S/../rvi-pseudos-invalid.s 2>&1 | FileCheck %S/../rvi-pseudos-invalid.s --check-prefixes=CHECK,CHECK-RV32 --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-y < %S/../rvi-pseudos-invalid.s 2>&1 | FileCheck %S/../rvi-pseudos-invalid.s --check-prefixes=CHECK,CHECK-RV64 --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-y < %s 2>&1 | FileCheck %s --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-y < %s 2>&1 | FileCheck %s --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-zyhybrid < %s 2>&1 | FileCheck %s --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-zyhybrid < %s 2>&1 | FileCheck %s --implicit-check-not=error:

ly x0, a_symbol
# CHECK: :[[#@LINE-1]]:4: error: register must be a GPR excluding zero (x0)
sy a2, a_symbol, x0
# CHECK: :[[#@LINE-1]]:18: error: register must be a GPR excluding zero (x0)
