; This test is designed to run 4 times, once with function attribute +c,
; once with function attribute -c for eq/ne in icmp
; The optimization should appear only with +c, otherwise default isel should be
; choosen.
;
; RUN: llc -mtriple=riscv32 -target-abi ilp32d -mattr=+c,+f,+d -filetype=obj \
; RUN:   -disable-block-placement < %s | llvm-objdump -d --triple=riscv32 --mattr=+c,+f,+d -M no-aliases -

; RUN: llc -mtriple=riscv32 -target-abi ilp32d -mattr=+c,+f,+d -filetype=obj \
; RUN:   -disable-block-placement < %s \
; RUN:   | llvm-objdump -d --triple=riscv32 --mattr=+c,+f,+d -M no-aliases - \
; RUN:   | FileCheck -check-prefix=RV32IFDC %s
;
; RUN: llc -mtriple=riscv32 -target-abi ilp32d -mattr=+zca,+f,+d -filetype=obj \
; RUN:   -disable-block-placement < %s \
; RUN:   | llvm-objdump -d --triple=riscv32 --mattr=+zca,+f,+d -M no-aliases - \
; RUN:   | FileCheck -check-prefix=RV32IFDC %s
;
; RUN: llc -mtriple=riscv32 -target-abi ilp32d -mattr=-c,+f,+d -filetype=obj \
; RUN:   -disable-block-placement < %s \
; RUN:   | llvm-objdump -d --triple=riscv32 --mattr=-c,+f,+d -M no-aliases - \
; RUN:   | FileCheck -check-prefix=RV32IFD %s


