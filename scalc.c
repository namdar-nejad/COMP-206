/*
	Program to implement a scientific calculator
*************************************************************** 
* Author	 Dept		Date 		Notes
***************************************************************
* Namdar N	 McGill CS	Nov 01 2020 	Initial version
*/

#include <stdio.h>

int main(int argc,char* argv[]) {

// Cheking the inputs
// Cheking # of inputs
if(argc != 4) { 
	printf("Error: invalid number of arguments!\n");
	printf("scalc <operand1> <operator> <operand2>\n");
	return 1;
}
// Cheking operator input
else if (*argv[2] != '+'){
	printf("Error: operator can only be + !\n");
	return 1;
}

char *i = argv[1];	// Points to first int
char *j = argv[3];	// Points to second int
int lengthI = 0;	// Length of first number
int lengthJ = 0;	// Length of second number

// Cheking if all the chars in i are numbers between 0 and 9
while(*i != '\0'){
	if(!('0' <= *i && *i <= '9')){
	printf("Error!! operand can only be positive integers\n");
	return 1;
	}
	i++;
	lengthI++;
}

// Cheking if all the chars in j are numbers between 0 and 9
while(*j != '\0'){
         if(!('0' <= *j && *j <= '9')){
         printf("Error!! operand can only be positive integers\n");
         return 1;
         }
         j++;
	 lengthJ++;
}

// Calculation
int carry = 0;		// Carry bit
char arr[1100];		// Array to store the results in
i--, j--;		// Decramenting the pointers to pint to the last digit of the numbers, before null char

int lenMin;		// The length of the smaller number
int lenMax;		// The length of the larger number
int bitAdd = 0;		// Hold the value of addition of each digit later on
int a = 0;		// int value of i
int b = 0;		// int value of j
int len = 0;		// used to indicated hiw many digits of the arry to print

//printf("lenI: %d, lenJ: %d", lengthI, lengthJ);
//printf("\n I: %c, J: %c", *i, *j);

// Calculating the lengths
if (lengthI <= lengthJ) {
	lenMin = lengthI;
	lenMax = lengthJ;
}
else {
	lenMin = lengthJ;
	lenMax = lengthI;
} 

//printf("\nminLen: %d, maxLen: %d", lenMin, lenMax);

// Calculating the addition
for(int x = 1; x <= lenMin; x++){
	//printf("\nI: %c, J: %c", *i, *j);
	//printf("\nI: %d, J: %d", *i, *j);
	
	a = *i - 48;		// ASCII code - 48 = int valu
	b = *j - 48;
	
	i--, j--;
	
	//printf("\na: %d, b: %d", a, b);
	
	bitAdd = a + b + carry;
	//printf("\n%d", bitAdd);
	
	if (bitAdd <= 9){
		arr[x]= bitAdd + 48;
		carry = 0;
	}
	else{
		arr[x] = bitAdd - 10 + 48;
		carry = 1;	
	}
}

for(int x = lenMin+1; x <= lenMax; x++){
	//printf("\nSecond Section:");
	//printf("\nI: %c, J: %c", *i, *j);

	if (lengthI >= lengthJ){
	bitAdd = *i - 48 + carry;
	i--;
	//printf("\nselected I.");
	//printf("bitAdd: %d", bitAdd);
	}
	else{
	bitAdd = *j - 48 + carry;
	j--;
	//printf("Selected J.");
	//printf("bitAdd: %d", bitAdd);
	}	
	
	if (bitAdd <= 9){
		arr[x] = bitAdd + 48;
		carry = 0;
	}
	else{
		arr[x] = bitAdd - 10 + 48;
		carry = 1;
	}
}

// If we have a carry bit after the last digit addition, we just add a 1 to the end and print the extar digit added
if (carry == 1){
	arr[lenMax+1] = '1';
	len = 1;
}

// Printing the result
for (int x = lenMax+len; x >= 1; x--){
	printf("%c", arr[x]);
}
printf("\n");

  return 0;
}
