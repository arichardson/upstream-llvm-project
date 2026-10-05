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
// RUN: llvm-mc --filetype=obj --triple=riscv32 \
// RUN:   --mattr=+experimental,+experimental-y,+experimental-zyhybrid,+zce,+f \
// RUN:   %t/rv32.s -o %t/rv32-zce.o
// RUN: llvm-objdump -d -M no-aliases --show-all-symbols %t/rv32-zce.o \
// RUN:   | FileCheck %t/rv32.s --check-prefixes=RV32,RV32-ZCE

//--- rv64.s
c.ly a0, 0x100(a0)
c.sy a0, 0x100(a0)
c.lysp a0, 0x200(sp)
c.sysp a0, 0x200(sp)
ymodeswi
// RV64-LABEL: <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV64-NEXT:   2508 c.ly a0, 0x100(a0)
// RV64-NEXT:   a508 c.sy a0, 0x100(a0)
// RV64-NEXT:   2522 c.lysp a0, 0x200(sp)
// RV64-NEXT:   a42a c.sysp a0, 0x200(sp)
// RV64-NEXT:   ymodeswi
// RV64-EMPTY:

c.fld fa0, 8(a0)
c.fsd fa0, 8(a0)
c.fldsp fa0, 8(sp)
c.fsdsp fa0, 8(sp)
ymodeswy
// RV64-NEXT:  <$xrv64i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// RV64-NEXT:   2508 c.fld fa0, 0x8(a0)
// RV64-NEXT:   a508 c.fsd fa0, 0x8(a0)
// RV64-NEXT:   2522 c.fldsp fa0, 0x8(sp)
// RV64-NEXT:   a42a c.fsdsp fa0, 0x8(sp)
// RV64-NEXT:   ymodeswy
// RV64-EMPTY:

c.ly a0, 0x100(a0)
// RV64-NEXT:  <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV64-NEXT:   2508 c.ly a0, 0x100(a0)
// RV64-EMPTY:

//--- rv32.s
c.ly a0, 0x80(a0)
c.sy a0, 0x80(a0)
c.lysp a0, 0x100(sp)
c.sysp a0, 0x100(sp)
ymodeswi
// RV32-C-LABEL:   <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV32-ZCE-LABEL: <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// RV32-NEXT:       6148 c.ly a0, 0x80(a0)
// RV32-NEXT:       e148 c.sy a0, 0x80(a0)
// RV32-NEXT:       6512 c.lysp a0, 0x100(sp)
// RV32-NEXT:       e22a c.sysp a0, 0x100(sp)
// RV32-NEXT:       ymodeswi
// RV32-EMPTY:

c.flw fa0, 4(a0)
c.fsw fa0, 4(a0)
c.flwsp fa0, 4(sp)
c.fswsp fa0, 4(sp)
ymodeswy
// RV32-C-NEXT:    <$xrv32i2p1_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcf1p0>:
// RV32-ZCE-NEXT:  <$xrv32i2p1_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcf1p0_zcmp1p0_zcmt1p0>:
// RV32-NEXT:       6148 c.flw fa0, 0x4(a0)
// RV32-NEXT:       e148 c.fsw fa0, 0x4(a0)
// RV32-NEXT:       6512 c.flwsp fa0, 0x4(sp)
// RV32-NEXT:       e22a c.fswsp fa0, 0x4(sp)
// RV32-NEXT:       ymodeswy
// RV32-EMPTY:

c.ly a0, 0x80(a0)
// RV32-C-NEXT:    <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// RV32-ZCE-NEXT:  <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// RV32-NEXT:       6148 c.ly a0, 0x80(a0)
// RV32-EMPTY:
