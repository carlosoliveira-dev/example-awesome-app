.section .text,"x"

update_title:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    lea rax, [rip + current_path]
    cmp BYTE PTR [rax], 0
    jne .title_find_base
    lea rax, [rip + untitled_text]
    jmp .title_copy
.title_find_base:
    mov QWORD PTR [rbp - 8], rax
    mov QWORD PTR [rbp - 16], rax
.title_scan:
    mov rax, QWORD PTR [rbp - 16]
    mov dl, BYTE PTR [rax]
    test dl, dl
    jz .title_base_found
    cmp dl, 92
    je .title_advance_base
    cmp dl, '/'
    jne .title_next
.title_advance_base:
    lea rdx, [rax + 1]
    mov QWORD PTR [rbp - 8], rdx
.title_next:
    inc QWORD PTR [rbp - 16]
    jmp .title_scan
.title_base_found:
    mov rax, QWORD PTR [rbp - 8]
.title_copy:
    lea rcx, [rip + title_buffer]
    mov rdx, rax
    cmp BYTE PTR [rip + current_path], 0
    jne .title_use_base
    lea rdx, [rip + untitled_text]
.title_use_base:
    call lstrcpyA
    cmp DWORD PTR [rip + is_dirty], 0
    je .title_suffix
    lea rcx, [rip + title_buffer]
    lea rdx, [rip + star_text]
    call lstrcatA
.title_suffix:
    lea rcx, [rip + title_buffer]
    lea rdx, [rip + title_suffix]
    call lstrcatA
    mov rcx, QWORD PTR [rip + main_window]
    lea rdx, [rip + title_buffer]
    call SetWindowTextA
    add rsp, 48
    pop rbp
    ret

confirm_save:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    cmp DWORD PTR [rip + is_dirty], 0
    je .confirm_yes
    mov rcx, QWORD PTR [rip + main_window]
    lea rdx, [rip + confirm_text]
    lea r8, [rip + confirm_title]
    mov r9d, MB_YESNOCANCEL | MB_ICONQUESTION
    call MessageBoxA
    cmp eax, 6
    je .confirm_save_yes
    cmp eax, 7
    je .confirm_yes
    xor eax, eax
    jmp .confirm_return
.confirm_save_yes:
    xor ecx, ecx
    call save_document
    jmp .confirm_return
.confirm_yes:
    mov eax, 1
.confirm_return:
    add rsp, 48
    pop rbp
    ret

new_document:
    push rbp
    mov rbp, rsp
    sub rsp, 48
    call confirm_save
    test eax, eax
    jz .new_return
    mov BYTE PTR [rip + current_path], 0
    mov DWORD PTR [rip + is_dirty], 0
    mov rcx, QWORD PTR [rip + edit_window]
    lea rdx, [rip + empty_text]
    call SetWindowTextA
    call update_title
.new_return:
    add rsp, 48
    pop rbp
    ret

open_document:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    call confirm_save
    test eax, eax
    jz .open_return

    mov DWORD PTR [rip + open_file_dialog], 152
    mov rax, QWORD PTR [rip + main_window]
    mov QWORD PTR [rip + open_file_dialog + 8], rax
    lea rax, [rip + filter_text]
    mov QWORD PTR [rip + open_file_dialog + 24], rax
    mov DWORD PTR [rip + open_file_dialog + 44], 1
    lea rcx, [rip + dialog_path]
    mov BYTE PTR [rcx], 0
    lea rax, [rip + dialog_path]
    mov QWORD PTR [rip + open_file_dialog + 48], rax
    mov DWORD PTR [rip + open_file_dialog + 56], 260
    mov QWORD PTR [rip + open_file_dialog + 64], 0
    mov DWORD PTR [rip + open_file_dialog + 72], 0
    mov DWORD PTR [rip + open_file_dialog + 96], OFN_FILEMUSTEXIST | OFN_PATHMUSTEXIST | OFN_HIDEREADONLY
    lea rcx, [rip + open_file_dialog]
    call GetOpenFileNameA
    test eax, eax
    jz .open_return

    lea rcx, [rip + dialog_path]
    mov edx, GENERIC_READ
    mov r8d, FILE_SHARE_READ
    xor r9d, r9d
    mov DWORD PTR [rsp + 32], OPEN_EXISTING
    mov DWORD PTR [rsp + 40], FILE_ATTRIBUTE_NORMAL
    mov QWORD PTR [rsp + 48], 0
    call CreateFileA
    cmp rax, -1
    je .open_error
    mov QWORD PTR [rbp - 8], rax
    mov rcx, rax
    mov DWORD PTR [rbp - 16], 0
    lea rdx, [rbp - 16]
    call GetFileSize
    cmp DWORD PTR [rbp - 16], 0
    jne .open_close_error
    cmp eax, -1
    je .open_close_error
    mov DWORD PTR [rbp - 20], eax
    inc eax
    mov DWORD PTR [rbp - 24], eax
    call GetProcessHeap
    mov rcx, rax
    mov edx, HEAP_ZERO_MEMORY
    mov r8d, DWORD PTR [rbp - 24]
    call HeapAlloc
    test rax, rax
    jz .open_close_error
    mov QWORD PTR [rbp - 32], rax
    mov rcx, QWORD PTR [rbp - 8]
    mov rdx, rax
    mov r8d, DWORD PTR [rbp - 20]
    lea r9, [rip + read_count]
    mov QWORD PTR [rsp + 32], 0
    call ReadFile
    test eax, eax
    jz .open_free_error
    mov eax, DWORD PTR [rip + read_count]
    cmp eax, DWORD PTR [rbp - 20]
    jne .open_free_error
    mov eax, DWORD PTR [rip + read_count]
    mov rdx, QWORD PTR [rbp - 32]
    mov BYTE PTR [rdx + rax], 0
    lea rcx, [rip + current_path]
    lea rdx, [rip + dialog_path]
    call lstrcpyA
    mov rcx, QWORD PTR [rip + edit_window]
    mov rdx, QWORD PTR [rbp - 32]
    call SetWindowTextA
    mov rcx, QWORD PTR [rbp - 8]
    call CloseHandle
    call GetProcessHeap
    mov rcx, rax
    xor edx, edx
    mov r8, QWORD PTR [rbp - 32]
    call HeapFree
    mov DWORD PTR [rip + is_dirty], 0
    call update_title
    jmp .open_return

