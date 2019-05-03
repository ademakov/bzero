#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_B)
CNAME(bzero_B):
	movq	%rsi, %rax
	cmpq	$15, %rsi
	jbe	4f
	andq	$-128, %rsi
	addq	%rdi, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	cmpq	%rdi, %rsi
	je	2f

	ALIGN
1:	vmovdqu	%ymm0, (%rdi)
	addq	$128, %rdi
	vmovdqu	%ymm0, -96(%rdi)
	vmovdqu	%ymm0, -64(%rdi)
	vmovdqu	%ymm0, -32(%rdi)
	cmpq	%rdi, %rsi
	ja	1b
	testb	$127, %al
	je	0f
2:	testb	$64, %al
	je	3f
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, 32(%rdi)
	testb	$63, %al
	je	0f
	addq	$64, %rdi
3:	testb	$32, %al
	je	3f
	andq	$31, %rax
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, (%rdi, %rax)
	ret
3:	testb	$16, %al
	je	3f
	andq	$15, %rax
	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm0, (%rdi, %rax)
	ret
3:	andq	$15, %rax
	vmovdqu	%xmm0, -16(%rdi, %rax)
	ret
	nop
4:	testb	%al, %al
	jne	4f
	ret
4:	xorq	%rdx, %rdx
	testb	$8, %al
	je	4f
	movq	%rdx, (%rdi)
	movq	%rdx, -8(%rdi, %rax)
	ret
4:	testb	$4, %al
	je	4f
	movl	%edx, (%rdi)
	movl	%edx, -4(%rdi, %rax)
	ret
4:	testb	$2, %al
	je	4f
	movw	%dx, (%rdi)
	movw	%dx, -2(%rdi, %rax)
0:	ret
4:	movb	%dl, (%rdi)
	ret
