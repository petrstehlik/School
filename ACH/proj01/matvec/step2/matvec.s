# mark_description "Intel(R) C++ Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 16.0.1.150 Build 20151021";
# mark_description "";
# mark_description "-lpapi -ansi-alias -O2 -xavx -qopenmp-simd -S -fsource-asm -c";
	.file "matvec.cpp"
	.text
..TXTST0:
# -- Begin  _Z11mat_vec_muljjPPfS_S_
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z11mat_vec_muljjPPfS_S_
# --- mat_vec_mul(unsigned int, unsigned int, float **, float *, float *)
_Z11mat_vec_muljjPPfS_S_:
# parameter 1: %edi
# parameter 2: %esi
# parameter 3: %rdx
# parameter 4: %rcx
# parameter 5: %r8
..B1.1:                         # Preds ..B1.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z11mat_vec_muljjPPfS_S_.1:
..L2:
                                                          #10.1

###     for (int i = 0; i < rows; i++)

        xorl      %r10d, %r10d                                  #11.5
        testl     %edi, %edi                                    #11.25
        jbe       ..B1.22       # Prob 9%                       #11.25
                                # LOE rdx rcx rbx rbp r8 r10 r12 r13 r14 r15 esi edi
..B1.2:                         # Preds ..B1.1

###     {
### 	float sum = 0.0f;
### 
### 	#pragma omp simd reduction(+:sum)
###         for (int j = 0; j < cols; j++)

        movq      %rcx, %r11                                    #16.9
        andq      $31, %r11                                     #16.9
        movl      %r11d, %eax                                   #16.9
        movl      %r11d, %r9d                                   #16.9
        negl      %eax                                          #16.9
        andl      $3, %r9d                                      #16.9
        addl      $32, %eax                                     #16.9
        movslq    %edi, %rdi                                    #11.5
        shrl      $2, %eax                                      #16.9
        movq      %r12, -8(%rsp)                                #16.9
        movq      %r13, -40(%rsp)                               #16.9
        movq      %r14, -32(%rsp)                               #16.9
        movq      %r15, -24(%rsp)                               #16.9
        movq      %rbx, -16(%rsp)                               #16.9
	.cfi_offset 3, -24
	.cfi_offset 12, -16
	.cfi_offset 13, -48
	.cfi_offset 14, -40
	.cfi_offset 15, -32
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d
..B1.3:                         # Preds ..B1.20 ..B1.2

###         {

        testl     %esi, %esi                                    #17.9
        vxorps    %xmm0, %xmm0, %xmm0                           #13.12
        jbe       ..B1.20       # Prob 50%                      #17.9
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d xmm0
..B1.4:                         # Preds ..B1.3
        cmpl      $16, %esi                                     #16.9
        jb        ..B1.23       # Prob 10%                      #16.9
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d xmm0
..B1.5:                         # Preds ..B1.4
        movl      %r11d, %r13d                                  #16.9
        testl     %r11d, %r11d                                  #16.9
        je        ..B1.8        # Prob 50%                      #16.9
                                # LOE rdx rcx rbp rdi r8 r10 r13 eax esi r9d r11d xmm0
..B1.6:                         # Preds ..B1.5
        testl     %r9d, %r9d                                    #16.9
        jne       ..B1.23       # Prob 10%                      #16.9
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d xmm0
..B1.7:                         # Preds ..B1.6
        movl      %eax, %r13d                                   #16.9
                                # LOE rdx rcx rbp rdi r8 r10 r13 eax esi r9d r11d xmm0
..B1.8:                         # Preds ..B1.7 ..B1.5
        lea       16(%r13), %ebx                                #16.9
        cmpl      %ebx, %esi                                    #16.9
        jb        ..B1.23       # Prob 10%                      #16.9
                                # LOE rdx rcx rbp rdi r8 r10 r13 eax esi r9d r11d xmm0
..B1.9:                         # Preds ..B1.8
        movl      %esi, %r14d                                   #16.9
        xorl      %ebx, %ebx                                    #16.9
        subl      %r13d, %r14d                                  #16.9
        andl      $15, %r14d                                    #16.9
        negl      %r14d                                         #16.9
        addl      %esi, %r14d                                   #16.9

### 		sum += a[i][j] * b[j];

        movq      (%rdx), %r12                                  #18.10
        testq     %r13, %r13                                    #16.9
        jbe       ..B1.13       # Prob 10%                      #16.9
                                # LOE rdx rcx rbx rbp rdi r8 r10 r12 r13 eax esi r9d r11d r14d xmm0
..B1.11:                        # Preds ..B1.9 ..B1.11
        vmovss    (%r12,%rbx,4), %xmm1                          #18.10
        vmulss    (%rcx,%rbx,4), %xmm1, %xmm2                   #18.20
        incq      %rbx                                          #16.9
        vaddss    %xmm2, %xmm0, %xmm0                           #18.3
        cmpq      %r13, %rbx                                    #16.9
        jb        ..B1.11       # Prob 82%                      #16.9
                                # LOE rdx rcx rbx rbp rdi r8 r10 r12 r13 eax esi r9d r11d r14d xmm0
..B1.13:                        # Preds ..B1.11 ..B1.9
        movslq    %r14d, %rbx                                   #16.9
        vxorps    %xmm1, %xmm1, %xmm1                           #13.12
        vmovss    %xmm0, %xmm1, %xmm0                           #13.12
        vinsertf128 $1, %xmm1, %ymm0, %ymm1                     #13.12
        vxorps    %ymm0, %ymm0, %ymm0                           #13.12
                                # LOE rdx rcx rbx rbp rdi r8 r10 r12 r13 eax esi r9d r11d r14d ymm0 ymm1
