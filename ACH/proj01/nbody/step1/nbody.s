# mark_description "Intel(R) C++ Intel(R) 64 Compiler for applications running on Intel(R) 64, Version 16.0.1.150 Build 20151021";
# mark_description "";
# mark_description "-lpapi -ansi-alias -O2 -xavx -qopenmp-simd -DN=1000 -DDT=0.001f -DSTEPS=1000 -S -fsource-asm -c";
	.file "nbody.cpp"
	.text
..TXTST0:
# -- Begin  _Z18particles_simulateR11t_particles
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z18particles_simulateR11t_particles
# --- particles_simulate(t_particles &)
_Z18particles_simulateR11t_particles:
# parameter 1: %rdi
..B1.1:                         # Preds ..B1.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z18particles_simulateR11t_particles.1:
..L2:
                                                          #13.1
        pushq     %rbp                                          #13.1
	.cfi_def_cfa_offset 16
        movq      %rsp, %rbp                                    #13.1
	.cfi_def_cfa 6, 16
	.cfi_offset 6, -16
        andq      $-32, %rsp                                    #13.1
        pushq     %r13                                          #13.1
        pushq     %r14                                          #13.1
        pushq     %r15                                          #13.1
        pushq     %rbx                                          #13.1
        subq      $12000, %rsp                                  #13.1

### 	float __declspec(align(32)) F_x[N];
### 	float __declspec(align(32)) F_y[N];
### 	float __declspec(align(32)) F_z[N];
### 	float R, F;
### 	float vel_x_i, vel_y_i, vel_z_i;
### 
### 	float dx, dy, dz;
### 	const float GDT = G * DT;
### 
### 	for (int n = 0; n < STEPS; n++) {

        xorl      %eax, %eax                                    #23.2

### 		// Initialization
### 		memset(F_x, 0, N*sizeof(float));
### 		memset(F_y, 0, N*sizeof(float));
### 		memset(F_z, 0, N*sizeof(float));
### 
### 		for (int i = 0; i < N; i++) {
### 			vel_x_i = vel_y_i = vel_z_i =  0.0f;
### 
### 			#pragma omp simd reduction(+:vel_x_i,vel_y_i,vel_z_i) aligned(F_x:32, F_y:32, F_z:32)
### 			for (int j = i + 1; j < N; j++) {
### 				// Calculate distance between two points in each axis
### 				dx = p.pos_x[j] - p.pos_x[i];
### 				dy = p.pos_y[j] - p.pos_y[i];
### 				dz = p.pos_z[j] - p.pos_z[i];
### 
### 				// Calculate vector distance between two points
### 				R = sqrtf(dx*dx + dy*dy + dz*dz);
### 
### 				F = (GDT * p.weight[j]) / (R * R * R);
### 
### 				vel_x_i += F * dx;
### 				vel_y_i += F * dy;
### 				vel_z_i += F * dz;
### 
### 				F_x[j] -= F * dx;
### 				F_y[j] -= F * dy;
### 				F_z[j] -= F * dz;
### 			}
### 
### 			F_x[i] = vel_x_i;
### 			F_y[i] = vel_y_i;
### 			F_z[i] = vel_z_i;
### 		}
### 
### 		#pragma omp simd
### 		#pragma vector aligned
### 		for (int i = 0; i < N; i++) {
### 			p.vel_x[i] += F_x[i];
### 			p.vel_y[i] += F_y[i];
### 			p.vel_z[i] += F_z[i];
### 
### 			p.pos_x[i] += p.vel_x[i] * DT;

        vmovups   .L_2il0floatpacket.0(%rip), %ymm3             #65.31
	.cfi_escape 0x10, 0x03, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x22
	.cfi_escape 0x10, 0x0d, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xf8, 0xff, 0xff, 0xff, 0x22
	.cfi_escape 0x10, 0x0e, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xf0, 0xff, 0xff, 0xff, 0x22
	.cfi_escape 0x10, 0x0f, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xe8, 0xff, 0xff, 0xff, 0x22
        movl      %eax, %r13d                                   #30.24
        vmovss    .L_2il0floatpacket.2(%rip), %xmm1             #42.10
        vxorps    %xmm0, %xmm0, %xmm0                           #30.24
        vmovups   .L_2il0floatpacket.1(%rip), %ymm2             #42.10
        movq      %rdi, %rbx                                    #30.24
                                # LOE rbx r12 r13d
..B1.2:                         # Preds ..B1.23 ..B1.1
        xorl      %esi, %esi                                    #25.3
        lea       (%rsp), %rdi                                  #25.3
        movl      $4000, %edx                                   #25.3
        vzeroupper                                              #25.3
        call      _intel_fast_memset                            #25.3
                                # LOE rbx r12 r13d
..B1.3:                         # Preds ..B1.2
        xorl      %esi, %esi                                    #26.3
        lea       4000(%rsp), %rdi                              #26.3
        movl      $4000, %edx                                   #26.3
        call      _intel_fast_memset                            #26.3
                                # LOE rbx r12 r13d
..B1.4:                         # Preds ..B1.3
        xorl      %esi, %esi                                    #27.3
        lea       8000(%rsp), %rdi                              #27.3
        movl      $4000, %edx                                   #27.3
        call      _intel_fast_memset                            #27.3
                                # LOE rbx r12 r13d
..B1.5:                         # Preds ..B1.4
        xorl      %r10d, %r10d                                  #29.3
        xorl      %edi, %edi                                    #29.3
        vmovss    .L_2il0floatpacket.2(%rip), %xmm6             #29.3
        xorl      %esi, %esi                                    #29.3
        vmovups   .L_2il0floatpacket.1(%rip), %ymm5             #29.3
                                # LOE rbx rsi r10 r12 edi r13d xmm6 ymm5
..B1.6:                         # Preds ..B1.20 ..B1.5
        incl      %edi                                          #51.4
        vxorps    %xmm4, %xmm4, %xmm4                           #30.24
        vxorps    %xmm3, %xmm3, %xmm3                           #30.14
        vxorps    %xmm0, %xmm0, %xmm0                           #30.4
        cmpl      $1000, %edi                                   #33.36
        jge       ..B1.20       # Prob 50%                      #33.36
                                # LOE rbx rsi r10 r12 edi r13d xmm0 xmm3 xmm4 xmm6 ymm5
..B1.7:                         # Preds ..B1.6
        lea       999(%rsi), %r8                                #33.4
        cmpq      $8, %r8                                       #33.4
        jl        ..B1.25       # Prob 10%                      #33.4
                                # LOE rbx rsi r8 r10 r12 edi r13d xmm0 xmm3 xmm4 xmm6 ymm5
..B1.8:                         # Preds ..B1.7
        lea       8000(%rsp,%r10,4), %rax                       #50.5
        lea       4(%rax), %rdx                                 #50.5
        andq      $31, %rdx                                     #33.4
        movl      %edx, %r9d                                    #33.4
        negl      %r9d                                          #33.4
        addl      $32, %r9d                                     #33.4
        shrl      $2, %r9d                                      #33.4
        testl     %edx, %edx                                    #33.4
        cmovne    %r9d, %edx                                    #33.4
        movl      %edx, %r9d                                    #33.4
        lea       8(%r9), %rcx                                  #33.4
        cmpq      %rcx, %r8                                     #33.4
        jl        ..B1.25       # Prob 10%                      #33.4
                                # LOE rax rbx rsi r8 r9 r10 r12 edx edi r13d xmm0 xmm3 xmm4 xmm6 ymm5
..B1.9:                         # Preds ..B1.8
        movl      %r8d, %ecx                                    #33.4
        negl      %edx                                          #33.4
        addl      %ecx, %edx                                    #33.4
        xorl      %r15d, %r15d                                  #33.4
        andl      $7, %edx                                      #33.4
        subl      %edx, %ecx                                    #33.4
        movslq    %ecx, %rdx                                    #33.4
        lea       (%rbx,%r10,4), %rcx                           #35.10
        vmovss    (%rcx), %xmm9                                 #35.23
        vmovss    4000(%rcx), %xmm12                            #36.23
        vmovss    8000(%rcx), %xmm1                             #37.23
        testq     %r9, %r9                                      #33.4
        jbe       ..B1.13       # Prob 9%                       #33.4
                                # LOE rax rdx rcx rbx rsi r8 r9 r10 r12 r15 edi r13d xmm0 xmm1 xmm3 xmm4 xmm6 xmm9 xmm12 ymm5
..B1.10:                        # Preds ..B1.9
        lea       4000(%rsp,%r10,4), %r14                       #49.5
        lea       (%rsp,%r10,4), %r11                           #48.5
                                # LOE rax rdx rcx rbx rsi r8 r9 r10 r11 r12 r14 r15 edi r13d xmm0 xmm1 xmm3 xmm4 xmm6 xmm9 xmm12 ymm5
