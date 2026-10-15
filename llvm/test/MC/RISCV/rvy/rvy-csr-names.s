// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC,CHECK-Y %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC,CHECK-Y %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC,CHECK-HYBRID %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-INST,CHECK-ENC,CHECK-HYBRID %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -d - \
// RUN:   | FileCheck --check-prefix=CHECK-INST-ALIAS %s

///
/// Unprivileged RVY / Zyhybrid CSRs (always YLEN):
///

/// ddc (0x03F)
// CHECK-INST: csrrs t1, ddc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, ddc
// CHECK-INST: csrrs t2, ddc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, ddc
csrrs t1, ddc, zero
csrrs t2, 0x03f, zero

/// utidc (0x07F)
// CHECK-INST: csrrs t1, utidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x07]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:127>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, utidc
// CHECK-INST: csrrs t2, utidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x07]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:127>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, utidc
csrrs t1, utidc, zero
csrrs t2, 0x07f, zero

///
/// Supervisor RVY CSRs (always YLEN):
///

/// stidc (0x17F)
// CHECK-INST: csrrs t1, stidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x17]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:383>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, stidc
// CHECK-INST: csrrs t2, stidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x17]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:383>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, stidc
csrrs t1, stidc, zero
csrrs t2, 0x17f, zero

///
/// Virtual Supervisor RVY CSRs (always YLEN):
///

/// vstidc (0x27F)
// CHECK-INST: csrrs t1, vstidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x27]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:639>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, vstidc
// CHECK-INST: csrrs t2, vstidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x27]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:639>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, vstidc
csrrs t1, vstidc, zero
csrrs t2, 0x27f, zero

///
/// Machine RVY CSRs (always YLEN):
///

/// mtidc (0x37F)
// CHECK-INST: csrrs t1, mtidc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x37]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:895>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, mtidc
// CHECK-INST: csrrs t2, mtidc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x37]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:895>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, mtidc
csrrs t1, mtidc, zero
csrrs t2, 0x37f, zero

///
/// Debug Mode RVY / Zyhybrid CSRs:
///

/// drootcsel (0x7BD, always XLEN)
// CHECK-INST: csrrs t1, drootcsel, zero
// CHECK-ENC: encoding: [0x73,0x23,0xd0,0x7b]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6>
// CHECK-ENC-NEXT: <MCOperand Imm:1981>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, drootcsel
// CHECK-INST: csrrs t2, drootcsel, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xd0,0x7b]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7>
// CHECK-ENC-NEXT: <MCOperand Imm:1981>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, drootcsel
csrrs t1, drootcsel, zero
csrrs t2, 0x7bd, zero

/// drootc (0x7BE, always YLEN)
// CHECK-INST: csrrs t1, drootc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xe0,0x7b]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:1982>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, drootc
// CHECK-INST: csrrs t2, drootc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xe0,0x7b]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:1982>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, drootc
csrrs t1, drootc, zero
csrrs t2, 0x7be, zero

/// dddc (0x7BF, always YLEN)
// CHECK-INST: csrrs t1, dddc, zero
// CHECK-ENC: encoding: [0x73,0x23,0xf0,0x7b]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X6_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:1983>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t1, dddc
// CHECK-INST: csrrs t2, dddc, zero
// CHECK-ENC: encoding: [0xf3,0x23,0xf0,0x7b]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X7_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:1983>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr t2, dddc
csrrs t1, dddc, zero
csrrs t2, 0x7bf, zero

///
/// Zicsr instructions and aliases with RVY CSRs and widened YLEN CSRs:
///

// CHECK-INST: csrrw a0, ddc, a1
// CHECK-ENC: encoding: [0x73,0x95,0xf5,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X10_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-INST-ALIAS: csrrw a0, ddc, a1
csrrw a0, ddc, a1

// CHECK-INST: csrrw a0, ddc, zero
// CHECK-ENC: encoding: [0x73,0x15,0xf0,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X10_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>>
// CHECK-INST-ALIAS: csrrw a0, ddc, zero
csrrw a0, ddc, null

// CHECK-INST: csrrw zero, ddc, zero
// CHECK-ENC: encoding: [0x73,0x10,0xf0,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>>
// CHECK-INST-ALIAS: csrw ddc, zero
csrw ddc, null

// CHECK-INST: csrrw zero, ddc, a1
// CHECK-ENC: encoding: [0x73,0x90,0xf5,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-INST-ALIAS: csrw ddc, a1
csrrw null, ddc, a1

// CHECK-INST: csrrs zero, ddc, zero
// CHECK-ENC: encoding: [0x73,0x20,0xf0,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Reg:X0>>
// CHECK-INST-ALIAS: csrr zero, ddc
csrrs null, ddc, zero

// CHECK-INST: csrrw zero, utidc, a1
// CHECK-ENC: encoding: [0x73,0x90,0xf5,0x07]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:127>
// CHECK-ENC-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-INST-ALIAS: csrw utidc, a1
csrw utidc, a1

// CHECK-INST: csrrs zero, stidc, a1
// CHECK-ENC: encoding: [0x73,0xa0,0xf5,0x17]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRS_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:383>
// CHECK-ENC-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrs stidc, a1
csrs stidc, a1

