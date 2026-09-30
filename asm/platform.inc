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