..B1.11:                        # Preds ..B1.11 ..B1.10
        vmovss    4(%rcx,%r15,4), %xmm10                        #35.10
        vmovss    4004(%rcx,%r15,4), %xmm11                     #36.10
        vsubss    %xmm9, %xmm10, %xmm8                          #35.23
        vsubss    %xmm12, %xmm11, %xmm7                         #36.23
        vmulss    %xmm8, %xmm8, %xmm14                          #40.18
        vmulss    %xmm7, %xmm7, %xmm15                          #40.26
        vmovss    8004(%rcx,%r15,4), %xmm13                     #37.10
        vaddss    %xmm15, %xmm14, %xmm10                        #40.26
        vsubss    %xmm1, %xmm13, %xmm2                          #37.23
        vmulss    24004(%rcx,%r15,4), %xmm6, %xmm15             #42.16
        vmulss    %xmm2, %xmm2, %xmm11                          #40.34
        vaddss    %xmm11, %xmm10, %xmm13                        #40.34
        vsqrtss   %xmm13, %xmm13, %xmm14                        #40.9
        vmulss    %xmm14, %xmm13, %xmm10                        #42.40
        vdivss    %xmm10, %xmm15, %xmm11                        #42.40
        vmulss    %xmm11, %xmm8, %xmm8                          #44.20
        vmulss    %xmm11, %xmm7, %xmm10                         #45.20
        vmulss    %xmm11, %xmm2, %xmm11                         #46.20
        vaddss    %xmm8, %xmm0, %xmm0                           #44.5
        vaddss    %xmm10, %xmm3, %xmm3                          #45.5
        vaddss    %xmm11, %xmm4, %xmm4                          #46.5
        vmovss    4(%r11,%r15,4), %xmm2                         #48.5
        vsubss    %xmm8, %xmm2, %xmm7                           #48.5
        vmovss    4(%r14,%r15,4), %xmm2                         #49.5
        vmovss    4(%rax,%r15,4), %xmm8                         #50.5
        vmovss    %xmm7, 4(%r11,%r15,4)                         #48.5
        vsubss    %xmm10, %xmm2, %xmm7                          #49.5
        vsubss    %xmm11, %xmm8, %xmm13                         #50.5
        vmovss    %xmm7, 4(%r14,%r15,4)                         #49.5
        vmovss    %xmm13, 4(%rax,%r15,4)                        #50.5
        incq      %r15                                          #33.4
        cmpq      %r9, %r15                                     #33.4
        jb        ..B1.11       # Prob 99%                      #33.4
                                # LOE rax rdx rcx rbx rsi r8 r9 r10 r11 r12 r14 r15 edi r13d xmm0 xmm1 xmm3 xmm4 xmm6 xmm9 xmm12 ymm5
..B1.13:                        # Preds ..B1.11 ..B1.9
        vshufps   $0, %xmm1, %xmm1, %xmm7                       #37.23
        lea       (%r10,%r9), %r11                              #33.4
        vxorps    %xmm11, %xmm11, %xmm11                        #18.2
        vmovss    %xmm0, %xmm11, %xmm2                          #18.2
        vmovss    %xmm3, %xmm11, %xmm0                          #18.2
        vshufps   $0, %xmm9, %xmm9, %xmm3                       #35.23
        vmovss    %xmm4, %xmm11, %xmm10                         #18.2
        vshufps   $0, %xmm12, %xmm12, %xmm4                     #36.23
        vinsertf128 $1, %xmm11, %ymm2, %ymm2                    #18.2
        vinsertf128 $1, %xmm11, %ymm0, %ymm0                    #18.2
        vinsertf128 $1, %xmm11, %ymm10, %ymm11                  #18.2
        vinsertf128 $1, %xmm3, %ymm3, %ymm10                    #35.23
        vinsertf128 $1, %xmm4, %ymm4, %ymm9                     #36.23
        vinsertf128 $1, %xmm7, %ymm7, %ymm8                     #37.23
                                # LOE rdx rcx rbx rsi r8 r9 r10 r11 r12 edi r13d xmm6 ymm0 ymm2 ymm5 ymm8 ymm9 ymm10 ymm11
