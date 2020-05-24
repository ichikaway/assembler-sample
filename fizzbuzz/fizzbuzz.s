.intel_syntax noprefix
.global main

main:
    mov rcx,1
    mov r14, 0x31

loop1:
    #print
    mov rdx, 0x1 #3 size

    mov r11, rsp
    sub r11, 0x60
    mov [r11], r14
    lea rsi, [r11] #2 text

    mov rdi, 0x1 #1 fd
    mov rax, 0x1
    push rcx
    syscall
    pop rcx


    # count % 3
    mov rdx,0 #割られる上位
    mov rax, rcx #割られる下位
    mov r15, 3 #割る数
    div r15
    cmp rdx, 0 #余りがrdx, 答えrax
    jne skip1

    #print
    mov rdx, 0x4 #3 size
    lea rsi, [fizz] #2 text
    mov rdi, 0x1 #1 fd
    mov rax, 0x1
    push rcx
    syscall
    pop rcx

skip1:
    # count % 5
    mov rdx,0 #割られる上位
    mov rax, rcx #割られる下位
    mov r15, 5 #割る数
    div r15
    cmp rdx, 0 #余りがrdx, 答えrax
    jne next

    #print
    mov rdx, 0x4 #3 size
    lea rsi, [buzz] #2 text
    mov rdi, 0x1 #1 fd
    mov rax, 0x1
    push rcx
    syscall
    pop rcx


next:
    #print
    mov rdx, 0x1 #3 size
    lea rsi, [newline] #2 text
    mov rdi, 0x1 #1 fd
    mov rax, 0x1
    push rcx
    syscall
    pop rcx

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
