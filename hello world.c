#define WIN32_LEAN_AND_MEAN
#include <windows.h>
DWORD temp;
void main() {WriteFile(STD_OUTPUT_HANDLE, "Hello world!", 14, &temp, NULL);}