..B1.14:                        # Preds ..B1.14 ..B1.13
        vmovups   4(%rcx,%r9,4), %ymm12                         #35.10
        vmovups   4004(%rcx,%r9,4), %ymm13                      #36.10
        vmovups   8004(%rcx,%r9,4), %ymm14                      #37.10
        vsubps    %ymm10, %ymm12, %ymm7                         #35.23
        vsubps    %ymm9, %ymm13, %ymm4                          #36.23
        vsubps    %ymm8, %ymm14, %ymm3                          #37.23
        vmulps    %ymm7, %ymm7, %ymm15                          #40.18
        vmulps    %ymm4, %ymm4, %ymm1                           #40.26
        vmulps    %ymm3, %ymm3, %ymm13                          #40.34
        vaddps    %ymm1, %ymm15, %ymm12                         #40.26
        vaddps    %ymm13, %ymm12, %ymm12                        #40.34
        vrsqrtps  %ymm12, %ymm1                                 #40.9
        vandps    .L_2il0floatpacket.6(%rip), %ymm12, %ymm14    #40.9
        vcmpgeps  .L_2il0floatpacket.5(%rip), %ymm14, %ymm15    #40.9
        vandps    %ymm1, %ymm15, %ymm13                         #40.9
        vmulps    %ymm13, %ymm12, %ymm15                        #40.9
        vmulps    %ymm13, %ymm15, %ymm14                        #40.9
        vsubps    .L_2il0floatpacket.3(%rip), %ymm14, %ymm1     #40.9
        vmulps    %ymm1, %ymm15, %ymm12                         #40.9
        vmulps    24004(%rcx,%r9,4), %ymm5, %ymm1               #42.16
        vmulps    .L_2il0floatpacket.4(%rip), %ymm12, %ymm13    #40.9
        vmulps    %ymm13, %ymm13, %ymm14                        #42.36
        addq      $8, %r9                                       #33.4
        vmulps    %ymm14, %ymm13, %ymm15                        #42.40
        vrcpps    %ymm15, %ymm12                                #42.40
        vmulps    %ymm15, %ymm12, %ymm15                        #42.40
        vaddps    %ymm12, %ymm12, %ymm13                        #42.40
        vmulps    %ymm12, %ymm15, %ymm14                        #42.40
        vsubps    %ymm14, %ymm13, %ymm12                        #42.40
        vmulps    %ymm12, %ymm1, %ymm1                          #42.40
        vmulps    %ymm1, %ymm7, %ymm7                           #44.20
        vmulps    %ymm1, %ymm4, %ymm12                          #45.20
        vmulps    %ymm1, %ymm3, %ymm1                           #46.20
        vmovups   4(%rsp,%r11,4), %ymm3                         #48.5
        vaddps    %ymm7, %ymm2, %ymm2                           #44.5
        vaddps    %ymm12, %ymm0, %ymm0                          #45.5
        vsubps    %ymm7, %ymm3, %ymm4                           #48.5
        vaddps    %ymm1, %ymm11, %ymm11                         #46.5
        vmovups   4004(%rsp,%r11,4), %ymm3                      #49.5
        vmovups   8004(%rsp,%r11,4), %ymm7                      #50.5
        vmovups   %ymm4, 4(%rsp,%r11,4)                         #48.5
        vsubps    %ymm12, %ymm3, %ymm4                          #49.5
        vsubps    %ymm1, %ymm7, %ymm13                          #50.5
        vmovups   %ymm4, 4004(%rsp,%r11,4)                      #49.5
        vmovups   %ymm13, 8004(%rsp,%r11,4)                     #50.5
        addq      $8, %r11                                      #33.4
        cmpq      %rdx, %r9                                     #33.4
        jb        ..B1.14       # Prob 99%                      #33.4
                                # LOE rdx rcx rbx rsi r8 r9 r10 r11 r12 edi r13d xmm6 ymm0 ymm2 ymm5 ymm8 ymm9 ymm10 ymm11
..B1.15:                        # Preds ..B1.14
        vextractf128 $1, %ymm11, %xmm4                          #18.2
        vaddps    %xmm4, %xmm11, %xmm3                          #18.2
        vmovhlps  %xmm3, %xmm3, %xmm1                           #18.2
        vaddps    %xmm1, %xmm3, %xmm7                           #18.2
        vshufps   $245, %xmm7, %xmm7, %xmm8                     #18.2
        vaddss    %xmm8, %xmm7, %xmm4                           #18.2
        vextractf128 $1, %ymm0, %xmm9                           #18.2
        vextractf128 $1, %ymm2, %xmm15                          #18.2
        vaddps    %xmm9, %xmm0, %xmm10                          #18.2
        vaddps    %xmm15, %xmm2, %xmm0                          #18.2
        vmovhlps  %xmm10, %xmm10, %xmm12                        #18.2
        vmovhlps  %xmm0, %xmm0, %xmm1                           #18.2
        vaddps    %xmm12, %xmm10, %xmm13                        #18.2
        vaddps    %xmm1, %xmm0, %xmm2                           #18.2
        vshufps   $245, %xmm13, %xmm13, %xmm14                  #18.2
        vshufps   $245, %xmm2, %xmm2, %xmm7                     #18.2
        vaddss    %xmm14, %xmm13, %xmm3                         #18.2
        vaddss    %xmm7, %xmm2, %xmm0                           #18.2
                                # LOE rdx rbx rsi r8 r10 r12 edi r13d xmm0 xmm3 xmm4 xmm6 ymm5
