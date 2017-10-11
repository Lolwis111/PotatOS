%ifndef _FAT12_INC_
%define _FAT12_INC_

[BITS 16]

%include "defines.asm"
%include "floppy16.asm"
; %include "fat12/createfile.asm"
; %include "fat12/deletefile.asm"
; %include "fat12/writefile.asm"
%include "fat12/readfile.asm"
%include "fat12/readdirectory.asm"
%include "fat12/root.asm"
%include "fat12/fat.asm"
%include "fat12/findfile.asm"
%include "fat12/countfiles.asm"

%endif
