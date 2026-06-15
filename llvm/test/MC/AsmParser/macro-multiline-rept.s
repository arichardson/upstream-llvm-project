## Test that multi-line macro-like expansions (like .rept) have correct line numbers in diagnostics.
# RUN: not llvm-mc -triple x86_64 %s -o /dev/null 2>&1 | FileCheck %s

.macro inner
  unknown_directive_here
.endm

.rept 2
  nop
  inner
.endr

# CHECK: <macro inner instantiation>:1:{{[0-9]+}}: error: invalid instruction mnemonic 'unknown_directive_here'
# CHECK-NEXT:   unknown_directive_here
# CHECK-NEXT:   ^
# CHECK-NEXT: {{.*}}macro-multiline-rept.s:10:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT:   inner
# CHECK-NEXT:   ^
# CHECK-NEXT: {{.*}}macro-multiline-rept.s:8:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT: .rept 2
# CHECK-NEXT: ^
# CHECK: <macro inner instantiation>:1:{{[0-9]+}}: error: invalid instruction mnemonic 'unknown_directive_here'
# CHECK-NEXT:   unknown_directive_here
# CHECK-NEXT:   ^
# CHECK-NEXT: {{.*}}macro-multiline-rept.s:12:{{[0-9]+}}: note: while in macro instantiation
# CHECK-EMPTY:
# CHECK-NEXT: {{^ *}}^
# CHECK-NEXT: {{.*}}macro-multiline-rept.s:8:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT: .rept 2
# CHECK-NEXT: ^
