.intel_syntax noprefix
.global main

.data

.text
main:
    mov rdi, 0x05 #文字数をrdiに入れてallocateで文字数分のメモリ確保
    call allocate
    mov r15, rax

exit:
    #exit
    mov rax, 0x3c
    syscall

allocate:
    push rbp
    mov rbp, rsp
    push rcx
    push r11

    # brk(0)でヒープの先頭アドレスを取得
    mov rdi, 0x00
    mov rax, 12 #sys_brk
    syscall
    mov r13, rax #ヒープの先頭アドレスをr13に入れる

    # ヒープの先頭アドレスから文字数分、brkでメモリ確保
    # 最小単位ページは4KBのためrax + 0x1000が確保される
    add rax, 0x05
    mov r12, rax #確保するアドレスをr12に入れる
    mov rdi, rax
    mov rax, 12 #sys_brk
    syscall

    # brk(0)でヒープのアドレスを取得
    mov rdi, 0x00
    mov rax, 12 #sys_brk
    syscall

    mov r14, 0x31
    mov [r13], r14
    mov r14, 0x32
    mov [r13+1], r14
    mov r14, 0x33
    mov [r13+2], r14
    #mov [r13+4080], r14
    mov [r13+4088], r14 #ここまで書き込み可能
    #mov [r13+4090], r14 #ここからsegmentation fault

    # 一度確保した領域にもう一度brkすると正常終了するようにみえる、なぜ？
    sub r12, 0x04
    mov rdi, r12 #確保したアドレスから４引いたところにもう一度確保できるか
    mov rax, 12 #sys_brk
    syscall

    # brk(0)でヒープのアドレスを取得
    mov rdi, 0x00
    mov rax, 12 #sys_brk
    syscall

    pop r11
    pop rcx
    mov rsp, rbp
    pop rbp
    ret

