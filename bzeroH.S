#ifdef __APPLE__
# define ALIGN .align 4,0x90
# define CNAME(name) _##name
#else
# define ALIGN .align 16,0x90
# define CNAME(name) name
#endif

	.text
	ALIGN
	.globl CNAME(bzero_H)
CNAME(bzero_H):
	// Keep the size in RAX as there is a lot of TESTB ops below and
	// 	testb $imm, %al   ; is encoded with 2 bytes
	// 	testb $imm, %sil  ; is encoded with 4 bytes
	movq	%rsi, %rax
	cmpq	$15, %rsi
	jbe	1f
	///
	/// Handle sizes from 16 and up.
	///
3:	andq	$-32, %rsi
	vpxor	%xmm0, %xmm0, %xmm0
	je	6f
	addq	%rdi, %rsi
	testb	$32, %al
	je	4f
	// Take out a block of 32 bytes, this might leave a tail
	// from 0 to 31 bytes.
	addq	$32, %rdi
	jmp	5f
	// Take out blocks of 64 bytes.
4:	vmovdqu	%ymm0, (%rdi)
	addq	$64, %rdi
5:	vmovdqu	%ymm0, -32(%rdi)
	cmpq	%rdi, %rsi
	ja	4b
	andq	$31, %rax
	// Handle tails from 0 to 31.
	vmovdqu	%ymm0, -32(%rdi, %rax)
	ret
	// Handle sizes from 16 to 31.
	ALIGN
6:	vmovdqu	%xmm0, (%rdi)
	vmovdqu	%xmm0, -16(%rdi, %rax)
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
	movq	%rdx, (%rdi)
	movq	%rdx, -8(%rdi, %rax)
	ret
	// Handle sizes from 4 to 7.
1:	movl	%edx, (%rdi)
	movl	%edx, -4(%rdi, %rax)
	ret
	// Handle sizes from 0 to 3.
2:	testb	$2, %al
	je	2f
	movw	%dx, (%rdi)
	movw	%dx, -2(%rdi, %rax)
	ret
2:	testb	$1, %al
	je	2f
	movb	%dl, (%rdi)
2:	ret

