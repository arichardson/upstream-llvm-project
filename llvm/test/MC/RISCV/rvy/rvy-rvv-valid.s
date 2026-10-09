// RUN: llvm-mc --triple=riscv32 --mattr=+v,+experimental-y --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+v,+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ %s
// RUN: llvm-mc --triple=riscv64 --mattr=+v,+experimental-y --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-CAP %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+v,+experimental-y --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ %s

// RUN: llvm-mc --triple=riscv32 --mattr=+v,+experimental-zyhybrid --defsym=INT_MODE=1 --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-INT-ASM-AND-OBJ %s
// RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+v,+experimental-zyhybrid --defsym=INT_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-INT-ASM-AND-OBJ %s
// RUN: llvm-mc --triple=riscv64 --mattr=+v,+experimental-zyhybrid --defsym=INT_MODE=1 --riscv-no-aliases --show-encoding --show-inst < %s \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM,CHECK-INT,CHECK-INT-ASM-AND-OBJ %s
// RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+v,+experimental-zyhybrid --defsym=INT_MODE=1 --riscv-add-build-attributes < %s \
// RUN:   | llvm-objdump -M no-aliases -d --no-print-imm-hex - \
// RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-INT-ASM-AND-OBJ %s

///
/// Unit-stride, mask, whole-register, and fault-only-first loads:
///

// CHECK-ASM-AND-OBJ: vle8.v v8, (a0), v0.t
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLE8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vle8.v v8, (a0), v0.t

// CHECK-ASM-AND-OBJ: vle32.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x64,0x05,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLE32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vle32.v v8, 0(a0)

// CHECK-ASM-AND-OBJ: vle64.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x74,0x05,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLE64_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vle64.v v8, (a0)

// CHECK-ASM-AND-OBJ: vlm.v v0, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x00,0xb5,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLM_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>>
vlm.v v0, (a0)

// CHECK-ASM-AND-OBJ: vl1re8.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x85,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VL1RE8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>>
vl1re8.v v8, (a0)

// CHECK-ASM-AND-OBJ: vl8re64.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x74,0x85,0xe2]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VL8RE64_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8M8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>>
vl8re64.v v8, (a0)

// CHECK-ASM-AND-OBJ: vl1re8.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x85,0x02]
vl1r.v v8, (a0)

// CHECK-ASM-AND-OBJ: vl2re8.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x85,0x22]
vl2r.v v8, (a0)

// CHECK-ASM-AND-OBJ: vl4re8.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x85,0x62]
vl4r.v v8, (a0)

// CHECK-ASM-AND-OBJ: vl8re8.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x85,0xe2]
vl8r.v v8, (a0)

// CHECK-ASM-AND-OBJ: vle16ff.v v8, (a0), v0.t
// CHECK-ASM-SAME: # encoding: [0x07,0x54,0x05,0x01]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLE16FF_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vle16ff.v v8, (a0), v0.t

///
/// Strided and indexed loads (rs1 is BasePtrZeroOffset, rs2 is GPR/VR):
///

// CHECK-ASM-AND-OBJ: vlse32.v v8, (a0), a1, v0.t
// CHECK-ASM-SAME: # encoding: [0x07,0x64,0xb5,0x08]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLSE32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vlse32.v v8, (a0), a1, v0.t

// CHECK-ASM-AND-OBJ: vluxei32.v v8, (a0), v4
// CHECK-ASM-SAME: # encoding: [0x07,0x64,0x45,0x06]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLUXEI32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vluxei32.v v8, 0(a0), v4

// CHECK-ASM-AND-OBJ: vloxei32.v v8, (a0), v4, v0.t
// CHECK-ASM-SAME: # encoding: [0x07,0x64,0x45,0x0c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLOXEI32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vloxei32.v v8, (a0), v4, v0.t

///
/// Segment loads:
///

// CHECK-ASM-AND-OBJ: vlseg2e8.v v8, (a0), v0.t
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x05,0x20]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLSEG2E8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vlseg2e8.v v8, (a0), v0.t

// CHECK-ASM-AND-OBJ: vlseg2e8ff.v v8, (a0)
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x05,0x23]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLSEG2E8FF_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vlseg2e8ff.v v8, (a0)

// CHECK-ASM-AND-OBJ: vlsseg2e16.v v8, (a0), a1
// CHECK-ASM-SAME: # encoding: [0x07,0x54,0xb5,0x2a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLSSEG2E16_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vlsseg2e16.v v8, (a0), a1

// CHECK-ASM-AND-OBJ: vluxseg2ei8.v v8, (a0), v4
// CHECK-ASM-SAME: # encoding: [0x07,0x04,0x45,0x26]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLUXSEG2EI8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vluxseg2ei8.v v8, (a0), v4

