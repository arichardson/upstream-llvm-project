// RUN: not llvm-mc --triple riscv32 --mattr=+experimental,+experimental-zyhybrid,+c,+d <%s 2>&1 \
// RUN:   | FileCheck %s --check-prefixes=CHECK,RV32 --implicit-check-not=error:
// RUN: not llvm-mc --triple riscv64 --mattr=+experimental,+experimental-zyhybrid,+c,+d --defsym=RV64=1 <%s 2>&1 \
// RUN:   | FileCheck %s --check-prefixes=CHECK,RV64 --implicit-check-not=error:

ymodew x0, a0, a0
// CHECK: :[[#@LINE-1]]:8: error: register must be a GPR excluding zero (x0)
ymodew f0, a0, a0
// CHECK: :[[#@LINE-1]]:8: error: register must be a GPR excluding zero (x0)
yadd f0, a0, a0
// CHECK: :[[#@LINE-1]]:6: error: register must be a GPR

/// Capability pointer mode disables Zcd on RV64 and Zcf on RV32 (Zcd remains
/// valid on RV32Y). Both are restored in RVI compatibility mode.
c.fld fa0, 0(a0)
.ifndef RV64
c.flw fa0, 0(a0)
.endif

ymodeswy
c.fld fa0, 0(a0)
// RV64: :[[#@LINE-1]]:1: error: instruction requires the following: 'C' (Compressed Instructions) and 'D' (Double-Precision Floating-Point) or 'Zcd' (Compressed Double-Precision Floating-Point Instructions){{$}}
.ifndef RV64
c.flw fa0, 0(a0)
// RV32: :[[#@LINE-1]]:1: error: instruction requires the following: 'C' (Compressed Instructions) and 'F' (Single-Precision Floating-Point) or 'Zcf' (Compressed Single-Precision Floating-Point Instructions){{$}}
.endif

ymodeswi
c.fld fa0, 0(a0)
.ifndef RV64
c.flw fa0, 0(a0)
.endif

/// The same applies to Zcmp/Zcmt on RV64 and Zclsd on RV32, which also cannot
/// be enabled explicitly in capability pointer mode. Also verify that having
/// D (on RV64) or F (on RV32) enabled alongside Zca without C does not cause
/// ymodeswy + ymodeswi to implicitly enable C and Zcd/Zcf.
.ifdef RV64
.option arch, rv64i_d_zce_zyhybrid0p910
.else
.option arch, rv32i_f_zca_zcb_zcmp_zcmt_zclsd_zyhybrid0p910
.endif
cm.push {ra}, -16
cm.jt 0
c.ld a0, 0(a1)

ymodeswy
cm.push {ra}, -16
// RV64: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zcmp' (sequenced instructions for code-size reduction){{$}}
cm.jt 0
// RV64: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zcmt' (table jump instructions for code-size reduction){{$}}
c.ld a0, 0(a1)
// RV32: :[[#@LINE-1]]:1: error: instruction requires the following: 'Zclsd' (Compressed Load/Store pair instructions){{$}}
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

ymodeswi
cm.push {ra}, -16
cm.jt 0
c.ld a0, 0(a1)
.ifdef RV64
c.fld fa0, 0(a0)
// RV64: :[[#@LINE-1]]:1: error: instruction requires the following: 'C' (Compressed Instructions) and 'D' (Double-Precision Floating-Point) or 'Zcd' (Compressed Double-Precision Floating-Point Instructions){{$}}
.else
c.flw fa0, 0(a0)
// RV32: :[[#@LINE-1]]:1: error: instruction requires the following: 'C' (Compressed Instructions) and 'F' (Single-Precision Floating-Point) or 'Zcf' (Compressed Single-Precision Floating-Point Instructions){{$}}
.endif

/// Only standard extensions are suspended, other conflicts are reported.
.ifdef RV64
.option arch, rv64i_zyhybrid0p910
.option arch, +xqccmp
ymodeswy
// RV64: :[[#@LINE-1]]:1: error: 'xqccmp' is incompatible with rv64y base
.endif
