@echo off
ml -c -nologo -Cp /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\*.asm
cd Build
wl32.exe /ex /q /m /cs /non @..\wl32.rsp
rem jwlink format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
