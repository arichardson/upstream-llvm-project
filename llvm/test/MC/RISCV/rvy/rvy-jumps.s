# RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,+cap-mode --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-CAP %s
# RUN: llvm-mc --triple=riscv32 --mattr=+experimental-y,-cap-mode --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,+cap-mode --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-CAP %s
# RUN: llvm-mc --triple=riscv64 --mattr=+experimental-y,-cap-mode --riscv-no-aliases --show-encoding --show-inst < %s \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-ASM,CHECK-INT %s
# RUN: llvm-mc --filetype=obj --triple=riscv32 --mattr=+experimental-y,+cap-mode < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+cap-mode -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s
# RUN: llvm-mc --filetype=obj --triple=riscv64 --mattr=+experimental-y,+cap-mode - < %s \
# RUN:   | llvm-objdump --mattr=+experimental-y,+cap-mode -M no-aliases -d -r --no-print-imm-hex - \
# RUN:   | FileCheck --check-prefixes=CHECK,CHECK-OBJ %s

# CHECK: jalr a0, 0(a1)
# CHECK-ASM-SAME: # encoding: [0x67,0x85,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] JALR{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
jalr a0, a1, 0
# CHECK-NEXT: jalr a0, 10(a1)
# CHECK-ASM-SAME: # encoding: [0x67,0x85,0xa5,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] JALR{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X11>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X11_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:10>>
jalr a0, a1, 10
# CHECK-NEXT: jalr zero, 0(a0)
# CHECK-ASM-SAME: # encoding: [0x67,0x00,0x05,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] JALR{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X0>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X0_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X10>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X10_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
jr a0
# CHECK-NEXT: jalr zero, 0(ra)
# CHECK-ASM-SAME: # encoding: [0x67,0x80,0x00,0x00]
# CHECK-ASM-NEXT: # <MCInst #[[#]] JALR{{$}}
# CHECK-INT-NEXT: #  <MCOperand Reg:X0>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X0_Y>
# CHECK-INT-NEXT: #  <MCOperand Reg:X1>
# CHECK-CAP-NEXT: #  <MCOperand Reg:X1_Y>
# CHECK-ASM-NEXT: #  <MCOperand Imm:0>>
ret
# CHECK-ASM-NEXT: call sym
# CHECK-ASM-SAME: # encoding: [0x97'A',A,A,A,0xe7'A',0x80'A',A,A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: sym, kind: fixup_riscv_call_plt
# CHECK-ASM-NEXT: # <MCInst #[[#]] PseudoCALL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Expr:sym>>
# CHECK-OBJ: 10: 00000097 auipc ra, 0
# CHECK-OBJ-NEXT: R_RISCV_CALL_PLT sym
# CHECK-OBJ-NEXT: 14: 000080e7 jalr ra, 0(ra)
call sym
# CHECK-ASM-NEXT: tail sym
# CHECK-ASM-SAME: # encoding: [0x17'A',0x03'A',A,A,0x67'A',A,0x03'A',A]
# CHECK-ASM-NEXT: #   fixup A - offset: 0, value: sym, kind: fixup_riscv_call_plt
# CHECK-ASM-NEXT: # <MCInst #[[#]] PseudoTAIL{{$}}
# CHECK-ASM-NEXT: #  <MCOperand Expr:sym>>
# CHECK-OBJ-NEXT: auipc t1, 0
# CHECK-OBJ-NEXT: R_RISCV_CALL_PLT sym
# CHECK-OBJ-NEXT: jalr zero, 0(t1)
tail sym
# CHECK-EMPTY:

.data
sym:
.4byte 0
