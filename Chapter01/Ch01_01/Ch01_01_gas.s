.intel_syntax noprefix
.section .text
.global CalcZ_Aavx
.type CalcZ_Aavx, @function

// void CalcZ_Aavx(float* z, const float* x, const float* y, size_t n)
// Parameters: rdi=z, rsi=x, rdx=y, rcx=n
CalcZ_Aavx:
    xor rax, rax                # i = 0

.Lloop1:
    mov r10, rcx                # r10 = n
    sub r10, rax                # r10 = n - i
    cmp r10, 8                  # if (n - i < 8)
    jb .Lloop2

    vmovups ymm0, [rsi + rax*4] # ymm0 = x[i:i+7]
    vmovups ymm1, [rdx + rax*4] # ymm1 = y[i:i+7]
    vaddps ymm2, ymm0, ymm1     # ymm2 = x + y
    vmovups [rdi + rax*4], ymm2 # z[i:i+7] = x + y

    add rax, 8                  # i += 8
    jmp .Lloop1

.Lloop2:
    cmp rax, rcx                # if (i >= n)
    jae .Ldone

    vmovss xmm0, [rsi + rax*4]  # xmm0 = x[i]
    vmovss xmm1, [rdx + rax*4]  # xmm1 = y[i]
    vaddss xmm2, xmm0, xmm1     # xmm2 = x[i] + y[i]
    vmovss [rdi + rax*4], xmm2  # z[i] = x[i] + y[i]

    inc rax
    jmp .Lloop2

.Ldone:
    vzeroupper
    ret