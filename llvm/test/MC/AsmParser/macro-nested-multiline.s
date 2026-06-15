## Test that nested macro call sites are correctly mapped back to definition lines
## even when preceding arguments expand to multiple lines.
# RUN: not llvm-mc -triple x86_64 %s -o /dev/null 2>&1 | FileCheck %s

.altmacro
.macro inner
  unknown_directive_here
.endm

.macro outer arg
  nop
  \arg
  inner
  nop
.endm

outer <nop!
nop>

# CHECK: <macro inner instantiation>:1:{{[0-9]+}}: error: invalid instruction mnemonic 'unknown_directive_here'
# CHECK-NEXT:   unknown_directive_here
# CHECK-NEXT:   ^
# CHECK-NEXT: {{.*}}macro-nested-multiline.s:14:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT:   nop
# CHECK-NEXT:   ^
# CHECK-NEXT: {{.*}}macro-nested-multiline.s:17:{{[0-9]+}}: note: while in macro instantiation
# CHECK-NEXT: outer <nop!
# CHECK-NEXT: ^
