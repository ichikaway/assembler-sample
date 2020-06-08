.intel_syntax noprefix
.global main

.data
str:
  .ascii "000"

.text
main:
    mov rcx,1
    mov r14, 0x31

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
    add r14, 0x1
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

    # nullbyteがくるまでpopして数字を文字列に変換してstr変数のアドレスにいれていく
    pop r12
    #cmp r12, 0

    mov rdi, r13 #文字数
    mov [str], r12
    lea rsi, [str]
    call put

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
