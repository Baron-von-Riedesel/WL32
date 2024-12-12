@echo off
if not exist BldClar\NUL mkdir BldClar
jwasm /nologo /DCLARION -FoBldClar\ src\*.asm
cd BldClar
wl32.exe /q /ex /m @..\wl32clar.rsp;
rem jwlink format dos f {@..\wl32claj.rsp} n wl32.exe op q,m
cd ..
