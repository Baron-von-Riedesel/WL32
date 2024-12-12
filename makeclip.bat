@echo off
if not exist BldClip\NUL mkdir BldClip
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\*.asm
cd BldClip                                        
wl32.exe /q /ex /m /non @..\wl32clip.rsp;
rem jwlink format dos f {@..\wl32clij.rsp} n wl32.exe op q,m
cd ..
