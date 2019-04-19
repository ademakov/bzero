#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_9)
CNAME(bzero_9):
	movq	%rsi, %rax
	cmpq	$15, %rsi
	jbe	8f
	andq	$-64, %rsi
	addq	%rdi, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	cmpq	%rdi, %rsi
	je	2f
	ALIGN
1:
	vmovdqu	%ymm0, (%rdi)
	addq	$64, %rdi
	vmovdqu	%ymm0, -32(%rdi)
	cmpq	%rdi, %rsi
	ja	1b
	testb	$63, %al
	je	0f
2:
	testb	$32, %al
	je	3f
	vmovdqu	%ymm0, (%rdi)
	testb	$31, %al
	je	0f
	addq	$32, %rdi
3:
	testb	$16, %al
	je	4f
	vmovdqu	%xmm0, (%rdi)
	testb	$15, %al
	je	0f
	addq	$16, %rdi
4:
	xorq	%rdx, %rdx
	testb	$8, %al
	je	5f
	movq	%rdx, (%rdi)
	testb	$7, %al
	je	0f
	addq	$8, %rdi
5:
	testb	$4, %al
	je	6f
	movl	%edx, (%rdi)
	testb	$3, %al
	je	0f
	addq	$4, %rdi
6:
	testb	$2, %al
	je	7f
	movw	%dx, (%rdi)
	testb	$1, %al
	je	0f
	addq	$2, %rdi
7:
	movb	%dl, (%rdi)
	ret
8:
	testl	%eax, %eax
	jne	4b
	ALIGN
0:
	ret
