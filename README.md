# Assembly Notepad

Um editor de texto para Windows x64, escrito em Assembly GNU (sintaxe Intel) e usando a API Win32.

## Compilar e executar

1. Instale o GCC MinGW-w64 x64, por exemplo, pelo ambiente MSYS2 UCRT64.
2. Abra o Prompt de Comando nesta pasta e execute `build.bat`.
3. Execute `AssemblyNotepad.exe`.

Também e possivel compilar diretamente:

```bat
gcc -mwindows -o AssemblyNotepad.exe notepad.S -lcomdlg32 -luser32 -lgdi32
```

## Recursos

- Criar, abrir, editar e salvar arquivos de texto.
- Salvar como, com confirmacao antes de sobrescrever.
- Aviso para salvar alteracoes ao abrir outro arquivo, criar um documento ou sair.
- Menus de edicao, selecao de texto, copiar/colar e atalhos de teclado.
- O texto e lido e gravado usando a pagina de codigo ANSI ativa do Windows.
