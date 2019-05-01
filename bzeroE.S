#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_E)
CNAME(bzero_E):
	movq	%rsi, %rax
	cmpq	$15, %rsi
	ja	3f
	///
	/// Handle sizes from 0 to 15
	///
	xorq	%rdx, %rdx
	testb	$12, %al
	je	2f
	testb	$8, %al
	je	1f
	// Handle sizes from 8 to 15
	andb	$7, %al
	movq	%rdx, (%rdi)
	movq	%rdx, (%rdi, %rax)
	ret
	// Handle sizes from 4 to 7
1:	andb	$3, %al
	movl	%edx, (%rdi)
	movl	%edx, (%rdi, %rax)
	ret
	// Handle sizes from 0 to 3
2:	testb	$2, %al
	je	2f
	movw	%dx, (%rdi)
	addq	$2, %rdi
2:	testb	$1, %al
	je	2f
	movb	%dl, (%rdi)
2:	ret
	///
	/// Handle sizes from 16 and up
	///
3:	andq	$-128, %rsi
	addq	%rdi, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	cmpq	%rdi, %rsi
	jne	6f
	// Need to handle 2 cases here:
	// 1. sizes from 16 to 127;
	// 2. tails from 16 to 127.
4:	testb	$64, %al
	je	5f
	/// Take out a block of 64 bytes, this might leave a tail
	/// from 0 to 63 bytes.
	vmovdqu	%ymm0, (%rdi)
	addq	$64, %rdi
	vmovdqu	%ymm0, -32(%rdi)
	// Filter out tails from 16 to 63
	testb	$48, %al
	jne	5f
	// Handle tails from 0 to 15
	andq	$15, %rax
	vmovdqu	%xmm0, -16(%rdi, %rax)
	ret
5:	testb	$32, %al
	jne	5f
	// Handle sizes or tails from 16 to 31
	andq	$15, %rax
	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm0, (%rdi, %rax)
	ret
	// Handle sizes or tails from 32 to 63.
5:	andq	$31, %rax
	vmovdqu	%ymm0, (%rdi)
	vmovdqu	%ymm0, (%rdi, %rax)
	ret
	///
	/// For sizes from 128 and up take out blocks of 128 bytes.
	/// This might leave a tail from 0 to 127 bytes.
	///
6:	vmovdqu	%ymm0, (%rdi)
	addq	$128, %rdi
	vmovdqu	%ymm0, -96(%rdi)
	vmovdqu	%ymm0, -64(%rdi)
	vmovdqu	%ymm0, -32(%rdi)
	cmpq	%rdi, %rsi
	ja	6b
	// Filter out tails from 16 to 127
	testb	$112, %al
	jne	4b
	// Handle tails from 0 to 15
	andq	$15, %rax
	vmovdqu	%xmm0, -16(%rdi, %rax)
	ret
