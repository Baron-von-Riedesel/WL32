WARPLINK SOURCE FILE DOCUMENTATION


COMMENTS ON THE SOURCE CODE

Most of the WarpLink code was written over the time period of
1989 through 1993. The operating system and programming
landscape was much different then, so this code probably needs
updates and modifications to work with later date software
versions.  Given the age, the programming team's learning
curves, the then cutting-edge technology, and fairly substantial
codebase involved, there doubtless exist operational errors and
examples of what is now considered poor code.  Please keep the
historic perspective in mind if you choose to use or study the
software and source code.

The original files were assembled with TASM 2.0 or 2.5 in MASM
emulation. Now the source is assembled with either JWasm or Masm v6.
To link the binary, either WL32, (J)Wlink or MS link may be used.

WarpLink is a real-mode application, it should run on any 8086 cpu.

Finally, a naming note.  WarpLink was originally called Machlink
when it was in development before initial release.  That's why you
see all those MACHLINK and ML*.ASM files.


DISTRIBUTION FILES

Following is the full directory file list with a brief
description on what the file is for.

Files for WarpLink (WL.EXE):

MACHLINK ASM
MLCLEAN  ASM
MLCLIP   ASM
MLCOMM   ASM
MLCREDIT ASM
MLDDL1   ASM
MLDDL2   ASM
MLERROR  ASM
MLGETARG ASM
MLIMAGE1 ASM
MLIMAGE2 ASM
MLLIB1   ASM
MLLIB2   ASM
MLMAP    ASM
MLMEMORY ASM
MLOVL1   ASM
MLOVLFIL ASM
MLOVLRES ASM
MLPAROVL ASM
MLPARSE  ASM
MLPASS1  ASM
MLPASS1A ASM
MLPASS1B ASM
MLPASS1C ASM
MLPASS2  ASM
MLPASS2A ASM
MLPASS2B ASM
MLPASS2C ASM
MLPASS2D ASM
MLPASS2E ASM
MLQUICK  ASM
MLSETUP  ASM
MLSHARED ASM
MLSUM    ASM

MLDATA   INC
MLEQUATE INC
MLERRMES INC
MLGLOBAL INC
MLSYMTOK INC

---

Linker response files, used to link WarpLink OBJ files to
final executable:

WARPLINK RSP       for Tlink
WL       RSP       for WL(32) or MS Link
WLJ      RSP       for (J)Wlink

---

Batch files:

MAKE.BAT           create WL.EXE with JWasm and WL32|(J)Wlink
MAKEM.BAT          create WL.EXE with Masm v6+ and WL32|(J)Wlink


LEGAL NOTES

As of November 4, 1999, Michael Devore surrendered all his
copyrights for WarpLink and released it to the public domain.
A few optional-use components of the WarpLink development files
retain their separate third party copyrights and are not part
of the release of the WarpLink software to public domain.

You may see several copyright notices within the source files.
When Michael Devore purchased the WarpLink property from
hyperkinetix in early 1993, copyrights for the files contained
in this distribution were assigned to Michael Devore as part of
the WarpLink property.  They were previously done as a work for
hire by other programmers, internally developed, or developed
on a per-copy royalty basis by Michael Devore.

This is a true public domain release.  It is not Yet Another
Open Source licensing arrangement.  You may use the binary and
source files in whatever manner you desire, INCLUDING for
commercial purposes, without explicit credit or compensation to
Michael Devore.

