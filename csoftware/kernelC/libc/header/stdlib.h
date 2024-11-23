#ifndef _STDLIB_H_
#define _STDLIB_H_

typedef unsigned int size_t;
#define NULL 0

typedef struct div_t {
    int quot;
    int rem;
} div_t;

typedef struct ldiv_t {
    long quot;
    long rem;
} ldiv_t;

double atof(const char* buf);
int atoi(const char* buf);
long atol(const char* buf);
div_t div(int x, int y);

#endif