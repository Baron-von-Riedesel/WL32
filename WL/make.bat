@echo off
if not exist Build\NUL mkdir Build
jwasm -c -nologo -Cp -FoBuild\ src\*.asm
cd Build
WL32 /q /ex /m /cs /non @..\wl.rsp
rem jwlink format dos f { @..\wlj.rsp } n WL.EXE op q,m
rem \msvc\bin\link /nologo /map /non @..\wl.rsp;
cd ..
