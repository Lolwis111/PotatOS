#ifndef _TIME_H_
#define _TIME_H_

#include "stdint.h"

#define CURRENT_YEAR 2024

typedef uint32_t time_t;

typedef struct tm {
    int tm_sec;
    int tm_min;
    int tm_hour;
    int tm_mday;
    int tm_mon;
    int tm_year;
    int tm_wday;
    int tm_yday;
    int tm_isdst;
} tm;
 
enum 
{
    cmos_address = 0x70,
    cmos_data    = 0x71
};

time_t time(time_t* arg);
time_t mktime(struct tm* t);
time_t time(time_t* arg);

#endif