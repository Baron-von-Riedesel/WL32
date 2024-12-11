@echo off
if not exist Build\NUL mkdir Build
ml -c -nologo -Zm -Cp -FoBuild\ src\machlink.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlclean.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlclip.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mlcomm.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mlcredit.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlddl1.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mlddl2.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mlerror.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlgetarg.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlimage1.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlimage2.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mllib1.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mllib2.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mlmap.asm   
ml -c -nologo -Zm -Cp -FoBuild\ src\mlmemory.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlovl1.asm  
ml -c -nologo -Zm -Cp -FoBuild\ src\mlovlfil.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlovlres.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlparovl.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlparse.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass1.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass1a.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass1b.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass1c.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass2.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass2a.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass2b.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass2c.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass2d.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlpass2e.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlquick.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlsetup.asm 
ml -c -nologo -Zm -Cp -FoBuild\ src\mlshared.asm
ml -c -nologo -Zm -Cp -FoBuild\ src\mlsum.asm   
cd Build
WL32 /q /ex /m /cs /non @..\wl.rsp
rem jwlink format dos f { @..\wlj.rsp } n WL.EXE op q,m
rem \msvc\bin\link /nologo /map /non @..\wl.rsp;
cd ..
