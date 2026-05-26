// RUN: not llvm-mc --triple riscv32 --mattr=+experimental-zyhybrid <%s 2>&1 \
// RUN:   | FileCheck %s --implicit-check-not=error:
// RUN: not llvm-mc --triple riscv64 --mattr=+experimental-zyhybrid <%s 2>&1 \
// RUN:   | FileCheck %s --implicit-check-not=error:

ymodew x0, a0, a0
// CHECK: :[[#@LINE-1]]:8: error: register must be a GPR excluding zero (x0)
