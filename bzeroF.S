#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_F)
CNAME(bzero_F):
	movq	%rsi, %rax
	cmpq	$15, %rsi
	jbe	1f
	///
	/// Handle sizes from 16 and up.
	///
3:	andq	$-64, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	je	6f
	addq	%rdi, %rsi
	testb	$64, %al
	je	4f
	// Take out a block of 64 bytes, this might leave a tail
	// from 0 to 63 bytes.
	addq	$64, %rdi
	jmp	5f
	// Take out blocks of 128 bytes.
	ALIGN
4:	vmovdqu	%ymm0, (%rdi)
	addq	$128, %rdi
	vmovdqu	%ymm0, -96(%rdi)
5:	vmovdqu	%ymm0, -64(%rdi)
	vmovdqu	%ymm0, -32(%rdi)
	cmpq	%rdi, %rsi
	ja	4b
	testb	$32, %al
	jne	7f
	// Handle tails from 0 to 31.
	andq	$31, %rax
	vmovdqu	%ymm0, -32(%rdi, %rax)
	ret
	ALIGN
6:	testb	$32, %al
	jne	7f
	// Handle sizes from 16 to 31.
	andb	$15, %al
	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm0, (%rdi, %rax)
	ret
	// Handle sizes and tails from 32 to 63.
7:	andq	$31, %rax
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, (%rdi, %rax)
	ret
	///
	/// Handle sizes from 0 to 15.
	///
	ALIGN
1:	xorq	%rdx, %rdx
	testb	$12, %al
	je	2f
	testb	$8, %al
	je	1f
	// Handle sizes from 8 to 15.
	andb	$7, %al
	movq	%rdx, (%rdi)
	movq	%rdx, (%rdi, %rax)
	ret
	// Handle sizes from 4 to 7.
1:	andb	$3, %al
	movl	%edx, (%rdi)
	movl	%edx, (%rdi, %rax)
	ret
	// Handle sizes from 0 to 3.
2:	testb	$2, %al
	je	2f
	movw	%dx, (%rdi)
	addq	$2, %rdi
2:	testb	$1, %al
	je	2f
	movb	%dl, (%rdi)
2:	ret
