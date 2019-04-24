#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_C)
CNAME(bzero_C):
	movq	%rsi, %rax
	cmpq	$15, %rsi
	jbe	4f
	andq	$-128, %rsi
	addq	%rdi, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	cmpq	%rdi, %rsi
	je	2f

	ALIGN
1:
	vmovdqu	%ymm0, (%rdi)
	addq	$128, %rdi
	vmovdqu	%ymm0, -96(%rdi)
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
	je	3f
	andq	$31, %rax
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, (%rdi, %rax)
	ret
3:
	testb	$16, %al
	je	3f
	andq	$15, %rax
	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm0, (%rdi, %rax)
	ret
3:
	andq	$15, %rax
	vmovdqu	%xmm0, -16(%rdi, %rax)
	ret

	ALIGN
4:
 	xorq	%rdx, %rdx
	cmpq	$3, %rsi
	jbe	2f
	testb	$8, %al
	je	3f
	andb	$7, %al
	movq	%rdx, (%rdi)
	movq	%rdx, (%rdi, %rax)
	ret
3:
	andb	$3, %al
	movl	%edx, (%rdi)
	movl	%edx, (%rdi, %rax)
	ret
2:
	testb	$2, %al
	je	1f
	andb	$1, %al
	movw	%dx, (%rdi)
	movw	%dx, (%rdi, %rax)
	ret
1:
 	testb	%al, %al
	je	0f
	movb	%dl, (%rdi)
0:
	ret


