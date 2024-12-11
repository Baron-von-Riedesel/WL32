@echo off
if not exist Build\NUL mkdir Build
jwasm -c -nologo -Zm -FoBuild\ src\machlink.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlclean.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlclip.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mlcomm.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mlcredit.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlddl1.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mlddl2.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mlerror.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlgetarg.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlimage1.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlimage2.asm
jwasm -c -nologo -Zm -FoBuild\ src\mllib1.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mllib2.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mlmap.asm   
jwasm -c -nologo -Zm -FoBuild\ src\mlmemory.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlovl1.asm  
jwasm -c -nologo -Zm -FoBuild\ src\mlovlfil.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlovlres.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlparovl.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlparse.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlpass1.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlpass1a.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass1b.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass1c.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass2.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlpass2a.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass2b.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass2c.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass2d.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlpass2e.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlquick.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlsetup.asm 
jwasm -c -nologo -Zm -FoBuild\ src\mlshared.asm
jwasm -c -nologo -Zm -FoBuild\ src\mlsum.asm   
cd Build
WL32 /q /ex /m /cs /non @..\wl.rsp
rem jwlink format dos f { @..\wlj.rsp } n WL.EXE op q,m
rem \msvc\bin\link /nologo /map /non @..\wl.rsp;
cd ..
