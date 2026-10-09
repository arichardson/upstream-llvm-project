// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y --riscv-no-aliases --show-encoding < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y --riscv-no-aliases --show-encoding < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-zyhybrid --riscv-no-aliases --show-encoding < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid --riscv-no-aliases --show-encoding < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s

///
/// Unprivileged RVY / Zyhybrid CSRs:
///

/// ddc (0x03F)
// CHECK-INST: csrrs t1, ddc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x03]
// CHECK-INST-ALIAS: csrr t1, ddc
// CHECK-INST: csrrs t2, ddc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x03]
// CHECK-INST-ALIAS: csrr t2, ddc
csrrs t1, ddc, zero
csrrs t2, 0x03f, zero

/// utidc (0x07F)
// CHECK-INST: csrrs t1, utidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x07]
// CHECK-INST-ALIAS: csrr t1, utidc
// CHECK-INST: csrrs t2, utidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x07]
// CHECK-INST-ALIAS: csrr t2, utidc
csrrs t1, utidc, zero
csrrs t2, 0x07f, zero

///
/// Supervisor RVY CSRs:
///

/// stidc (0x17F)
// CHECK-INST: csrrs t1, stidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x17]
// CHECK-INST-ALIAS: csrr t1, stidc
// CHECK-INST: csrrs t2, stidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x17]
// CHECK-INST-ALIAS: csrr t2, stidc
csrrs t1, stidc, zero
csrrs t2, 0x17f, zero

///
/// Virtual Supervisor RVY CSRs:
///

/// vstidc (0x27F)
// CHECK-INST: csrrs t1, vstidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x27]
// CHECK-INST-ALIAS: csrr t1, vstidc
// CHECK-INST: csrrs t2, vstidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x27]
// CHECK-INST-ALIAS: csrr t2, vstidc
csrrs t1, vstidc, zero
csrrs t2, 0x27f, zero

///
/// Machine RVY CSRs:
///

/// mtidc (0x37F)
// CHECK-INST: csrrs t1, mtidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x37]
// CHECK-INST-ALIAS: csrr t1, mtidc
// CHECK-INST: csrrs t2, mtidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x37]
// CHECK-INST-ALIAS: csrr t2, mtidc
csrrs t1, mtidc, zero
csrrs t2, 0x37f, zero

///
/// Debug Mode RVY / Zyhybrid CSRs:
///

/// drootcsel (0x7BD)
// CHECK-INST: csrrs t1, drootcsel, zero
// CHECK-ENC: encoding: [0x73,0x23,0xd0,0x7b]
// CHECK-INST-ALIAS: csrr t1, drootcsel
// CHECK-INST: csrrs t2, drootcsel, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xd0,0x7b]
// CHECK-INST-ALIAS: csrr t2, drootcsel
csrrs t1, drootcsel, zero
csrrs t2, 0x7bd, zero

/// drootc (0x7BE)
// CHECK-INST: csrrs t1, drootc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xe0,0x7b]
// CHECK-INST-ALIAS: csrr t1, drootc
// CHECK-INST: csrrs t2, drootc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xe0,0x7b]
// CHECK-INST-ALIAS: csrr t2, drootc
csrrs t1, drootc, zero
csrrs t2, 0x7be, zero

/// dddc (0x7BF)
// CHECK-INST: csrrs t1, dddc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x7b]
// CHECK-INST-ALIAS: csrr t1, dddc
// CHECK-INST: csrrs t2, dddc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x7b]
// CHECK-INST-ALIAS: csrr t2, dddc
csrrs t1, dddc, zero
csrrs t2, 0x7bf, zero

