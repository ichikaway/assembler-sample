	.file	"test1.c"
	.intel_syntax noprefix
	.text
	.globl	hoge
	.type	hoge, @function
hoge:
.LFB5:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	mov	eax, 11
	pop	rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	hoge, .-hoge
	.globl	main
	.type	main, @function
main:
.LFB6:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp
	.cfi_def_cfa_register 6
	sub	rsp, 16
	mov	DWORD PTR -8[rbp], 10
	mov	eax, DWORD PTR -8[rbp]
	mov	DWORD PTR -4[rbp], eax
	mov	eax, 0
	call	hoge
	mov	edi, 0
	call	exit@PLT
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
