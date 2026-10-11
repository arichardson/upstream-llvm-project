# RUN: llvm-mc -triple=riscv32 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv32 -target-abi ilp32 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv32 -mattr=+f -target-abi ilp32 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv32 -mattr=+d -target-abi ilp32 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv64 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv64 -target-abi lp64 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+f -target-abi lp64 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+d -target-abi lp64 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-NONE %s

# RUN: llvm-mc -triple=riscv32 -mattr=+f -target-abi ilp32f -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-FLOAT-SINGLE %s
# RUN: llvm-mc -triple=riscv32 -mattr=+d -target-abi ilp32f -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-FLOAT-SINGLE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+f -target-abi lp64f -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-FLOAT-SINGLE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+d -target-abi lp64f -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-FLOAT-SINGLE %s

# RUN: llvm-mc -triple=riscv32 -mattr=+d -target-abi ilp32d -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-FLOAT-DOUBLE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+d -target-abi lp64d -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-FLOAT-DOUBLE %s

# RUN: llvm-mc -triple=riscv32 -target-abi ilp32e -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVE %s

# RUN: llvm-mc -triple=riscv64 -target-abi lp64e -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVE %s

# RUN: llvm-mc -triple=riscv32 -mattr=+xcheriot -target-abi cheriot -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-CHERIOT %s

# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-y -target-abi il32pc64 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY %s
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-y -target-abi l64pc128 -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY %s
# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-y,+f -target-abi il32pc64f -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY-FLOAT-SINGLE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-y,+f -target-abi l64pc128f -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY-FLOAT-SINGLE %s
# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-y,+d -target-abi il32pc64d -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY-FLOAT-DOUBLE %s
# RUN: llvm-mc -triple=riscv64 -mattr=+experimental-y,+d -target-abi l64pc128d -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY-FLOAT-DOUBLE %s
# RUN: llvm-mc -triple=riscv32 -mattr=+experimental-y -target-abi il32pc64e -filetype=obj < %s \
# RUN:   | llvm-readobj --file-headers - \
# RUN:   | FileCheck -check-prefix=CHECK-RVY-RVE %s

# CHECK-NONE:               Flags [ (0x0)
# CHECK-NONE-NEXT:          ]

# CHECK-FLOAT-SINGLE:       Flags [ (0x2)
# CHECK-FLOAT-SINGLE-NEXT:    EF_RISCV_FLOAT_ABI_SINGLE (0x2)
# CHECK-FLOAT-SINGLE-NEXT:  ]

# CHECK-FLOAT-DOUBLE:       Flags [ (0x4)
# CHECK-FLOAT-DOUBLE-NEXT:    EF_RISCV_FLOAT_ABI_DOUBLE (0x4)
# CHECK-FLOAT-DOUBLE-NEXT:  ]

# CHECK-RVE:                Flags [ (0x8)
# CHECK-RVE-NEXT:             EF_RISCV_RVE (0x8)
# CHECK-RVE-NEXT:           ]

# CHECK-CHERIOT:                Flags [ (0x9)
# CHECK-CHERIOT-NEXT:             EF_RISCV_RVC (0x1)
# CHECK-CHERIOT-NEXT:             EF_RISCV_RVE (0x8)
# CHECK-CHERIOT-NEXT:           ]

# CHECK-RVY:                Flags [ (0x40)
# CHECK-RVY-NEXT:             EF_RISCV_RVY (0x40)
# CHECK-RVY-NEXT:           ]

# CHECK-RVY-FLOAT-SINGLE:       Flags [ (0x42)
# CHECK-RVY-FLOAT-SINGLE-NEXT:    EF_RISCV_FLOAT_ABI_SINGLE (0x2)
# CHECK-RVY-FLOAT-SINGLE-NEXT:    EF_RISCV_RVY (0x40)
# CHECK-RVY-FLOAT-SINGLE-NEXT:  ]

# CHECK-RVY-FLOAT-DOUBLE:       Flags [ (0x44)
# CHECK-RVY-FLOAT-DOUBLE-NEXT:    EF_RISCV_FLOAT_ABI_DOUBLE (0x4)
# CHECK-RVY-FLOAT-DOUBLE-NEXT:    EF_RISCV_RVY (0x40)
# CHECK-RVY-FLOAT-DOUBLE-NEXT:  ]

# CHECK-RVY-RVE:            Flags [ (0x48)
# CHECK-RVY-RVE-NEXT:         EF_RISCV_RVE (0x8)
# CHECK-RVY-RVE-NEXT:         EF_RISCV_RVY (0x40)
# CHECK-RVY-RVE-NEXT:       ]

nop

