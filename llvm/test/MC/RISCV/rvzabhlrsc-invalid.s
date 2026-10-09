# RUN: not llvm-mc -triple riscv32 -mattr=+experimental-zabhlrsc < %s 2>&1 | FileCheck %s
# RUN: not llvm-mc -triple riscv64 -mattr=+experimental-zabhlrsc < %s 2>&1 | FileCheck %s

## Final operand must have parentheses and zero offset
lr.b a1, a2 # CHECK: :[[@LINE]]:10: error: expected '(' or optional integer offset
lr.h a1, 1 # CHECK: :[[@LINE]]:12: error: expected '(' after optional integer offset
lr.b a1, 1(a2) # CHECK: :[[@LINE]]:10: error: optional integer offset must be 0
lr.h a1, 1(a2) # CHECK: :[[@LINE]]:10: error: optional integer offset must be 0
sc.b a1, a2, a3 # CHECK: :[[@LINE]]:14: error: expected '(' or optional integer offset
sc.h a1, a2, 1 # CHECK: :[[@LINE]]:16: error: expected '(' after optional integer offset
sc.b a1, a2, 1(a3) # CHECK: :[[@LINE]]:14: error: optional integer offset must be 0
sc.h a1, a2, 1(a3) # CHECK: :[[@LINE]]:14: error: optional integer offset must be 0

## Wrong number of operands
lr.b a1, a2, (a3) # CHECK: :[[@LINE]]:10: error: expected '(' or optional integer offset
lr.h a1, a2, (a3) # CHECK: :[[@LINE]]:10: error: expected '(' or optional integer offset
sc.b a1, (a2) # CHECK: :[[@LINE]]:10: error: register must be a GPR
sc.h a1, (a2) # CHECK: :[[@LINE]]:10: error: register must be a GPR

## Only .aq, .rl, and .aqrl suffixes are valid
lr.b.rlqa a1, (a2) # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
lr.h.aq.rl a1, (a2) # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
sc.b.rlqa a1, a2, (a3) # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
sc.h. a1, a2, (a3) # CHECK: :[[@LINE]]:1: error: unrecognized instruction mnemonic