// CHECK-INST: csrrc zero, mtidc, a1
// CHECK-ENC: encoding: [0x73,0xb0,0xf5,0x37]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRC_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:895>
// CHECK-ENC-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrc mtidc, a1
csrc mtidc, a1

// CHECK-INST: csrrwi a0, ddc, 0
// CHECK-ENC: encoding: [0x73,0x55,0xf0,0x03]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRWI_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X10_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:63>
// CHECK-ENC-NEXT: <MCOperand Imm:0>>
// CHECK-INST-ALIAS: csrrwi a0, ddc, 0x0
csrrwi a0, ddc, 0

// CHECK-INST: csrrwi zero, utidc, 1
// CHECK-ENC: encoding: [0x73,0xd0,0xf0,0x07]
// CHECK-ENC-NEXT: <MCInst #{{[0-9]+}} CSRRWI_Y{{$}}
// CHECK-ENC-NEXT: <MCOperand Reg:X0_Y>
// CHECK-ENC-NEXT: <MCOperand Imm:127>
// CHECK-ENC-NEXT: <MCOperand Imm:1>>
// CHECK-INST-ALIAS: csrwi utidc, 0x1
csrwi utidc, 1

// CHECK-INST: csrrsi zero, stvec, 2
// CHECK-ENC: encoding: [0x73,0x60,0x51,0x10]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRSI_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X0_Y>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRSI{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X0>
// CHECK-ENC-NEXT: <MCOperand Imm:261>
// CHECK-ENC-NEXT: <MCOperand Imm:2>>
// CHECK-INST-ALIAS: csrsi stvec, 0x2
csrsi stvec, 2

// CHECK-INST: csrrci zero, mtvec, 3
// CHECK-ENC: encoding: [0x73,0xf0,0x51,0x30]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRCI_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X0_Y>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRCI{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X0>
// CHECK-ENC-NEXT: <MCOperand Imm:773>
// CHECK-ENC-NEXT: <MCOperand Imm:3>>
// CHECK-INST-ALIAS: csrci mtvec, 0x3
csrci mtvec, 3

// CHECK-INST: csrrw a0, mscratch, a1
// CHECK-ENC: encoding: [0x73,0x95,0x05,0x34]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:832>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:832>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, mscratch, a1
csrrw a0, mscratch, a1

// CHECK-INST: csrrw a0, mepc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x34]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:833>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:833>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, mepc, a1
csrrw a0, mepc, a1

// CHECK-INST: csrrw a0, sscratch, a1
// CHECK-ENC: encoding: [0x73,0x95,0x05,0x14]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:320>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:320>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, sscratch, a1
csrrw a0, sscratch, a1

// CHECK-INST: csrrw a0, sepc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x14]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:321>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:321>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, sepc, a1
csrrw a0, sepc, a1

// CHECK-INST: csrrw a0, vstvec, a1
// CHECK-ENC: encoding: [0x73,0x95,0x55,0x20]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:517>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:517>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, vstvec, a1
csrrw a0, vstvec, a1

// CHECK-INST: csrrw a0, vsscratch, a1
// CHECK-ENC: encoding: [0x73,0x95,0x05,0x24]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:576>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:576>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, vsscratch, a1
csrrw a0, vsscratch, a1

// CHECK-INST: csrrw a0, vsepc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x24]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:577>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:577>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, vsepc, a1
csrrw a0, vsepc, a1

// CHECK-INST: csrrw a0, jvt, a1
// CHECK-ENC: encoding: [0x73,0x95,0x75,0x01]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:23>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:23>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, jvt, a1
csrrw a0, jvt, a1

// CHECK-INST: csrrw a0, dpc, a1
// CHECK-ENC: encoding: [0x73,0x95,0x15,0x7b]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:1969>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:1969>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, dpc, a1
csrrw a0, dpc, a1

// CHECK-INST: csrrw a0, dscratch0, a1
// CHECK-ENC: encoding: [0x73,0x95,0x25,0x7b]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:1970>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:1970>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, dscratch0, a1
csrrw a0, dscratch0, a1

// CHECK-INST: csrrw a0, dscratch1, a1
// CHECK-ENC: encoding: [0x73,0x95,0x35,0x7b]
// CHECK-Y-NEXT: <MCInst #{{[0-9]+}} CSRRW_Y{{$}}
// CHECK-Y-NEXT: <MCOperand Reg:X10_Y>
// CHECK-Y-NEXT: <MCOperand Imm:1971>
// CHECK-Y-NEXT: <MCOperand Reg:X11_Y>>
// CHECK-HYBRID-NEXT: <MCInst #{{[0-9]+}} CSRRW{{$}}
// CHECK-HYBRID-NEXT: <MCOperand Reg:X10>
// CHECK-HYBRID-NEXT: <MCOperand Imm:1971>
// CHECK-HYBRID-NEXT: <MCOperand Reg:X11>>
// CHECK-INST-ALIAS: csrrw a0, dscratch1, a1
csrrw a0, dscratch1, a1
