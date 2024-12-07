@echo off
if not exist Build\NUL mkdir Build
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlprog.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlfeed.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlparse.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlp1mod.asm
jwasm -nologo /DDLLSUPPORT              -FoBuild\ wlp1lib.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlp2mod.asm
jwasm -nologo /DDLLSUPPORT              -FoBuild\ wlp2lib.asm
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wltable.asm
jwasm -nologo /DDLLSUPPORT              -FoBuild\ wlp1res.asm
jwasm -nologo                           -FoBuild\ wlmain.asm
jwasm -nologo                           -FoBuild\ wlparcon.asm
jwasm -nologo                           -FoBuild\ wlsetup.asm
jwasm -nologo                           -FoBuild\ wlfile.asm
jwasm -nologo                           -FoBuild\ wlmemory.asm
jwasm -nologo                           -FoBuild\ wlconv.asm
jwasm -nologo                           -FoBuild\ wlbuffer.asm
jwasm -nologo                           -FoBuild\ wlp2res.asm
jwasm -nologo                           -FoBuild\ wlmap.asm
jwasm -nologo                           -FoBuild\ wlterm.asm
jwasm -nologo                           -FoBuild\ wlerror.asm
jwasm -nologo                           -FoBuild\ patchrel.asm
cd Build
wl32.exe /ex /m @..\wl32.rsp
rem \msvc\bin\link /NON/MAP/NOLOGO @..\wl32.rsp;
rem jwlink.exe format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