.open_free_error:
    call GetProcessHeap
    mov rcx, rax
    xor edx, edx
    mov r8, QWORD PTR [rbp - 32]
    call HeapFree
.open_close_error:
    mov rcx, QWORD PTR [rbp - 8]
    call CloseHandle
.open_error:
    mov rcx, QWORD PTR [rip + main_window]
    lea rdx, [rip + error_open]
    lea r8, [rip + error_title]
    mov r9d, MB_OK | MB_ICONERROR
    call MessageBoxA
.open_return:
    add rsp, 128
    pop rbp
    ret

save_document:
    push rbp
    mov rbp, rsp
    sub rsp, 160
    mov DWORD PTR [rbp - 4], ecx
    lea rcx, [rip + dialog_path]
    lea rdx, [rip + current_path]
    call lstrcpyA
    cmp DWORD PTR [rbp - 4], 0
    jne .save_dialog
    cmp BYTE PTR [rip + current_path], 0
    jne .save_to_disk
.save_dialog:
    mov DWORD PTR [rip + open_file_dialog], 152
    mov rax, QWORD PTR [rip + main_window]
    mov QWORD PTR [rip + open_file_dialog + 8], rax
    lea rax, [rip + filter_text]
    mov QWORD PTR [rip + open_file_dialog + 24], rax
    mov DWORD PTR [rip + open_file_dialog + 44], 1
    lea rax, [rip + dialog_path]
    mov QWORD PTR [rip + open_file_dialog + 48], rax
    mov DWORD PTR [rip + open_file_dialog + 56], 260
    mov QWORD PTR [rip + open_file_dialog + 64], 0
    mov DWORD PTR [rip + open_file_dialog + 72], 0
    mov DWORD PTR [rip + open_file_dialog + 96], OFN_PATHMUSTEXIST | OFN_HIDEREADONLY
    or DWORD PTR [rip + open_file_dialog + 96], OFN_OVERWRITEPROMPT
.save_dialog_open:
    lea rax, [rip + default_extension]
    mov QWORD PTR [rip + open_file_dialog + 104], rax
    lea rcx, [rip + open_file_dialog]
    call GetSaveFileNameA
    test eax, eax
    jz .save_fail_no_message

.save_to_disk:
    mov rcx, QWORD PTR [rip + edit_window]
    call GetWindowTextLengthA
    mov DWORD PTR [rbp - 20], eax
    call GetProcessHeap
    mov rcx, rax
    mov edx, HEAP_ZERO_MEMORY
    mov r8d, DWORD PTR [rbp - 20]
    inc r8d
    call HeapAlloc
    test rax, rax
    jz .save_error
    mov QWORD PTR [rbp - 32], rax
    mov rcx, QWORD PTR [rip + edit_window]
    mov rdx, rax
    mov r8d, DWORD PTR [rbp - 20]
    inc r8d
    call GetWindowTextA

    lea rcx, [rip + dialog_path]
    mov edx, GENERIC_WRITE
    xor r8d, r8d
    xor r9d, r9d
    mov DWORD PTR [rsp + 32], CREATE_ALWAYS
    mov DWORD PTR [rsp + 40], FILE_ATTRIBUTE_NORMAL
    mov QWORD PTR [rsp + 48], 0
    call CreateFileA
    cmp rax, -1
    je .save_open_error
    mov QWORD PTR [rbp - 16], rax
    mov rcx, QWORD PTR [rbp - 16]
    mov rdx, QWORD PTR [rbp - 32]
    mov r8d, DWORD PTR [rbp - 20]
    lea r9, [rip + write_count]
    mov QWORD PTR [rsp + 32], 0
    call WriteFile
    test eax, eax
    jz .save_free_error
    mov eax, DWORD PTR [rip + write_count]
    cmp eax, DWORD PTR [rbp - 20]
    jne .save_free_error
    mov rcx, QWORD PTR [rbp - 16]
    call CloseHandle
    call GetProcessHeap
    mov rcx, rax
    xor edx, edx
    mov r8, QWORD PTR [rbp - 32]
    call HeapFree
    lea rcx, [rip + current_path]
    lea rdx, [rip + dialog_path]
    call lstrcpyA
    mov DWORD PTR [rip + is_dirty], 0
    call update_title
    mov eax, 1
    jmp .save_return

.save_free_error:
    call GetProcessHeap
    mov rcx, rax
    xor edx, edx
    mov r8, QWORD PTR [rbp - 32]
    call HeapFree
.save_close_error:
    mov rcx, QWORD PTR [rbp - 16]
    call CloseHandle
    jmp .save_error
.save_open_error:
    call GetProcessHeap
    mov rcx, rax
    xor edx, edx
    mov r8, QWORD PTR [rbp - 32]
    call HeapFree
.save_error:
    mov rcx, QWORD PTR [rip + main_window]
    lea rdx, [rip + error_save]
    lea r8, [rip + error_title]
    mov r9d, MB_OK | MB_ICONERROR
    call MessageBoxA
    xor eax, eax
    jmp .save_return
.save_fail_no_message:
    xor eax, eax
.save_return:
    add rsp, 160
    pop rbp
    ret
