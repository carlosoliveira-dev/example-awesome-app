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
