# RUN: llvm-mc %s --triple=riscv32 -mattr=+experimental-y --riscv-no-aliases --show-encoding \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-32,CHECK-ASM-AND-OBJ '-D#XLEN=32' %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y -M no-aliases -d --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ '-D#XLEN=32' %s
#
# RUN: llvm-mc %s --triple=riscv64 --mattr=+experimental-y --riscv-no-aliases \
# RUN:   --show-encoding --defsym=RV64=1 \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM,CHECK-ASM-64,CHECK-ASM-AND-OBJ '-D#XLEN=64' %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y \
# RUN:   --riscv-no-aliases --show-encoding --defsym=RV64=1 < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y -M no-aliases -d --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK-ASM-AND-OBJ '-D#XLEN=64' %s

# CHECK-ASM-AND-OBJ: addy a0, a0, a1
# CHECK-ASM-SAME: encoding: [0x33,0x05,0xb5,0x0c]
addy a0, a0, a1
# CHECK-ASM-AND-OBJ-NEXT: addiy a0, a0, 12
# CHECK-ASM-SAME: encoding: [0x1b,0x25,0xc5,0x00]
addiy a0, a0, 12
# CHECK-ASM-AND-OBJ-NEXT: addiy a0, a0, 12
# CHECK-ASM-SAME: encoding: [0x1b,0x25,0xc5,0x00]
addy a0, a0, 12
# CHECK-ASM-AND-OBJ-NEXT: yaddrw a0, a0, a1
# CHECK-ASM-SAME: encoding: [0x33,0x15,0xb5,0x0c]
yaddrw a0, a0, a1
#
#
# CHECK-ASM-AND-OBJ-NEXT: ypermc a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x25,0xa5,0x0c]
ypermc a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ymv a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x05,0x0c]
ymv a0, a0
## Note: mv expands to integer addi and not capability ymv:
# CHECK-ASM-AND-OBJ-NEXT: addi a0, a0,
# CHECK-ASM-SAME: encoding: [0x13,0x05,0x05,0x00]
mv a0, a0
# CHECK-ASM-AND-OBJ-NEXT: packy a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x35,0xa5,0x0c]
packy a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: packy a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x35,0xa5,0x0c]
yhiw a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ybndsw a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0xa5,0x0e]
ybndsw a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ybndsrw a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x15,0xa5,0x0e]
ybndsrw a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 12
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xb5,0x00]
ybndswi a0, a0, 12
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 12
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xb5,0x00]
ybndsw a0, a0, 12
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 12
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xb5,0x00]
ybndswi a0, a0, 12
## Test all the  min and max values for the ybndswi encoding
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 1
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0x05,0x00]
ybndswi a0, a0, 1
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 256
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xf5,0x0f]
ybndswi a0, a0, 256
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 258
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0x05,0x10]
ybndswi a0, a0, 258
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 768
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xf5,0x1f]
ybndswi a0, a0, 768
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 772
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0x05,0x20]
ybndswi a0, a0, 772
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 1792
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xf5,0x2f]
ybndswi a0, a0, 1792
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 1800
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0x05,0x30]
ybndswi a0, a0, 1800
# CHECK-ASM-AND-OBJ-NEXT: ybndswi a0, a0, 3840
# CHECK-ASM-SAME: encoding: [0x1b,0x35,0xf5,0x3f]
ybndswi a0, a0, 3840
# CHECK-ASM-AND-OBJ-NEXT: ybld a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x55,0xa5,0x0c]
ybld a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ysunseal a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x25,0xa5,0x0e]
ysunseal a0, a0, a0
#
#
# CHECK-ASM-AND-OBJ-NEXT: ybaser a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x55,0x10]
ybaser a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ylenr a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x65,0x10]
ylenr a0, a0
#
#
# CHECK-ASM-AND-OBJ-NEXT: ytagr a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x05,0x10]
ytagr a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ypermr a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x15,0x10]
ypermr a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ytyper a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x25,0x10]
ytyper a0, a0
# CHECK-ASM-AND-OBJ-NEXT: srliy a0, a0, [[#XLEN]]
.ifdef RV64
# CHECK-ASM-64-SAME: encoding: [0x13,0x55,0x05,0x04]
srliy a0, a0, 64
.else
# CHECK-ASM-32-SAME: encoding: [0x13,0x55,0x05,0x02]
srliy a0, a0, 32
.endif
# CHECK-ASM-AND-OBJ-NEXT: srliy a0, a0, [[#XLEN]]
# CHECK-ASM-32-SAME: encoding: [0x13,0x55,0x05,0x02]
# CHECK-ASM-64-SAME: encoding: [0x13,0x55,0x05,0x04]
yhir a0, a0
#
#
# CHECK-ASM-AND-OBJ-NEXT: syeq a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x45,0xa5,0x0c]
syeq a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: ylt a0, a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x65,0xa5,0x0c]
ylt a0, a0, a0
# CHECK-ASM-AND-OBJ-NEXT: yamask a0, a0
# CHECK-ASM-SAME: encoding: [0x33,0x05,0x75,0x10]
yamask a0, a0
