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

/// TODO: Support switching between rv*i and rv*y via `.option arch, +y/-y`.
.option arch, +y
// CHECK: :[[#@LINE-1]]:16: error: passing '+y'/'-y' is not supported yet; specify a full arch string instead
.option arch, -y
// CHECK: :[[#@LINE-1]]:16: error: passing '+y'/'-y' is not supported yet; specify a full arch string instead

/// Capability pointer mode disables Zcd on RV64 and Zcf on RV32 (Zcd remains
/// valid on RV32Y). Both are restored in RVI compatibility mode.
/// TODO: ymodeswy/ymodeswi should switch the assembler mode without requiring `.option arch`.
c.fld fa0, 0(a0)
.ifndef RV64
c.flw fa0, 0(a0)
.endif

ymodeswy
.ifdef RV64
.option arch, rv64y0p910_c_d_zyhybrid0p910
.else
.option arch, rv32y0p910_c_d_zyhybrid0p910
.endif
c.fld fa0, 0(a0)
// RV64: :[[#@LINE-1]]:1: error: instruction requires the following: 'C' (Compressed Instructions) and 'D' (Double-Precision Floating-Point) or 'Zcd' (Compressed Double-Precision Floating-Point Instructions){{$}}
.ifndef RV64
c.flw fa0, 0(a0)
// RV32: :[[#@LINE-1]]:1: error: instruction requires the following: 'C' (Compressed Instructions) and 'F' (Single-Precision Floating-Point) or 'Zcf' (Compressed Single-Precision Floating-Point Instructions){{$}}
.endif
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
.ifdef RV64
.option arch, rv64i_c_d_zyhybrid0p910
.else
.option arch, rv32i_c_d_zyhybrid0p910
.endif
c.fld fa0, 0(a0)
.ifndef RV64
c.flw fa0, 0(a0)
.endif
