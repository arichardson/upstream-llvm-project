// RUN: not llvm-mc --triple=riscv32 --mattr=+zicbom,+zicboz,+zicbop,+experimental-y < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-RVY --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+zicbom,+zicboz,+zicbop,+experimental-y < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-RVY --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv32 --mattr=+zicbom,+zicboz,+zicbop,+experimental-zyhybrid --defsym=INT_MODE=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+zicbom,+zicboz,+zicbop,+experimental-zyhybrid --defsym=INT_MODE=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK --implicit-check-not=error: %s

///
/// In RVY capability pointer mode, x0/zero/null is rejected as a base register:
///
.ifndef INT_MODE
// CHECK-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
cbo.clean (zero)
// CHECK-RVY: :[[#@LINE+1]]:13: error: operand must be a GPR with optional zero immediate
cbo.clean 0(null)
// CHECK-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
cbo.flush (zero)
// CHECK-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
cbo.inval (zero)
// CHECK-RVY: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
cbo.zero (zero)
// CHECK-RVY: :[[#@LINE+1]]:14: error: register must be a GPR excluding zero (x0)
prefetch.i 0(zero)
// CHECK-RVY: :[[#@LINE+1]]:15: error: register must be a GPR excluding zero (x0)
prefetch.r 32(null)
// CHECK-RVY: :[[#@LINE+1]]:16: error: register must be a GPR excluding zero (x0)
prefetch.w -32(x0)
.endif

///
/// Non-zero offsets and invalid operands are rejected in both modes:
///
// CHECK: :[[#@LINE+1]]:11: error: optional integer offset must be 0
cbo.clean 1(t0)
// CHECK: :[[#@LINE+1]]:11: error: optional integer offset must be 0
cbo.flush 2(t0)
// CHECK: :[[#@LINE+1]]:11: error: optional integer offset must be 0
cbo.inval 3(t0)
// CHECK: :[[#@LINE+1]]:10: error: optional integer offset must be 0
cbo.zero 1(t0)

// CHECK: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
cbo.clean (f0)
// CHECK: :[[#@LINE+1]]:11: error: operand must be a GPR with optional zero immediate
cbo.zero (f0)
// CHECK: :[[#@LINE+1]]:14: error: register must be a GPR
prefetch.i 0(f0)

// CHECK: :[[#@LINE+1]]:12: error: immediate must be a multiple of 32 bytes in the range [-2048, 2016]
prefetch.i 16(t0)
// CHECK: :[[#@LINE+1]]:12: error: immediate must be a multiple of 32 bytes in the range [-2048, 2016]
prefetch.r 2048(t0)
// CHECK: :[[#@LINE+1]]:12: error: immediate must be a multiple of 32 bytes in the range [-2048, 2016]
prefetch.w -2080(t0)
