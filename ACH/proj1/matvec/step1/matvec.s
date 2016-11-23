# mark_description "Intel(R) C++ Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 16.0.1.150 Build 20151021";
# mark_description "";
# mark_description "-lpapi -ansi-alias -O2 -xavx -S -fsource-asm -c";
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

        xorl      %r9d, %r9d                                    #11.5
        testl     %edi, %edi                                    #11.25
        jbe       ..B1.41       # Prob 9%                       #11.25
                                # LOE rdx rcx rbx rbp r8 r9 r12 r13 r14 r15 esi edi
..B1.2:                         # Preds ..B1.1

###     {
###         c[i] = 0.0f;

        xorl      %r11d, %r11d                                  #13.9
        movl      %r11d, (%r8)                                  #13.9
        movslq    %edi, %r10                                    #11.5

### 
###         for (int j = 0; j < cols; j++)

        testl     %esi, %esi                                    #15.29
        ja        ..B1.6        # Prob 50%                      #15.29
        jmp       ..B1.4        # Prob 100%                     #15.29
                                # LOE rdx rcx rbx rbp r8 r9 r10 r12 r13 r14 r15 esi r11d
..B1.5:                         # Preds ..B1.4
        movl      %r11d, (%r8,%r9,4)                            #13.9
                                # LOE rbx rbp r8 r9 r10 r12 r13 r14 r15 r11d
..B1.4:                         # Preds ..B1.2 ..B1.5
        incq      %r9                                           #11.5
        cmpq      %r10, %r9                                     #11.5
        jb        ..B1.5        # Prob 82%                      #11.5
        jmp       ..B1.41       # Prob 100%                     #11.5
                                # LOE rbx rbp r8 r9 r10 r12 r13 r14 r15 r11d
..B1.6:                         # Preds ..B1.2
        movl      %esi, %edi                                    #9.6
        shrl      $1, %edi                                      #9.6
        movslq    %esi, %rax                                    #15.9
        movq      %r12, -48(%rsp)                               #15.9
        movq      %r14, -40(%rsp)                               #15.9
        movq      %r15, -32(%rsp)                               #15.9
        movq      %rbx, -24(%rsp)                               #15.9
	.cfi_offset 3, -32
	.cfi_offset 12, -56
	.cfi_offset 14, -48
	.cfi_offset 15, -40
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 esi edi r11d
..B1.7:                         # Preds ..B1.39 ..B1.6
        cmpl      $6, %esi                                      #15.9
        jbe       ..B1.33       # Prob 50%                      #15.9
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 esi edi r11d
..B1.8:                         # Preds ..B1.7
        movq      %rcx, %r12                                    #15.9

###         {
###             c[i] += a[i][j] * b[j];

        lea       (%r8,%r9,4), %r15                             #17.13
        andq      $31, %r12                                     #15.9
        movl      %r12d, %ebx                                   #15.9
        movl      %r12d, %r14d                                  #15.9
        negl      %ebx                                          #15.9
        andl      $3, %r14d                                     #15.9
        addl      $32, %ebx                                     #15.9
        vxorps    %ymm0, %ymm0, %ymm0                           #17.13
        shrl      $2, %ebx                                      #15.9
        movq      %rax, -72(%rsp)                               #15.9
        movl      %edi, -64(%rsp)                               #15.9
        movq      %r13, -56(%rsp)                               #15.9
        jmp       ..B1.9        # Prob 100%                     #15.9
	.cfi_offset 13, -64
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d ymm0
..B1.30:                        # Preds ..B1.29
        lea       (%r8,%r9,4), %r15                             #13.9
        movl      %r11d, (%r15)                                 #13.9
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d ymm0
..B1.9:                         # Preds ..B1.30 ..B1.8
        cmpq      %rcx, %r15                                    #17.31
        jbe       ..B1.11       # Prob 50%                      #17.31
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d ymm0
..B1.10:                        # Preds ..B1.9
        movl      %esi, %edi                                    #9.6
        movq      %r15, %rax                                    #17.31
        shlq      $2, %rdi                                      #17.31
        subq      %rcx, %rax                                    #17.31
        cmpq      %rdi, %rax                                    #17.31
        jge       ..B1.13       # Prob 50%                      #17.31
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d ymm0
..B1.11:                        # Preds ..B1.9 ..B1.10
        cmpq      %r15, %rcx                                    #17.31
        jbe       ..B1.53       # Prob 50%                      #17.31
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d ymm0
..B1.12:                        # Preds ..B1.11
        negq      %r15                                          #17.31
        addq      %rcx, %r15                                    #17.31
        cmpq      $4, %r15                                      #17.31
        jl        ..B1.53       # Prob 50%                      #17.31
                                # LOE rdx rcx rbp r8 r9 r10 ebx esi r11d r12d r14d ymm0
