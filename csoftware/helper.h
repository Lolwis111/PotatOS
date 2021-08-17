#ifndef _HELPER_C_
#define _HELPER_C_

int getLinearAddress(short segment, short offset);
void getSegmentOffsetAddress(short linear);

void farWrite_byte(short segment, short offset, char data);
void farWrite_word(short segment, short offset, short data);
void farWrite_dword(short segment, short offset, int data);
char farRead_byte(short segment, short offset);
short farRead_word(short segment, short offset);
int farRead_dword(short segment, short offset);

#endif