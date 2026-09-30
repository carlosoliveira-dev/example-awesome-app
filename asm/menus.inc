.section .text,"x"

build_menus:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    call CreateMenu
    mov QWORD PTR [rbp - 8], rax
    call CreatePopupMenu
    mov QWORD PTR [rbp - 16], rax
    mov rcx, QWORD PTR [rbp - 16]
    mov edx, MF_STRING
    mov r8d, IDM_NEW
    lea r9, [rip + text_new]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 16]
    mov edx, MF_STRING
    mov r8d, IDM_OPEN
    lea r9, [rip + text_open]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 16]
    mov edx, MF_STRING
    mov r8d, IDM_SAVE
    lea r9, [rip + text_save]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 16]
    mov edx, MF_STRING
    mov r8d, IDM_SAVEAS
    lea r9, [rip + text_saveas]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 16]
    mov edx, MF_SEPARATOR
    xor r8d, r8d
    xor r9d, r9d
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 16]
    mov edx, MF_STRING
    mov r8d, IDM_EXIT
    lea r9, [rip + text_exit]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 8]
    mov edx, MF_POPUP
    mov r8, QWORD PTR [rbp - 16]
    lea r9, [rip + menu_file]
    call AppendMenuA

    call CreatePopupMenu
    mov QWORD PTR [rbp - 24], rax
    mov rcx, QWORD PTR [rbp - 24]
    mov edx, MF_STRING
    mov r8d, IDM_CUT
    lea r9, [rip + text_cut]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 24]
    mov edx, MF_STRING
    mov r8d, IDM_COPY
    lea r9, [rip + text_copy]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 24]
    mov edx, MF_STRING
    mov r8d, IDM_PASTE
    lea r9, [rip + text_paste]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 24]
    mov edx, MF_STRING
    mov r8d, IDM_SELECTALL
    lea r9, [rip + text_selectall]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 8]
    mov edx, MF_POPUP
    mov r8, QWORD PTR [rbp - 24]
    lea r9, [rip + menu_edit]
    call AppendMenuA

    call CreatePopupMenu
    mov QWORD PTR [rbp - 32], rax
    mov rcx, QWORD PTR [rbp - 32]
    mov edx, MF_STRING
    mov r8d, IDM_ABOUT
    lea r9, [rip + text_about]
    call AppendMenuA
    mov rcx, QWORD PTR [rbp - 8]
    mov edx, MF_POPUP
    mov r8, QWORD PTR [rbp - 32]
    lea r9, [rip + menu_help]
    call AppendMenuA

    mov rax, QWORD PTR [rbp - 8]
    add rsp, 128
    pop rbp
    ret