..B1.16:                        # Preds ..B1.15 ..B1.25
        cmpq      %r8, %rdx                                     #33.4
        jae       ..B1.20       # Prob 9%                       #33.4
                                # LOE rdx rbx rsi r8 r10 r12 edi r13d xmm0 xmm3 xmm4 xmm6 ymm5
..B1.17:                        # Preds ..B1.16
        lea       (%rbx,%r10,4), %r9                            #35.10
        vmovss    (%r9), %xmm10                                 #35.23
        lea       4000(%rsp,%r10,4), %r14                       #49.5
        vmovss    4000(%r9), %xmm9                              #36.23
        lea       (%rsp,%r10,4), %r11                           #48.5
        vmovss    8000(%r9), %xmm8                              #37.23
        lea       8000(%rsp,%r10,4), %rcx                       #50.5
                                # LOE rdx rcx rbx rsi r8 r9 r10 r11 r12 r14 edi r13d xmm0 xmm3 xmm4 xmm6 xmm8 xmm9 xmm10 ymm5
..B1.18:                        # Preds ..B1.18 ..B1.17
        vmovss    4(%r9,%rdx,4), %xmm11                         #35.10
        vmovss    4004(%r9,%rdx,4), %xmm12                      #36.10
        vsubss    %xmm10, %xmm11, %xmm7                         #35.23
        vsubss    %xmm9, %xmm12, %xmm2                          #36.23
        vmulss    %xmm7, %xmm7, %xmm14                          #40.18
        vmulss    %xmm2, %xmm2, %xmm15                          #40.26
        vmovss    8004(%r9,%rdx,4), %xmm13                      #37.10
        vaddss    %xmm15, %xmm14, %xmm11                        #40.26
        vsubss    %xmm8, %xmm13, %xmm1                          #37.23
        vmulss    24004(%r9,%rdx,4), %xmm6, %xmm15              #42.16
        vmulss    %xmm1, %xmm1, %xmm12                          #40.34
        vaddss    %xmm12, %xmm11, %xmm13                        #40.34
        vsqrtss   %xmm13, %xmm13, %xmm14                        #40.9
        vmulss    %xmm14, %xmm13, %xmm11                        #42.40
        vdivss    %xmm11, %xmm15, %xmm12                        #42.40
        vmulss    %xmm12, %xmm7, %xmm7                          #44.20
        vmulss    %xmm12, %xmm2, %xmm11                         #45.20
        vmulss    %xmm12, %xmm1, %xmm12                         #46.20
        vaddss    %xmm7, %xmm0, %xmm0                           #44.5
        vaddss    %xmm11, %xmm3, %xmm3                          #45.5
        vaddss    %xmm12, %xmm4, %xmm4                          #46.5
        vmovss    4(%r11,%rdx,4), %xmm1                         #48.5
        vsubss    %xmm7, %xmm1, %xmm2                           #48.5
        vmovss    4(%r14,%rdx,4), %xmm1                         #49.5
        vmovss    4(%rcx,%rdx,4), %xmm7                         #50.5
        vmovss    %xmm2, 4(%r11,%rdx,4)                         #48.5
        vsubss    %xmm11, %xmm1, %xmm2                          #49.5
        vsubss    %xmm12, %xmm7, %xmm13                         #50.5
        vmovss    %xmm2, 4(%r14,%rdx,4)                         #49.5
        vmovss    %xmm13, 4(%rcx,%rdx,4)                        #50.5
        incq      %rdx                                          #33.4
        cmpq      %r8, %rdx                                     #33.4
        jb        ..B1.18       # Prob 99%                      #33.4
                                # LOE rdx rcx rbx rsi r8 r9 r10 r11 r12 r14 edi r13d xmm0 xmm3 xmm4 xmm6 xmm8 xmm9 xmm10 ymm5
..B1.20:                        # Preds ..B1.18 ..B1.6 ..B1.16
        vmovss    %xmm0, (%rsp,%r10,4)                          #53.4
        decq      %rsi                                          #51.4
        vmovss    %xmm3, 4000(%rsp,%r10,4)                      #54.4
        vmovss    %xmm4, 8000(%rsp,%r10,4)                      #55.4
        incq      %r10                                          #51.4
        cmpl      $1000, %edi                                   #29.3
        jb        ..B1.6        # Prob 99%                      #29.3
                                # LOE rbx rsi r10 r12 edi r13d xmm6 ymm5
