/// Check the interaction of `.option` directives with ymodeswy/ymodeswi.

// RUN: split-file %s %t
// RUN: llvm-mc --triple=riscv64 --mattr=+experimental,+experimental-zyhybrid,+c,+d \
// RUN:   --filetype=obj %t/rv64.s -o %t/rv64.o
// RUN: llvm-objdump -d --show-all-symbols %t/rv64.o | FileCheck %t/rv64.s
// RUN: llvm-mc --triple=riscv32 --mattr=+experimental,+experimental-zyhybrid,+c,+f \
// RUN:   --filetype=obj %t/rv32.s -o %t/rv32.o
// RUN: llvm-objdump -d --show-all-symbols %t/rv32.o | FileCheck %t/rv32.s
// RUN: not llvm-mc --triple=riscv32 --mattr=+experimental,+experimental-zyhybrid,+c,+d \
// RUN:   %t/invalid.s 2>&1 | FileCheck %t/invalid.s --check-prefix=RV32 --implicit-check-not=error:
// RUN: not llvm-mc --triple=riscv64 --mattr=+experimental,+experimental-zyhybrid,+c,+d --defsym=RV64=1 \
// RUN:   %t/invalid.s 2>&1 | FileCheck %t/invalid.s --check-prefix=RV64 --implicit-check-not=error:

//--- rv64.s
/// Start in RVI compatibility mode: C+D implies Zcd.
/// Switching to the current mode does not emit a new mapping symbol.
ymodeswi
// CHECK-LABEL: <$xrv64i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// CHECK-NEXT:    ymodeswi
.option arch, -y

/// `.option pop` restores the mode from before `.option push`.
.option push
ymodeswy
// CHECK-NEXT:    ymodeswy
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    nop
.option pop

/// `.option norvc` and `.option rvc` in capability pointer mode must not imply
/// Zcd until switching back to RVI compatibility mode.
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// CHECK-NEXT:    ymodeswy
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    nop
.option norvc
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_f2p2_d2p2_zicsr2p0_zyhybrid0p910>:
// CHECK-NEXT:    nop
.option rvc
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// CHECK-NEXT:    nop

/// Mode switches can be combined with other extensions in a single directive.
.option arch, +y, -c, -zca
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_f2p2_d2p2_zicsr2p0_zyhybrid0p910>:
// CHECK-NEXT:    nop
.option arch, -y, +c
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// CHECK-NEXT:    nop

/// Zce/Zcmp/Zcmt are suspended in capability pointer mode and restored on
/// ymodeswi unless explicitly disabled in the meantime.
.option arch, rv64i_zce_zyhybrid0p910
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    ymodeswy
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0>:
// CHECK-NEXT:    nop
.option arch, +zba
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zba1p0>:
// CHECK-NEXT:    ymodeswi
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0_zba1p0>:
// CHECK-NEXT:    ymodeswy
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zba1p0>:
// CHECK-NEXT:    nop
.option arch, -zcmp
ymodeswi
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zcmt1p0_zba1p0>:
// CHECK-NEXT:    nop

/// Capability pointer mode implies C from Zca even with D, but it must not
/// leak back into RVI compatibility mode (where it would imply Zcd).
.option arch, rv64i_zce_d_zyhybrid0p910
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_f2p2_d2p2_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    ymodeswy
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0>:
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv64i2p1_f2p2_d2p2_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    nop
// CHECK-EMPTY:

//--- rv32.s
/// Zcd is compatible with RV32Y, so only Zcf is suspended.
.option arch, +d
ymodeswy
// CHECK-LABEL: <$xrv32i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0_zcf1p0>:
// CHECK-NEXT:    ymodeswy
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0>:
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_f2p2_d2p2_c2p0_zicsr2p0_zyhybrid0p910_zca1p0_zcd1p0_zcf1p0>:
// CHECK-NEXT:    nop

/// Zclsd is suspended and restored, unless its Zilsd prerequisite has been
/// disabled by the time we switch back to RVI compatibility mode.
.option arch, rv32i_zclsd_zyhybrid0p910
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_c2p0_zilsd1p0_zyhybrid0p910_zca1p0_zclsd1p0>:
// CHECK-NEXT:    ymodeswy
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_c2p0_zilsd1p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    ymodeswi
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_c2p0_zilsd1p0_zyhybrid0p910_zca1p0_zclsd1p0>:
// CHECK-NEXT:    ymodeswy
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_c2p0_zilsd1p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    nop
.option arch, -zilsd
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_c2p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_c2p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    nop

/// Likewise, C implied by Zca+F in capability pointer mode must not leak back
/// into RVI compatibility mode (where it would imply Zcf).
.option arch, rv32i_zclsd_f_zyhybrid0p910
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_f2p2_zicsr2p0_zilsd1p0_zyhybrid0p910_zca1p0_zclsd1p0>:
// CHECK-NEXT:    ymodeswy
ymodeswi
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_f2p2_c2p0_zicsr2p0_zilsd1p0_zyhybrid0p910_zca1p0>:
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_f2p2_zicsr2p0_zilsd1p0_zyhybrid0p910_zca1p0_zclsd1p0>:
// CHECK-NEXT:    nop

/// Disabling Zce in capability pointer mode (when C was not enabled) must
/// prevent Zcf from being restored on ymodeswi.
.option arch, rv32i_zce_d_zyhybrid0p910
ymodeswy
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_f2p2_d2p2_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcf1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    ymodeswy
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32y0p910_f2p2_d2p2_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zce1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    nop
.option arch, -zce
ymodeswi
// CHECK-NEXT:    ymodeswi
nop
// CHECK-EMPTY:
// CHECK-NEXT:  <$xrv32i2p1_f2p2_d2p2_zicsr2p0_zyhybrid0p910_zca1p0_zcb1p0_zcmp1p0_zcmt1p0>:
// CHECK-NEXT:    nop
// CHECK-EMPTY:

//--- invalid.s
/// Extensions that conflict with RVY cannot be enabled in capability pointer mode.
ymodeswy
.ifdef RV64
.option arch, +zcd
// RV64: :[[#@LINE-1]]:16: error: 'zcd' is incompatible with rv64y base
.option arch, +zcmp
// RV64: :[[#@LINE-1]]:16: error: 'zcmp' is incompatible with rv64y base
.option arch, +zcmt
// RV64: :[[#@LINE-1]]:16: error: 'zcmt' is incompatible with rv64y base
.else
.option arch, +zcf
// RV32: :[[#@LINE-1]]:16: error: 'zcf' is incompatible with rv32y base
.option arch, +zclsd
// RV32: :[[#@LINE-1]]:16: error: 'zclsd' is incompatible with rv32y base
.endif
