## In RVY capability mode we should get the same diagnostics as in rvi-pseudos-invalid.s
# RUN: not llvm-mc -triple=riscv32 -mattr=+experimental-y,+cap-mode < %S/../rvi-pseudos-invalid.s 2>&1 | FileCheck %S/../rvi-pseudos-invalid.s  --implicit-check-not=error:
# RUN: not llvm-mc -triple=riscv64 -mattr=+experimental-y,+cap-mode < %S/../rvi-pseudos-invalid.s  2>&1 | FileCheck %S/../rvi-pseudos-invalid.s  --implicit-check-not=error:
