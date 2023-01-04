#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>

int main()
{
	char x = 0x30;
	char y = 0;
	system("cls");
	system("mode com3 dtr=off rts=off baud=9600 parity=N data=8 stop=1 to=on");
	FILE* f;
	f = fopen("COM3","wb+");
	setvbuf(f, NULL, _IONBF, 0);
	//setbuf(stdout, x);
	
	if (f == NULL)
	{
		return -1;
	}
	while (1)
	{
		y = fgetc(f);
		printf("%c",y);
		fputc(x,f);
		x++;
	}
}