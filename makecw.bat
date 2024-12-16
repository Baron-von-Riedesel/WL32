@echo off
rem build WL32 as a CauseWay app
if not exist Build\NUL mkdir Build
jwasm -nologo -Cp /DCW /DDLLSUPPORT /DWATCOM_ASM -FoBuild\ src\*.asm
cd Build
wl32.exe /f /q /m /cs /non @..\wl32.rsp;
cd ..
