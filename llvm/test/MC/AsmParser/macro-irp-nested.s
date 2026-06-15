## Test that nested macro call sites are correctly mapped back to definition lines
## even in `.irp` expansions.
# RUN: not llvm-mc -triple x86_64 %s -o /dev/null 2>&1 | FileCheck %s

.macro inner
  unknown_directive_here
.endm

.irp val, nop, inner
  \val
.endr

# CHECK: <macro inner instantiation>:1:{{[0-9]+}}: error: invalid instruction mnemonic 'unknown_directive_here'
# CHECK-NEXT:   unknown_directive_here
# CHECK-NEXT:   ^
# CHECK-NEXT: {{.*}}macro-irp-nested.s:11:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT: .endr
# CHECK-NEXT: ^
# CHECK-NEXT: {{.*}}macro-irp-nested.s:9:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT: .irp val, nop, inner
# CHECK-NEXT: ^
