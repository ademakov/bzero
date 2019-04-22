#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_A)
CNAME(bzero_A):
	movq	%rsi, %rax
	cmpq	$15, %rsi
	jbe	9f
	andq	$-128, %rsi
	addq	%rdi, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	cmpq	%rdi, %rsi
	je	2f
	ALIGN
1:
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, 32(%rdi)
	addq	$128, %rdi
	vmovdqu	%ymm0, -64(%rdi)
	vmovdqu	%ymm0, -32(%rdi)
	cmpq	%rdi, %rsi
	ja	1b
	testb	$127, %al
	je	0f
2:
	testb	$64, %al
	je	3f
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, 32(%rdi)
	testb	$63, %al
	je	0f
	addq	$64, %rdi
3:
	testb	$32, %al
	je	4f
	vmovdqu	%ymm0, (%rdi)
	testb	$31, %al
	je	0f
	addq	$32, %rdi
4:
	testb	$16, %al
	je	5f
	vmovdqu	%xmm0, (%rdi)
	testb	$15, %al
	je	0f
	addq	$16, %rdi
5:
	xorq	%rdx, %rdx
	testb	$8, %al
	je	6f
	movq	%rdx, (%rdi)
	testb	$7, %al
	je	0f
	addq	$8, %rdi
6:
	testb	$4, %al
	je	7f
	movl	%edx, (%rdi)
	testb	$3, %al
	je	0f
	addq	$4, %rdi
7:
	testb	$2, %al
	je	8f
	movw	%dx, (%rdi)
	testb	$1, %al
	je	0f
	addq	$2, %rdi
8:
	movb	%dl, (%rdi)
	ret
9:
	testl	%eax, %eax
	jne	5b
	ALIGN
0:
	ret