..B1.13:                        # Preds ..B1.10 ..B1.12
        vmovss    (%r8,%r9,4), %xmm1                            #17.13
        cmpl      $16, %esi                                     #15.9
        jb        ..B1.43       # Prob 10%                      #15.9
                                # LOE rdx rcx rbp r8 r9 r10 ebx esi r11d r12d r14d xmm1 ymm0
..B1.14:                        # Preds ..B1.13
        movl      %r12d, %r15d                                  #15.9
        testl     %r12d, %r12d                                  #15.9
        je        ..B1.17       # Prob 50%                      #15.9
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d xmm1 ymm0
..B1.15:                        # Preds ..B1.14
        testl     %r14d, %r14d                                  #15.9
        jne       ..B1.43       # Prob 10%                      #15.9
                                # LOE rdx rcx rbp r8 r9 r10 ebx esi r11d r12d r14d xmm1 ymm0
..B1.16:                        # Preds ..B1.15
        movl      %ebx, %r15d                                   #15.9
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d xmm1 ymm0
..B1.17:                        # Preds ..B1.16 ..B1.14
        lea       16(%r15), %eax                                #15.9
        cmpl      %eax, %esi                                    #15.9
        jb        ..B1.43       # Prob 10%                      #15.9
                                # LOE rdx rcx rbp r8 r9 r10 r15 ebx esi r11d r12d r14d xmm1 ymm0
..B1.18:                        # Preds ..B1.17
        movl      %esi, %eax                                    #15.9
        xorl      %edi, %edi                                    #15.9
        subl      %r15d, %eax                                   #15.9
        andl      $15, %eax                                     #15.9
        negl      %eax                                          #15.9
        addl      %esi, %eax                                    #15.9
        movq      (%rdx,%r9,8), %r13                            #17.21
        testq     %r15, %r15                                    #15.9
        jbe       ..B1.22       # Prob 10%                      #15.9
                                # LOE rdx rcx rbp rdi r8 r9 r10 r13 r15 eax ebx esi r11d r12d r14d xmm1 ymm0
..B1.20:                        # Preds ..B1.18 ..B1.20
        vmovss    (%r13,%rdi,4), %xmm2                          #17.21
        vmulss    (%rcx,%rdi,4), %xmm2, %xmm3                   #17.31
        incq      %rdi                                          #15.9
        vaddss    %xmm3, %xmm1, %xmm1                           #17.13
        cmpq      %r15, %rdi                                    #15.9
        jb        ..B1.20       # Prob 82%                      #15.9
                                # LOE rdx rcx rbp rdi r8 r9 r10 r13 r15 eax ebx esi r11d r12d r14d xmm1 ymm0
..B1.22:                        # Preds ..B1.20 ..B1.18
        movslq    %eax, %rdi                                    #15.9
        vxorps    %xmm2, %xmm2, %xmm2                           #17.13
        vmovss    %xmm1, %xmm2, %xmm1                           #17.13
        vinsertf128 $1, %xmm2, %ymm1, %ymm2                     #17.13
        vmovaps   %ymm0, %ymm1                                  #17.13
                                # LOE rdx rcx rbp rdi r8 r9 r10 r13 r15 eax ebx esi r11d r12d r14d ymm0 ymm1 ymm2
..B1.23:                        # Preds ..B1.23 ..B1.22
        vmovups   (%r13,%r15,4), %xmm3                          #17.21
        vmovups   32(%r13,%r15,4), %xmm6                        #17.21
        vinsertf128 $1, 16(%r13,%r15,4), %ymm3, %ymm4           #17.21
        vinsertf128 $1, 48(%r13,%r15,4), %ymm6, %ymm7           #17.21
        vmulps    (%rcx,%r15,4), %ymm4, %ymm5                   #17.31
        vmulps    32(%rcx,%r15,4), %ymm7, %ymm8                 #17.31
        vaddps    %ymm5, %ymm2, %ymm2                           #17.13
        vaddps    %ymm1, %ymm8, %ymm1                           #17.13
        addq      $16, %r15                                     #15.9
        cmpq      %rdi, %r15                                    #15.9
        jb        ..B1.23       # Prob 82%                      #15.9
                                # LOE rdx rcx rbp rdi r8 r9 r10 r13 r15 eax ebx esi r11d r12d r14d ymm0 ymm1 ymm2
