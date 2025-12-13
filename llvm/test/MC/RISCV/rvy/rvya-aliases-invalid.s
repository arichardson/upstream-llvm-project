## In RVY capability mode we should get the same diagnostics as in rva-aliases-invalid.s
# RUN: not llvm-mc -triple=riscv32 --mattr=+a,+experimental-y,+cap-mode < %S/../rva-aliases-invalid.s 2>&1 | FileCheck %S/../rva-aliases-invalid.s
# RUN: not llvm-mc -triple=riscv64 --mattr=+a,+experimental-y,+cap-mode < %S/../rva-aliases-invalid.s  2>&1 | FileCheck %S/../rva-aliases-invalid.s
