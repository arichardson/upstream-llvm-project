// RUN: split-file %s %t
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+h --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+h --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d -r - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+h --defsym=RV64=1 --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP,CHECK-RV64-ASM-AND-OBJ,CHECK-RV64-ASM,CHECK-RV64-CAP
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+h --defsym=RV64=1 --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d -r - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-RV64-ASM-AND-OBJ

// RUN: llvm-mc --triple=riscv32 --mattr=+experimental-zyhybrid,+h --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-zyhybrid,+h --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d -r - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental-zyhybrid,+h --defsym=RV64=1 --riscv-no-aliases --show-encoding --show-inst %t/valid.s \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-RV64-ASM-AND-OBJ,CHECK-RV64-ASM,CHECK-RV64-INT
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-zyhybrid,+h --defsym=RV64=1 --riscv-add-build-attributes %t/valid.s \
// RUN:   | llvm-objdump -M no-aliases -d -r - \
// RUN:   | FileCheck %t/valid.s --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-RV64-ASM-AND-OBJ

// RUN: not llvm-mc --triple=riscv64 --mattr=+experimental-y %t/invalid.s 2>&1 \
// RUN:   | FileCheck %t/invalid.s --check-prefix=ERR-NO-H --implicit-check-not=error:
// RUN: not llvm-mc --triple=riscv64 --mattr=+h %t/invalid.s 2>&1 \
// RUN:   | FileCheck %t/invalid.s --check-prefix=ERR-NO-Y --implicit-check-not=error:

//--- valid.s
/// Hypervisor capability load and store instructions (hlv.y, hsv.y):
// CHECK-ASM-AND-OBJ: hlv.y a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc5,0x05,0x70]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_Y{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.y a0, (a1)

// CHECK-ASM-AND-OBJ: hlv.y a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc5,0x05,0x70]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_Y{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.y a0, 0(a1)

// CHECK-ASM-AND-OBJ: hsv.y a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc0,0xa5,0x72]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HSV_Y{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hsv.y a0, (a1)

// CHECK-ASM-AND-OBJ: hsv.y a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc0,0xa5,0x72]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HSV_Y{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hsv.y a0, 0(a1)

/// Existing H-extension loads/stores use BasePtrZeroOffset for rs1:
// CHECK-ASM-AND-OBJ: hlv.b a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc5,0x05,0x60]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_B{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.b a0, (a1)

// CHECK-ASM-AND-OBJ: hlv.bu a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc5,0x15,0x60]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_BU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.bu a0, (a1)

// CHECK-ASM-AND-OBJ: hlv.h a1, (a2)
// CHECK-ASM-SAME: # encoding: [0xf3,0x45,0x06,0x64]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_H{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-INT-NEXT: #  <MCOperand Reg:X12>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X12_Y>>
hlv.h a1, (a2)

// CHECK-ASM-AND-OBJ: hlv.hu a1, (a1)
// CHECK-ASM-SAME: # encoding: [0xf3,0xc5,0x15,0x64]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_HU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.hu a1, (a1)

// CHECK-ASM-AND-OBJ: hlvx.hu a1, (a2)
// CHECK-ASM-SAME: # encoding: [0xf3,0x45,0x36,0x64]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLVX_HU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-INT-NEXT: #  <MCOperand Reg:X12>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X12_Y>>
hlvx.hu a1, (a2)

// CHECK-ASM-AND-OBJ: hlv.w a2, (a2)
// CHECK-ASM-SAME: # encoding: [0x73,0x46,0x06,0x68]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLV_W{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
// CHECK-INT-NEXT: #  <MCOperand Reg:X12>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X12_Y>>
hlv.w a2, (a2)

// CHECK-ASM-AND-OBJ: hlvx.wu a2, (a3)
// CHECK-ASM-SAME: # encoding: [0x73,0xc6,0x36,0x68]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HLVX_WU{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X12>
// CHECK-INT-NEXT: #  <MCOperand Reg:X13>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X13_Y>>
hlvx.wu a2, (a3)

// CHECK-ASM-AND-OBJ: hsv.b a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc0,0xa5,0x62]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HSV_B{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hsv.b a0, (a1)

// CHECK-ASM-AND-OBJ: hsv.h a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc0,0xa5,0x66]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HSV_H{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hsv.h a0, (a1)

// CHECK-ASM-AND-OBJ: hsv.w a0, (a1)
// CHECK-ASM-SAME: # encoding: [0x73,0xc0,0xa5,0x6a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HSV_W{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hsv.w a0, (a1)

.ifdef RV64
// CHECK-RV64-ASM-AND-OBJ: hlv.wu a0, (a1)
// CHECK-RV64-ASM-SAME: # encoding: [0x73,0xc5,0x15,0x68]
// CHECK-RV64-ASM-NEXT: # <MCInst #[[#]] HLV_WU{{$}}
// CHECK-RV64-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-RV64-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-RV64-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.wu a0, (a1)

// CHECK-RV64-ASM-AND-OBJ: hlv.d a0, (a1)
// CHECK-RV64-ASM-SAME: # encoding: [0x73,0xc5,0x05,0x6c]
// CHECK-RV64-ASM-NEXT: # <MCInst #[[#]] HLV_D{{$}}
// CHECK-RV64-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-RV64-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-RV64-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hlv.d a0, (a1)

// CHECK-RV64-ASM-AND-OBJ: hsv.d a0, (a1)
// CHECK-RV64-ASM-SAME: # encoding: [0x73,0xc0,0xa5,0x6e]
// CHECK-RV64-ASM-NEXT: # <MCInst #[[#]] HSV_D{{$}}
// CHECK-RV64-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-RV64-INT-NEXT: #  <MCOperand Reg:X11>>
// CHECK-RV64-CAP-NEXT: #  <MCOperand Reg:X11_Y>>
hsv.d a0, (a1)
.endif

/// HFENCE.* instructions continue to take XLEN-bit GPR operands:
// CHECK-ASM-AND-OBJ: hfence.vvma a0, a1
// CHECK-ASM-SAME: # encoding: [0x73,0x00,0xb5,0x22]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HFENCE_VVMA{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>>
hfence.vvma a0, a1

// CHECK-ASM-AND-OBJ: hfence.gvma a0, a1
// CHECK-ASM-SAME: # encoding: [0x73,0x00,0xb5,0x62]
// CHECK-ASM-NEXT: # <MCInst #[[#]] HFENCE_GVMA{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:X10>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>>
hfence.gvma a0, a1

//--- invalid.s
hlv.y a0, (a1)
// ERR-NO-H: :[[#@LINE-1]]:1: error: instruction requires the following: 'H' (Hypervisor){{$}}
// ERR-NO-Y: :[[#@LINE-2]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
hsv.y a0, (a1)
// ERR-NO-H: :[[#@LINE-1]]:1: error: instruction requires the following: 'H' (Hypervisor){{$}}
// ERR-NO-Y: :[[#@LINE-2]]:1: error: instruction requires the following: 'Base Y' (CHERI) or 'Zyhybrid' (Hybrid Extension for RVI Compatibility){{$}}
