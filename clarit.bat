@echo off
if not exist BldClar\NUL mkdir BldClar
jwasm /nologo /DCLARION -FoBldClar\ wlprog.asm
jwasm /nologo /DCLARION -FoBldClar\ wlfeed.asm
jwasm /nologo /DCLARION -FoBldClar\ wlparse.asm
jwasm /nologo /DCLARION -FoBldClar\ wlp1mod.asm
jwasm /nologo /DCLARION -FoBldClar\ wlp1lib.asm
jwasm /nologo /DCLARION -FoBldClar\ wlp2mod.asm
jwasm /nologo /DCLARION -FoBldClar\ wlp2lib.asm
jwasm /nologo /DCLARION -FoBldClar\ wltable.asm
jwasm /nologo /DCLARION -FoBldClar\ wlp1res.asm
jwasm -nologo           -FoBldClar\ wlmain.asm
jwasm -nologo           -FoBldClar\ wlparcon.asm
jwasm -nologo           -FoBldClar\ wlsetup.asm
jwasm -nologo           -FoBldClar\ wlfile.asm
jwasm -nologo           -FoBldClar\ wlmemory.asm
jwasm -nologo           -FoBldClar\ wlconv.asm
jwasm -nologo           -FoBldClar\ wlbuffer.asm
jwasm -nologo           -FoBldClar\ wlp2res.asm
jwasm -nologo           -FoBldClar\ wlmap.asm
jwasm -nologo           -FoBldClar\ wlterm.asm
jwasm -nologo           -FoBldClar\ wlerror.asm
jwasm -nologo           -FoBldClar\ patchrel.asm
cd BldClar
jwlink format dos f {@..\wl32clar.rsp} n wl32.exe op q,m
cd ..
