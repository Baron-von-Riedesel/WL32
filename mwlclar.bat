@echo off
if not exist BldClar\NUL mkdir BldClar
jwasm /nologo /DCLARION -FoBldClar\ src\wlprog.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlfeed.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlparse.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlp1mod.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlp1lib.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlp2mod.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlp2lib.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wltable.asm
jwasm /nologo /DCLARION -FoBldClar\ src\wlp1res.asm
jwasm -nologo           -FoBldClar\ src\wlmain.asm
jwasm -nologo           -FoBldClar\ src\wlparcon.asm
jwasm -nologo           -FoBldClar\ src\wlsetup.asm
jwasm -nologo           -FoBldClar\ src\wlfile.asm
jwasm -nologo           -FoBldClar\ src\wlmemory.asm
jwasm -nologo           -FoBldClar\ src\wlconv.asm
jwasm -nologo           -FoBldClar\ src\wlbuffer.asm
jwasm -nologo           -FoBldClar\ src\wlp2res.asm
jwasm -nologo           -FoBldClar\ src\wlmap.asm
jwasm -nologo           -FoBldClar\ src\wlterm.asm
jwasm -nologo           -FoBldClar\ src\wlerror.asm
jwasm -nologo           -FoBldClar\ src\patchrel.asm
cd BldClar
wl32.exe /ex /m /cs @..\wl32clar.rsp
rem jwlink format dos f {@..\wl32claj.rsp} n wl32.exe op q,m
cd ..
