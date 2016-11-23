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
        movq      %rdx, %r9                                     #10.1

### 	float sum;
### 
###     for (int i = 0; i < rows; i++)

        xorl      %edx, %edx                                    #13.5
        testl     %edi, %edi                                    #13.25
        jbe       ..B1.25       # Prob 9%                       #13.25
                                # LOE rdx rcx rbx rbp r8 r9 r12 r13 r14 r15 esi edi
..B1.2:                         # Preds ..B1.1

###     {
### 		sum = 0.0f;
### 
### 		#pragma omp simd reduction(+:sum)
### 		#pragma unroll(4)
### 		#pragma vector aligned
###         for (int j = 0; j < cols; j++)

        movl      %esi, %eax                                    #20.9
        andl      $-32, %eax                                    #20.9
        movslq    %eax, %r10                                    #20.9
        movslq    %edi, %rdi                                    #13.5
        vxorps    %ymm0, %ymm0, %ymm0                           #11.2
        movq      %r10, -16(%rsp)                               #20.9
        movq      %r12, -40(%rsp)                               #20.9
        movq      %r13, -32(%rsp)                               #20.9
        movq      %r14, -24(%rsp)                               #20.9
        movq      %r15, -56(%rsp)                               #20.9
        movq      %rbx, -48(%rsp)                               #20.9
	.cfi_offset 3, -56
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -64
                                # LOE rdx rcx rbp rdi r8 r9 eax esi ymm0
..B1.3:                         # Preds ..B1.23 ..B1.2

###         {

        testl     %esi, %esi                                    #21.9
        vxorps    %xmm2, %xmm2, %xmm2                           #15.3
        jbe       ..B1.23       # Prob 50%                      #21.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi xmm2 ymm0
..B1.4:                         # Preds ..B1.3
        vmovaps   %ymm0, %ymm1                                  #11.2
        cmpl      $32, %esi                                     #20.9
        vmovaps   %ymm1, %ymm5                                  #11.2
        jb        ..B1.27       # Prob 10%                      #20.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi xmm2 ymm0 ymm1 ymm5
..B1.5:                         # Preds ..B1.4
        vmovaps   %ymm0, %ymm4                                  #11.2
        movl      %eax, %r13d                                   #20.9
        vmovaps   %ymm0, %ymm3                                  #11.2
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r13d xmm2 ymm0 ymm1 ymm3 ymm4 ymm5
..B1.7:                         # Preds ..B1.5

### 			sum += a[i][j] * b[j];

        movq      (%r9), %rbx                                   #22.11
        xorl      %r10d, %r10d                                  #20.9
        movq      -16(%rsp), %r11                               #22.11
        .align    16,0x90
                                # LOE rdx rcx rbx rbp rdi r8 r9 r10 r11 eax esi r13d xmm2 ymm0 ymm1 ymm3 ymm4 ymm5
..B1.8:                         # Preds ..B1.8 ..B1.7
        vmovups   (%rbx,%r10,4), %ymm6                          #22.11
        vmovups   32(%rbx,%r10,4), %ymm8                        #22.11
        vmovups   64(%rbx,%r10,4), %ymm10                       #22.11
        vmovups   96(%rbx,%r10,4), %ymm12                       #22.11
        vmulps    (%rcx,%r10,4), %ymm6, %ymm7                   #22.21
        vmulps    32(%rcx,%r10,4), %ymm8, %ymm9                 #22.21
        vmulps    64(%rcx,%r10,4), %ymm10, %ymm11               #22.21
        vmulps    96(%rcx,%r10,4), %ymm12, %ymm13               #22.21
        vaddps    %ymm7, %ymm1, %ymm1                           #22.4
        vaddps    %ymm5, %ymm9, %ymm5                           #22.4
        vaddps    %ymm4, %ymm11, %ymm4                          #22.4
        vaddps    %ymm3, %ymm13, %ymm3                          #22.4
        addq      $32, %r10                                     #20.9
        cmpq      %r11, %r10                                    #20.9
        jb        ..B1.8        # Prob 82%                      #20.9
                                # LOE rdx rcx rbx rbp rdi r8 r9 r10 r11 eax esi r13d xmm2 ymm0 ymm1 ymm3 ymm4 ymm5
..B1.9:                         # Preds ..B1.8
        vaddps    %ymm5, %ymm1, %ymm1                           #11.2
        vaddps    %ymm3, %ymm4, %ymm3                           #11.2
        vaddps    %ymm3, %ymm1, %ymm1                           #11.2
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r13d xmm2 ymm0 ymm1
..B1.10:                        # Preds ..B1.9 ..B1.27
        lea       1(%r13), %ebx                                 #20.9
        cmpl      %ebx, %esi                                    #20.9
        jb        ..B1.22       # Prob 50%                      #20.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r13d xmm2 ymm0 ymm1
..B1.11:                        # Preds ..B1.10
        movl      %esi, %r12d                                   #20.9
        subl      %r13d, %r12d                                  #20.9
        cmpl      $8, %r12d                                     #20.9
        jb        ..B1.26       # Prob 10%                      #20.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r12d r13d xmm2 ymm0 ymm1
