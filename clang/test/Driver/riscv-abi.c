// RUN: %clang --target=riscv32-unknown-elf %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32 %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -mabi=ilp32 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32 %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32imc 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32 %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32 %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -mabi=ilp32 2>&1 | FileCheck -check-prefix=CHECK-ILP32 %s

// CHECK-ILP32: "-target-abi" "ilp32"

// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32e -mabi=ilp32e 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32E %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -mabi=ilp32e 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32E %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32e 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32E %s

// CHECK-ILP32E: "-target-abi" "ilp32e"

// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32if -mabi=ilp32f 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32F %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -mabi=ilp32f 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32F %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32if 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32F %s

// CHECK-ILP32F: "-target-abi" "ilp32f"

// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32ifd -mabi=ilp32d 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32D %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32ifd 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32D %s
// RUN: %clang --target=riscv32-unknown-elf %s -### -march=rv32g 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32D %s
// RUN: %clang --target=riscv32-unknown-linux-gnu %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32D %s
// RUN: %clang --target=riscv32-unknown-linux-gnu -x assembler %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-ILP32D %s

// CHECK-ILP32D: "-target-abi" "ilp32d"

// RUN: not %clang --target=riscv32-unknown-elf %s -o %t.o -mabi=lp64 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV32-LP64 %s

// CHECK-RV32-LP64: error: unknown target ABI 'lp64'

// RUN: %clang --target=riscv64-unknown-elf %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64 %s
// RUN: %clang --target=riscv64-unknown-elf %s -### -mabi=lp64 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64 %s
// RUN: %clang --target=riscv64-unknown-elf %s -### -march=rv64imc 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64 %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64  %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -mabi=lp64 2>&1 | FileCheck -check-prefix=CHECK-LP64 %s

// CHECK-LP64: "-target-abi" "lp64"

// RUN:  %clang --target=riscv64-unknown-elf %s -### -march=rv64if -mabi=lp64f 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64F %s
// RUN:  %clang --target=riscv64-unknown-elf %s -### -mabi=lp64f 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64F %s
// RUN:  %clang --target=riscv64-unknown-elf %s -### -march=rv64if 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64F %s

// CHECK-LP64F: "-target-abi" "lp64f"

// RUN: %clang --target=riscv64-unknown-elf %s -### -march=rv64ifd -mabi=lp64d 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64D %s
// RUN: %clang --target=riscv64-unknown-elf %s -### -march=rv64ifd 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64D %s
// RUN: %clang --target=riscv64-unknown-elf %s -### -march=rv64g 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64D %s
// RUN: %clang --target=riscv64-unknown-linux-gnu %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64D %s
// RUN: %clang --target=riscv64-unknown-linux-gnu -x assembler %s -### 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-LP64D  %s

// CHECK-LP64D: "-target-abi" "lp64d"

// RUN: not %clang --target=riscv64-unknown-elf %s -o %t.o -mabi=ilp32 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV64-ILP32 %s

// CHECK-RV64-ILP32: error: unknown target ABI 'ilp32'

// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -march=rv32y0p910 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64 %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -mabi=il32pc64 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64 %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -march=rv32y0p910 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64-PP %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -mabi=il32pc64 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64-PP %s

// CHECK-IL32PC64: "-cc1as" {{.*}}"-target-abi" "il32pc64"
// CHECK-IL32PC64-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "il32pc64"
// CHECK-IL32PC64-PP: "-cc1as" {{.*}}"-target-abi" "il32pc64"

// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -mabi=il32pc64e -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64E %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -mabi=il32pc64e -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64E-PP %s

// CHECK-IL32PC64E: "-cc1as" {{.*}}"-target-abi" "il32pc64e"
// CHECK-IL32PC64E-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "il32pc64e"
// CHECK-IL32PC64E-PP: "-cc1as" {{.*}}"-target-abi" "il32pc64e"

// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -march=rv32y0p910f -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64F %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -mabi=il32pc64f -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64F %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -march=rv32y0p910f -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64F-PP %s