..B1.21:                        # Preds ..B1.20
        vmovups   .L_2il0floatpacket.0(%rip), %ymm12            #60.14
        xorl      %edx, %edx                                    #60.14
                                # LOE rdx rbx r12 r13d ymm12
..B1.22:                        # Preds ..B1.22 ..B1.21
        vmovups   12000(%rbx,%rdx,4), %ymm0                     #61.4
        vmovups   16000(%rbx,%rdx,4), %ymm1                     #62.4
        vmovups   20000(%rbx,%rdx,4), %ymm2                     #63.4
        vaddps    (%rsp,%rdx,4), %ymm0, %ymm3                   #61.4
        vaddps    4000(%rsp,%rdx,4), %ymm1, %ymm6               #62.4
        vaddps    8000(%rsp,%rdx,4), %ymm2, %ymm9               #63.4
        vmulps    %ymm3, %ymm12, %ymm4                          #65.31

### 			p.pos_y[i] += p.vel_y[i] * DT;

        vmulps    %ymm6, %ymm12, %ymm7                          #66.31

### 			p.pos_z[i] += p.vel_z[i] * DT;

        vmulps    %ymm9, %ymm12, %ymm10                         #67.31
        vmovups   %ymm3, 12000(%rbx,%rdx,4)                     #61.4
        vmovups   %ymm6, 16000(%rbx,%rdx,4)                     #62.4
        vmovups   %ymm9, 20000(%rbx,%rdx,4)                     #63.4
        vaddps    (%rbx,%rdx,4), %ymm4, %ymm5                   #65.4
        vaddps    4000(%rbx,%rdx,4), %ymm7, %ymm8               #66.4
        vaddps    8000(%rbx,%rdx,4), %ymm10, %ymm11             #67.4
        vmovups   %ymm5, (%rbx,%rdx,4)                          #65.4
        vmovups   %ymm8, 4000(%rbx,%rdx,4)                      #66.4
        vmovups   %ymm11, 8000(%rbx,%rdx,4)                     #67.4
        addq      $8, %rdx                                      #60.14
        cmpq      $1000, %rdx                                   #60.14
        jb        ..B1.22       # Prob 82%                      #60.14
                                # LOE rdx rbx r12 r13d ymm12
..B1.23:                        # Preds ..B1.22
        incl      %r13d                                         #23.2
        cmpl      $1000, %r13d                                  #23.2
        jb        ..B1.2        # Prob 99%                      #23.2
                                # LOE rbx r12 r13d
..B1.24:                        # Preds ..B1.23

### 
### 		}
### 	}
### }

        vzeroupper                                              #71.1
        addq      $12000, %rsp                                  #71.1
	.cfi_restore 3
        popq      %rbx                                          #71.1
	.cfi_restore 15
        popq      %r15                                          #71.1
	.cfi_restore 14
        popq      %r14                                          #71.1
	.cfi_restore 13
        popq      %r13                                          #71.1
        movq      %rbp, %rsp                                    #71.1
        popq      %rbp                                          #71.1
	.cfi_def_cfa 7, 8
	.cfi_restore 6
        ret                                                     #71.1
	.cfi_def_cfa 6, 16
	.cfi_escape 0x10, 0x03, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x22
	.cfi_offset 6, -16
	.cfi_escape 0x10, 0x0d, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xf8, 0xff, 0xff, 0xff, 0x22
	.cfi_escape 0x10, 0x0e, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xf0, 0xff, 0xff, 0xff, 0x22
	.cfi_escape 0x10, 0x0f, 0x0e, 0x38, 0x1c, 0x0d, 0xe0, 0xff, 0xff, 0xff, 0x1a, 0x0d, 0xe8, 0xff, 0xff, 0xff, 0x22
                                # LOE
..B1.25:                        # Preds ..B1.7 ..B1.8           # Infreq
        xorl      %edx, %edx                                    #33.4
        jmp       ..B1.16       # Prob 100%                     #33.4
        .align    16,0x90
	.cfi_endproc
                                # LOE rdx rbx rsi r8 r10 r12 edi r13d xmm0 xmm3 xmm4 xmm6 ymm5
# mark_end;
	.type	_Z18particles_simulateR11t_particles,@function
	.size	_Z18particles_simulateR11t_particles,.-_Z18particles_simulateR11t_particles
	.data
# -- End  _Z18particles_simulateR11t_particles
	.text
