#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <stdlib.h>
extern void FUNC1();
extern void FUNC2();
extern void FUNC3();
extern void FUNC4();
extern void FUNC6();
extern void FUNC8();

int main()
{
	int op = 0;
	while (op != 9)
	{
		printf("SHOP:MY SHOP\n");
		printf("---------------------------------------------\n");
		printf("1.Login in\n2.Select good\n3.Buy good\n4.Update recommendation\n6.Update good\n8.Show CS\n9.Exit\n");
		printf("---------------------------------------------\n");
		printf("Please Enter a Number:");
		scanf("%d", &op);
		printf("*********************************************\n");
		switch (op)
		{
		case 1:
			
			FUNC1();
			break;
		case 2:
			FUNC2();
			break;
		case 3:
			FUNC3();
			break;
		case 4:
			FUNC4();
			break;
		case 6:
			getchar();
			FUNC6();
			break;
		case 8:
			FUNC8();
			break;
		default:
			break;
		}
		printf("*********************************************\n");
		system("pause");
		system(("cls"));
	}
	return 0;
}