..B1.24:                        # Preds ..B1.23
        vaddps    %ymm1, %ymm2, %ymm1                           #17.13
        vextractf128 $1, %ymm1, %xmm2                           #17.13
        vaddps    %xmm2, %xmm1, %xmm3                           #17.13
        vmovhlps  %xmm3, %xmm3, %xmm4                           #17.13
        vaddps    %xmm4, %xmm3, %xmm5                           #17.13
        vshufps   $245, %xmm5, %xmm5, %xmm6                     #17.13
        vaddss    %xmm6, %xmm5, %xmm1                           #17.13
                                # LOE rdx rcx rbp r8 r9 r10 eax ebx esi r11d r12d r14d xmm1 ymm0
..B1.25:                        # Preds ..B1.24 ..B1.43
        movl      %r11d, %r15d                                  #15.9
        lea       1(%rax), %edi                                 #15.9
        cmpl      %edi, %esi                                    #15.9
        jb        ..B1.29       # Prob 10%                      #15.9
                                # LOE rdx rcx rbp r8 r9 r10 eax ebx esi r11d r12d r14d r15d xmm1 ymm0
..B1.26:                        # Preds ..B1.25
        movl      %esi, %edi                                    #15.9
        movq      (%rdx,%r9,8), %r13                            #17.21
        subl      %eax, %edi                                    #15.9
        movq      %r8, -16(%rsp)                                #15.9
                                # LOE rdx rcx rbp r9 r10 r13 eax ebx esi edi r11d r12d r14d r15d xmm1 ymm0
..B1.27:                        # Preds ..B1.27 ..B1.26
        lea       (%rax,%r15), %r8d                             #17.21
        incl      %r15d                                         #15.9
        movslq    %r8d, %r8                                     #17.31
        vmovss    (%r13,%r8,4), %xmm2                           #17.21
        vmulss    (%rcx,%r8,4), %xmm2, %xmm3                    #17.31
        vaddss    %xmm3, %xmm1, %xmm1                           #17.13
        cmpl      %edi, %r15d                                   #15.9
        jb        ..B1.27       # Prob 82%                      #15.9
                                # LOE rdx rcx rbp r9 r10 r13 eax ebx esi edi r11d r12d r14d r15d xmm1 ymm0
..B1.28:                        # Preds ..B1.27
        movq      -16(%rsp), %r8                                #
                                # LOE rdx rcx rbp r8 r9 r10 ebx esi r11d r12d r14d xmm1 ymm0
..B1.29:                        # Preds ..B1.28 ..B1.25
        vmovss    %xmm1, (%r8,%r9,4)                            #17.13
        incq      %r9                                           #11.5
        cmpq      %r10, %r9                                     #11.5
        jb        ..B1.30       # Prob 82%                      #11.5
        jmp       ..B1.42       # Prob 100%                     #11.5
                                # LOE rdx rcx rbp r8 r9 r10 ebx esi r11d r12d r14d ymm0
..B1.53:                        # Preds ..B1.12 ..B1.11
        movq      -72(%rsp), %rax                               #
        movl      -64(%rsp), %edi                               #
        movq      -56(%rsp), %r13                               #
	.cfi_restore 13
                                # LOE rax rdx rcx rbp rdi r8 r9 r10 r13 eax esi edi r11d r13d al ah dil r13b
..B1.33:                        # Preds ..B1.53 ..B1.7
        movl      $1, %r12d                                     #15.9
        movl      %r11d, %ebx                                   #15.9
        testl     %edi, %edi                                    #15.9
        jbe       ..B1.37       # Prob 10%                      #15.9
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 ebx esi edi r11d r12d
..B1.34:                        # Preds ..B1.33
        vmovss    (%r8,%r9,4), %xmm0                            #17.13
        movq      (%rdx,%r9,8), %r12                            #17.21
                                # LOE rax rdx rcx rbp r8 r9 r10 r12 r13 ebx esi edi r11d xmm0
