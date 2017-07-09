#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_7)
CNAME(bzero_7):
	cmpq	$15, %rsi
	jbe	8f
	movq	%rsi, %rdx
	andq	$-64, %rdx
	addq	%rdi, %rdx
	pxor	%xmm0, %xmm0
	cmpq	%rdx, %rdi
	je	2f
	ALIGN
1:
	movups	%xmm0, (%rdi)
	addq	$64, %rdi
	movdqu	%xmm0, -48(%rdi)
	movdqu	%xmm0, -32(%rdi)
	movdqu	%xmm0, -16(%rdi)
	cmpq	%rdi, %rdx
	ja	1b
	testb	$63, %sil
	je	0f
2:
	testb	$32, %sil
	je	3f
	movdqu	%xmm0, (%rdi)
	movdqu	%xmm0, 16(%rdi)
	testb	$31, %sil
	je	0f
	addq	$32, %rdi
3:
	testb	$16, %sil
	je	4f
	movdqu	%xmm0, (%rdi)
	testb	$15, %sil
	je	0f
	addq	$16, %rdi
4:
	testb	$8, %sil
	je	5f
	movq	$0, (%rdi)
	testb	$7, %sil
	je	0f
	addq	$8, %rdi
5:
	testb	$4, %sil
	je	6f
	movl	$0, (%rdi)
	testb	$3, %sil
	je	0f
	addq	$4, %rdi
6:
	testb	$2, %sil
	je	7f
	xorl	%edx, %edx
	movw	%dx, (%rdi)
	testb	$1, %sil
	je	0f
	addq	$2, %rdi
7:
	movb	$0, (%rdi)
	ret
8:
	testl	%esi, %esi
	jne	4b
0:
	ret