# -- Begin  _Z14particles_readP8_IO_FILER11t_particles
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z14particles_readP8_IO_FILER11t_particles
# --- particles_read(FILE *, t_particles &)
_Z14particles_readP8_IO_FILER11t_particles:
# parameter 1: %rdi
# parameter 2: %rsi
..B2.1:                         # Preds ..B2.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z14particles_readP8_IO_FILER11t_particles.23:
..L24:
                                                         #74.1
        pushq     %r12                                          #74.1
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
        pushq     %r13                                          #74.1
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
        pushq     %r14                                          #74.1
	.cfi_def_cfa_offset 32
	.cfi_offset 14, -32

###     for (int i = 0; i < N; i++)

        xorl      %eax, %eax                                    #75.16
        movq      %rax, %r12                                    #75.16
        movq      %rsi, %r13                                    #75.16
        movq      %rdi, %r14                                    #75.16
                                # LOE rbx rbp r12 r13 r14 r15
..B2.2:                         # Preds ..B2.3 ..B2.1

###     {
###         fscanf(fp, "%f %f %f %f %f %f %f \n",

        addq      $-32, %rsp                                    #77.9
	.cfi_def_cfa_offset 64

###             &p.pos_x[i], &p.pos_y[i], &p.pos_z[i],
###             &p.vel_x[i], &p.vel_y[i], &p.vel_z[i],
###             &p.weight[i]);

        lea       (%r13,%r12,4), %rdx                           #80.14
        movq      %r14, %rdi                                    #77.9
        lea       4000(%rdx), %rcx                              #77.9
        movl      $.L_2__STRING.0, %esi                         #77.9
        lea       8000(%rdx), %r8                               #77.9
        xorl      %eax, %eax                                    #77.9
        lea       12000(%rdx), %r9                              #77.9
        lea       16000(%rdx), %r10                             #77.9
        movq      %r10, (%rsp)                                  #77.9
        lea       20000(%rdx), %r11                             #77.9
        movq      %r11, 8(%rsp)                                 #77.9
        lea       24000(%rdx), %r10                             #77.9
        movq      %r10, 16(%rsp)                                #77.9
#       fscanf(FILE *, const char *, ...)
        call      fscanf                                        #77.9
                                # LOE rbx rbp r12 r13 r14 r15
..B2.7:                         # Preds ..B2.2
        addq      $32, %rsp                                     #77.9
	.cfi_def_cfa_offset 32
                                # LOE rbx rbp r12 r13 r14 r15
..B2.3:                         # Preds ..B2.7
        incq      %r12                                          #75.28
        cmpq      $1000, %r12                                   #75.25
        jl        ..B2.2        # Prob 99%                      #75.25
                                # LOE rbx rbp r12 r13 r14 r15
..B2.4:                         # Preds ..B2.3

###     }
### }

	.cfi_restore 14
        popq      %r14                                          #82.1
	.cfi_def_cfa_offset 24
	.cfi_restore 13
        popq      %r13                                          #82.1
	.cfi_def_cfa_offset 16
	.cfi_restore 12
        popq      %r12                                          #82.1
	.cfi_def_cfa_offset 8
        ret                                                     #82.1
        .align    16,0x90
	.cfi_endproc
                                # LOE
# mark_end;
	.type	_Z14particles_readP8_IO_FILER11t_particles,@function
	.size	_Z14particles_readP8_IO_FILER11t_particles,.-_Z14particles_readP8_IO_FILER11t_particles
	.data
# -- End  _Z14particles_readP8_IO_FILER11t_particles
	.text
# -- Begin  _Z15particles_writeP8_IO_FILER11t_particles
	.text
# mark_begin;
       .align    16,0x90
	.globl _Z15particles_writeP8_IO_FILER11t_particles
# --- particles_write(FILE *, t_particles &)
_Z15particles_writeP8_IO_FILER11t_particles:
# parameter 1: %rdi
# parameter 2: %rsi
..B3.1:                         # Preds ..B3.0

### {

	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
..___tag_value__Z15particles_writeP8_IO_FILER11t_particles.40:
..L41:
                                                         #85.1
        pushq     %r12                                          #85.1
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
        pushq     %r13                                          #85.1
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
        pushq     %r14                                          #85.1
	.cfi_def_cfa_offset 32
	.cfi_offset 14, -32

###     for (int i = 0; i < N; i++)

        xorl      %eax, %eax                                    #86.16
        movq      %rax, %r12                                    #86.16
        movq      %rsi, %r14                                    #86.16
        movq      %rdi, %r13                                    #86.16
                                # LOE rbx rbp r12 r13 r14 r15
