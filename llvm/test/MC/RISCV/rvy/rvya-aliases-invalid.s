## In RVY capability mode we should get the same diagnostics as in rva-aliases-invalid.s
# RUN: not llvm-mc -triple=riscv32 --mattr=+a,+experimental-y < %S/../rva-aliases-invalid.s 2>&1 | FileCheck %S/../rva-aliases-invalid.s
# RUN: not llvm-mc -triple=riscv64 --mattr=+a,+experimental-y < %S/../rva-aliases-invalid.s 2>&1 | FileCheck %S/../rva-aliases-invalid.s
# RUN: not llvm-mc %s -triple=riscv32 --mattr=+a,+experimental-y 2>&1 | FileCheck %s --implicit-check-not=error:
# RUN: not llvm-mc %s -triple=riscv64 --mattr=+a,+experimental-y 2>&1 | FileCheck %s --implicit-check-not=error:
# RUN: not llvm-mc %s -triple=riscv32 --mattr=+a 2>&1 | FileCheck %s --check-prefix=CHECK-NO-Y
# RUN: not llvm-mc %s -triple=riscv64 --mattr=+a 2>&1 | FileCheck %s --check-prefix=CHECK-NO-Y

lr.y a1, a0
# CHECK: :[[@LINE-1]]:10: error: expected '(' or optional integer offset
lr.y a1, foo
# CHECK: :[[@LINE-1]]:10: error: expected '(' or optional integer offset
lr.y a1, 1(a0)
# CHECK: :[[@LINE-1]]:10: error: optional integer offset must be 0
lr.y a1, (foo)
# CHECK: :[[@LINE-1]]:11: error: expected register
lr.y a1, 0(foo)
# CHECK: :[[@LINE-1]]:12: error: expected register
lr.y a1, (f0)
# CHECK: :[[@LINE-1]]:11: error: operand must be a GPR with optional zero immediate
lr.y a1, 0(f0)
# CHECK: :[[@LINE-1]]:12: error: operand must be a GPR with optional zero immediate
lr.y f0, (a0)
# CHECK: :[[@LINE-1]]:6: error: register must be a GPR
lr.y a1, 0(a0
# CHECK: :[[@LINE-1]]:14: error: expected ')'
lr.y a1, (a0
# CHECK: :[[@LINE-1]]:13: error: expected ')'
lr.y a1, (a0)
# CHECK-NO-Y: :[[@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}

sc.y a2, a1, a0
# CHECK: :[[@LINE-1]]:14: error: expected '(' or optional integer offset
sc.y a2, a1, foo
# CHECK: :[[@LINE-1]]:14: error: expected '(' or optional integer offset
sc.y a2, a1, 1(a0)
# CHECK: :[[@LINE-1]]:14: error: optional integer offset must be 0
sc.y a2, a1, (foo)
# CHECK: :[[@LINE-1]]:15: error: expected register
sc.y a2, a1, 0(foo)
# CHECK: :[[@LINE-1]]:16: error: expected register
sc.y a2, a1, (f0)
# CHECK: :[[@LINE-1]]:15: error: operand must be a GPR with optional zero immediate
sc.y a2, a1, 0(f0)
# CHECK: :[[@LINE-1]]:16: error: operand must be a GPR with optional zero immediate
sc.y f0, a1, (a0)
# CHECK: :[[@LINE-1]]:6: error: register must be a GPR
sc.y a2, f0, (a0)
# CHECK: :[[@LINE-1]]:10: error: register must be a GPR
sc.y a2, a1, 0(a0
# CHECK: :[[@LINE-1]]:18: error: expected ')'
sc.y a2, a1, (a0
# CHECK: :[[@LINE-1]]:17: error: expected ')'
sc.y a2, a1, (a0)
# CHECK-NO-Y: :[[@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}

amoswap.y a2, a1, a0
# CHECK: :[[@LINE-1]]:19: error: expected '(' or optional integer offset
amoswap.y a2, a1, foo
# CHECK: :[[@LINE-1]]:19: error: expected '(' or optional integer offset
amoswap.y a2, a1, 1(a0)
# CHECK: :[[@LINE-1]]:19: error: optional integer offset must be 0
amoswap.y a2, a1, (foo)
# CHECK: :[[@LINE-1]]:20: error: expected register
amoswap.y a2, a1, 0(foo)
# CHECK: :[[@LINE-1]]:21: error: expected register
amoswap.y a2, a1, (f0)
# CHECK: :[[@LINE-1]]:20: error: operand must be a GPR with optional zero immediate
amoswap.y a2, a1, 0(f0)
# CHECK: :[[@LINE-1]]:21: error: operand must be a GPR with optional zero immediate
amoswap.y f0, a1, (a0)
# CHECK: :[[@LINE-1]]:11: error: register must be a GPR
amoswap.y a2, f0, (a0)
# CHECK: :[[@LINE-1]]:15: error: register must be a GPR
amoswap.y a2, a1, 0(a0
# CHECK: :[[@LINE-1]]:23: error: expected ')'
amoswap.y a2, a1, (a0
# CHECK: :[[@LINE-1]]:22: error: expected ')'
amoswap.y a2, a1, (a0)
# CHECK-NO-Y: :[[@LINE-1]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
