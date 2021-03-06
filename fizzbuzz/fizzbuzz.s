.intel_syntax noprefix
.global main

.data

.text
main:
    mov rcx,1

loop1:

    call echocount

    # count % 3
    mov rdx,0 #割られる上位
    mov rax, rcx #割られる下位
    mov r15, 3 #割る数
    div r15
    cmp rdx, 0 #余りがrdx, 商rax
    jne skip1

    #print
    mov rdi, 0x04#文字数
    lea rsi, [fizz]
    call put

skip1:
    # count % 5
    mov rdx,0 #割られる上位
    mov rax, rcx #割られる下位
    mov r15, 5 #割る数
    div r15
    cmp rdx, 0 #余りがrdx, 商rax
    jne next

    #print
    mov rdi, 0x04#文字数
    lea rsi, [buzz]
    call put

next:
    #print
    mov rdi, 0x01 #文字数
    lea rsi, [newline]
    call put

    # for loop, count up
    inc rcx
    cmp rcx, 16
    je exit
    jmp loop1

exit:
    #exit
    mov rax, 0x3c
    syscall

fizz:
    .ascii "fizz"
buzz:
    .ascii "buzz"
newline:
    .ascii "\n"
nullbyte:
    .ascii "\0"

echocount:
    push rbp
    mov rbp, rsp

    mov r13, 0 #数字の桁数
    push [nullbyte]
    mov r11, rcx


    echocount_div_again:
    # カウンタの数字の下位の桁から数字文字列変換してスタックに積む
    inc r13
    mov rdx,0 #割られる上位
    mov rax, r11 #割られる下位
    mov r12, 10 #割る数
    div r12
    mov r11, rax #商 rax
    or rdx, 0x30 #余りrdxの数字をascii文字の数字に変換
    push rdx #余りrdx
    cmp rax, 0 #余りがrdx, 商 rax
    # 商がゼロでなければまだ桁が残っているためループする
    jne echocount_div_again

    # nullbyteがくるまでpopして数字を文字列に変換してヒープのアドレスにいれていく
    mov r10, 0
    mov rdi, r13 #文字数をrdiに入れてallocateで文字数分のメモリ確保
    call allocate
    mov r15, rax
    echocount_pop_loop:
    pop r12
    mov [r15+r10], r12
    inc r10
    cmp r12, [nullbyte]
    jne echocount_pop_loop

    #print
    mov rdi, r13 #文字数
    lea rsi, [r15]
    call put

    mov rsp, rbp
    pop rbp
    ret

allocate:
    push rbp
    mov rbp, rsp
    push rcx
    push r11

    push rdi #allocate呼び出し時の文字数

    # brk(0)でヒープの先頭アドレスを取得
    mov rdi, 0x00
    mov rax, 12 #sys_brk
    syscall

    # ヒープの先頭アドレスraxをスタックに入れてreturn前にraxに入れる
    # ヒープの先頭アドレスから文字数分、brkでメモリ確保
    pop rdi
    push rax
    add rax, rdi
    mov rdi, rax
    mov rax, 12 #sys_brk
    syscall
    pop rax

    pop r11
    pop rcx
    mov rsp, rbp
    pop rbp
    ret

put:
    push rbp
    mov rbp, rsp

    #print
    mov rdx, rdi #3 size
    # write syscall 第2引数rsiはputの呼び出しの第2引数で指定されているのでここでは指定しない
    #lea rsi, [rsp-0x70] #2 text
    mov rdi, 0x1 #1 fd
    mov rax, 0x1
    push rcx
    syscall
    pop rcx

    mov rsp, rbp
    pop rbp

