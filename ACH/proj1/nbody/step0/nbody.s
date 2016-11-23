# mark_description "Intel(R) C++ Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 16.0.1.150 Build 20151021";
# mark_description "";
# mark_description "-lpapi -ansi-alias -O2 -xavx -DN=1000 -DDT=0.001f -DSTEPS=1000 -S -fsource-asm -c";
	.file "nbody.cpp"
	.text
..TXTST0:
# -- Begin  _Z18particles_simulateP10t_particle
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z18particles_simulateP10t_particle
# --- particles_simulate(t_particle *)
_Z18particles_simulateP10t_particle:
# parameter 1: %rdi
..B1.1:                         # Preds ..B1.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z18particles_simulateP10t_particle.1:
..L2:
                                                          #12.1
        pushq     %rbx                                          #12.1
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
        pushq     %rbp                                          #12.1
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24

### 	float dx, dy, dz;
### 	float fx,fy,fz;
### 	float GDT = G * DT;
### 	float EPS = 3E4;
### 	for (int step = 0; step < STEPS; step++) {

        xorl      %r8d, %r8d                                    #17.2

### 		for (int i = 0; i < N; i++) {
### 			fx = fy = fz = 0.0f;
### 
### 			for (int j = 0; j < N; j++) {
### 				if (i != j) {
### 					// Calculate distance between two points in each axis
### 					dx = p[j].pos_x - p[i].pos_x;
### 					dy = p[j].pos_y - p[i].pos_y;
### 					dz = p[j].pos_z - p[i].pos_z;
### 
### 					// Calculate vector distance between two points
### 					float R = sqrt(dx*dx + dy*dy + dz*dz);
### 
### 					// Calculate force
### 					float F = (GDT * p[j].weight) / (R * R * R);
### 					p[i].vel_x += F * dx;
### 					p[i].vel_y += F * dy;
### 					p[i].vel_z += F * dz;
### 				}
### 			}
### 			p[i].pos_x += p[i].vel_x * DT;

        vmovss    .L_2il0floatpacket.0(%rip), %xmm1             #38.31
        movq      %rdi, %r9                                     #12.1
        vmovss    .L_2il0floatpacket.1(%rip), %xmm0             #15.12
        xorl      %edi, %edi                                    #17.2
        xorl      %esi, %esi                                    #15.12
                                # LOE rsi r9 r12 r13 r14 r15 edi r8d xmm0 xmm1
..B1.2:                         # Preds ..B1.12 ..B1.1
        movl      %edi, %ebp                                    #18.3
        movq      %rsi, %rcx                                    #18.3
                                # LOE rcx rsi r9 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1
..B1.3:                         # Preds ..B1.11 ..B1.2
        movq      %rsi, %r10                                    #21.4
        lea       1(%rbp), %ebx                                 #38.4
        movq      %r10, %rdx                                    #21.4
        testl     %ebp, %ebp                                    #21.4
        jle       ..B1.7        # Prob 0%                       #21.4
                                # LOE rdx rcx rbx rsi r9 r10 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1
..B1.4:                         # Preds ..B1.3
        movl      %ebp, %eax                                    #21.4
        vmovss    20(%rcx,%r9), %xmm5                           #35.6
        vmovss    16(%rcx,%r9), %xmm10                          #34.6
        vmovss    12(%rcx,%r9), %xmm7                           #33.6
        vmovss    8(%rcx,%r9), %xmm6                            #26.24
        vmovss    4(%rcx,%r9), %xmm8                            #25.24
        vmovss    (%rcx,%r9), %xmm9                             #24.24
        .align    16,0x90
                                # LOE rax rdx rcx rbx rsi r9 r10 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1 xmm5 xmm6 xmm7 xmm8 xmm9 xmm10
..B1.5:                         # Preds ..B1.5 ..B1.4
        vmovss    (%rdx,%r9), %xmm11                            #24.11
        incq      %r10                                          #21.4
        vmovss    4(%rdx,%r9), %xmm12                           #25.11
        vsubss    %xmm9, %xmm11, %xmm4                          #24.24
        vsubss    %xmm8, %xmm12, %xmm3                          #25.24
        vmulss    %xmm4, %xmm4, %xmm14                          #29.24
        vmulss    %xmm3, %xmm3, %xmm15                          #29.32
        vmovss    8(%rdx,%r9), %xmm13                           #26.11
        vaddss    %xmm15, %xmm14, %xmm11                        #29.32
        vsubss    %xmm6, %xmm13, %xmm2                          #26.24
        vmulss    24(%rdx,%r9), %xmm0, %xmm15                   #32.23
        vmulss    %xmm2, %xmm2, %xmm12                          #29.40
        addq      $28, %rdx                                     #21.4
        vaddss    %xmm12, %xmm11, %xmm13                        #29.40
        vsqrtss   %xmm13, %xmm13, %xmm14                        #29.16
        vmulss    %xmm14, %xmm13, %xmm11                        #32.47
        vdivss    %xmm11, %xmm15, %xmm12                        #32.47
        vmulss    %xmm12, %xmm4, %xmm4                          #33.24
        vmulss    %xmm12, %xmm3, %xmm3                          #34.24
        vmulss    %xmm12, %xmm2, %xmm2                          #35.24
        vaddss    %xmm4, %xmm7, %xmm7                           #33.6
        vaddss    %xmm3, %xmm10, %xmm10                         #34.6
        vaddss    %xmm2, %xmm5, %xmm5                           #35.6
        cmpq      %rax, %r10                                    #21.4
        jb        ..B1.5        # Prob 99%                      #21.4
                                # LOE rax rdx rcx rbx rsi r9 r10 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1 xmm5 xmm6 xmm7 xmm8 xmm9 xmm10
..B1.6:                         # Preds ..B1.5
        vmovss    %xmm5, 20(%rcx,%r9)                           #35.6
        vmovss    %xmm10, 16(%rcx,%r9)                          #34.6
        vmovss    %xmm7, 12(%rcx,%r9)                           #33.6
                                # LOE rcx rbx rsi r9 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1
..B1.7:                         # Preds ..B1.3 ..B1.6
        movq      %rsi, %rdx                                    #21.4
        lea       2(%rbp), %r10d                                #21.4
        movq      %rdx, %rax                                    #21.4
        cmpl      $1000, %r10d                                  #21.4
        ja        ..B1.11       # Prob 0%                       #21.4
                                # LOE rax rdx rcx rbx rsi r9 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1
..B1.8:                         # Preds ..B1.7
        movq      %rbx, %r10                                    #24.11
        shlq      $5, %r10                                      #24.11
        vmovss    20(%rcx,%r9), %xmm5                           #35.6
        vmovss    16(%rcx,%r9), %xmm10                          #34.6
        lea       (,%rbx,4), %r11                               #24.11
        subq      %r11, %r10                                    #24.11
        negq      %rbx                                          #21.15
        vmovss    12(%rcx,%r9), %xmm7                           #33.6
        addq      %r9, %r10                                     #24.11
        vmovss    8(%rcx,%r9), %xmm6                            #26.24
        addq      $1000, %rbx                                   #21.15
        vmovss    4(%rcx,%r9), %xmm8                            #25.24
        vmovss    (%rcx,%r9), %xmm9                             #24.24
        .align    16,0x90
                                # LOE rax rdx rcx rbx rsi r9 r10 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1 xmm5 xmm6 xmm7 xmm8 xmm9 xmm10
..B1.9:                         # Preds ..B1.9 ..B1.8
        vmovss    (%rax,%r10), %xmm11                           #24.11
        incq      %rdx                                          #21.4
        vmovss    4(%rax,%r10), %xmm12                          #25.11
        vsubss    %xmm9, %xmm11, %xmm4                          #24.24
        vsubss    %xmm8, %xmm12, %xmm3                          #25.24
        vmulss    %xmm4, %xmm4, %xmm14                          #29.24
        vmulss    %xmm3, %xmm3, %xmm15                          #29.32
        vmovss    8(%rax,%r10), %xmm13                          #26.11
        vaddss    %xmm15, %xmm14, %xmm11                        #29.32
        vsubss    %xmm6, %xmm13, %xmm2                          #26.24
        vmulss    24(%rax,%r10), %xmm0, %xmm15                  #32.23
        vmulss    %xmm2, %xmm2, %xmm12                          #29.40
        addq      $28, %rax                                     #21.4
        vaddss    %xmm12, %xmm11, %xmm13                        #29.40
        vsqrtss   %xmm13, %xmm13, %xmm14                        #29.16
        vmulss    %xmm14, %xmm13, %xmm11                        #32.47
        vdivss    %xmm11, %xmm15, %xmm12                        #32.47
        vmulss    %xmm12, %xmm4, %xmm4                          #33.24
        vmulss    %xmm12, %xmm3, %xmm3                          #34.24
        vmulss    %xmm12, %xmm2, %xmm2                          #35.24
        vaddss    %xmm4, %xmm7, %xmm7                           #33.6
        vaddss    %xmm3, %xmm10, %xmm10                         #34.6
        vaddss    %xmm2, %xmm5, %xmm5                           #35.6
        cmpq      %rbx, %rdx                                    #21.4
        jb        ..B1.9        # Prob 99%                      #21.4
                                # LOE rax rdx rcx rbx rsi r9 r10 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1 xmm5 xmm6 xmm7 xmm8 xmm9 xmm10
..B1.10:                        # Preds ..B1.9
        vmovss    %xmm5, 20(%rcx,%r9)                           #35.6
        vmovss    %xmm10, 16(%rcx,%r9)                          #34.6
        vmovss    %xmm7, 12(%rcx,%r9)                           #33.6
                                # LOE rcx rsi r9 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1
..B1.11:                        # Preds ..B1.7 ..B1.10
        vmulss    12(%r9,%rcx), %xmm1, %xmm2                    #38.31
        incl      %ebp                                          #18.3

### 			p[i].pos_y += p[i].vel_y * DT;

        vmulss    16(%r9,%rcx), %xmm1, %xmm4                    #39.31

### 			p[i].pos_z += p[i].vel_z * DT;

        vmulss    20(%r9,%rcx), %xmm1, %xmm6                    #40.31
        vaddss    (%r9,%rcx), %xmm2, %xmm3                      #38.4
        vaddss    4(%r9,%rcx), %xmm4, %xmm5                     #39.4
        vaddss    8(%r9,%rcx), %xmm6, %xmm7                     #40.4
        vmovss    %xmm3, (%r9,%rcx)                             #38.4
        vmovss    %xmm5, 4(%r9,%rcx)                            #39.4
        vmovss    %xmm7, 8(%r9,%rcx)                            #40.4
        addq      $28, %rcx                                     #18.3
        cmpl      $1000, %ebp                                   #18.3
        jb        ..B1.3        # Prob 99%                      #18.3
                                # LOE rcx rsi r9 r12 r13 r14 r15 ebp edi r8d xmm0 xmm1
..B1.12:                        # Preds ..B1.11
        .byte     15                                            #17.2
        .byte     31                                            #17.2
        .byte     64                                            #17.2
        .byte     0                                             #17.2
        incl      %r8d                                          #17.2
        cmpl      $1000, %r8d                                   #17.2
        jb        ..B1.2        # Prob 99%                      #17.2
                                # LOE rsi r9 r12 r13 r14 r15 edi r8d xmm0 xmm1
..B1.13:                        # Preds ..B1.12

### 		}
### 	}
### 
### }

	.cfi_restore 6
        popq      %rbp                                          #44.1
	.cfi_def_cfa_offset 16
	.cfi_restore 3
        popq      %rbx                                          #44.1
	.cfi_def_cfa_offset 8
        ret                                                     #44.1
        .align    16,0x90
	.cfi_endproc
                                # LOE
# mark_end;
	.type	_Z18particles_simulateP10t_particle,@function
	.size	_Z18particles_simulateP10t_particle,.-_Z18particles_simulateP10t_particle
	.data
# -- End  _Z18particles_simulateP10t_particle
	.text
# -- Begin  _Z14particles_readP8_IO_FILEP10t_particle
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z14particles_readP8_IO_FILEP10t_particle
# --- particles_read(FILE *, t_particle *)
_Z14particles_readP8_IO_FILEP10t_particle:
# parameter 1: %rdi
# parameter 2: %rsi
..B2.1:                         # Preds ..B2.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z14particles_readP8_IO_FILEP10t_particle.12:
..L13:
                                                         #47.1
        pushq     %r12                                          #47.1
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
        pushq     %r13                                          #47.1
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
        pushq     %r14                                          #47.1
	.cfi_def_cfa_offset 32
	.cfi_offset 14, -32

###     for (int i = 0; i < N; i++)

        xorl      %eax, %eax                                    #48.16
        movl      %eax, %r12d                                   #48.16
        movq      %rsi, %r14                                    #48.16
        movq      %rdi, %r13                                    #48.16
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.2:                         # Preds ..B2.3 ..B2.1

###     {
###         fscanf(fp, "%f %f %f %f %f %f %f \n",

        addq      $-32, %rsp                                    #50.9
	.cfi_def_cfa_offset 64
        lea       4(%r14), %rcx                                 #50.9
        movq      %r13, %rdi                                    #50.9
        lea       8(%r14), %r8                                  #50.9
        movl      $.L_2__STRING.0, %esi                         #50.9
        lea       12(%r14), %r9                                 #50.9
        movq      %r14, %rdx                                    #50.9
        xorl      %eax, %eax                                    #50.9
        lea       16(%r14), %r10                                #50.9
        movq      %r10, (%rsp)                                  #50.9
        lea       20(%r14), %r11                                #50.9
        movq      %r11, 8(%rsp)                                 #50.9
        lea       24(%r14), %r10                                #50.9
        movq      %r10, 16(%rsp)                                #50.9
#       fscanf(FILE *, const char *, ...)
        call      fscanf                                        #50.9
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.7:                         # Preds ..B2.2
        addq      $32, %rsp                                     #50.9
	.cfi_def_cfa_offset 32
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.3:                         # Preds ..B2.7
        incl      %r12d                                         #48.28
        addq      $28, %r14                                     #48.28
        cmpl      $1000, %r12d                                  #48.25
        jl        ..B2.2        # Prob 99%                      #48.25
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.4:                         # Preds ..B2.3

###             &p[i].pos_x, &p[i].pos_y, &p[i].pos_z,
###             &p[i].vel_x, &p[i].vel_y, &p[i].vel_z,
###             &p[i].weight);
###     }
### }

	.cfi_restore 14
        popq      %r14                                          #55.1
	.cfi_def_cfa_offset 24
	.cfi_restore 13
        popq      %r13                                          #55.1
	.cfi_def_cfa_offset 16
	.cfi_restore 12
        popq      %r12                                          #55.1
	.cfi_def_cfa_offset 8
        ret                                                     #55.1
        .align    16,0x90
	.cfi_endproc
                                # LOE
# mark_end;
	.type	_Z14particles_readP8_IO_FILEP10t_particle,@function
	.size	_Z14particles_readP8_IO_FILEP10t_particle,.-_Z14particles_readP8_IO_FILEP10t_particle
	.data
# -- End  _Z14particles_readP8_IO_FILEP10t_particle
	.text
# -- Begin  _Z15particles_writeP8_IO_FILEP10t_particle
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z15particles_writeP8_IO_FILEP10t_particle
# --- particles_write(FILE *, t_particle *)
_Z15particles_writeP8_IO_FILEP10t_particle:
# parameter 1: %rdi
# parameter 2: %rsi
..B3.1:                         # Preds ..B3.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z15particles_writeP8_IO_FILEP10t_particle.29:
..L30:
                                                         #58.1
        pushq     %r12                                          #58.1
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
        pushq     %r13                                          #58.1
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
        pushq     %r14                                          #58.1
	.cfi_def_cfa_offset 32
	.cfi_offset 14, -32
        pushq     %r15                                          #58.1
	.cfi_def_cfa_offset 40
	.cfi_offset 15, -40
        pushq     %rsi                                          #58.1
	.cfi_def_cfa_offset 48

###     for (int i = 0; i < N; i++)

        xorl      %edx, %edx                                    #59.16
        xorl      %eax, %eax                                    #59.16
        movl      %edx, %r13d                                   #59.16
        movq      %rax, %r12                                    #59.16
        movq      %rsi, %r15                                    #59.16
        movq      %rdi, %r14                                    #59.16
                                # LOE rbx rbp r12 r14 r15 r13d
..B3.2:                         # Preds ..B3.3 ..B3.1