..B1.12:                        # Preds ..B1.11
        movl      %r12d, %r11d                                  #20.9
        andl      $-8, %r11d                                    #20.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r11d r12d r13d xmm2 ymm0 ymm1
..B1.14:                        # Preds ..B1.12
        movslq    %r13d, %rbx                                   #22.4
        xorl      %r10d, %r10d                                  #20.9
        movq      (%r9), %r14                                   #22.11
        lea       (%r14,%rbx,4), %r15                           #22.11
        xorl      %r14d, %r14d                                  #20.9
                                # LOE rdx rcx rbx rbp rdi r8 r9 r14 r15 eax esi r10d r11d r12d r13d xmm2 ymm0 ymm1
..B1.15:                        # Preds ..B1.15 ..B1.14
        vmovups   (%r14,%r15), %ymm3                            #22.11
        addl      $8, %r10d                                     #20.9
        vmulps    (%rcx,%rbx,4), %ymm3, %ymm4                   #22.21
        addq      $8, %rbx                                      #20.9
        addq      $32, %r14                                     #20.9
        vaddps    %ymm4, %ymm1, %ymm1                           #22.4
        cmpl      %r11d, %r10d                                  #20.9
        jb        ..B1.15       # Prob 82%                      #20.9
                                # LOE rdx rcx rbx rbp rdi r8 r9 r14 r15 eax esi r10d r11d r12d r13d xmm2 ymm0 ymm1
..B1.18:                        # Preds ..B1.15 ..B1.26
        cmpl      %r12d, %r11d                                  #20.9
        jae       ..B1.22       # Prob 10%                      #20.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r11d r12d r13d xmm2 ymm0 ymm1
..B1.19:                        # Preds ..B1.18
        movq      (%r9), %rbx                                   #22.11
                                # LOE rdx rcx rbx rbp rdi r8 r9 eax esi r11d r12d r13d xmm2 ymm0 ymm1
..B1.20:                        # Preds ..B1.20 ..B1.19
        lea       (%r13,%r11), %r10d                            #22.11
        incl      %r11d                                         #20.9
        movslq    %r10d, %r10                                   #22.21
        vmovss    (%rbx,%r10,4), %xmm3                          #22.11
        vmulss    (%rcx,%r10,4), %xmm3, %xmm4                   #22.21
        vaddss    %xmm4, %xmm2, %xmm2                           #22.4
        cmpl      %r12d, %r11d                                  #20.9
        jb        ..B1.20       # Prob 82%                      #20.9
                                # LOE rdx rcx rbx rbp rdi r8 r9 eax esi r11d r12d r13d xmm2 ymm0 ymm1
..B1.22:                        # Preds ..B1.20 ..B1.18 ..B1.10
        vextractf128 $1, %ymm1, %xmm3                           #11.2
        vaddps    %xmm3, %xmm1, %xmm4                           #11.2
        vmovhlps  %xmm4, %xmm4, %xmm5                           #11.2
        vaddps    %xmm5, %xmm4, %xmm6                           #11.2
        vshufps   $245, %xmm6, %xmm6, %xmm7                     #11.2
        vaddss    %xmm7, %xmm6, %xmm8                           #11.2
        vaddss    %xmm2, %xmm8, %xmm2                           #11.2
                                # LOE rdx rcx rbp rdi r8 r9 eax esi xmm2 ymm0
..B1.23:                        # Preds ..B1.22 ..B1.3

###         }
### 		
### 		c[i] = sum;

        vmovss    %xmm2, (%r8,%rdx,4)                           #25.3
        incq      %rdx                                          #13.5
        addq      $8, %r9                                       #13.5
        cmpq      %rdi, %rdx                                    #13.5
        jb        ..B1.3        # Prob 82%                      #13.5
                                # LOE rdx rcx rbp rdi r8 r9 eax esi ymm0
..B1.24:                        # Preds ..B1.23
        movq      -40(%rsp), %r12                               #
	.cfi_restore 12
        movq      -32(%rsp), %r13                               #
	.cfi_restore 13
        movq      -24(%rsp), %r14                               #
	.cfi_restore 14
        movq      -56(%rsp), %r15                               #
	.cfi_restore 15
        movq      -48(%rsp), %rbx                               #
	.cfi_restore 3
                                # LOE rbx rbp r12 r13 r14 r15
..B1.25:                        # Preds ..B1.1 ..B1.24

###     }
### }

        vzeroupper                                              #27.1
        ret                                                     #27.1
	.cfi_offset 3, -56
	.cfi_offset 12, -48
	.cfi_offset 13, -40
	.cfi_offset 14, -32
	.cfi_offset 15, -64
                                # LOE
..B1.26:                        # Preds ..B1.11                 # Infreq
        xorl      %r11d, %r11d                                  #20.9
        jmp       ..B1.18       # Prob 100%                     #20.9
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r11d r12d r13d xmm2 ymm0 ymm1
..B1.27:                        # Preds ..B1.4                  # Infreq
        xorl      %r13d, %r13d                                  #20.9
        jmp       ..B1.10       # Prob 100%                     #20.9
        .align    16,0x90
	.cfi_endproc
                                # LOE rdx rcx rbp rdi r8 r9 eax esi r13d xmm2 ymm0 ymm1
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
