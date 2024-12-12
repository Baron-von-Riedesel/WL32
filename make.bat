@echo off
if not exist Build\NUL mkdir Build
jwasm -nologo /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\*.asm
cd Build
wl32.exe /ex /q /m /cs /non @..\wl32.rsp;
rem \msvc\bin\link /NON/MAP/NOLOGO @..\wl32.rsp;
rem jwlink.exe format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
