/**
  gcc -std=c99 -Wall a.c
 *   * */ 
#include <stdio.h>
#include <malloc.h>
#include <stdlib.h>
	   
#define MAX_LEN 1000
#define MAX_LINE 20

int top1k[MAX_LEN]={0}; // 全局变量

void list_min(int* num, int* pos){
	int m = top1k[0];
	int p = 0;

	for(int i = 1; i < MAX_LEN; i++) {
		if (m > top1k[i]) {
			m =  top1k[i];
			p = i;
		}
	}
	*num = m;
	*pos = p;
}

void list_disp(){
	for(int i = 0; i < MAX_LEN; i++) {
		printf("%d\n", top1k[i]);
	}
}

void list_replace(int pos, int new){
	top1k[pos] = new;
}

int main(int args, char* argv[]){
	
	FILE* fp = fopen(argv[1], "r");
	if (NULL == fp){
		printf("ERROR: Open file %s Failed!\n", argv[1]);
		exit(0);
	}

	char buf[MAX_LINE]; /*缓冲区*/

	int* min;
	int* pos;
	min = (int*)malloc(sizeof(int));
	pos = (int*)malloc(sizeof(int));
	
	// 查找到 top1k 中最小值. 值保存到 min 中.  位置保存到 pos 中
	list_min(min, pos);
	
	printf("%d, %d\n", *min, *pos);
	
	while(fgets(buf, MAX_LINE, fp) != NULL){
		// 读每行. 转成 int
		int x = atoi(buf);
		
		if (x > *min) {
			// 用 x 替换 top1k 中的最小值.
			list_replace(*pos, x);
			
			// 替换后, 重新计算 top1k 中的最小值. 将值保存到 min中. 将它的位置保存到 pos 中
			list_min(min, pos);
		}
	}
	fclose(fp);
	free(min);
	free(pos);

	list_disp();

	return 0;
}
