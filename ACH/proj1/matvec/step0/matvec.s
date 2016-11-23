# mark_description "Intel(R) C++ Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 16.0.1.150 Build 20151021";
# mark_description "";
# mark_description "-lpapi -ansi-alias -O0 -S -fsource-asm -c";
	.file "matvec.cpp"
	.text
..TXTST0:
# -- Begin  _Z11mat_vec_muljjPPfS_S_
	.text
# mark_begin;

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
        pushq     %rbp                                          #10.1
	.cfi_def_cfa_offset 16
        movq      %rsp, %rbp                                    #10.1
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
        subq      $48, %rsp                                     #10.1
        movl      %edi, -40(%rbp)                               #10.1
        movl      %esi, -32(%rbp)                               #10.1
        movq      %rdx, -24(%rbp)                               #10.1
        movq      %rcx, -16(%rbp)                               #10.1
        movq      %r8, -8(%rbp)                                 #10.1

###     for (int i = 0; i < rows; i++)

        movl      $0, -48(%rbp)                                 #11.16
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.2:                         # Preds ..B1.3 ..B1.1
        movl      -48(%rbp), %eax                               #11.21
        movl      -40(%rbp), %edx                               #11.25
        cmpl      %edx, %eax                                    #11.25
        jb        ..B1.4        # Prob 50%                      #11.25
        jmp       ..B1.9        # Prob 100%                     #11.25
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.3:                         # Preds ..B1.7
        movl      $1, %eax                                      #11.31
        addl      -48(%rbp), %eax                               #11.31
        movl      %eax, -48(%rbp)                               #11.31
        jmp       ..B1.2        # Prob 100%                     #11.31
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.4:                         # Preds ..B1.2

###     {
###         c[i] = 0.0f;

        pxor      %xmm0, %xmm0                                  #13.9
        movl      -48(%rbp), %eax                               #13.11
        movslq    %eax, %rax                                    #13.9
        imulq     $4, %rax, %rax                                #13.9
        addq      -8(%rbp), %rax                                #13.9
        movss     %xmm0, (%rax)                                 #13.9
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.5:                         # Preds ..B1.4
..B1.6:                         # Preds ..B1.5

### 
###         #pragma nounroll
###         for (int j = 0; j < cols; j++)

        movl      $0, -44(%rbp)                                 #16.20
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.7:                         # Preds ..B1.8 ..B1.6
        movl      -44(%rbp), %eax                               #16.25
        movl      -32(%rbp), %edx                               #16.29
        cmpl      %edx, %eax                                    #16.29
        jae       ..B1.3        # Prob 50%                      #16.29
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.8:                         # Preds ..B1.7

###         {
###             c[i] += a[i][j] * b[j];

        movl      -48(%rbp), %eax                               #18.15
        movslq    %eax, %rax                                    #18.13
        imulq     $4, %rax, %rax                                #18.13
        addq      -8(%rbp), %rax                                #18.13
        movl      -48(%rbp), %edx                               #18.23
        movslq    %edx, %rdx                                    #18.21
        imulq     $8, %rdx, %rdx                                #18.21
        addq      -24(%rbp), %rdx                               #18.21
        movl      -44(%rbp), %ecx                               #18.26
        movslq    %ecx, %rcx                                    #18.21
        imulq     $4, %rcx, %rcx                                #18.21
        addq      (%rdx), %rcx                                  #18.21
        movss     (%rcx), %xmm0                                 #18.21
        movl      -44(%rbp), %edx                               #18.33
        movslq    %edx, %rdx                                    #18.31
        imulq     $4, %rdx, %rdx                                #18.31
        addq      -16(%rbp), %rdx                               #18.31
        movss     (%rdx), %xmm1                                 #18.31
        mulss     %xmm1, %xmm0                                  #18.31
        movss     (%rax), %xmm1                                 #18.13
        addss     %xmm0, %xmm1                                  #18.13
        movl      -48(%rbp), %eax                               #18.15
        movslq    %eax, %rax                                    #18.13
        imulq     $4, %rax, %rax                                #18.13
        addq      -8(%rbp), %rax                                #18.13
        movss     %xmm1, (%rax)                                 #18.13
        movl      $1, %eax                                      #16.35
        addl      -44(%rbp), %eax                               #16.35
        movl      %eax, -44(%rbp)                               #16.35
        jmp       ..B1.7        # Prob 100%                     #16.35
                                # LOE rbx rbp rsp r12 r13 r14 r15 rip
..B1.9:                         # Preds ..B1.2

###         }
###     }
### }

        leave                                                   #21.1
	.cfi_restore 6
        ret                                                     #21.1
	.cfi_endproc
                                # LOE
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
