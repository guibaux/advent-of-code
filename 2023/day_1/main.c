#include <ctype.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

uint32_t speltnum(char* spell){
    char* based = calloc(6, sizeof(char));
    memcpy(based, spell, 5);
    // leak kek

    // 5 digits
    if(strcmp("three", based) == 0) return 3;
    if(strcmp("seven", based) == 0) return 7;
    if(strcmp("eight", based) == 0) return 8;

    based[4] = '\0';

    if(strcmp("four", based) == 0) return 4;
    if(strcmp("five", based) == 0) return 5;
    if(strcmp("nine", based) == 0) return 9;

    based[3] = '\0';
    if(strcmp("one", based) == 0) return 1;
    if(strcmp("two", based) == 0) return 2;
    if(strcmp("six", based) == 0) return 6;

    free(based);

    return 0;
}

int main(void){
    char *line = NULL;
    size_t len = 0;
    size_t read;
    
    uint32_t sum = 0; 

    while((read = getline(&line, &len, stdin)) != -1){
        //puts(line);

        int first = 1;
        uint32_t lastdigit = 0;
        uint32_t firstdigit = 0;
        for(int i = 0; line[i]; i++){
            uint32_t num = 0;
            if(isdigit(line[i])) {
                if(first) firstdigit = (line[i] - '0'), first = 0;
                lastdigit = (line[i] - '0');
            }
            #ifdef SOL2
            else if((num = speltnum(&line[i]))){
                if(first) firstdigit = num, first = 0;
                lastdigit = num;
            }
            #endif
        }
        
        //printf("%d%d\n", firstdigit, lastdigit);
        sum += firstdigit * 10;
        sum += lastdigit;
    }

    printf("The sum is: %d\n", sum);

    free(line);
    return 0;
}
