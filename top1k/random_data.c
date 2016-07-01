/**
生成 n 个 随机数

 gcc -std=c99 -Wall random_data.c -o random_data
 
p.s.
	long int random(void);
	void srandom(unsigned int seed);
		
*/
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int args, char* argv[]){
	int nums = 10;
	if (args >= 2){
		nums = atoi(argv[1]);
	}

	srand((unsigned) time(NULL));

	for (int i = 0; i < nums; i++) {
		printf("%d\n", random());
	}

	return 0;
}
