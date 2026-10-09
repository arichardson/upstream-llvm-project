// RUN: not llvm-mc --triple=riscv32 --mattr=+v,+experimental-y < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-RVY --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+v,+experimental-y < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK,CHECK-RVY --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv32 --mattr=+v,+experimental-zyhybrid --defsym=INT_MODE=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK --implicit-check-not=error: %s
// RUN: not llvm-mc --triple=riscv64 --mattr=+v,+experimental-zyhybrid --defsym=INT_MODE=1 < %s 2>&1 \
// RUN:   | FileCheck --check-prefixes=CHECK --implicit-check-not=error: %s

///
/// In RVY capability pointer mode, x0/zero/null is rejected as a base register
/// across all vector load and store classes:
///
.ifndef INT_MODE
// CHECK-RVY: :[[#@LINE+1]]:13: error: operand must be a GPR with optional zero immediate
vle8.v v8, (zero)
// CHECK-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
vle32.v v8, 0(null)
// CHECK-RVY: :[[#@LINE+1]]:12: error: operand must be a GPR with optional zero immediate
vlm.v v0, (zero)
// CHECK-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
vl1re8.v v8, (zero)
// CHECK-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
vle8ff.v v8, (zero)
// CHECK-RVY: :[[#@LINE+1]]:15: error: operand must be a GPR with optional zero immediate
vlse32.v v8, (zero), a1
// CHECK-RVY: :[[#@LINE+1]]:16: error: operand must be a GPR with optional zero immediate
vluxei8.v v8, (zero), v4
// CHECK-RVY: :[[#@LINE+1]]:17: error: operand must be a GPR with optional zero immediate
vloxei32.v v8, (zero), v4
// CHECK-RVY: :[[#@LINE+1]]:17: error: operand must be a GPR with optional zero immediate
vlseg2e8.v v8, (zero)
// CHECK-RVY: :[[#@LINE+1]]:19: error: operand must be a GPR with optional zero immediate
vlseg2e8ff.v v8, (zero)
// CHECK-RVY: :[[#@LINE+1]]:19: error: operand must be a GPR with optional zero immediate
vlsseg2e16.v v8, (zero), a1
// CHECK-RVY: :[[#@LINE+1]]:20: error: operand must be a GPR with optional zero immediate
vluxseg2ei8.v v8, (zero), v4
// CHECK-RVY: :[[#@LINE+1]]:21: error: operand must be a GPR with optional zero immediate
vloxseg2ei32.v v8, (zero), v4

// CHECK-RVY: :[[#@LINE+1]]:14: error: operand must be a GPR with optional zero immediate
vse8.v v24, (zero)
// CHECK-RVY: :[[#@LINE+1]]:16: error: operand must be a GPR with optional zero immediate
vse32.v v24, 0(null)
// CHECK-RVY: :[[#@LINE+1]]:13: error: operand must be a GPR with optional zero immediate
vsm.v v24, (zero)
// CHECK-RVY: :[[#@LINE+1]]:14: error: operand must be a GPR with optional zero immediate
vs1r.v v24, (zero)
// CHECK-RVY: :[[#@LINE+1]]:16: error: operand must be a GPR with optional zero immediate
vsse16.v v24, (zero), a1
// CHECK-RVY: :[[#@LINE+1]]:17: error: operand must be a GPR with optional zero immediate
vsuxei8.v v24, (zero), v4
// CHECK-RVY: :[[#@LINE+1]]:18: error: operand must be a GPR with optional zero immediate
vsoxei32.v v24, (zero), v4
// CHECK-RVY: :[[#@LINE+1]]:18: error: operand must be a GPR with optional zero immediate
vsseg2e8.v v24, (zero)
// CHECK-RVY: :[[#@LINE+1]]:20: error: operand must be a GPR with optional zero immediate
vssseg2e16.v v24, (zero), a1
// CHECK-RVY: :[[#@LINE+1]]:21: error: operand must be a GPR with optional zero immediate
vsuxseg2ei8.v v24, (zero), v4
// CHECK-RVY: :[[#@LINE+1]]:22: error: operand must be a GPR with optional zero immediate
vsoxseg2ei32.v v24, (zero), v4
.endif

///
/// Non-zero offsets and non-GPR base registers are rejected in both modes:
///
// CHECK: :[[#@LINE+1]]:12: error: optional integer offset must be 0
vle8.v v8, 4(a0)
// CHECK: :[[#@LINE+1]]:13: error: optional integer offset must be 0
vse8.v v24, 4(a0)
// CHECK: :[[#@LINE+1]]:13: error: operand must be a GPR with optional zero immediate
vle8.v v8, (f0)
// CHECK: :[[#@LINE+1]]:14: error: operand must be a GPR with optional zero immediate
vse8.v v24, (f0)
