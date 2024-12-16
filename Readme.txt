
 WL32 Linker Source File Documentation


 1. Comments on the Source Code

  If you wish to rebuild the source files, rather than use the
 current binary release, you can do so using the batch files
 provided or create your own.

  The original files were assembled with TASM 2.5.
 Linkers used were either Borland's TLink or WL32 itself.

  The source has now been adjusted to Masm syntax. JWasm is actually
 used to assemble the source files; the JWasm version must be at least
 v2.19. Masm v6+ works as well.
  As for linking the object modules, most 16-bit linkers should do the job.
 As default, WL32 itself is used - may be changed to (J)Wlink or MS link
 in the corresponding .BAT files.

  The default WL32 binary created by MAKE.BAT (see below) isn't a CauseWay
 application anymore. A "CauseWay application" is a binary in so-called 3P
 (32- and 16-bit) or LE (32-bit only) format, stubbed with the CauseWay DOS
 extender (CWSTUB.EXE, as it is called in Open Watcom ). Instead, it's a HX
 MZ binary - to run it in plain DOS, HX's DPMI host HDPMI32 is searched.
 However, since WL32 may need to attach the CauseWay extender stub to the
 binary that is to be created, file CWSTUB.EXE will be searched in this case
 - in either the current directory or the directory of the WL32.EXE binary.

  There's still the possibility to create WL32 as CauseWay application ( see
 file MAKECW.BAT ). But even in this format does WL32 now search for stub
 CWSTUB.EXE.


 2. Distribution Files

 Following is the file list for WL32, with comments.

 Assembly Language source files:

 WLBUFFER.ASM
 WLCLIP.ASM
 WLCONV.ASM
 WLERROR.ASM
 WLFEED.ASM
 WLFILE.ASM
 WLMAIN.ASM     main proc
 WLMAP.ASM
 WLMEMORY.ASM
 WLP1LIB.ASM
 WLP1MOD.ASM
 WLP1RES.ASM
 WLP2LIB.ASM
 WLP2MOD.ASM
 WLP2RES.ASM
 WLPARCON.ASM
 WLPARSE.ASM
 WLPROG.ASM
 WLSETUP.ASM
 WLTABLE.ASM
 WLTERM.ASM
 PATCHREL.ASM    adjust segment relocs in memory for protected-mode.

 Assembly language include files:

 WLDATA.INC
 WLEQUATE.INC
 WLERRCOD.INC
 WLSYMTOK.INC
 INITPM.INC     initializes application as 32-bit DPMI client.

 Batch files:

 MAKE.BAT       build WL32 as HX MZ app with JWasm and WL32
 MAKEM.BAT      like MAKE.BAT, but use Masm v6+ instead of JWasm
 MAKECW.BAT     build WL32 as CauseWay app with JWasm and WL32
 MAKECLAR.BAT   build the Clarion-specific WL32
 MAKECLIP.BAT   build the Clipper-specific WL32
 DOALL.BAT      runs MAKE.BAT, MAKECLAR.BAT and MAKECLIP.BAT

 Linker response files:

 WL32.RSP       WL32 resp. file to build WL32.EXE
 WL32J.RSP      (J)Wlink resp. file to build WL32.EXE
 WL32CLAR.RSP   WL32 resp. file to build Clarion WL32.EXE
 WL32CLIP.RSP   WL32 resp. file to build Clipper WL32.EXE


 3. Legal Notes

 As of January 9, 2000, Michael Devore surrendered all his
 copyrights for CauseWay for Watcom C/C++ & Assembly Language and
 released it to the public domain. This included the source code
 for the WL32 WarpLink linker.

