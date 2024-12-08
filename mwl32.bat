@echo off
if not exist Build\NUL mkdir Build
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlprog.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlfeed.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlparse.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlp1mod.asm
jwasm -nologo /DDLLSUPPORT              -FoBuild\ src\wlp1lib.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlp2mod.asm
jwasm -nologo /DDLLSUPPORT              -FoBuild\ src\wlp2lib.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wltable.asm
jwasm -nologo /DDLLSUPPORT              -FoBuild\ src\wlp1res.asm
jwasm -nologo                           -FoBuild\ src\wlmain.asm
jwasm -nologo                           -FoBuild\ src\wlparcon.asm
jwasm -nologo                           -FoBuild\ src\wlsetup.asm
jwasm -nologo                           -FoBuild\ src\wlfile.asm
jwasm -nologo                           -FoBuild\ src\wlmemory.asm
jwasm -nologo                           -FoBuild\ src\wlconv.asm
jwasm -nologo                           -FoBuild\ src\wlbuffer.asm
jwasm -nologo                           -FoBuild\ src\wlp2res.asm
jwasm -nologo                           -FoBuild\ src\wlmap.asm
jwasm -nologo                           -FoBuild\ src\wlterm.asm
jwasm -nologo                           -FoBuild\ src\wlerror.asm
jwasm -nologo                           -FoBuild\ src\patchrel.asm
cd Build
wl32.exe /ex /m /cs @..\wl32.rsp
rem \msvc\bin\link /NON/MAP/NOLOGO @..\wl32.rsp;
rem jwlink.exe format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
