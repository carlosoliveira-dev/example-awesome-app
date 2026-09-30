.intel_syntax noprefix

.equ WS_OVERLAPPEDWINDOW, 0x00cf0000
.equ WS_VISIBLE,           0x10000000
.equ WS_CHILD,             0x40000000
.equ WS_VSCROLL,           0x00200000
.equ WS_HSCROLL,           0x00100000
.equ ES_MULTILINE,         0x0004
.equ ES_AUTOVSCROLL,       0x0040
.equ ES_AUTOHSCROLL,       0x0080
.equ ES_NOHIDESEL,         0x0100
.equ WS_EX_CLIENTEDGE,     0x00000200
.equ WM_CREATE,            0x0001
.equ WM_DESTROY,           0x0002
.equ WM_SIZE,              0x0005
.equ WM_SETFOCUS,          0x0007
.equ WM_CLOSE,             0x0010
.equ WM_COMMAND,           0x0111
.equ WM_SETFONT,           0x0030
.equ WM_CUT,               0x0300
.equ WM_COPY,              0x0301
.equ WM_PASTE,             0x0302
.equ WM_SETTEXT,           0x000c
.equ EM_SETLIMITTEXT,      0x00c5
.equ EN_CHANGE,            0x0300
.equ IDM_NEW,              1001
.equ IDM_OPEN,             1002
.equ IDM_SAVE,             1003
.equ IDM_SAVEAS,           1004
.equ IDM_EXIT,             1005
.equ IDM_CUT,               1010
.equ IDM_COPY,              1011
.equ IDM_PASTE,             1012
.equ IDM_SELECTALL,         1013
.equ IDM_ABOUT,             1020
.equ MB_OK,                 0
.equ MB_ICONERROR,          0x10
.equ MB_ICONQUESTION,      0x20
.equ MB_YESNOCANCEL,       0x03
.equ OFN_OVERWRITEPROMPT,  0x00000002
.equ OFN_HIDEREADONLY,     0x00000004
.equ OFN_PATHMUSTEXIST,    0x00000800
.equ OFN_FILEMUSTEXIST,    0x00001000
.equ GENERIC_READ,         0x80000000
.equ GENERIC_WRITE,        0x40000000
.equ FILE_SHARE_READ,      0x00000001
.equ CREATE_ALWAYS,        2
.equ OPEN_EXISTING,        3
.equ FILE_ATTRIBUTE_NORMAL,0x00000080
.equ HEAP_ZERO_MEMORY,     8
.equ DEFAULT_GUI_FONT,     17
.equ WHITE_BRUSH,         0
.equ CS_VREDRAW,          1
.equ CS_HREDRAW,          2
.equ MF_STRING,           0
.equ MF_POPUP,            0x10
.equ MF_SEPARATOR,        0x800
.equ FVIRTKEY,            1
.equ FSHIFT,              4
.equ FCONTROL,            8

.section .rdata,"dr"
class_name:       .asciz "AssemblyNotepadWindow"
app_title:        .asciz "Assembly Notepad"
untitled_text:    .asciz "Untitled"
star_text:        .asciz "*"
title_suffix:    .asciz " - Assembly Notepad"
filter_text:
                  .asciz "Text files (*.txt)"
                  .asciz "*.txt"
                  .asciz "All files (*.*)"
                  .asciz "*.*"
                  .byte 0
default_extension:.asciz "txt"
menu_file:        .asciz "&File"
menu_edit:        .asciz "&Edit"
menu_help:        .asciz "&Help"
text_new:         .asciz "&New\tCtrl+N"
text_open:        .asciz "&Open...\tCtrl+O"
text_save:        .asciz "&Save\tCtrl+S"
text_saveas:      .asciz "Save &As...\tCtrl+Shift+S"
text_exit:        .asciz "E&xit"
text_cut:         .asciz "Cu&t"
text_copy:        .asciz "&Copy"
text_paste:       .asciz "&Paste"
text_selectall:   .asciz "Select &All\tCtrl+A"
text_about:       .asciz "&About"
confirm_text:     .asciz "Save changes to this document?"
confirm_title:    .asciz "Unsaved changes"
error_open:       .asciz "The file could not be opened."
error_save:       .asciz "The file could not be saved."
error_title:      .asciz "Assembly Notepad"
about_text:       .asciz "Assembly Notepad\r\nA small Windows text editor written in x86-64 Assembly."
edit_class:       .asciz "EDIT"

.section .data,"dw"
.align 8
instance_handle:  .quad 0
main_window:      .quad 0
edit_window:      .quad 0
accelerators:     .quad 0
menu_handle:      .quad 0
is_dirty:         .long 0
current_path:     .zero 260
dialog_path:      .zero 260
title_buffer:     .zero 600
window_class:     .zero 80
open_file_dialog: .zero 152
read_count:       .long 0
write_count:      .long 0

.align 2
accelerator_entries:
    .byte FVIRTKEY | FCONTROL
    .byte 0
    .short 'N', IDM_NEW
    .byte FVIRTKEY | FCONTROL
    .byte 0
    .short 'O', IDM_OPEN
    .byte FVIRTKEY | FCONTROL
    .byte 0
    .short 'S', IDM_SAVE
    .byte FVIRTKEY | FCONTROL | FSHIFT
    .byte 0
    .short 'S', IDM_SAVEAS
    .byte FVIRTKEY | FCONTROL
    .byte 0
    .short 'A', IDM_SELECTALL

.section .text,"x"
.globl main
.extern GetModuleHandleA
.extern RegisterClassExA
.extern LoadCursorA
.extern GetStockObject
.extern CreateWindowExA
.extern CreateMenu
.extern CreatePopupMenu
.extern AppendMenuA
.extern CreateAcceleratorTableA
.extern GetMessageA
.extern TranslateAcceleratorA
.extern TranslateMessage
.extern DispatchMessageA
.extern DefWindowProcA
.extern PostQuitMessage
.extern MoveWindow
.extern SendMessageA
.extern SetFocus
.extern MessageBoxA
.extern DestroyWindow
.extern GetOpenFileNameA
.extern GetSaveFileNameA
.extern CreateFileA
.extern ReadFile
.extern WriteFile
.extern GetFileSize
.extern CloseHandle
.extern GetProcessHeap
.extern HeapAlloc
.extern HeapFree
.extern GetWindowTextLengthA
.extern GetWindowTextA
.extern SetWindowTextA
.extern lstrcpyA
.extern lstrcatA

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

.section .rdata,"dr"
empty_text: .asciz ""
.section .text,"x"

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