// CHECK-IL32PC64F: "-cc1as" {{.*}}"-target-abi" "il32pc64f"
// CHECK-IL32PC64F-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "il32pc64f"
// CHECK-IL32PC64F-PP: "-cc1as" {{.*}}"-target-abi" "il32pc64f"

// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -march=rv32y0p910fd -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64D %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler %s -### \
// RUN:   -mabi=il32pc64d -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64D %s
// RUN: %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -march=rv32y0p910fd -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-IL32PC64D-PP %s

// CHECK-IL32PC64D: "-cc1as" {{.*}}"-target-abi" "il32pc64d"
// CHECK-IL32PC64D-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "il32pc64d"
// CHECK-IL32PC64D-PP: "-cc1as" {{.*}}"-target-abi" "il32pc64d"

// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -march=rv64y0p910 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128 %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -mabi=l64pc128 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128 %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -march=rv64y0p910 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128-PP %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -mabi=l64pc128 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128-PP %s

// CHECK-L64PC128: "-cc1as" {{.*}}"-target-abi" "l64pc128"
// CHECK-L64PC128-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "l64pc128"
// CHECK-L64PC128-PP: "-cc1as" {{.*}}"-target-abi" "l64pc128"

// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -march=rv64y0p910f -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128F %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -mabi=l64pc128f -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128F %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -march=rv64y0p910f -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128F-PP %s

// CHECK-L64PC128F: "-cc1as" {{.*}}"-target-abi" "l64pc128f"
// CHECK-L64PC128F-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "l64pc128f"
// CHECK-L64PC128F-PP: "-cc1as" {{.*}}"-target-abi" "l64pc128f"

// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -march=rv64y0p910fd -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128D %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler %s -### \
// RUN:   -mabi=l64pc128d -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128D %s
// RUN: %clang --target=riscv64-unknown-elf -x assembler-with-cpp %s -### \
// RUN:   -march=rv64y0p910fd -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-L64PC128D-PP %s

// CHECK-L64PC128D: "-cc1as" {{.*}}"-target-abi" "l64pc128d"
// CHECK-L64PC128D-PP: "-cc1" {{.*}}"-E" {{.*}}"-target-abi" "l64pc128d"
// CHECK-L64PC128D-PP: "-cc1as" {{.*}}"-target-abi" "l64pc128d"

// RUN: not %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -o %t.o \
// RUN:   -mabi=l64pc128 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV32-L64PC128 %s
// CHECK-RV32-L64PC128: error: unknown target ABI 'l64pc128'

// RUN: not %clang --target=riscv64-unknown-elf -x assembler-with-cpp %s -o %t.o \
// RUN:   -mabi=il32pc64 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV64-IL32PC64 %s
// CHECK-RV64-IL32PC64: error: unknown target ABI 'il32pc64'

// RUN: not %clang --target=riscv32-unknown-elf -x assembler-with-cpp %s -o %t.o \
// RUN:   -march=rv32i -mabi=il32pc64 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV32I-IL32PC64 %s
// CHECK-RV32I-IL32PC64: error: invalid feature combination: 'il32pc64' ABI is only supported for RVY targets

// RUN: not %clang --target=riscv64-unknown-elf -x assembler-with-cpp %s -o %t.o \
// RUN:   -march=rv64i -mabi=l64pc128 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV64I-L64PC128 %s
// CHECK-RV64I-L64PC128: error: invalid feature combination: 'l64pc128' ABI is only supported for RVY targets

// RUN: not %clang --target=riscv32-unknown-elf %s -### \
// RUN:   -march=rv32y0p910 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV32Y-NO-C %s
// CHECK-RV32Y-NO-C: error: the clang compiler does not support 'non-assembly input for ABI 'il32pc64''

// RUN: not %clang --target=riscv64-unknown-elf %s -### \
// RUN:   -march=rv64y0p910 -menable-experimental-extensions 2>&1 \
// RUN:   | FileCheck -check-prefix=CHECK-RV64Y-NO-C %s
// CHECK-RV64Y-NO-C: error: the clang compiler does not support 'non-assembly input for ABI 'l64pc128''