..B1.14:                        # Preds ..B1.14 ..B1.13
        vmovups   (%r12,%r13,4), %xmm2                          #18.10
        vmovups   32(%r12,%r13,4), %xmm5                        #18.10
        vinsertf128 $1, 16(%r12,%r13,4), %ymm2, %ymm3           #18.10
        vinsertf128 $1, 48(%r12,%r13,4), %ymm5, %ymm6           #18.10
        vmulps    (%rcx,%r13,4), %ymm3, %ymm4                   #18.20
        vmulps    32(%rcx,%r13,4), %ymm6, %ymm7                 #18.20
        vaddps    %ymm4, %ymm1, %ymm1                           #18.3
        vaddps    %ymm0, %ymm7, %ymm0                           #18.3
        addq      $16, %r13                                     #16.9
        cmpq      %rbx, %r13                                    #16.9
        jb        ..B1.14       # Prob 82%                      #16.9
                                # LOE rdx rcx rbx rbp rdi r8 r10 r12 r13 eax esi r9d r11d r14d ymm0 ymm1
..B1.15:                        # Preds ..B1.14
        vaddps    %ymm0, %ymm1, %ymm0                           #13.12
        vextractf128 $1, %ymm0, %xmm1                           #13.12
        vaddps    %xmm1, %xmm0, %xmm2                           #13.12
        vmovhlps  %xmm2, %xmm2, %xmm3                           #13.12
        vaddps    %xmm3, %xmm2, %xmm4                           #13.12
        vshufps   $245, %xmm4, %xmm4, %xmm5                     #13.12
        vaddss    %xmm5, %xmm4, %xmm0                           #13.12
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d r14d xmm0
..B1.16:                        # Preds ..B1.15 ..B1.23
        xorl      %r13d, %r13d                                  #16.9
        lea       1(%r14), %ebx                                 #16.9
        cmpl      %ebx, %esi                                    #16.9
        jb        ..B1.20       # Prob 10%                      #16.9
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d r13d r14d xmm0
..B1.17:                        # Preds ..B1.16
        movl      %esi, %ebx                                    #16.9
        movq      (%rdx), %r12                                  #18.10
        subl      %r14d, %ebx                                   #16.9
                                # LOE rdx rcx rbp rdi r8 r10 r12 eax ebx esi r9d r11d r13d r14d xmm0
..B1.18:                        # Preds ..B1.18 ..B1.17
        lea       (%r14,%r13), %r15d                            #18.10
        incl      %r13d                                         #16.9
        movslq    %r15d, %r15                                   #18.20
        vmovss    (%r12,%r15,4), %xmm1                          #18.10
        vmulss    (%rcx,%r15,4), %xmm1, %xmm2                   #18.20
        vaddss    %xmm2, %xmm0, %xmm0                           #18.3
        cmpl      %ebx, %r13d                                   #16.9
        jb        ..B1.18       # Prob 82%                      #16.9
                                # LOE rdx rcx rbp rdi r8 r10 r12 eax ebx esi r9d r11d r13d r14d xmm0
..B1.20:                        # Preds ..B1.18 ..B1.16 ..B1.3

###         }
### 	c[i] = sum;

        vmovss    %xmm0, (%r8,%r10,4)                           #20.2
        incq      %r10                                          #11.5
        addq      $8, %rdx                                      #11.5
        cmpq      %rdi, %r10                                    #11.5
        jb        ..B1.3        # Prob 82%                      #11.5
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d
..B1.21:                        # Preds ..B1.20
        movq      -8(%rsp), %r12                                #
	.cfi_restore 12
        movq      -40(%rsp), %r13                               #
	.cfi_restore 13
        movq      -32(%rsp), %r14                               #
	.cfi_restore 14
        movq      -24(%rsp), %r15                               #
	.cfi_restore 15
        movq      -16(%rsp), %rbx                               #
	.cfi_restore 3
                                # LOE rbx rbp r12 r13 r14 r15
..B1.22:                        # Preds ..B1.21 ..B1.1

###     }
### }

        vzeroupper                                              #22.1
        ret                                                     #22.1
	.cfi_offset 3, -24
	.cfi_offset 12, -16
	.cfi_offset 13, -48
	.cfi_offset 14, -40
	.cfi_offset 15, -32
                                # LOE
..B1.23:                        # Preds ..B1.4 ..B1.6 ..B1.8    # Infreq
        xorl      %r14d, %r14d                                  #16.9
        jmp       ..B1.16       # Prob 100%                     #16.9
        .align    16,0x90
	.cfi_endproc
                                # LOE rdx rcx rbp rdi r8 r10 eax esi r9d r11d r14d xmm0
# mark_end;
	.type	_Z11mat_vec_muljjPPfS_S_,@function
	.size	_Z11mat_vec_muljjPPfS_S_,.-_Z11mat_vec_muljjPPfS_S_
	.data
# -- End  _Z11mat_vec_muljjPPfS_S_
	.data
	.section .note.GNU-stack, ""
// -- Begin DWARF2 SEGMENT .eh_frame
	.section .eh_frame,"a",@progbits
.eh_frame_seg:
	.align 8
# End
