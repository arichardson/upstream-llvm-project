# RUN: llvm-mc --triple=riscv32 -mattr=+experimental-y --riscv-no-aliases --show-encoding < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc --triple=riscv32 -mattr=+experimental-y,+cap-mode --riscv-no-aliases --show-encoding < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y -M no-aliases -d --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+cap-mode < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+cap-mode -M no-aliases -d --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ %s

# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y --riscv-no-aliases --show-encoding --defsym=RV64=1 < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-64,CHECK-ASM-AND-OBJ,CHECK-ASM-AND-OBJ-64 %s
# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+cap-mode --riscv-no-aliases --show-encoding --defsym=RV64=1 < %s \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-64,CHECK-ASM-AND-OBJ,CHECK-ASM-AND-OBJ-64 %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y --riscv-no-aliases --show-encoding --defsym=RV64=1 < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y -M no-aliases -d --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM-AND-OBJ-64 %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+cap-mode --riscv-no-aliases --show-encoding --defsym=RV64=1 < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+cap-mode -M no-aliases -d --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ,CHECK-ASM-AND-OBJ-64 %s

## Both capability & normal RISC-V instruction use the same encoding, and the
## same MCInst as we rely on RegClassByHwMode to select the rigt base pointer.

# CHECK-ASM-AND-OBJ: lb	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0x85,0x05,0x00]
lb a0, 0(a1)
# CHECK-ASM-AND-OBJ: sb	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0x80,0xa5,0x00]
sb a0, 0(a1)
# CHECK-ASM-AND-OBJ: lbu	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xc5,0x05,0x00]
lbu a0, 0(a1)
# CHECK-ASM-AND-OBJ: lh	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0x95,0x05,0x00]
lh a0, 0(a1)
# CHECK-ASM-AND-OBJ: sh	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0x90,0xa5,0x00]
sh a0, 0(a1)
# CHECK-ASM-AND-OBJ: lhu	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xd5,0x05,0x00]
lhu a0, 0(a1)
# CHECK-ASM-AND-OBJ: lw	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x03,0xa5,0x05,0x00]
lw a0, 0(a1)
# CHECK-ASM-AND-OBJ: sw	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0xa0,0xa5,0x00]
sw a0, 0(a1)

.ifdef RV64
# CHECK-ASM-AND-OBJ-64: lwu	a0, 0(a1)
# CHECK-ASM-64-SAME: # encoding: [0x03,0xe5,0x05,0x00]
lwu a0, 0(a1)
# CHECK-ASM-AND-OBJ-64: ld	a0, 0(a1)
# CHECK-ASM-64-SAME: # encoding: [0x03,0xb5,0x05,0x00]
ld a0, 0(a1)
# CHECK-ASM-AND-OBJ-64: sd	a0, 0(a1)
# CHECK-ASM-64-SAME: # encoding: [0x23,0xb0,0xa5,0x00]
sd a0, 0(a1)
.endif

# CHECK-ASM-AND-OBJ: ly	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x0f,0xc5,0x05,0x00]
ly a0, 0(a1)
# CHECK-ASM-AND-OBJ: sy	a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x23,0xc0,0xa5,0x00]
sy a0, 0(a1)
