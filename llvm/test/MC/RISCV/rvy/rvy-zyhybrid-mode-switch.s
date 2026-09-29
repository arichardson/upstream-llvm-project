/// Check that ymodeswi/ymodeswy enable/disable Zcd (RV64) and Zcf (RV32), whose
/// encodings are reused for capability loads/stores in capability pointer mode.

// RUN: split-file %s %t
// RUN: llvm-mc --filetype=obj --triple=riscv64 \
// RUN:   --mattr=+experimental,+experimental-y,+experimental-zyhybrid,+c,+d \
// RUN:   %t/rv64.s -o %t/rv64.o
// RUN: llvm-objdump -d -M no-aliases --show-all-symbols %t/rv64.o \
// RUN:   | FileCheck %t/rv64.s --check-prefix=RV64

// RUN: llvm-mc --filetype=obj --triple=riscv32 \
// RUN:   --mattr=+experimental,+experimental-y,+experimental-zyhybrid,+c,+f \
// RUN:   %t/rv32.s -o %t/rv32-c.o
// RUN: llvm-objdump -d -M no-aliases --show-all-symbols %t/rv32-c.o \
// RUN:   | FileCheck %t/rv32.s --check-prefixes=RV32,RV32-C

/// On RV32, Zce+F also implies Zcf in RVI compatibility mode.
// RUN: llvm-mc --filetype=obj --triple=riscv32 --defsym=ZCE=1 \
// RUN:   --mattr=+experimental,+experimental-y,+experimental-zyhybrid,+zce,+f \
// RUN:   %t/rv32.s -o %t/rv32-zce.o
// RUN: llvm-objdump -d -M no-aliases --show-all-symbols %t/rv32-zce.o \
// RUN:   | FileCheck %t/rv32.s --check-prefixes=RV32,RV32-ZCE

//--- rv64.s
.insn 2, 0x2508
.insn 2, 0xa508
.insn 2, 0x2522
.insn 2, 0xa42a
ymodeswi
/// TODO: ymodeswi/ymodeswy should switch the assembler mode without requiring `.option arch`.
.option arch, rv64i_c_d_zyhybrid0p910
// RV64-LABEL: <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV64-NEXT:   2508 <unknown>
// RV64-NEXT:   a508 <unknown>
// RV64-NEXT:   2522 <unknown>
// RV64-NEXT:   a42a <unknown>
// RV64-NEXT:   ymodeswi
// RV64-EMPTY:

c.fld fa0, 8(a0)
c.fsd fa0, 8(a0)
c.fldsp fa0, 8(sp)
c.fsdsp fa0, 8(sp)
ymodeswy
.option arch, rv64y0p910_c_d_zyhybrid0p910
// RV64-NEXT:  <$xrv64i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// RV64-NEXT:   2508 c.fld fa0, 0x8(a0)
// RV64-NEXT:   a508 c.fsd fa0, 0x8(a0)
// RV64-NEXT:   2522 c.fldsp fa0, 0x8(sp)
// RV64-NEXT:   a42a c.fsdsp fa0, 0x8(sp)
// RV64-NEXT:   ymodeswy
// RV64-EMPTY:

.insn 2, 0x2508
// RV64-NEXT:  <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV64-NEXT:   2508 <unknown>
// RV64-EMPTY:

//--- rv32.s
.insn 2, 0x6148
.insn 2, 0xe148
.insn 2, 0x6512
.insn 2, 0xe22a
ymodeswi
/// TODO: ymodeswi/ymodeswy should switch the assembler mode without requiring `.option arch`.
.ifdef ZCE
.option arch, rv32i_zce_f_zyhybrid0p910
.else
.option arch, rv32i_c_f_zyhybrid0p910
.endif
// RV32-C-LABEL:   <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV32-ZCE-LABEL: <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// RV32-NEXT:       6148 <unknown>
// RV32-NEXT:       e148 <unknown>
// RV32-NEXT:       6512 <unknown>
// RV32-NEXT:       e22a <unknown>
// RV32-NEXT:       ymodeswi
// RV32-EMPTY:

c.flw fa0, 4(a0)
c.fsw fa0, 4(a0)
c.flwsp fa0, 4(sp)
c.fswsp fa0, 4(sp)
ymodeswy
.ifdef ZCE
.option arch, rv32y0p910_zce_f_zyhybrid0p910
.else
.option arch, rv32y0p910_c_f_zyhybrid0p910
.endif
// RV32-C-NEXT:    <$xrv32i2p1_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcf1p0>:
// RV32-ZCE-NEXT:  <$xrv32i2p1_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcf1p0_zcmp1p0_zcmt1p0>:
// RV32-NEXT:       6148 c.flw fa0, 0x4(a0)
// RV32-NEXT:       e148 c.fsw fa0, 0x4(a0)
// RV32-NEXT:       6512 c.flwsp fa0, 0x4(sp)
// RV32-NEXT:       e22a c.fswsp fa0, 0x4(sp)
// RV32-NEXT:       ymodeswy
// RV32-EMPTY:

.insn 2, 0x6148
// RV32-C-NEXT:    <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV32-ZCE-NEXT:  <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// RV32-NEXT:       6148 <unknown>
// RV32-EMPTY:
