# mark_description "Intel(R) C++ Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 16.0.1.150 Build 20151021";
# mark_description "";
# mark_description "-lpapi -ansi-alias -O2 -xavx -qopenmp-simd -DN=1000 -DDT=0.001f -DSTEPS=1000 -S -fsource-asm -c";
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

### 	float dx, dy, dz;
### 	float vel_x, vel_y, vel_z;
### 	float pos_x, pos_y, pos_z;
### 	float F, R;
### 	const float GDT = G * DT;
### 
### 	for (int step = 0; step < STEPS; step++) {
### 		#pragma omp simd reduction(+:pos_x,pos_y,pos_z) 
### 		#pragma vector aligned
### 		for (int i = 0; i < N; i++) {
### 			vel_x = p[i].vel_x;
### 			vel_y = p[i].vel_y;
### 			vel_z = p[i].vel_z;
### 
### 			pos_x = p[i].pos_x;
### 			pos_y = p[i].pos_y;
### 			pos_z = p[i].pos_z;
### 
### 			#pragma omp simd reduction(+:vel_x,vel_y,vel_z)
### 			#pragma vector aligned
### 			for (int j = 0; j < N; j++) {
### 				if (i == j) {
### 					continue;
### 				}
### 				// Calculate distance between two points in each axis
### 				dx = p[j].pos_x - pos_x;
### 				dy = p[j].pos_y - pos_y;
### 				dz = p[j].pos_z - pos_z;
### 
### 				// Calculate vector distance between two points
### 				R = sqrtf(dx*dx + dy*dy + dz*dz);
### 
### 				// Calculate force
### 				F = (GDT * p[j].weight) / (R * R * R);
### 				vel_x += F * dx;
### 				vel_y += F * dy;
### 				vel_z += F * dz;
### 			}
### 
### 			p[i].vel_x = vel_x;

        movl      $8, %eax                                      #52.4
        xorl      %edx, %edx                                    #19.2
        vmovdqu   .L_2il0floatpacket.0(%rip), %xmm3             #52.4
        vmovdqu   .L_2il0floatpacket.1(%rip), %xmm2             #52.4
        xorl      %r10d, %r10d                                  #19.2
        vmovd     %eax, %xmm0                                   #52.4
        xorl      %eax, %eax                                    #52.4
        vpshufd   $0, %xmm0, %xmm0                              #52.4

### 			p[i].vel_y = vel_y;
### 			p[i].vel_z = vel_z;
### 
### 			pos_x += vel_x * DT;

        vmovups   .L_2il0floatpacket.4(%rip), %ymm1             #56.21
        vmovss    .L_2il0floatpacket.5(%rip), %xmm9             #46.10
                                # LOE rax rbx rbp rdi r12 r13 r14 r15 edx r10d xmm0 xmm2 xmm3 xmm9 ymm1
..B1.2:                         # Preds ..B1.8 ..B1.1
        vmovdqa   %xmm3, %xmm12                                 #52.4
        vmovdqa   %xmm2, %xmm13                                 #52.4
        movq      %rax, %r8                                     #22.14
                                # LOE rax rbx rbp rdi r8 r12 r13 r14 r15 edx r10d xmm0 xmm9 xmm12 xmm13 ymm1
..B1.3:                         # Preds ..B1.7 ..B1.2
        movq      %r8, %r9                                      #23.12
        lea       (,%r8,4), %rcx                                #23.12
        shlq      $5, %r9                                       #23.12
        movl      %r10d, %esi                                   #33.15
        subq      %rcx, %r9                                     #23.12
        movq      %rax, %rcx                                    #33.15
        vmovdqu   %xmm0, -24(%rsp)                              #33.15
        lea       20(%rdi,%r9), %r11                            #23.12
        vmovss    (%r11), %xmm10                                #23.12
        vmovss    112(%r11), %xmm8                              #23.12
        vinsertps $16, 28(%r11), %xmm10, %xmm11                 #23.12
        vinsertps $80, 160(%rdi,%r9), %xmm8, %xmm7              #23.12
        vinsertps $32, 56(%r11), %xmm11, %xmm14                 #23.12
        vinsertps $96, 188(%rdi,%r9), %xmm7, %xmm2              #23.12
        vinsertps $48, 84(%r11), %xmm14, %xmm3                  #23.12
        vmovss    -4(%r11), %xmm5                               #23.12
        vinsertps $112, 216(%rdi,%r9), %xmm2, %xmm4             #23.12
        vmovss    108(%r11), %xmm11                             #23.12
        vinsertps $16, 24(%r11), %xmm5, %xmm6                   #23.12
        vinsertps $80, 156(%rdi,%r9), %xmm11, %xmm14            #23.12
        vinsertps $32, 52(%r11), %xmm6, %xmm15                  #23.12
        vinsertps $96, 184(%rdi,%r9), %xmm14, %xmm8             #23.12
        vinsertps $48, 80(%r11), %xmm15, %xmm7                  #23.12
        vmovss    104(%r11), %xmm6                              #23.12
        vinsertps $112, 212(%rdi,%r9), %xmm8, %xmm2             #23.12
        vinsertps $80, 152(%rdi,%r9), %xmm6, %xmm15             #23.12
        vinsertps $96, 180(%rdi,%r9), %xmm15, %xmm14            #23.12
        vinsertf128 $1, %xmm4, %ymm3, %ymm10                    #23.12
        vmovss    -8(%r11), %xmm3                               #23.12
        vinsertps $16, 20(%r11), %xmm3, %xmm4                   #23.12
        vinsertps $32, 48(%r11), %xmm4, %xmm5                   #23.12
        vinsertps $48, 76(%r11), %xmm5, %xmm8                   #23.12
        vmovss    100(%r11), %xmm5                              #23.12
        vinsertps $80, 148(%rdi,%r9), %xmm5, %xmm6              #23.12
        vmovss    96(%r11), %xmm5                               #23.12
        vinsertps $96, 176(%rdi,%r9), %xmm6, %xmm15             #23.12
        vinsertps $80, 124(%r11), %xmm5, %xmm6                  #23.12
        vinsertf128 $1, %xmm2, %ymm7, %ymm11                    #23.12
        vmovss    -12(%r11), %xmm2                              #23.12
        vinsertps $16, 16(%r11), %xmm2, %xmm3                   #23.12
        vmovss    -16(%r11), %xmm2                              #23.12
        vinsertps $32, 44(%r11), %xmm3, %xmm4                   #23.12
        vinsertps $112, 208(%rdi,%r9), %xmm14, %xmm7            #23.12
        vinsertps $16, 12(%r11), %xmm2, %xmm3                   #23.12
        vinsertf128 $1, %xmm7, %ymm8, %ymm14                    #23.12
        vinsertps $48, 72(%r11), %xmm4, %xmm8                   #23.12
        vinsertps $32, 40(%r11), %xmm3, %xmm4                   #23.12
        vinsertps $112, 204(%rdi,%r9), %xmm15, %xmm7            #23.12
        vinsertps $96, 172(%rdi,%r9), %xmm6, %xmm15             #23.12
        vmovss    -20(%r11), %xmm3                              #23.12
        vmovss    92(%r11), %xmm6                               #23.12
        vinsertps $112, 200(%rdi,%r9), %xmm15, %xmm2            #23.12
        vinsertps $80, 120(%r11), %xmm6, %xmm15                 #23.12
        vinsertps $96, 168(%rdi,%r9), %xmm15, %xmm6             #23.12
        vinsertf128 $1, %xmm7, %ymm8, %ymm8                     #23.12
        vinsertps $48, 68(%r11), %xmm4, %xmm7                   #23.12
        vinsertps $16, 8(%r11), %xmm3, %xmm4                    #23.12
        vinsertps $32, 36(%r11), %xmm4, %xmm5                   #23.12
        vinsertps $112, 196(%rdi,%r9), %xmm6, %xmm3             #23.12
        vinsertf128 $1, %xmm2, %ymm7, %ymm7                     #23.12
        vinsertps $48, 64(%r11), %xmm5, %xmm2                   #23.12
        vinsertf128 $1, %xmm3, %ymm2, %ymm6                     #23.12
                                # LOE rax rcx rbx rbp rdi r8 r9 r12 r13 r14 r15 edx esi r10d xmm9 xmm12 xmm13 ymm6 ymm7 ymm8 ymm10 ymm11 ymm14
..B1.4:                         # Preds ..B1.6 ..B1.3
        vmovd     %esi, %xmm0                                   #33.27
        vpshufd   $0, %xmm0, %xmm2                              #33.27
        vpcmpeqd  %xmm15, %xmm15, %xmm15                        #34.14
        vpcmpeqd  %xmm2, %xmm12, %xmm1                          #34.14
        vpcmpeqd  %xmm2, %xmm13, %xmm3                          #34.14
        vpshufb   .L_2il0floatpacket.2(%rip), %xmm1, %xmm4      #34.14
        vpshufb   .L_2il0floatpacket.3(%rip), %xmm3, %xmm5      #34.14
        vpor      %xmm5, %xmm4, %xmm0                           #34.14
        vpxor     %xmm0, %xmm15, %xmm3                          #34.14
        vpmovmskb %xmm3, %r11d                                  #34.14
        testb     %r11b, %r11b                                  #34.14
        je        ..B1.6        # Prob 20%                      #34.14
                                # LOE rax rcx rbx rbp rdi r8 r9 r12 r13 r14 r15 edx esi r10d xmm3 xmm9 xmm12 xmm13 ymm6 ymm7 ymm8 ymm10 ymm11 ymm14
..B1.5:                         # Preds ..B1.4
        vbroadcastss (%rcx,%rdi), %xmm5                         #38.10
        vbroadcastss 8(%rcx,%rdi), %xmm15                       #40.10
        vinsertf128 $1, %xmm5, %ymm5, %ymm4                     #38.10
        vbroadcastss 4(%rcx,%rdi), %xmm5                        #39.10
        vsubps    %ymm6, %ymm4, %ymm1                           #38.23
        vinsertf128 $1, %xmm5, %ymm5, %ymm2                     #39.10
        vsubps    %ymm7, %ymm2, %ymm4                           #39.23
        vmulps    %ymm1, %ymm1, %ymm2                           #43.18
        vinsertf128 $1, %xmm15, %ymm15, %ymm0                   #40.10
        vmulps    %ymm4, %ymm4, %ymm15                          #43.26
        vsubps    %ymm8, %ymm0, %ymm5                           #40.23
        vaddps    %ymm15, %ymm2, %ymm0                          #43.26
        vmulps    %ymm5, %ymm5, %ymm2                           #43.34
        vaddps    %ymm2, %ymm0, %ymm2                           #43.34
        vandps    .L_2il0floatpacket.9(%rip), %ymm2, %ymm15     #43.9
        vcmpgeps  .L_2il0floatpacket.8(%rip), %ymm15, %ymm0     #43.9
        vrsqrtps  %ymm2, %ymm15                                 #43.9
        vandps    %ymm15, %ymm0, %ymm15                         #43.9
        vmulps    %ymm15, %ymm2, %ymm0                          #43.9
        vmulps    %ymm15, %ymm0, %ymm2                          #43.9
        vmulss    24(%rdi,%rcx), %xmm9, %xmm15                  #46.16
        vsubps    .L_2il0floatpacket.6(%rip), %ymm2, %ymm2      #43.9
        vmulps    %ymm2, %ymm0, %ymm0                           #43.9
        vmulps    .L_2il0floatpacket.7(%rip), %ymm0, %ymm2      #43.9
        vshufps   $0, %xmm15, %xmm15, %xmm0                     #46.16
        vmulps    %ymm2, %ymm2, %ymm15                          #46.36
        vmulps    %ymm15, %ymm2, %ymm2                          #46.40
        vrcpps    %ymm2, %ymm15                                 #46.40
        vmulps    %ymm2, %ymm15, %ymm2                          #46.40
        vmulps    %ymm15, %ymm2, %ymm2                          #46.40
        vaddps    %ymm15, %ymm15, %ymm15                        #46.40
        vsubps    %ymm2, %ymm15, %ymm2                          #46.40
        vpmovsxbd %xmm3, %xmm15                                 #34.14
        vpsrldq   $4, %xmm3, %xmm3                              #34.14
        vpmovsxbd %xmm3, %xmm3                                  #34.14
        vinsertf128 $1, %xmm0, %ymm0, %ymm0                     #46.16
        vmulps    %ymm2, %ymm0, %ymm2                           #46.40
        vmulps    %ymm2, %ymm1, %ymm1                           #47.18
        vmulps    %ymm2, %ymm4, %ymm4                           #48.18
        vaddps    %ymm1, %ymm14, %ymm1                          #47.5
        vaddps    %ymm4, %ymm11, %ymm0                          #48.5
        vinsertf128 $1, %xmm3, %ymm15, %ymm3                    #34.14
        vblendvps %ymm3, %ymm1, %ymm14, %ymm14                  #14.2
        vblendvps %ymm3, %ymm0, %ymm11, %ymm11                  #14.2
        vmulps    %ymm2, %ymm5, %ymm1                           #49.18
        vaddps    %ymm1, %ymm10, %ymm2                          #49.5
        vblendvps %ymm3, %ymm2, %ymm10, %ymm10                  #14.2
                                # LOE rax rcx rbx rbp rdi r8 r9 r12 r13 r14 r15 edx esi r10d xmm9 xmm12 xmm13 ymm6 ymm7 ymm8 ymm10 ymm11 ymm14
..B1.6:                         # Preds ..B1.5 ..B1.4
        incl      %esi                                          #33.15
        addq      $28, %rcx                                     #33.15
        cmpl      $1000, %esi                                   #33.15
        jb        ..B1.4        # Prob 82%                      #33.15
                                # LOE rax rcx rbx rbp rdi r8 r9 r12 r13 r14 r15 edx esi r10d xmm9 xmm12 xmm13 ymm6 ymm7 ymm8 ymm10 ymm11 ymm14
..B1.7:                         # Preds ..B1.6
        vmovups   .L_2il0floatpacket.4(%rip), %ymm1             #
        addq      $8, %r8                                       #22.14
        vmovdqu   -24(%rsp), %xmm0                              #
        vpaddd    %xmm0, %xmm12, %xmm12                         #52.4
        vpaddd    %xmm0, %xmm13, %xmm13                         #52.4
        vmulps    %ymm14, %ymm1, %ymm2                          #56.21

### 			pos_y += vel_y * DT;

        vmulps    %ymm11, %ymm1, %ymm3                          #57.21

### 			pos_z += vel_z * DT;

        vmulps    %ymm10, %ymm1, %ymm4                          #58.21
        vaddps    %ymm2, %ymm6, %ymm6                           #56.4
        vaddps    %ymm3, %ymm7, %ymm7                           #57.4
        vaddps    %ymm4, %ymm8, %ymm8                           #58.4

### 
### 			p[i].pos_x = pos_x;
### 			p[i].pos_y = pos_y;
### 			p[i].pos_z = pos_z;

        vextractf128 $1, %ymm10, %xmm5                          #62.4
        vmovss    %xmm10, 20(%rdi,%r9)                          #62.4
        vmovss    %xmm5, 132(%rdi,%r9)                          #62.4
        vextractps $1, %xmm5, 160(%rdi,%r9)                     #62.4
        vextractps $2, %xmm5, 188(%rdi,%r9)                     #62.4
        vextractps $3, %xmm5, 216(%rdi,%r9)                     #62.4
        vextractps $1, %xmm10, 48(%rdi,%r9)                     #62.4
        vextractps $2, %xmm10, 76(%rdi,%r9)                     #62.4
        vextractps $3, %xmm10, 104(%rdi,%r9)                    #62.4
        vextractf128 $1, %ymm11, %xmm15                         #62.4
        vextractf128 $1, %ymm14, %xmm2                          #62.4
        vextractf128 $1, %ymm8, %xmm3                           #62.4
        vextractf128 $1, %ymm7, %xmm4                           #62.4
        vextractf128 $1, %ymm6, %xmm5                           #62.4
        vmovss    %xmm11, 16(%rdi,%r9)                          #62.4
        vmovss    %xmm15, 128(%rdi,%r9)                         #62.4
        vextractps $1, %xmm11, 44(%rdi,%r9)                     #62.4
        vextractps $2, %xmm11, 72(%rdi,%r9)                     #62.4
        vextractps $3, %xmm11, 100(%rdi,%r9)                    #62.4
        vextractps $1, %xmm15, 156(%rdi,%r9)                    #62.4
        vextractps $2, %xmm15, 184(%rdi,%r9)                    #62.4
        vextractps $3, %xmm15, 212(%rdi,%r9)                    #62.4
        vmovss    %xmm14, 12(%rdi,%r9)                          #62.4
        vextractps $1, %xmm14, 40(%rdi,%r9)                     #62.4
        vextractps $2, %xmm14, 68(%rdi,%r9)                     #62.4
        vextractps $3, %xmm14, 96(%rdi,%r9)                     #62.4
        vmovss    %xmm2, 124(%rdi,%r9)                          #62.4
        vextractps $1, %xmm2, 152(%rdi,%r9)                     #62.4
        vextractps $2, %xmm2, 180(%rdi,%r9)                     #62.4
        vextractps $3, %xmm2, 208(%rdi,%r9)                     #62.4
        vmovss    %xmm8, 8(%rdi,%r9)                            #62.4
        vextractps $1, %xmm8, 36(%rdi,%r9)                      #62.4
        vextractps $2, %xmm8, 64(%rdi,%r9)                      #62.4
        vextractps $3, %xmm8, 92(%rdi,%r9)                      #62.4
        vmovss    %xmm3, 120(%rdi,%r9)                          #62.4
        vextractps $1, %xmm3, 148(%rdi,%r9)                     #62.4
        vextractps $2, %xmm3, 176(%rdi,%r9)                     #62.4
        vextractps $3, %xmm3, 204(%rdi,%r9)                     #62.4
        vmovss    %xmm7, 4(%rdi,%r9)                            #62.4
        vextractps $1, %xmm7, 32(%rdi,%r9)                      #62.4
        vextractps $2, %xmm7, 60(%rdi,%r9)                      #62.4
        vextractps $3, %xmm7, 88(%rdi,%r9)                      #62.4
        vmovss    %xmm4, 116(%rdi,%r9)                          #62.4
        vextractps $1, %xmm4, 144(%rdi,%r9)                     #62.4
        vextractps $2, %xmm4, 172(%rdi,%r9)                     #62.4
        vextractps $3, %xmm4, 200(%rdi,%r9)                     #62.4
        vmovss    %xmm6, (%rdi,%r9)                             #62.4
        vextractps $1, %xmm6, 28(%rdi,%r9)                      #62.4
        vextractps $2, %xmm6, 56(%rdi,%r9)                      #62.4
        vextractps $3, %xmm6, 84(%rdi,%r9)                      #62.4
        vmovss    %xmm5, 112(%rdi,%r9)                          #62.4
        vextractps $1, %xmm5, 140(%rdi,%r9)                     #62.4
        vextractps $2, %xmm5, 168(%rdi,%r9)                     #62.4
        vextractps $3, %xmm5, 196(%rdi,%r9)                     #62.4
        cmpq      $1000, %r8                                    #22.14
        jb        ..B1.3        # Prob 81%                      #22.14
                                # LOE rax rbx rbp rdi r8 r12 r13 r14 r15 edx r10d xmm0 xmm9 xmm12 xmm13 ymm0 ymm1 zmm0
..B1.8:                         # Preds ..B1.7
        incl      %edx                                          #19.2
        vmovdqu   .L_2il0floatpacket.1(%rip), %xmm2             #
        vmovdqu   .L_2il0floatpacket.0(%rip), %xmm3             #
        cmpl      $1000, %edx                                   #19.2
        jb        ..B1.2        # Prob 99%                      #19.2
                                # LOE rax rbx rbp rdi r12 r13 r14 r15 edx r10d xmm0 xmm2 xmm3 xmm9 ymm0 ymm1 zmm0
..B1.9:                         # Preds ..B1.8

### 		}
### 	}
### 
### }

        vzeroupper                                              #66.1
        ret                                                     #66.1
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
..___tag_value__Z14particles_readP8_IO_FILEP10t_particle.4:
..L5:
                                                          #69.1
        pushq     %r12                                          #69.1
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
        pushq     %r13                                          #69.1
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
        pushq     %r14                                          #69.1
	.cfi_def_cfa_offset 32
	.cfi_offset 14, -32

###     for (int i = 0; i < N; i++)

        xorl      %eax, %eax                                    #70.16
        movl      %eax, %r12d                                   #70.16
        movq      %rsi, %r14                                    #70.16
        movq      %rdi, %r13                                    #70.16
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.2:                         # Preds ..B2.3 ..B2.1

###     {
###         fscanf(fp, "%f %f %f %f %f %f %f \n",

        addq      $-32, %rsp                                    #72.9
	.cfi_def_cfa_offset 64
        lea       4(%r14), %rcx                                 #72.9
        movq      %r13, %rdi                                    #72.9
        lea       8(%r14), %r8                                  #72.9
        movl      $.L_2__STRING.0, %esi                         #72.9
        lea       12(%r14), %r9                                 #72.9
        movq      %r14, %rdx                                    #72.9
        xorl      %eax, %eax                                    #72.9
        lea       16(%r14), %r10                                #72.9
        movq      %r10, (%rsp)                                  #72.9
        lea       20(%r14), %r11                                #72.9
        movq      %r11, 8(%rsp)                                 #72.9
        lea       24(%r14), %r10                                #72.9
        movq      %r10, 16(%rsp)                                #72.9
#       fscanf(FILE *, const char *, ...)
        call      fscanf                                        #72.9
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.7:                         # Preds ..B2.2
        addq      $32, %rsp                                     #72.9
	.cfi_def_cfa_offset 32
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.3:                         # Preds ..B2.7
        incl      %r12d                                         #70.28
        addq      $28, %r14                                     #70.28
        cmpl      $1000, %r12d                                  #70.25
        jl        ..B2.2        # Prob 99%                      #70.25
                                # LOE rbx rbp r13 r14 r15 r12d
..B2.4:                         # Preds ..B2.3

###             &p[i].pos_x, &p[i].pos_y, &p[i].pos_z,
###             &p[i].vel_x, &p[i].vel_y, &p[i].vel_z,
###             &p[i].weight);
###     }
### }

	.cfi_restore 14
        popq      %r14                                          #77.1
	.cfi_def_cfa_offset 24
	.cfi_restore 13
        popq      %r13                                          #77.1
	.cfi_def_cfa_offset 16
	.cfi_restore 12
        popq      %r12                                          #77.1
	.cfi_def_cfa_offset 8
        ret                                                     #77.1
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
..___tag_value__Z15particles_writeP8_IO_FILEP10t_particle.21:
..L22:
                                                         #80.1
        pushq     %r12                                          #80.1
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
        pushq     %r13                                          #80.1
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
        pushq     %r14                                          #80.1
	.cfi_def_cfa_offset 32
	.cfi_offset 14, -32
        pushq     %r15                                          #80.1
	.cfi_def_cfa_offset 40
	.cfi_offset 15, -40
        pushq     %rsi                                          #80.1
	.cfi_def_cfa_offset 48

###     for (int i = 0; i < N; i++)

        xorl      %edx, %edx                                    #81.16
        xorl      %eax, %eax                                    #81.16
        movl      %edx, %r13d                                   #81.16
        movq      %rax, %r12                                    #81.16
        movq      %rsi, %r15                                    #81.16
        movq      %rdi, %r14                                    #81.16
                                # LOE rbx rbp r12 r14 r15 r13d
..B3.2:                         # Preds ..B3.3 ..B3.1

###     {
###         fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",

        vxorpd    %xmm0, %xmm0, %xmm0                           #83.9
        vxorpd    %xmm1, %xmm1, %xmm1                           #83.9
        vxorpd    %xmm2, %xmm2, %xmm2                           #83.9
        vxorpd    %xmm3, %xmm3, %xmm3                           #83.9
        vxorpd    %xmm4, %xmm4, %xmm4                           #83.9
        vxorpd    %xmm5, %xmm5, %xmm5                           #83.9
        vxorpd    %xmm6, %xmm6, %xmm6                           #83.9
        movq      %r14, %rdi                                    #83.9
        vcvtss2sd (%r12,%r15), %xmm0, %xmm0                     #83.9
        vcvtss2sd 4(%r12,%r15), %xmm1, %xmm1                    #83.9
        vcvtss2sd 8(%r12,%r15), %xmm2, %xmm2                    #83.9
        vcvtss2sd 12(%r12,%r15), %xmm3, %xmm3                   #83.9
        vcvtss2sd 16(%r12,%r15), %xmm4, %xmm4                   #83.9
        vcvtss2sd 20(%r12,%r15), %xmm5, %xmm5                   #83.9
        vcvtss2sd 24(%r12,%r15), %xmm6, %xmm6                   #83.9
        movl      $.L_2__STRING.1, %esi                         #83.9
        movl      $7, %eax                                      #83.9
#       fprintf(FILE *, const char *, ...)
        call      fprintf                                       #83.9
                                # LOE rbx rbp r12 r14 r15 r13d
..B3.3:                         # Preds ..B3.2
        incl      %r13d                                         #81.28
        addq      $28, %r12                                     #81.28
        cmpl      $1000, %r13d                                  #81.25
        jl        ..B3.2        # Prob 99%                      #81.25
                                # LOE rbx rbp r12 r14 r15 r13d
..B3.4:                         # Preds ..B3.3

###             p[i].pos_x, p[i].pos_y, p[i].pos_z,
###             p[i].vel_x, p[i].vel_y, p[i].vel_z,
###             p[i].weight);
###     }
### }

        popq      %rcx                                          #88.1
	.cfi_def_cfa_offset 40
	.cfi_restore 15
        popq      %r15                                          #88.1
	.cfi_def_cfa_offset 32
	.cfi_restore 14
        popq      %r14                                          #88.1
	.cfi_def_cfa_offset 24
	.cfi_restore 13
        popq      %r13                                          #88.1
	.cfi_def_cfa_offset 16
	.cfi_restore 12
        popq      %r12                                          #88.1
	.cfi_def_cfa_offset 8
        ret                                                     #88.1
        .align    16,0x90
	.cfi_endproc
                                # LOE
# mark_end;
	.type	_Z15particles_writeP8_IO_FILEP10t_particle,@function
	.size	_Z15particles_writeP8_IO_FILEP10t_particle,.-_Z15particles_writeP8_IO_FILEP10t_particle
	.data
# -- End  _Z15particles_writeP8_IO_FILEP10t_particle
	.section .rodata, "a"
	.align 32
	.align 32
.L_2il0floatpacket.4:
	.long	0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f
	.type	.L_2il0floatpacket.4,@object
	.size	.L_2il0floatpacket.4,32
	.align 32
.L_2il0floatpacket.6:
	.long	0x40400000,0x40400000,0x40400000,0x40400000,0x40400000,0x40400000,0x40400000,0x40400000
	.type	.L_2il0floatpacket.6,@object
	.size	.L_2il0floatpacket.6,32
	.align 32
.L_2il0floatpacket.7:
	.long	0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000
	.type	.L_2il0floatpacket.7,@object
	.size	.L_2il0floatpacket.7,32
	.align 32
.L_2il0floatpacket.8:
	.long	0x00800000,0x00800000,0x00800000,0x00800000,0x00800000,0x00800000,0x00800000,0x00800000
	.type	.L_2il0floatpacket.8,@object
	.size	.L_2il0floatpacket.8,32
	.align 32
.L_2il0floatpacket.9:
	.long	0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff
	.type	.L_2il0floatpacket.9,@object
	.size	.L_2il0floatpacket.9,32
	.align 16
.L_2il0floatpacket.0:
	.long	0x00000000,0x00000001,0x00000002,0x00000003
	.type	.L_2il0floatpacket.0,@object
	.size	.L_2il0floatpacket.0,16
	.align 16
.L_2il0floatpacket.1:
	.long	0x00000004,0x00000005,0x00000006,0x00000007
	.type	.L_2il0floatpacket.1,@object
	.size	.L_2il0floatpacket.1,16
	.align 16
.L_2il0floatpacket.2:
	.long	0x0c080400,0xffffffff,0xffffffff,0xffffffff
	.type	.L_2il0floatpacket.2,@object
	.size	.L_2il0floatpacket.2,16
	.align 16
.L_2il0floatpacket.3:
	.long	0xffffffff,0x0c080400,0xffffffff,0xffffffff
	.type	.L_2il0floatpacket.3,@object
	.size	.L_2il0floatpacket.3,16
	.align 4
.L_2il0floatpacket.5:
	.long	0x29964812
	.type	.L_2il0floatpacket.5,@object
	.size	.L_2il0floatpacket.5,4
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
