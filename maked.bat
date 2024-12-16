@echo off
if not exist BuildD\NUL mkdir BuildD
jwasm -nologo -D_DEBUG -Cp /DDLLSUPPORT /DWATCOM_ASM -FlBuildD\ -Sg -FoBuildD\ src\*.asm
cd BuildD
wl32.exe /ex /q /m /cs /non @..\wl32.rsp;
rem \msvc\bin\link /NON/MAP/NOLOGO @..\wl32.rsp;
rem jwlink.exe format dos f {@..\wl32j.rsp} n wl32.exe op q,m
cd ..
