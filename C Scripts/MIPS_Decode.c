#define _CRT_SECURE_NO_WARNINGS

#define R_Type_Op_Code	0b000000

// --- Define The R-Type instructions Constants --- \\

// --- Arithmetic Operations Constants --- \\

#define ADD_Funct		0b000100
#define SUB_Funct		0b000101
#define MUL_Funct		0b000110
#define DIV_Funct		0b000111

#define ADDU_Funct		0b010100
#define	SUBU_Funct		0b010101
#define MULU_Funct		0b010110
#define	DIVU_Funct		0b010111

#define ADDF_Funct		0b000000
#define SUBF_Funct		0b000001
#define MULF_Funct		0b000010
#define DIVF_Funct		0b000011

// --- Logic Operations Constants --- \\

#define AND_Funct		0b001000
#define OR_Funct		0b001001
#define NOR_Funct		0b001010
#define XOR_Funct		0b001011

// --- Shift Operations Constants --- \\

#define SLL_Funct		0b011000
#define SRL_Funct		0b011001
#define SLA_Funct		0b011010
#define SRA_Funct		0b011011

// --- Define The I-Type instructions Constants --- \\

// --- Arithmetic Operations Constants --- \\

#define ADDI_opcode		0b000100
#define SUBI_opcode		0b000101
#define MULI_opcode		0b000110
#define DIVI_opcode		0b000111

#define ADDIU_opcode	0b010100
#define	SUBIU_opcode	0b010101
#define MULIU_opcode	0b010110
#define	DIVIU_opcode	0b010111

#define ADDIH_opcode	0b100100
#define SUBIH_opcode	0b100101
#define MULIH_opcode	0b100110
#define DIVIH_opcode	0b100111

#define ADDIUH_opcode	0b110100
#define SUBIUH_opcode	0b110101
#define MULIUH_opcode	0b110110
#define DIVIUH_opcode	0b110111

// --- Logic Operations Constants --- \\

#define ANDI_opcode		0b001000
#define ORI_opcode		0b001001
#define NORI_opcode		0b001010
#define XORI_opcode		0b001011

#define ANDIH_opcode	0b101000
#define ORIH_opcode		0b101001
#define NORIH_opcode	0b101010
#define XORIH_opcode	0b101011

// --- Branch Operations Constants --- \\

#define BEQ_opcode		0b001100
#define BNE_opcode		0b001101
#define BGT_opcode		0b001110
#define BLE_opcode		0b001111

// --- Memory Storage Operations Constants --- \\

#define LDW_opcode		0b000001
#define STW_opcode		0b000010

// --- Define The J-Type instructions Constants --- \\

#define JMP_opcode		0b111111
#define	CALL_opcode		0b111110
#define RET_opcode		0b111101

// --- Define The BUS-Type instructions Constants --- \\

#define PERBUSW_opcode	0b111000
#define PERBUSR_opcode	0b111001

#include <stdio.h>
#include <string.h>

char* Read_Instruction(int x,char dir[]);
int Instruction_Decode(char* instruction);
void print_Binary(int val);
void print_Hex(int val);

int main(int argc, char *argv[])
{
	char dir[500];
	int Instruction_Dec;
	char *instruction;
	int i = 0 , j;
	printf("int size:  %d[Bytes] = %d[Bits]\n", sizeof(int), sizeof(int) * 8);
	printf("char size: %d[Bytes] = %d[Bits]\n", sizeof(char), sizeof(char) * 8);

	printf("\033[0;31m");
	printf("Make sure that the file contains only capital letters\n");
	printf("\033[0m");

	printf("\n");
	printf("Enter directory of the program:\n");
	scanf("%s",&dir);
	while (1)		// check 5 instructions from the file "P.txt" (from line 149)
	{
		if ((instruction = Read_Instruction(i,dir)) == NULL)
		{
			break;
		}
		else
		{
			j = 0;
			while (*instruction != NULL)
			{
				printf("%c", *instruction);
				instruction += 1;
				j += 1;
			}
			instruction -= j;
			printf("\n");
			Instruction_Dec = Instruction_Decode(instruction);
			printf("Binary Value: ");
			print_Binary(Instruction_Dec);
			printf("\nHexadecial Value: 0x");
			print_Hex(Instruction_Dec);
			printf("\nDecimal Value: %d",Instruction_Dec);
			printf("\033[0;32m");
			printf("\n-------------------------------------------------------\n");
			printf("\033[0m");
			i++;
		}
	}
	//system("pause");
	getch();
	return 0;
}

char* Read_Instruction(int x,char dir[])
{
	char temp[100];
	int i;
	FILE* f;
	f = fopen(dir,"r");
	if (f == NULL)
	{
		printf("File not found\n");
		return NULL;
	}
	for (i = 0; i < x; i++)
	{
		if (fgets(temp, 100, f) == NULL)
		{
			return NULL;	// Error
		}
	}
	if (fgets(temp, 100, f) == NULL)
	{
		fclose(f);
		return NULL;	// Error
	}
	else
	{
		i = 0;
		while (temp[i] != NULL)
		{
			if (temp[i] == '\n')
			{
				temp[i] = NULL;
			}
			i++;
		}
		fclose(f);
		return temp;
	}
}

int Instruction_Decode(char *instruction)
{
	int instruction_Dec = 0;
	int opcode;
	int rs = 0;
	int rt = 0;
	int rd = 0;
	int shamt=0;
	int funct=0;
	int i=0;
	while (instruction[i] != 0x20)
	{
		i++;
	}
	if (*(instruction + i - 1) == 'I')
	{
		return 1;	// I-Type
	}
	else if (instruction[0] == 'P')
	{
		return 3;	// BUS-Type
	}
	else if (instruction[0] == 'J' || instruction[0] == 'C' || instruction[0] == 'R')
	{
		return 2;	// J-Type
	}
	else
	{
		while (instruction[i] > 0x39 || instruction[i] < 0x30)
		{
			i++;
		}
		rd += (instruction[i] - 0x30) * 10;
		i++;
		if (instruction[i] != 0x20)
		{
			rd += (instruction[i] - 0x30);
		}
		else
		{
			rd /= 10;
		}
		while (instruction[i] > 0x39 || instruction[i] < 0x30)
		{
			i++;
		}
		rs += (instruction[i] - 0x30) * 10;
		i++;
		if (instruction[i] != ',')
		{
			rs += (instruction[i] - 0x30);
		}
		else
		{
			rs /= 10;
		}
		while (instruction[i] > 0x39 || instruction[i] < 0x30)
		{
			i++;
		}
		rt += (instruction[i] - 0x30) * 10;
		i++;
		if (instruction[i] != NULL)
		{
			rt += (instruction[i] - 0x30);
		}
		else
		{
			rt /= 10;
		}
		
		// -- Start Function Encoding --//
		opcode = 0;
		i = 0;
		while (instruction[i] != 0x20)
		{
			i++;
		}
		instruction[i] = NULL;
		if (!strcmp(instruction,"ADD"))
		{
			funct = ADD_Funct;
		}
		else if (!strcmp(instruction,"SUB"))
		{
			funct = SUB_Funct;
		}
		else if (!strcmp(instruction,"MUL"))
		{
			funct = MUL_Funct;
		}
		else if (!strcmp(instruction,"DIV"))
		{
			funct = DIV_Funct;
		}
		else if (!strcmp(instruction,"ADDU"))
		{
			funct = ADDU_Funct;
		}
		else if (!strcmp(instruction,"SUBU"))
		{
			funct = SUBU_Funct;
		}
		else if (!strcmp(instruction,"MULU"))
		{
			funct = MULU_Funct;
		}
		else if (!strcmp(instruction,"DIVU"))
		{
			funct = DIVU_Funct;
		}
		else if (!strcmp(instruction,"AND"))
		{
			funct = AND_Funct;
		}
		else if (!strcmp(instruction,"OR"))
		{
			funct = OR_Funct;
		}
		else if (!strcmp(instruction,"NOR"))
		{
			funct = NOR_Funct;
		}
		else if (!strcmp(instruction,"XOR"))
		{
			funct = XOR_Funct;
		}
		else if (!strcmp(instruction,"SLL"))
		{
			funct = SLL_Funct;
		}
		else if (!strcmp(instruction,"SRL"))
		{
			funct = SRL_Funct;
		}
		else if (!strcmp(instruction,"SLA"))
		{
			funct = SLA_Funct;
		}
		else if (!strcmp(instruction,"SRA"))
		{
			funct = SRA_Funct;
		}
		else if (!strcmp(instruction,"ADDF"))
		{
			funct = ADDF_Funct;
		}
		else if (!strcmp(instruction,"SUBF"))
		{
			funct = SUBF_Funct;
		}
		else if (!strcmp(instruction,"MULF"))
		{
			funct = MULF_Funct;
		}
		else if (!strcmp(instruction,"DIVF"))
		{
			funct = DIVF_Funct;
		}

		// -- End Function Encoding --//

		// -- Send the code back to the main function -- //
		instruction_Dec += (rs		<< 21);
		instruction_Dec += (rt		<< 16);
		instruction_Dec += (rd		<< 11);
		instruction_Dec += (shamt	<<  6);
		instruction_Dec += (funct);
		return instruction_Dec;	//R-Type
		// -- Send the code back to the main function -- //
	}
}

void print_Binary(int val)
{
	int i;
	int x = 0x80000000;
	for (i = 0; i < 32; i++)
	{
		if (!(i % 4))
		{
			printf(" ");
		}
		if (x & val)
		{
			printf("1");
		}
		else
		{
			printf("0");
		}
		if (i == 0)
		{
			x = 0x40000000;
		}
		else
		{
			x = x >> 1;
		}
	}
}

void print_Hex(int val)
{
	int y;
	int i;
	int x = 0xF0000000;
	for (i = 0; i < 8; i++)
	{
		y = (x & val) >> (28 - (i*4));
		switch (y)
		{
		case 0x0:	printf("0"); break;
		case 0x1:	printf("1"); break;
		case 0x2:	printf("2"); break;
		case 0x3:	printf("3"); break;
		case 0x4:	printf("4"); break;
		case 0x5:	printf("5"); break;
		case 0x6:	printf("6"); break;
		case 0x7:	printf("7"); break;
		case 0x8:	printf("8"); break;
		case 0x9:	printf("9"); break;
		case 0xA:	printf("A"); break;
		case 0xB:	printf("B"); break;
		case 0xC:	printf("C"); break;
		case 0xD:	printf("D"); break;
		case 0xF:	printf("F"); break;
		}
		if (i == 0)
		{
			x = 0x0F000000;
		}
		else
		{
			x = x >> 4;
		}
	}
}
