// RUN: not llvm-mc --triple=riscv32 --mattr=+zca,+experimental-y < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+zca,+experimental-y < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK-CAP --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv32 --mattr=+zca,+experimental-zyhybrid --defsym=INT_MODE=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK-INT --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+zca,+experimental-zyhybrid --defsym=INT_MODE=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK-INT --implicit-check-not=error: %s

// CHECK-CAP: :[[#@LINE+2]]:1: error: invalid instruction{{$}}
// CHECK-INT: :[[#@LINE+1]]:10: error: register must be a GPR excluding zero (x0)
c.mv a0, zero

// CHECK-CAP: :[[#@LINE+2]]:7: error: register must be a GPR excluding zero (x0)
// CHECK-INT: :[[#@LINE+1]]:1: error: invalid instruction{{$}}
c.ymv zero, a0

// CHECK-CAP: :[[#@LINE+2]]:11: error: register must be a GPR excluding zero (x0)
// CHECK-INT: :[[#@LINE+1]]:1: error: invalid instruction{{$}}
c.ymv a0, zero

// CHECK-CAP: :[[#@LINE+2]]:7: error: register must be a GPR excluding zero (x0)
// CHECK-INT: :[[#@LINE+1]]:1: error: invalid instruction{{$}}
c.ymv f0, a0

// CHECK-CAP: :[[#@LINE+2]]:11: error: register must be a GPR excluding zero (x0)
// CHECK-INT: :[[#@LINE+1]]:1: error: invalid instruction{{$}}
c.ymv a0, f0

.ifdef INT_MODE
// CHECK-INT: :[[#@LINE+1]]:1: error: instruction requires the following: RVY capability pointer mode{{$}}
c.ymv a0, a1
.else
// CHECK-CAP: :[[#@LINE+1]]:1: error: instruction requires the following: RVI pointer mode{{$}}
c.mv a0, a1
.endif