..B3.2:                         # Preds ..B3.3 ..B3.1

###     {
###         fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",

        vxorpd    %xmm0, %xmm0, %xmm0                           #88.9
        vxorpd    %xmm1, %xmm1, %xmm1                           #88.9
        vxorpd    %xmm2, %xmm2, %xmm2                           #88.9
        vxorpd    %xmm3, %xmm3, %xmm3                           #88.9
        vxorpd    %xmm4, %xmm4, %xmm4                           #88.9
        vxorpd    %xmm5, %xmm5, %xmm5                           #88.9
        vxorpd    %xmm6, %xmm6, %xmm6                           #88.9
        movq      %r13, %rdi                                    #88.9
        vcvtss2sd (%r14,%r12,4), %xmm0, %xmm0                   #88.9
        vcvtss2sd 4000(%r14,%r12,4), %xmm1, %xmm1               #88.9
        vcvtss2sd 8000(%r14,%r12,4), %xmm2, %xmm2               #88.9
        vcvtss2sd 12000(%r14,%r12,4), %xmm3, %xmm3              #88.9
        vcvtss2sd 16000(%r14,%r12,4), %xmm4, %xmm4              #88.9
        vcvtss2sd 20000(%r14,%r12,4), %xmm5, %xmm5              #88.9
        vcvtss2sd 24000(%r14,%r12,4), %xmm6, %xmm6              #88.9
        movl      $.L_2__STRING.1, %esi                         #88.9
        movl      $7, %eax                                      #88.9
#       fprintf(FILE *, const char *, ...)
        call      fprintf                                       #88.9
                                # LOE rbx rbp r12 r13 r14 r15
..B3.3:                         # Preds ..B3.2
        incq      %r12                                          #86.28
        cmpq      $1000, %r12                                   #86.25
        jl        ..B3.2        # Prob 99%                      #86.25
                                # LOE rbx rbp r12 r13 r14 r15
..B3.4:                         # Preds ..B3.3

###             p.pos_x[i], p.pos_y[i], p.pos_z[i],
###             p.vel_x[i], p.vel_y[i], p.vel_z[i],
###             p.weight[i]);
###     }
### }

	.cfi_restore 14
        popq      %r14                                          #93.1
	.cfi_def_cfa_offset 24
	.cfi_restore 13
        popq      %r13                                          #93.1
	.cfi_def_cfa_offset 16
	.cfi_restore 12
        popq      %r12                                          #93.1
	.cfi_def_cfa_offset 8
        ret                                                     #93.1
        .align    16,0x90
	.cfi_endproc
                                # LOE
# mark_end;
	.type	_Z15particles_writeP8_IO_FILER11t_particles,@function
	.size	_Z15particles_writeP8_IO_FILER11t_particles,.-_Z15particles_writeP8_IO_FILER11t_particles
	.data
# -- End  _Z15particles_writeP8_IO_FILER11t_particles
	.section .rodata, "a"
	.align 32
	.align 32
.L_2il0floatpacket.0:
	.long	0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f,0x3a83126f
	.type	.L_2il0floatpacket.0,@object
	.size	.L_2il0floatpacket.0,32
	.align 32
.L_2il0floatpacket.1:
	.long	0x29964812,0x29964812,0x29964812,0x29964812,0x29964812,0x29964812,0x29964812,0x29964812
	.type	.L_2il0floatpacket.1,@object
	.size	.L_2il0floatpacket.1,32
	.align 32
.L_2il0floatpacket.3:
	.long	0x40400000,0x40400000,0x40400000,0x40400000,0x40400000,0x40400000,0x40400000,0x40400000
	.type	.L_2il0floatpacket.3,@object
	.size	.L_2il0floatpacket.3,32
	.align 32
.L_2il0floatpacket.4:
	.long	0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000,0xbf000000
	.type	.L_2il0floatpacket.4,@object
	.size	.L_2il0floatpacket.4,32
	.align 32
.L_2il0floatpacket.5:
	.long	0x00800000,0x00800000,0x00800000,0x00800000,0x00800000,0x00800000,0x00800000,0x00800000
	.type	.L_2il0floatpacket.5,@object
	.size	.L_2il0floatpacket.5,32
	.align 32
.L_2il0floatpacket.6:
	.long	0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff,0x7fffffff
	.type	.L_2il0floatpacket.6,@object
	.size	.L_2il0floatpacket.6,32
	.align 4
.L_2il0floatpacket.2:
	.long	0x29964812
	.type	.L_2il0floatpacket.2,@object
	.size	.L_2il0floatpacket.2,4
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