; constant is small and fit in 6 bit (compress imm)
; RV32IFDC-LABEL: <f_small_pos_eq>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], -0x14
; RV32IFDC-NEXT: c.bnez [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_pos_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x14
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_pos_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, 20
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit (compress imm)
; RV32IFDC-LABEL: <f_small_pos_ne>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], -0x14
; RV32IFDC-NEXT: c.beqz [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_pos_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x14
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_pos_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, 20
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit (compress imm)
; RV32IFDC-LABEL: <f_small_neg_eq>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], 0x14
; RV32IFDC-NEXT: c.bnez [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_neg_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x14
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_neg_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, -20
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit (compress imm)
; RV32IFDC-LABEL: <f_small_neg_ne>:
; RV32IFDC-NEXT: c.mv [[REG]], a0
; RV32IFDC-NEXT: c.addi [[REG:.*]], 0x14
; RV32IFDC-NEXT: c.beqz [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_neg_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x14
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_neg_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, -20
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit (compress imm)
; RV32IFDC-LABEL: <f_small_edge_pos_eq>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], -0x1f
; RV32IFDC-NEXT: c.bnez [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_edge_pos_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x1f
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_edge_pos_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, 31
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit (compress imm)
; RV32IFDC-LABEL: <f_small_edge_pos_ne>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], -0x1f
; RV32IFDC-NEXT: c.beqz [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_edge_pos_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x1f
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_edge_pos_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, 31
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit, but not negated 6 bits (compress imm)
; RV32IFDC-LABEL: <f_small_edge_neg_eq>:
; RV32IFDC-NEXT: c.li [[REG:.*]], -0x20
; RV32IFDC-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_edge_neg_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x20
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_edge_neg_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, -32
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is small and fit in 6 bit, but not negated 6 bits (compress imm)
; RV32IFDC-LABEL: <f_small_edge_neg_ne>:
; RV32IFDC-NEXT: c.li [[REG:.*]], -0x20
; RV32IFDC-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_small_edge_neg_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x20
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_small_edge_neg_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, -32
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fits in negated 6 bits and in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_ledge_pos_eq>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], -0x20
; RV32IFDC-NEXT: c.bnez [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_ledge_pos_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x20
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_ledge_pos_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, 32
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fits in negated 6 bits and in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_ledge_pos_ne>:
; RV32IFDC-NEXT: c.mv [[REG:.*]], a0
; RV32IFDC-NEXT: c.addi [[REG]], -0x20
; RV32IFDC-NEXT: c.beqz [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_ledge_pos_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x20
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_ledge_pos_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, 32
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_ledge_neg_eq>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], 0x21
; RV32IFDC-NEXT: c.bnez [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_ledge_neg_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x21
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_ledge_neg_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, -33
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_ledge_neg_ne>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], 0x21
; RV32IFDC-NEXT: c.beqz [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_ledge_neg_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x21
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_ledge_neg_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, -33
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_pos_eq>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], -0x3f
; RV32IFDC-NEXT: c.bnez [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_pos_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x3f
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_pos_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, 63
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_pos_ne>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], -0x3f
; RV32IFDC-NEXT: c.beqz [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_pos_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x3f
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_pos_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, 63
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_neg_eq>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], 0x3f
; RV32IFDC-NEXT: c.bnez [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_neg_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x3f
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_neg_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, -63
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_neg_ne>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], 0x3f
; RV32IFDC-NEXT: c.beqz [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_neg_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x3f
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_neg_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, -63
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_bedge_pos_eq>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], -0x7ff
; RV32IFDC-NEXT: c.bnez [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_bedge_pos_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x7ff
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_bedge_pos_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, 2047
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm)
; RV32IFDC-LABEL: <f_medium_bedge_pos_ne>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], -0x7ff
; RV32IFDC-NEXT: c.beqz [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_bedge_pos_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, 0x7ff
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_bedge_pos_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, 2047
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm), negative value fit in 12 bit too.
; RV32IFDC-LABEL: <f_medium_bedge_neg_eq>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], 0x7ff
; RV32IFDC-NEXT: c.bnez [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_bedge_neg_eq>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x7ff
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_bedge_neg_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, -2047
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is medium and not fit in 6 bit (compress imm),
; but fit in 12 bit (imm), negative value fit in 12 bit too.
; RV32IFDC-LABEL: <f_medium_bedge_neg_ne>:
; RV32IFDC-NEXT: addi [[MAYZEROREG:.*]], [[REG:.*]], 0x7ff
; RV32IFDC-NEXT: c.beqz [[MAYZEROREG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_medium_bedge_neg_ne>:
; RV32IFD-NEXT: addi [[REG:.*]], zero, -0x7ff
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
define i32 @f_medium_bedge_neg_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, -2047
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is big and do not fit in 12 bit (imm), fit in i32
; RV32IFDC-LABEL: <f_big_ledge_pos_eq>:
; RV32IFDC-NEXT: c.li [[REG:.*]], 0x1
; RV32IFDC-NEXT: c.slli [[REG]], 0xb
; RV32IFDC-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_big_ledge_pos_eq>:
; RV32IFD-NEXT: addi [[REG1:.*]], zero, 0x1
; RV32IFD-NEXT: slli [[REG2:.*]], [[REG1]], 0xb
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG2]], [[PLACE:.*]]
define i32 @f_big_ledge_pos_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, 2048
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is big and do not fit in 12 bit (imm), fit in i32
; RV32IFDC-LABEL: <f_big_ledge_pos_ne>:
; RV32IFDC-NEXT: c.li [[REG:.*]], 0x1
; RV32IFDC-NEXT: c.slli [[REG]], 0xb
; RV32IFDC-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_big_ledge_pos_ne>:
; RV32IFD-NEXT: addi [[REG1:.*]], zero, 0x1
; RV32IFD-NEXT: slli [[REG2:.*]], [[REG1]], 0xb
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG2]], [[PLACE:.*]]
define i32 @f_big_ledge_pos_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, 2048
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is big and do not fit in 12 bit (imm), fit in i32
; RV32IFDC-LABEL: <f_big_ledge_neg_eq>:
; RV32IFDC-NEXT: c.lui [[REG1:.*]], 0xfffff
; RV32IFDC-NEXT: addi [[REG2:.*]], [[REG1]], 0x7ff
; RV32IFDC-NEXT: bne [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_big_ledge_neg_eq>:
; RV32IFD-NEXT: lui [[REG1:.*]], 0xfffff
; RV32IFD-NEXT: addi [[REG2:.*]], [[REG1]], 0x7ff
; RV32IFD-NEXT: bne [[ANOTHER:.*]], [[REG2]], [[PLACE:.*]]
define i32 @f_big_ledge_neg_eq(i32 %in0) minsize {
  %cmp = icmp eq i32 %in0, -2049
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}

; constant is big and do not fit in 12 bit (imm), fit in i32
; RV32IFDC-LABEL: <f_big_ledge_neg_ne>:
; RV32IFDC-NEXT: c.lui [[REG1:.*]], 0xfffff
; RV32IFDC-NEXT: addi [[REG2:.*]], [[REG1]], 0x7ff
; RV32IFDC-NEXT: beq [[ANOTHER:.*]], [[REG]], [[PLACE:.*]]
; --- no compress extension
; RV32IFD-LABEL: <f_big_ledge_neg_ne>:
; RV32IFD-NEXT: lui [[REG1:.*]], 0xfffff
; RV32IFD-NEXT: addi [[REG2:.*]], [[REG1]], 0x7ff
; RV32IFD-NEXT: beq [[ANOTHER:.*]], [[REG2]], [[PLACE:.*]]
define i32 @f_big_ledge_neg_ne(i32 %in0) minsize {
  %cmp = icmp ne i32 %in0, -2049
  br i1 %cmp, label %if.then, label %if.else
if.then:
  %call = shl i32 %in0, 1
  br label %if.end
if.else:
  %call2 = add i32 %in0, 42
  br label %if.end

if.end:
  %toRet = phi i32 [ %call, %if.then ], [ %call2, %if.else ]
  ret i32 %toRet
}
