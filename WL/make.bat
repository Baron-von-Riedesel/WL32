@echo off
if not exist Build\NUL mkdir Build
jwasm -c -nologo -Zm -FoBuild\ machlink.asm
jwasm -c -nologo -Zm -FoBuild\ mlclean.asm 
jwasm -c -nologo -Zm -FoBuild\ mlclip.asm  
jwasm -c -nologo -Zm -FoBuild\ mlcomm.asm  
jwasm -c -nologo -Zm -FoBuild\ mlcredit.asm
jwasm -c -nologo -Zm -FoBuild\ mlddl1.asm  
jwasm -c -nologo -Zm -FoBuild\ mlddl2.asm  
jwasm -c -nologo -Zm -FoBuild\ mlerror.asm 
jwasm -c -nologo -Zm -FoBuild\ mlgetarg.asm
jwasm -c -nologo -Zm -FoBuild\ mlimage1.asm
jwasm -c -nologo -Zm -FoBuild\ mlimage2.asm
jwasm -c -nologo -Zm -FoBuild\ mllib1.asm  
jwasm -c -nologo -Zm -FoBuild\ mllib2.asm  
jwasm -c -nologo -Zm -FoBuild\ mlmap.asm   
jwasm -c -nologo -Zm -FoBuild\ mlmemory.asm
jwasm -c -nologo -Zm -FoBuild\ mlovl1.asm  
jwasm -c -nologo -Zm -FoBuild\ mlovlfil.asm
jwasm -c -nologo -Zm -FoBuild\ mlovlres.asm
jwasm -c -nologo -Zm -FoBuild\ mlparovl.asm
jwasm -c -nologo -Zm -FoBuild\ mlparse.asm 
jwasm -c -nologo -Zm -FoBuild\ mlpass1.asm 
jwasm -c -nologo -Zm -FoBuild\ mlpass1a.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass1b.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass1c.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass2.asm 
jwasm -c -nologo -Zm -FoBuild\ mlpass2a.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass2b.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass2c.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass2d.asm
jwasm -c -nologo -Zm -FoBuild\ mlpass2e.asm
jwasm -c -nologo -Zm -FoBuild\ mlquick.asm 
jwasm -c -nologo -Zm -FoBuild\ mlsetup.asm 
jwasm -c -nologo -Zm -FoBuild\ mlshared.asm
jwasm -c -nologo -Zm -FoBuild\ mlsum.asm   
cd Build
WL32 /q /ex /m /cs @..\wl.rsp
rem jwlink format dos f { @..\wlj.rsp } n WL.EXE op q,m
rem \msvc\bin\link /nologo /map @..\wl.rsp;
cd ..
