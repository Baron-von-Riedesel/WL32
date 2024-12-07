@echo off
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlprog.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlfeed.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlparse.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlp1mod.asm
ml -c -nologo /DDLLSUPPORT              -FoBuild\ wlp1lib.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wlp2mod.asm
ml -c -nologo /DDLLSUPPORT              -FoBuild\ wlp2lib.asm
ml -c -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ wltable.asm
ml -c -nologo /DDLLSUPPORT              -FoBuild\ wlp1res.asm
ml -c -nologo                           -FoBuild\ wlmain.asm
ml -c -nologo                           -FoBuild\ wlparcon.asm
ml -c -nologo                           -FoBuild\ wlsetup.asm
ml -c -nologo                           -FoBuild\ wlfile.asm
ml -c -nologo                           -FoBuild\ wlmemory.asm
ml -c -nologo                           -FoBuild\ wlconv.asm
ml -c -nologo                           -FoBuild\ wlbuffer.asm
ml -c -nologo                           -FoBuild\ wlp2res.asm
ml -c -nologo                           -FoBuild\ wlmap.asm
ml -c -nologo                           -FoBuild\ wlterm.asm
ml -c -nologo                           -FoBuild\ wlerror.asm
ml -c -nologo                           -FoBuild\ patchrel.asm
cd Build
wl32.exe /ex /m @..\wl32.rsp
rem jwlink format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
