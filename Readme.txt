
 WL32 Linker Source File Documentation


 1. Comments on the Source Code

  If you wish to rebuild the source files, rather than use the
 current binary release, you can do so using the batch files
 provided or create your own.

  The original files were assembled with TASM 2.5.
 Linkers used were either Borland's TLink or WL32 itself.

  The source has now been adjusted to Masm syntax. JWasm is actually
 used to assemble the source files; the JWasm version must be at least
 v2.19.
  As for linking the object modules, most 16-bit linkers should do the job.
 As default, WL32 itself is used - may be changed to (J)Wlink or MS link
 in the corresponding .BAT files.
  Finally, WL32 isn't a CauseWay application anymore. To run it in plain
 DOS, HX's DPMI host HDPMI32 is searched. However, since WL32's /f option
 creates a flat binary WITH the CauseWay extender stub CWSTUB.EXE, this
 stub will be searched by WL32 in this case - in either the current directory
 or the directory of the WL32.EXE binary.


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

 MAKE.BAT       builds standard WL32 with JWasm and WL32
 MAKEM.BAT      like MAKE.BAT, but use Masm v6+ instead of JWasm
 MAKECLAR.BAT   builds the Clarion-specific WL32
 MAKECLIP.BAT   builds the Clipper-specific WL32
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

