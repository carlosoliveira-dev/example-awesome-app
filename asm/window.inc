.section .text,"x"

window_proc:
    push rbp
    mov rbp, rsp
    sub rsp, 96
    mov QWORD PTR [rbp - 8], rcx
    mov DWORD PTR [rbp - 16], edx
    mov QWORD PTR [rbp - 24], r8
    mov QWORD PTR [rbp - 32], r9

    cmp DWORD PTR [rbp - 16], WM_CREATE
    je .wm_create
    cmp DWORD PTR [rbp - 16], WM_SIZE
    je .wm_size
    cmp DWORD PTR [rbp - 16], WM_SETFOCUS
    je .wm_focus
    cmp DWORD PTR [rbp - 16], WM_COMMAND
    je .wm_command
    cmp DWORD PTR [rbp - 16], WM_CLOSE
    je .wm_close
    cmp DWORD PTR [rbp - 16], WM_DESTROY
    je .wm_destroy
    jmp .wm_default

.wm_create:
    mov ecx, WS_EX_CLIENTEDGE
    lea rdx, [rip + edit_class]
    xor r8d, r8d
    mov r9d, WS_CHILD | WS_VISIBLE | WS_VSCROLL | WS_HSCROLL | ES_MULTILINE | ES_AUTOVSCROLL | ES_AUTOHSCROLL | ES_NOHIDESEL
    mov QWORD PTR [rsp + 32], 0
    mov QWORD PTR [rsp + 40], 0
    mov QWORD PTR [rsp + 48], 0
    mov QWORD PTR [rsp + 56], 0
    mov rax, QWORD PTR [rbp - 8]
    mov QWORD PTR [rsp + 64], rax
    mov QWORD PTR [rsp + 72], 1
    mov rax, QWORD PTR [rip + instance_handle]
    mov QWORD PTR [rsp + 80], rax
    mov QWORD PTR [rsp + 88], 0
    call CreateWindowExA
    mov QWORD PTR [rip + edit_window], rax
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, WM_SETFONT
    xor r8d, r8d
    mov ecx, DEFAULT_GUI_FONT
    call GetStockObject
    mov r8, rax
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, WM_SETFONT
    mov r9d, 1
    call SendMessageA
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, EM_SETLIMITTEXT
    mov r8d, 0x7ffffffe
    xor r9d, r9d
    call SendMessageA
    xor eax, eax
    jmp .wm_return

.wm_size:
    mov rcx, QWORD PTR [rip + edit_window]
    xor edx, edx
    xor r8d, r8d
    mov r9d, DWORD PTR [rbp - 32]
    and r9d, 0xffff
    mov eax, DWORD PTR [rbp - 32]
    shr eax, 16
    mov DWORD PTR [rsp + 32], eax
    mov QWORD PTR [rsp + 40], 1
    call MoveWindow
    xor eax, eax
    jmp .wm_return

.wm_focus:
    mov rcx, QWORD PTR [rip + edit_window]
    call SetFocus
    xor eax, eax
    jmp .wm_return

.wm_command:
    mov eax, DWORD PTR [rbp - 24]
    and eax, 0xffff
    cmp eax, IDM_NEW
    je .command_new
    cmp eax, IDM_OPEN
    je .command_open
    cmp eax, IDM_SAVE
    je .command_save
    cmp eax, IDM_SAVEAS
    je .command_saveas
    cmp eax, IDM_EXIT
    je .command_exit
    cmp eax, IDM_CUT
    je .command_cut
    cmp eax, IDM_COPY
    je .command_copy
    cmp eax, IDM_PASTE
    je .command_paste
    cmp eax, IDM_SELECTALL
    je .command_selectall
    cmp eax, IDM_ABOUT
    je .command_about
    cmp eax, 1
    jne .wm_default
    mov eax, DWORD PTR [rbp - 24]
    shr eax, 16
    cmp eax, EN_CHANGE
    jne .wm_default
    mov DWORD PTR [rip + is_dirty], 1
    call update_title
    xor eax, eax
    jmp .wm_return
.command_new:
    call new_document
    xor eax, eax
    jmp .wm_return
.command_open:
    call open_document
    xor eax, eax
    jmp .wm_return
.command_save:
    xor ecx, ecx
    call save_document
    xor eax, eax
    jmp .wm_return
.command_saveas:
    mov ecx, 1
    call save_document
    xor eax, eax
    jmp .wm_return
.command_exit:
    mov rcx, QWORD PTR [rbp - 8]
    mov edx, WM_CLOSE
    xor r8d, r8d
    xor r9d, r9d
    call SendMessageA
    xor eax, eax
    jmp .wm_return
.command_cut:
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, WM_CUT
    xor r8d, r8d
    xor r9d, r9d
    call SendMessageA
    xor eax, eax
    jmp .wm_return
.command_copy:
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, WM_COPY
    xor r8d, r8d
    xor r9d, r9d
    call SendMessageA
    xor eax, eax
    jmp .wm_return
.command_paste:
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, WM_PASTE
    xor r8d, r8d
    xor r9d, r9d
    call SendMessageA
    xor eax, eax
    jmp .wm_return
.command_selectall:
    mov rcx, QWORD PTR [rip + edit_window]
    mov edx, 0x00b1
    xor r8d, r8d
    mov r9d, -1
    call SendMessageA
    xor eax, eax
    jmp .wm_return
.command_about:
    mov rcx, QWORD PTR [rbp - 8]
    lea rdx, [rip + about_text]
    lea r8, [rip + app_title]
    mov r9d, MB_OK
    call MessageBoxA
    xor eax, eax
    jmp .wm_return

.wm_close:
    call confirm_save
    test eax, eax
    jz .wm_handled
    mov rcx, QWORD PTR [rbp - 8]
    call DestroyWindow
.wm_handled:
    xor eax, eax
    jmp .wm_return
.wm_destroy:
    xor ecx, ecx
    call PostQuitMessage
    xor eax, eax
    jmp .wm_return
.wm_default:
    mov rcx, QWORD PTR [rbp - 8]
    mov edx, DWORD PTR [rbp - 16]
    mov r8, QWORD PTR [rbp - 24]
    mov r9, QWORD PTR [rbp - 32]
    call DefWindowProcA
.wm_return:
    add rsp, 96
    pop rbp
    ret
