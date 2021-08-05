; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Provides methods for reading and writing     %
; % to a floppy disk.       (LOW_LEVEL_IO)       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _FLOPPY16_INC_
%define _FLOPPY16_INC_

[BITS 16]

%include "bpb.asm"
%include "floppy/lba.asm"
%include "floppy/readsectors.asm"
%include "floppy/writesectors.asm"


%endif ; _FLOPPY16_INC_
