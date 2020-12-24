#include <mach-o/loader.h>
#include <stdio.h>

/* no sign support */
int atoi(char *s){
    int res = 0;

    while(*s){
        res = res * 10 + (*s - '0');
        s++;
    }

    return res;
}

int isdigit(int c){
    return c >= '0' && c <= '9';
}

char *strcpy(char *dest, const char *src){
    char *src0 = (char *)src;
    while((*dest++ = *src0++));
    *dest = '\0';
    /* who cares about strcpy return value */
    return dest;
}

struct mach_header_64 *mh_execute_header = NULL;
uint64_t kernel_slide = 0;

/* XXX do not panic so user can see what screen says */
__attribute__ ((noreturn)) void stalker_fatal_error(void){
    puts("svc_stalker: fatal error.");
    puts("     Please file an issue");
    puts("     on Github. Include");
    puts("     output up to this");
    puts("     point and device/iOS");
    puts("     version.");
    puts("Spinning forever.");

    for(;;);
}
