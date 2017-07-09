#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_8)
CNAME(bzero_8):
	movq	%rsi, %rdx
	pxor	%xmm0, %xmm0
	andq	$-32, %rdx
	addq	%rdi, %rdx
	cmpq	%rdx, %rdi
	je	2f
	ALIGN
1:
	movdqu	%xmm0, (%rdi)
	addq	$32, %rdi
	movdqu	%xmm0, -16(%rdi)
	cmpq	%rdi, %rdx
	ja	1b
2:
	testb	$16, %sil
	je	3f
	movdqu	%xmm0, (%rdi)
	addq	$16, %rdi
3:
	testb	$8, %sil
	je	4f
	movq	$0, (%rdi)
	addq	$8, %rdi
4:
	testb	$4, %sil
	je	5f
	movl	$0, (%rdi)
	addq	$4, %rdi
5:
	testb	$2, %sil
	je	6f
	xorl	%edx, %edx
	movw	%dx, (%rdi)
	addq	$2, %rdi
6:
	testb	$1, %sil
	je	7f
	movb	$0, (%rdi)
7:
	ret
