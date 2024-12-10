@echo off
if not exist Build\NUL mkdir Build
ml -c -nologo -Zm -FoBuild\ machlink.asm
ml -c -nologo -Zm -FoBuild\ mlclean.asm 
ml -c -nologo -Zm -FoBuild\ mlclip.asm  
ml -c -nologo -Zm -FoBuild\ mlcomm.asm  
ml -c -nologo -Zm -FoBuild\ mlcredit.asm
ml -c -nologo -Zm -FoBuild\ mlddl1.asm  
ml -c -nologo -Zm -FoBuild\ mlddl2.asm  
ml -c -nologo -Zm -FoBuild\ mlerror.asm 
ml -c -nologo -Zm -FoBuild\ mlgetarg.asm
ml -c -nologo -Zm -FoBuild\ mlimage1.asm
ml -c -nologo -Zm -FoBuild\ mlimage2.asm
ml -c -nologo -Zm -FoBuild\ mllib1.asm  
ml -c -nologo -Zm -FoBuild\ mllib2.asm  
ml -c -nologo -Zm -FoBuild\ mlmap.asm   
ml -c -nologo -Zm -FoBuild\ mlmemory.asm
ml -c -nologo -Zm -FoBuild\ mlovl1.asm  
ml -c -nologo -Zm -FoBuild\ mlovlfil.asm
ml -c -nologo -Zm -FoBuild\ mlovlres.asm
ml -c -nologo -Zm -FoBuild\ mlparovl.asm
ml -c -nologo -Zm -FoBuild\ mlparse.asm 
ml -c -nologo -Zm -FoBuild\ mlpass1.asm 
ml -c -nologo -Zm -FoBuild\ mlpass1a.asm
ml -c -nologo -Zm -FoBuild\ mlpass1b.asm
ml -c -nologo -Zm -FoBuild\ mlpass1c.asm
ml -c -nologo -Zm -FoBuild\ mlpass2.asm 
ml -c -nologo -Zm -FoBuild\ mlpass2a.asm
ml -c -nologo -Zm -FoBuild\ mlpass2b.asm
ml -c -nologo -Zm -FoBuild\ mlpass2c.asm
ml -c -nologo -Zm -FoBuild\ mlpass2d.asm
ml -c -nologo -Zm -FoBuild\ mlpass2e.asm
ml -c -nologo -Zm -FoBuild\ mlquick.asm 
ml -c -nologo -Zm -FoBuild\ mlsetup.asm 
ml -c -nologo -Zm -FoBuild\ mlshared.asm
ml -c -nologo -Zm -FoBuild\ mlsum.asm   
cd Build
WL32 /q /ex /m /cs @..\wl.rsp
rem jwlink format dos f { @..\wlj.rsp } n WL.EXE op q,m
rem \msvc\bin\link /nologo /map @..\wl.rsp;
cd ..