// CHECK-ASM-AND-OBJ: vloxseg2ei32.v v8, (a0), v4, v0.t
// CHECK-ASM-SAME: # encoding: [0x07,0x64,0x45,0x2c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLOXSEG2EI32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vloxseg2ei32.v v8, (a0), v4, v0.t

///
/// Unit-stride, mask, whole-register, strided, indexed, and segment stores:
///

// CHECK-ASM-AND-OBJ: vse8.v v24, (a0), v0.t
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0x05,0x00]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSE8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vse8.v v24, (a0), v0.t

// CHECK-ASM-AND-OBJ: vse32.v v24, (a0)
// CHECK-ASM-SAME: # encoding: [0x27,0x6c,0x05,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSE32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vse32.v v24, 0(a0)

// CHECK-ASM-AND-OBJ: vsm.v v24, (a0)
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0xb5,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSM_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>>
vsm.v v24, (a0)

// CHECK-ASM-AND-OBJ: vs1r.v v24, (a0)
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0x85,0x02]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VS1R_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>>
vs1r.v v24, (a0)

// CHECK-ASM-AND-OBJ: vs8r.v v24, (a0)
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0x85,0xe2]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VS8R_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24M8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>>
vs8r.v v24, (a0)

// CHECK-ASM-AND-OBJ: vsse16.v v24, (a0), a1, v0.t
// CHECK-ASM-SAME: # encoding: [0x27,0x5c,0xb5,0x08]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSSE16_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vsse16.v v24, (a0), a1, v0.t

// CHECK-ASM-AND-OBJ: vsuxei8.v v24, (a0), v4, v0.t
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0x45,0x04]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSUXEI8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vsuxei8.v v24, (a0), v4, v0.t

// CHECK-ASM-AND-OBJ: vsoxei32.v v24, (a0), v4
// CHECK-ASM-SAME: # encoding: [0x27,0x6c,0x45,0x0e]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSOXEI32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vsoxei32.v v24, (a0), v4

// CHECK-ASM-AND-OBJ: vsseg2e8.v v24, (a0)
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0x05,0x22]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSSEG2E8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vsseg2e8.v v24, (a0)

// CHECK-ASM-AND-OBJ: vssseg2e16.v v24, (a0), a1
// CHECK-ASM-SAME: # encoding: [0x27,0x5c,0xb5,0x2a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSSSEG2E16_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X11>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vssseg2e16.v v24, (a0), a1

// CHECK-ASM-AND-OBJ: vsuxseg2ei8.v v24, (a0), v4
// CHECK-ASM-SAME: # encoding: [0x27,0x0c,0x45,0x26]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSUXSEG2EI8_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vsuxseg2ei8.v v24, (a0), v4

// CHECK-ASM-AND-OBJ: vsoxseg2ei32.v v24, (a0), v4, v0.t
// CHECK-ASM-SAME: # encoding: [0x27,0x6c,0x45,0x2c]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VSOXSEG2EI32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V4>
// CHECK-ASM-NEXT: #  <MCOperand Reg:V0>>
vsoxseg2ei32.v v24, (a0), v4, v0.t

///
/// In RVY capability pointer mode, strided rs2 can still be zero (only rs1 is
/// a capability base pointer):
///

// CHECK-ASM-AND-OBJ: vlse32.v v8, (a0), zero
// CHECK-ASM-SAME: # encoding: [0x07,0x64,0x05,0x0a]
// CHECK-ASM-NEXT: # <MCInst #[[#]] VLSE32_V{{$}}
// CHECK-ASM-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X10>
// CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
// CHECK-ASM-NEXT: #  <MCOperand Reg:X0>
// CHECK-ASM-NEXT: #  <MCOperand Reg:>>
vlse32.v v8, (a0), zero

///
/// In RVI pointer mode (Zyhybrid), x0 is a valid base register:
///
.ifdef INT_MODE
// CHECK-INT-ASM-AND-OBJ: vle8.v v8, (zero)
// CHECK-INT-SAME: # encoding: [0x07,0x04,0x00,0x02]
// CHECK-INT-NEXT: # <MCInst #[[#]] VLE8_V{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:V8>
// CHECK-INT-NEXT: #  <MCOperand Reg:X0>
// CHECK-INT-NEXT: #  <MCOperand Reg:>>
vle8.v v8, (zero)

// CHECK-INT-ASM-AND-OBJ: vse8.v v24, (zero)
// CHECK-INT-SAME: # encoding: [0x27,0x0c,0x00,0x02]
// CHECK-INT-NEXT: # <MCInst #[[#]] VSE8_V{{$}}
// CHECK-INT-NEXT: #  <MCOperand Reg:V24>
// CHECK-INT-NEXT: #  <MCOperand Reg:X0>
// CHECK-INT-NEXT: #  <MCOperand Reg:>>
vse8.v v24, (zero)
.endif