..B1.35:                        # Preds ..B1.35 ..B1.34
        lea       (%rbx,%rbx), %r14d                            #17.21
        incl      %ebx                                          #15.9
        movslq    %r14d, %r14                                   #17.31
        vmovss    (%r12,%r14,4), %xmm1                          #17.21
        vmulss    (%rcx,%r14,4), %xmm1, %xmm2                   #17.31
        vaddss    %xmm2, %xmm0, %xmm3                           #17.13
        vmovss    %xmm3, (%r8,%r9,4)                            #17.13
        vmovss    4(%r12,%r14,4), %xmm0                         #17.21
        vmulss    4(%rcx,%r14,4), %xmm0, %xmm4                  #17.31
        vaddss    %xmm4, %xmm3, %xmm0                           #17.13
        vmovss    %xmm0, (%r8,%r9,4)                            #17.13
        cmpl      %edi, %ebx                                    #15.9
        jb        ..B1.35       # Prob 64%                      #15.9
                                # LOE rax rdx rcx rbp r8 r9 r10 r12 r13 ebx esi edi r11d xmm0
..B1.36:                        # Preds ..B1.35
        lea       1(%rbx,%rbx), %r12d                           #15.9
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 esi edi r11d r12d
..B1.37:                        # Preds ..B1.36 ..B1.33
        decl      %r12d                                         #15.9
        movslq    %r12d, %r12                                   #15.9
        cmpq      %rax, %r12                                    #15.9
        jae       ..B1.47       # Prob 10%                      #15.9
                                # LOE rax rdx rcx rbp r8 r9 r10 r12 r13 esi edi r11d
..B1.38:                        # Preds ..B1.37
        movq      (%rdx,%r9,8), %rbx                            #17.21
        vmovss    (%rbx,%r12,4), %xmm0                          #17.21
        vmulss    (%rcx,%r12,4), %xmm0, %xmm1                   #17.31
        vaddss    (%r8,%r9,4), %xmm1, %xmm2                     #17.13
        vmovss    %xmm2, (%r8,%r9,4)                            #17.13
        incq      %r9                                           #11.5
        cmpq      %r10, %r9                                     #11.5
        jae       ..B1.46       # Prob 18%                      #11.5
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 esi edi r11d
..B1.39:                        # Preds ..B1.47 ..B1.38
        movl      %r11d, (%r8,%r9,4)                            #13.9
        jmp       ..B1.7        # Prob 100%                     #13.9
	.cfi_offset 13, -64
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 esi edi r11d
..B1.42:                        # Preds ..B1.29                 # Infreq
        movq      -48(%rsp), %r12                               #
	.cfi_restore 12
        movq      -56(%rsp), %r13                               #
	.cfi_restore 13
        movq      -40(%rsp), %r14                               #
	.cfi_restore 14
        movq      -32(%rsp), %r15                               #
	.cfi_restore 15
        movq      -24(%rsp), %rbx                               #
	.cfi_restore 3
                                # LOE rbx rbp r12 r13 r14 r15
..B1.41:                        # Preds ..B1.4 ..B1.46 ..B1.42 ..B1.1 # Infreq

###         }
###     }
### }

        vzeroupper                                              #20.1
        ret                                                     #20.1
	.cfi_offset 3, -32
	.cfi_offset 12, -56
	.cfi_offset 13, -64
	.cfi_offset 14, -48
	.cfi_offset 15, -40
                                # LOE
..B1.43:                        # Preds ..B1.13 ..B1.15 ..B1.17 # Infreq
        movl      %r11d, %eax                                   #15.9
        jmp       ..B1.25       # Prob 100%                     #15.9
	.cfi_restore 13
                                # LOE rdx rcx rbp r8 r9 r10 eax ebx esi r11d r12d r14d xmm1 ymm0
..B1.46:                        # Preds ..B1.47 ..B1.38         # Infreq
        movq      -48(%rsp), %r12                               #
	.cfi_restore 12
        movq      -40(%rsp), %r14                               #
	.cfi_restore 14
        movq      -32(%rsp), %r15                               #
	.cfi_restore 15
        movq      -24(%rsp), %rbx                               #
	.cfi_restore 3
        jmp       ..B1.41       # Prob 100%                     #
	.cfi_offset 3, -32
	.cfi_offset 12, -56
	.cfi_offset 14, -48
	.cfi_offset 15, -40
                                # LOE rbx rbp r12 r13 r14 r15
..B1.47:                        # Preds ..B1.37                 # Infreq
        incq      %r9                                           #11.5
        cmpq      %r10, %r9                                     #11.5
        jb        ..B1.39       # Prob 82%                      #11.5
        jmp       ..B1.46       # Prob 100%                     #11.5
        .align    16,0x90
	.cfi_endproc
                                # LOE rax rdx rcx rbp r8 r9 r10 r13 esi edi r11d
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
