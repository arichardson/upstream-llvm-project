; RUN: split-file %s %t
; RUN: not llvm-as < %t/aarch64-svcount.ll -o /dev/null 2>&1 | FileCheck --check-prefix=CHECK-AARCH64-SVCOUNT %s
; RUN: not llvm-as < %t/riscv-vector-tuple.ll -o /dev/null 2>&1 | FileCheck --check-prefix=CHECK-RISCV-VECTOR-TUPLE %s
; RUN: not llvm-as < %t/amdgcn-named-barrier.ll -o /dev/null 2>&1 | FileCheck --check-prefix=CHECK-AMDGCN-NAMEDBARRIER %s
; RUN: not llvm-as < %t/amdgpu-stridemark-type-param.ll -disable-output 2>&1 | FileCheck --check-prefix=CHECK-AMDGPU-STRIDEMARK-TYPE %s
; RUN: not llvm-as < %t/amdgpu-stridemark-int-params.ll -disable-output 2>&1 | FileCheck --check-prefix=CHECK-AMDGPU-STRIDEMARK-INTS %s
; RUN: not llvm-as < %t/cheri-capability-params.ll -disable-output 2>&1 | FileCheck --check-prefix=CHECK-CHERI-CAPABILITY-PARAMS %s
; RUN: not llvm-as < %t/cheri-capability-bitwidth.ll -disable-output 2>&1 | FileCheck --check-prefix=CHECK-CHERI-CAPABILITY-BITWIDTH %s
; Check target extension type properties are verified in the assembler.

;--- aarch64-svcount.ll
declare target("aarch64.svcount", i32) @aarch64_svcount()
; CHECK-AARCH64-SVCOUNT: error: target extension type aarch64.svcount should have no parameters

;--- riscv-vector-tuple.ll
declare target("riscv.vector.tuple", 99) @riscv_vector_tuple()
; CHECK-RISCV-VECTOR-TUPLE: target extension type riscv.vector.tuple should have one type parameter and one integer parameter

;--- amdgcn-named-barrier.ll
declare target("amdgcn.named.barrier", i32) @amdgcn_named_barrier()
; CHECK-AMDGCN-NAMEDBARRIER: target extension type amdgcn.named.barrier should have no type parameters and one integer parameter

;--- amdgpu-stridemark-type-param.ll
declare target("amdgpu.stridemark", i32) @amdgcn_stridemark_type_param()
; CHECK-AMDGPU-STRIDEMARK-TYPE: target extension type amdgpu.stridemark should have no type parameters and at most one integer parameter

;--- amdgpu-stridemark-int-params.ll
declare target("amdgpu.stridemark", 16, 32) @amdgcn_stridemark_int_params()
; CHECK-AMDGPU-STRIDEMARK-INTS: target extension type amdgpu.stridemark should have no type parameters and at most one integer parameter

;--- cheri-capability-params.ll
declare target("cheri.capability", i32) @cheri_capability_type_param()
; CHECK-CHERI-CAPABILITY-PARAMS: target extension type cheri.capability should have no type parameters and one integer parameter

;--- cheri-capability-bitwidth.ll
declare target("cheri.capability", 32) @cheri_capability_bitwidth()
; CHECK-CHERI-CAPABILITY-BITWIDTH: target extension type cheri.capability bitwidth must be 64 or 128
