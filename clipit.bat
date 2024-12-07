@echo off
if not exist BldClip\NUL mkdir BldClip
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlprog.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlfeed.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlparse.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlp1mod.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlp1lib.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlp2mod.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlp2lib.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wltable.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlclip.asm
jwasm /nologo /DCLIPPER /DSYMBOLPACK /DDLLSUPPORT -FoBldClip\ wlp1res.asm
jwasm -nologo                                     -FoBldClip\ wlmain.asm
jwasm -nologo                                     -FoBldClip\ wlparcon.asm
jwasm -nologo                                     -FoBldClip\ wlsetup.asm
jwasm -nologo                                     -FoBldClip\ wlfile.asm
jwasm -nologo                                     -FoBldClip\ wlmemory.asm
jwasm -nologo                                     -FoBldClip\ wlconv.asm
jwasm -nologo                                     -FoBldClip\ wlbuffer.asm
jwasm -nologo                                     -FoBldClip\ wlp2res.asm
jwasm -nologo                                     -FoBldClip\ wlmap.asm
jwasm -nologo                                     -FoBldClip\ wlterm.asm
jwasm -nologo                                     -FoBldClip\ wlerror.asm
jwasm -nologo                                     -FoBldClip\ patchrel.asm
cd BldClip                                        
jwlink format dos f {@..\wl32clip.rsp} n wl32.exe op q,m
cd ..