###     {
###         fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",

        vxorpd    %xmm0, %xmm0, %xmm0                           #61.9
        vxorpd    %xmm1, %xmm1, %xmm1                           #61.9
        vxorpd    %xmm2, %xmm2, %xmm2                           #61.9
        vxorpd    %xmm3, %xmm3, %xmm3                           #61.9
        vxorpd    %xmm4, %xmm4, %xmm4                           #61.9
        vxorpd    %xmm5, %xmm5, %xmm5                           #61.9
        vxorpd    %xmm6, %xmm6, %xmm6                           #61.9
        movq      %r14, %rdi                                    #61.9
        vcvtss2sd (%r12,%r15), %xmm0, %xmm0                     #61.9
        vcvtss2sd 4(%r12,%r15), %xmm1, %xmm1                    #61.9
        vcvtss2sd 8(%r12,%r15), %xmm2, %xmm2                    #61.9
        vcvtss2sd 12(%r12,%r15), %xmm3, %xmm3                   #61.9
        vcvtss2sd 16(%r12,%r15), %xmm4, %xmm4                   #61.9
        vcvtss2sd 20(%r12,%r15), %xmm5, %xmm5                   #61.9
        vcvtss2sd 24(%r12,%r15), %xmm6, %xmm6                   #61.9
        movl      $.L_2__STRING.1, %esi                         #61.9
        movl      $7, %eax                                      #61.9
#       fprintf(FILE *, const char *, ...)
        call      fprintf                                       #61.9
                                # LOE rbx rbp r12 r14 r15 r13d
..B3.3:                         # Preds ..B3.2
        incl      %r13d                                         #59.28
        addq      $28, %r12                                     #59.28
        cmpl      $1000, %r13d                                  #59.25
        jl        ..B3.2        # Prob 99%                      #59.25
                                # LOE rbx rbp r12 r14 r15 r13d
..B3.4:                         # Preds ..B3.3

###             p[i].pos_x, p[i].pos_y, p[i].pos_z,
###             p[i].vel_x, p[i].vel_y, p[i].vel_z,
###             p[i].weight);
###     }
### }

        popq      %rcx                                          #66.1
	.cfi_def_cfa_offset 40
	.cfi_restore 15
        popq      %r15                                          #66.1
	.cfi_def_cfa_offset 32
	.cfi_restore 14
        popq      %r14                                          #66.1
	.cfi_def_cfa_offset 24
	.cfi_restore 13
        popq      %r13                                          #66.1
	.cfi_def_cfa_offset 16
	.cfi_restore 12
        popq      %r12                                          #66.1
	.cfi_def_cfa_offset 8
        ret                                                     #66.1
        .align    16,0x90
	.cfi_endproc
                                # LOE
# mark_end;
	.type	_Z15particles_writeP8_IO_FILEP10t_particle,@function
	.size	_Z15particles_writeP8_IO_FILEP10t_particle,.-_Z15particles_writeP8_IO_FILEP10t_particle
	.data
# -- End  _Z15particles_writeP8_IO_FILEP10t_particle
	.section .rodata, "a"
	.align 4
	.align 4
.L_2il0floatpacket.0:
	.long	0x3a83126f
	.type	.L_2il0floatpacket.0,@object
	.size	.L_2il0floatpacket.0,4
	.align 4
.L_2il0floatpacket.1:
	.long	0x29964812
	.type	.L_2il0floatpacket.1,@object
	.size	.L_2il0floatpacket.1,4
	.section .rodata.str1.4, "aMS",@progbits,1
	.align 4
	.align 4
.L_2__STRING.0:
	.long	622880293
	.long	1713709158
	.long	543565088
	.long	622880293
	.long	1713709158
	.word	2592
	.byte	0
	.type	.L_2__STRING.0,@object
	.size	.L_2__STRING.0,23
	.space 1, 0x00 	# pad
	.align 4
.L_2__STRING.1:
	.long	774910245
	.long	543567921
	.long	774910245
	.long	543567921
	.long	774910245
	.long	543567921
	.long	774910245
	.long	543567921
	.long	774910245
	.long	543567921
	.long	774910245
	.long	543567921
	.long	774910245
	.long	543567921
	.word	10
	.type	.L_2__STRING.1,@object
	.size	.L_2__STRING.1,58
	.data
	.section .note.GNU-stack, ""
// -- Begin DWARF2 SEGMENT .eh_frame
	.section .eh_frame,"a",@progbits
.eh_frame_seg:
	.align 8
# End
