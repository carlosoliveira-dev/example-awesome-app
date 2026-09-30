@echo off
setlocal

where gcc >nul 2>nul
if errorlevel 1 (
    echo GCC was not found. Install the MSYS2 UCRT64 MinGW-w64 toolchain and add it to PATH.
    exit /b 1
)

gcc -mwindows -o AssemblyNotepad.exe notepad.S -lcomdlg32 -luser32 -lgdi32
if errorlevel 1 (
    echo Build failed.
    exit /b 1
)

echo Built AssemblyNotepad.exe
