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

///
/// Zicsr instructions and aliases with RVY CSRs and widened YLEN CSRs:
///

// CHECK-INST: csrrw a0, ddc, a1
// CHECK-ENC: encoding: [0x73,0x95,0xf5,0x03]
// CHECK-INST-ALIAS: csrrw a0, ddc, a1
csrrw a0, ddc, a1

// CHECK-INST: csrrw zero, utidc, a1
// CHECK-ENC: encoding: [0x73,0x90,0xf5,0x07]
// CHECK-INST-ALIAS: csrw utidc, a1
csrw utidc, a1

// CHECK-INST: csrrs zero, stidc, a1
// CHECK-ENC: encoding: [0x73,0xa0,0xf5,0x17]
// CHECK-INST-ALIAS: csrs stidc, a1
csrs stidc, a1

// CHECK-INST: csrrc zero, mtidc, a1
// CHECK-ENC: encoding: [0x73,0xb0,0xf5,0x37]
// CHECK-INST-ALIAS: csrc mtidc, a1
csrc mtidc, a1

// CHECK-INST: csrrwi a0, ddc, 0
// CHECK-ENC: encoding: [0x73,0x55,0xf0,0x03]
// CHECK-INST-ALIAS: csrrwi a0, ddc, 0x0
csrrwi a0, ddc, 0

// CHECK-INST: csrrwi zero, utidc, 1
// CHECK-ENC: encoding: [0x73,0xd0,0xf0,0x07]
// CHECK-INST-ALIAS: csrwi utidc, 0x1
csrwi utidc, 1

// CHECK-INST: csrrsi zero, stvec, 2
// CHECK-ENC: encoding: [0x73,0x60,0x51,0x10]
// CHECK-INST-ALIAS: csrsi stvec, 0x2
csrsi stvec, 2

// CHECK-INST: csrrci zero, mtvec, 3
// CHECK-ENC: encoding: [0x73,0xf0,0x51,0x30]
// CHECK-INST-ALIAS: csrci mtvec, 0x3
csrci mtvec, 3

// CHECK-INST: csrrw a0, mscratch, a1
// CHECK-ENC: encoding: [0x73,0x95,0x05,0x34]
// CHECK-INST-ALIAS: csrrw a0, mscratch, a1
csrrw a0, mscratch, a1

// CHECK-INST: csrrw a0, mepc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x34]
// CHECK-INST-ALIAS: csrrw a0, mepc, a1
csrrw a0, mepc, a1

// CHECK-INST: csrrw a0, sscratch, a1
// CHECK-ENC: encoding: [0x73,0x95,0x05,0x14]
// CHECK-INST-ALIAS: csrrw a0, sscratch, a1
csrrw a0, sscratch, a1

// CHECK-INST: csrrw a0, sepc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x14]
// CHECK-INST-ALIAS: csrrw a0, sepc, a1
csrrw a0, sepc, a1

// CHECK-INST: csrrw a0, vstvec, a1
// CHECK-ENC: encoding: [0x73,0x95,0x55,0x20]
// CHECK-INST-ALIAS: csrrw a0, vstvec, a1
csrrw a0, vstvec, a1

// CHECK-INST: csrrw a0, vsscratch, a1
// CHECK-ENC: encoding: [0x73,0x95,0x05,0x24]
// CHECK-INST-ALIAS: csrrw a0, vsscratch, a1
csrrw a0, vsscratch, a1

// CHECK-INST: csrrw a0, vsepc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x24]
// CHECK-INST-ALIAS: csrrw a0, vsepc, a1
csrrw a0, vsepc, a1

// CHECK-INST: csrrw a0, jvt, a1
// CHECK-ENC: encoding: [0x73,0x95,0x75,0x01]
// CHECK-INST-ALIAS: csrrw a0, jvt, a1
csrrw a0, jvt, a1

// CHECK-INST: csrrw a0, dpc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x7b]
// CHECK-INST-ALIAS: csrrw a0, dpc, a1
csrrw a0, dpc, a1

// CHECK-INST: csrrw a0, dscratch0, a1
// CHECK-ENC: encoding: [0x73,0x95,0x25,0x7b]
// CHECK-INST-ALIAS: csrrw a0, dscratch0, a1
csrrw a0, dscratch0, a1

// CHECK-INST: csrrw a0, dscratch1, a1
// CHECK-ENC: encoding: [0x73,0x95,0x35,0x7b]
// CHECK-INST-ALIAS: csrrw a0, dscratch1, a1
csrrw a0, dscratch1, a1
