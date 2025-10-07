# RUN: not llvm-mc --triple riscv32 --mattr=+experimental-y,+cap-mode <%s 2>&1 \
# RUN:   | FileCheck %s --check-prefixes=CHECK --implicit-check-not=error:
# RUN: not llvm-mc --triple riscv64 --mattr=+experimental-y,+cap-mode <%s 2>&1 \
# RUN:   | FileCheck %s --check-prefixes=CHECK --implicit-check-not=error:
### The TLS pseudo expansions should not be supported for pure-capability ABIs
### yet since they depend on the chosen ABI and that support has not been
### upstreamed yet. For now check that we emit an error.

la.tls.ie a0, sym
# CHECK: :[[#@LINE-1]]:1: error: TLS pseudos are not supported in capability mode yet
la.tls.gd a0, sym
# CHECK: :[[#@LINE-1]]:1: error: TLS pseudos are not supported in capability mode yet

.data
sym:
.4byte 0
