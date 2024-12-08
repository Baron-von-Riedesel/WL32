@echo off
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlprog.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlfeed.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlparse.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlp1mod.asm
ml -c -nologo /DDLLSUPPORT              -FoBuild\ src\wlp1lib.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wlp2mod.asm
ml -c -nologo /DDLLSUPPORT              -FoBuild\ src\wlp2lib.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\wltable.asm
ml -c -nologo /DDLLSUPPORT              -FoBuild\ src\wlp1res.asm
ml -c -nologo                           -FoBuild\ src\wlmain.asm
ml -c -nologo                           -FoBuild\ src\wlparcon.asm
ml -c -nologo                           -FoBuild\ src\wlsetup.asm
ml -c -nologo                           -FoBuild\ src\wlfile.asm
ml -c -nologo                           -FoBuild\ src\wlmemory.asm
ml -c -nologo                           -FoBuild\ src\wlconv.asm
ml -c -nologo                           -FoBuild\ src\wlbuffer.asm
ml -c -nologo                           -FoBuild\ src\wlp2res.asm
ml -c -nologo                           -FoBuild\ src\wlmap.asm
ml -c -nologo                           -FoBuild\ src\wlterm.asm
ml -c -nologo                           -FoBuild\ src\wlerror.asm
ml -c -nologo                           -FoBuild\ src\patchrel.asm
cd Build
wl32.exe /ex /m /cs @..\wl32.rsp
rem jwlink format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
