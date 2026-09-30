.section .text,"x"
.globl main

main:
    push rbp
    mov rbp, rsp
    sub rsp, 128

    xor ecx, ecx
    call GetModuleHandleA
    mov QWORD PTR [rip + instance_handle], rax

    mov DWORD PTR [rip + window_class], 80
    mov DWORD PTR [rip + window_class + 4], CS_HREDRAW | CS_VREDRAW
    lea rax, [rip + window_proc]
    mov QWORD PTR [rip + window_class + 8], rax
    mov QWORD PTR [rip + window_class + 24], 0
    mov rax, QWORD PTR [rip + instance_handle]
    mov QWORD PTR [rip + window_class + 24], rax
    xor ecx, ecx
    mov edx, 32512
    call LoadCursorA
    mov QWORD PTR [rip + window_class + 40], rax
    xor ecx, ecx
    call GetStockObject
    mov QWORD PTR [rip + window_class + 48], rax
    lea rax, [rip + class_name]
    mov QWORD PTR [rip + window_class + 64], rax
    mov QWORD PTR [rip + window_class + 72], 0
    lea rcx, [rip + window_class]
    call RegisterClassExA
    test ax, ax
    jz .main_error

    call build_menus
    mov QWORD PTR [rip + menu_handle], rax
    mov DWORD PTR [rip + open_file_dialog], 152
    lea rcx, [rip + accelerator_entries]
    mov edx, 5
    call CreateAcceleratorTableA
    mov QWORD PTR [rip + accelerators], rax

    xor ecx, ecx
    lea rdx, [rip + class_name]
    lea r8, [rip + app_title]
    mov r9d, WS_OVERLAPPEDWINDOW | WS_VISIBLE
    mov DWORD PTR [rsp + 32], 0x80000000
    mov DWORD PTR [rsp + 40], 0x80000000
    mov QWORD PTR [rsp + 48], 900
    mov QWORD PTR [rsp + 56], 600
    mov QWORD PTR [rsp + 64], 0
    mov rax, QWORD PTR [rip + menu_handle]
    mov QWORD PTR [rsp + 72], rax
    mov rax, QWORD PTR [rip + instance_handle]
    mov QWORD PTR [rsp + 80], rax
    mov QWORD PTR [rsp + 88], 0
    call CreateWindowExA
    test rax, rax
    jz .main_error
    mov QWORD PTR [rip + main_window], rax

.message_loop:
    lea rcx, [rbp - 64]
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    call GetMessageA
    test eax, eax
    jz .main_done
    js .main_done
    mov rcx, QWORD PTR [rip + main_window]
    mov rdx, QWORD PTR [rip + accelerators]
    lea r8, [rbp - 64]
    call TranslateAcceleratorA
    test eax, eax
    jnz .message_loop
    lea rcx, [rbp - 64]
    call TranslateMessage
    lea rcx, [rbp - 64]
    call DispatchMessageA
    jmp .message_loop

.main_error:
    xor ecx, ecx
    lea rdx, [rip + error_save]
    lea r8, [rip + error_title]
    mov r9d, MB_OK | MB_ICONERROR
    call MessageBoxA
    mov eax, 1
    jmp .main_return
.main_done:
    xor eax, eax
.main_return:
    add rsp, 128
    pop rbp
    ret
