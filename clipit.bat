@echo off
if not exist BldClip\NUL mkdir BldClip
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlprog.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlfeed.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlparse.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlp1mod.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlp1lib.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlp2mod.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlp2lib.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wltable.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlclip.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ src\wlp1res.asm
jwasm -nologo                                     -FoBldClip\ src\wlmain.asm
jwasm -nologo                                     -FoBldClip\ src\wlparcon.asm
jwasm -nologo                                     -FoBldClip\ src\wlsetup.asm
jwasm -nologo                                     -FoBldClip\ src\wlfile.asm
jwasm -nologo                                     -FoBldClip\ src\wlmemory.asm
jwasm -nologo                                     -FoBldClip\ src\wlconv.asm
jwasm -nologo                                     -FoBldClip\ src\wlbuffer.asm
jwasm -nologo                                     -FoBldClip\ src\wlp2res.asm
jwasm -nologo                                     -FoBldClip\ src\wlmap.asm
jwasm -nologo                                     -FoBldClip\ src\wlterm.asm
jwasm -nologo                                     -FoBldClip\ src\wlerror.asm
jwasm -nologo                                     -FoBldClip\ src\patchrel.asm
cd BldClip                                        
jwlink format dos f {@..\wl32clip.rsp} n wl32.exe op q,m
cd ..
