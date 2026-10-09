# RUN: llvm-mc %s -triple=riscv32 -mattr=+experimental-zabhlrsc -M no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc %s -triple=riscv64 -mattr=+experimental-zabhlrsc -M no-aliases -show-encoding \
# RUN:     | FileCheck -check-prefixes=CHECK-ASM,CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv32 -mattr=+experimental-zabhlrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zabhlrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: llvm-mc -filetype=obj -triple=riscv64 -mattr=+experimental-zabhlrsc < %s \
# RUN:     | llvm-objdump --mattr=+experimental-zabhlrsc -M no-aliases -d -r - \
# RUN:     | FileCheck --check-prefix=CHECK-ASM-AND-OBJ %s
# RUN: not llvm-mc -triple=riscv32 -mattr=+a -show-encoding %s 2>&1 \
# RUN:     | FileCheck %s --check-prefix=CHECK-ERROR
# RUN: not llvm-mc -triple=riscv64 -mattr=+a -show-encoding %s 2>&1 \
# RUN:     | FileCheck %s --check-prefix=CHECK-ERROR

# CHECK-ASM-AND-OBJ: lr.b t0, (t1)
# CHECK-ASM: encoding: [0xaf,0x02,0x03,0x10]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.b t0, (t1)
# CHECK-ASM-AND-OBJ: lr.b t0, (t1)
# CHECK-ASM: encoding: [0xaf,0x02,0x03,0x10]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.b t0, 0(t1)
# CHECK-ASM-AND-OBJ: lr.b.aq t1, (t2)
# CHECK-ASM: encoding: [0x2f,0x83,0x03,0x14]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.b.aq t1, (t2)
# CHECK-ASM-AND-OBJ: lr.b.rl t2, (t3)
# CHECK-ASM: encoding: [0xaf,0x03,0x0e,0x12]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.b.rl t2, (t3)
# CHECK-ASM-AND-OBJ: lr.b.aqrl t3, (t4)
# CHECK-ASM: encoding: [0x2f,0x8e,0x0e,0x16]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.b.aqrl t3, (t4)

# CHECK-ASM-AND-OBJ: sc.b t6, t5, (t4)
# CHECK-ASM: encoding: [0xaf,0x8f,0xee,0x19]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.b t6, t5, (t4)
# CHECK-ASM-AND-OBJ: sc.b t6, t5, (t4)
# CHECK-ASM: encoding: [0xaf,0x8f,0xee,0x19]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.b t6, t5, 0(t4)
# CHECK-ASM-AND-OBJ: sc.b.aq t5, t4, (t3)
# CHECK-ASM: encoding: [0x2f,0x0f,0xde,0x1d]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.b.aq t5, t4, (t3)
# CHECK-ASM-AND-OBJ: sc.b.rl t4, t3, (t2)
# CHECK-ASM: encoding: [0xaf,0x8e,0xc3,0x1b]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.b.rl t4, t3, (t2)
# CHECK-ASM-AND-OBJ: sc.b.aqrl t3, t2, (t1)
# CHECK-ASM: encoding: [0x2f,0x0e,0x73,0x1e]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.b.aqrl t3, t2, (t1)

# CHECK-ASM-AND-OBJ: lr.h t0, (t1)
# CHECK-ASM: encoding: [0xaf,0x12,0x03,0x10]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.h t0, (t1)
# CHECK-ASM-AND-OBJ: lr.h t0, (t1)
# CHECK-ASM: encoding: [0xaf,0x12,0x03,0x10]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.h t0, 0(t1)
# CHECK-ASM-AND-OBJ: lr.h.aq t1, (t2)
# CHECK-ASM: encoding: [0x2f,0x93,0x03,0x14]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.h.aq t1, (t2)
# CHECK-ASM-AND-OBJ: lr.h.rl t2, (t3)
# CHECK-ASM: encoding: [0xaf,0x13,0x0e,0x12]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.h.rl t2, (t3)
# CHECK-ASM-AND-OBJ: lr.h.aqrl t3, (t4)
# CHECK-ASM: encoding: [0x2f,0x9e,0x0e,0x16]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
lr.h.aqrl t3, (t4)

# CHECK-ASM-AND-OBJ: sc.h t6, t5, (t4)
# CHECK-ASM: encoding: [0xaf,0x9f,0xee,0x19]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.h t6, t5, (t4)
# CHECK-ASM-AND-OBJ: sc.h t6, t5, (t4)
# CHECK-ASM: encoding: [0xaf,0x9f,0xee,0x19]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.h t6, t5, 0(t4)
# CHECK-ASM-AND-OBJ: sc.h.aq t5, t4, (t3)
# CHECK-ASM: encoding: [0x2f,0x1f,0xde,0x1d]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.h.aq t5, t4, (t3)
# CHECK-ASM-AND-OBJ: sc.h.rl t4, t3, (t2)
# CHECK-ASM: encoding: [0xaf,0x9e,0xc3,0x1b]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.h.rl t4, t3, (t2)
# CHECK-ASM-AND-OBJ: sc.h.aqrl t3, t2, (t1)
# CHECK-ASM: encoding: [0x2f,0x1e,0x73,0x1e]
# CHECK-ERROR: instruction requires the following: 'Zabhlrsc' (Byte and Halfword Load-Reserved/Store-Conditional){{$}}
sc.h.aqrl t3, t2, (t1)
