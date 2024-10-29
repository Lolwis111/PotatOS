#include "io.h"
#include "time.h"
#include "stdio.h"
#include "string.h"
 
static int century_register = 0x00;

static int get_update_in_progress_flag() 
{
    outportb(cmos_address, 0x0A);
    return (inportb(cmos_data) & 0x80);
}
 
static unsigned char get_RTC_register(int reg) 
{
    outportb(cmos_address, reg);
    return inportb(cmos_data);
}

static void read_rtc(tm* time)
{
    unsigned char century = 20;
    unsigned char last_second;
    unsigned char last_minute;
    unsigned char last_hour;
    unsigned char last_day;
    unsigned char last_wday;
    unsigned char last_month;
    unsigned char last_year;
    unsigned char last_century;
    unsigned char registerB;
 
    // Note: This uses the "read registers until you get the same values twice in a row" technique
    //     to avoid getting dodgy/inconsistent values due to RTC updates
 
    while (get_update_in_progress_flag());            // Make sure an update isn't in progress
    time->tm_sec = get_RTC_register(0x00);
    time->tm_min = get_RTC_register(0x02);
    time->tm_hour = get_RTC_register(0x04);
    time->tm_wday = get_RTC_register(0x06);
    time->tm_mday = get_RTC_register(0x07);
    time->tm_mon = get_RTC_register(0x08);
    time->tm_year = get_RTC_register(0x09);
    if(century_register != 0)
    {
        century = get_RTC_register(century_register);
    }
 
    do
    {
        last_second = time->tm_sec;
        last_minute = time->tm_min;
        last_hour = time->tm_hour;
        last_day = time->tm_mday;
        last_wday = time->tm_wday;
        last_month = time->tm_mon;
        last_year = time->tm_year;
        last_century = century;
 
        while (get_update_in_progress_flag()) ;         // Make sure an update isn't in progress

        time->tm_sec = get_RTC_register(0x00);
        time->tm_min = get_RTC_register(0x02);
        time->tm_hour = get_RTC_register(0x04);
        time->tm_mday = get_RTC_register(0x07);
        time->tm_wday = get_RTC_register(0x06);
        time->tm_mon = get_RTC_register(0x08);
        time->tm_year = get_RTC_register(0x09);

        if(century_register != 0)
        {
            century = get_RTC_register(century_register);
        }
    } while( (last_second != time->tm_sec) || 
            (last_minute != time->tm_min) || 
            (last_hour != time->tm_hour) ||
            (last_day != time->tm_mday) || 
            (last_month != time->tm_mon) || 
            (last_year != time->tm_year) ||
            (last_century != century) ||
            (last_wday != time->tm_wday));
 
    registerB = get_RTC_register(0x0B);
 
    // Convert BCD to binary values if necessary
 
    if (!(registerB & 0x04))
    {
        time->tm_sec = (time->tm_sec & 0x0F) + ((time->tm_sec / 16) * 10);
        time->tm_min = (time->tm_min & 0x0F) + ((time->tm_min / 16) * 10);
        time->tm_hour = ( (time->tm_hour & 0x0F) + (((time->tm_hour & 0x70) / 16) * 10) ) | (time->tm_hour & 0x80);
        time->tm_mday = (time->tm_mday & 0x0F) + ((time->tm_mday / 16) * 10);
        time->tm_wday = (time->tm_wday & 0x0F) + ((time->tm_wday / 16) * 10);
        time->tm_mon = (time->tm_mon & 0x0F) + ((time->tm_mon / 16) * 10);
        time->tm_year = (time->tm_year & 0x0F) + ((time->tm_year / 16) * 10);
        if(century_register != 0)
        {
            century = (century & 0x0F) + ((century / 16) * 10);
        }
    }
 
    // Convert 12 hour clock to 24 hour clock if necessary
 
    if (!(registerB & 0x02) && (time->tm_hour & 0x80))
    {
        time->tm_hour = ((time->tm_hour & 0x7F) + 12) % 24;
    }
 
    // Calculate the full (4-digit) year
 
    if(century_register != 0)
    {
        time->tm_year += century * 100;
    }
    else
    {
        time->tm_year += (CURRENT_YEAR / 100) * 100;
        if(time->tm_year < CURRENT_YEAR) time->tm_year += 100;
    }
}

time_t mktime(struct tm* t)
{
    // https://de.wikipedia.org/wiki/Unixzeit

    const short days_in_months[12] = {0,31,59,90,120,151,181,212,243,273,304,334};

    int leapyears = ((t->tm_year-1) - 1968) / 4 
        - ((t->tm_year - 1) - 1900) / 100 
        + ((t->tm_year-1) - 1600) / 400;
        
    long long days_since_1970 = (t->tm_year - 1970) * 365 
        + leapyears 
        + days_in_months[t->tm_mon - 1] + t->tm_mday - 1;

    if( (t->tm_mon > 2) && (t->tm_year % 4 == 0 && (t->tm_year % 100 != 0 || t->tm_year % 400 == 0)))
    {
        days_since_1970 += 1;
    }

    return t->tm_sec + 60 * (t->tm_min + 60 * (t->tm_hour + 24 * days_since_1970));
}

time_t time(time_t* arg)
{    
    struct tm t;
    read_rtc(&t);

    if(arg != NULL)
    {
        memcpy(arg, &t, sizeof(struct tm));
    }

    return mktime(&t);
}
 
double difftime(time_t time_end, time_t time_start)
{
    return time_end - time_start;
}

char* asctime(const struct tm* time_ptr)
{

    // char** months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

    // char* buffer = "Www Mmm dd hh:mm:ss yyyy\n";

    // char buffer[26];

    // Www Mmm dd hh:mm:ss yyyy\n

    return NULL;
}

struct tm* localtime(const time_t* timer)
{
    static struct tm t;

    const unsigned long int SECONDS_PER_DAY   =  24ul * 60ul * 60ul;
    const unsigned long int DAYS_PER_YEAR =    365ul;
    const unsigned long int DAYS_PER_4YEARS   =   1461ul;
    const unsigned long int DAYS_PER_100YEARS =  36524ul;
    const unsigned long int DAYS_PER_400YEARS = 146097ul;
    const unsigned long int TAGN_AD_1970_01_01 = 719468ul;

    unsigned long int TagN = TAGN_AD_1970_01_01 + *timer / SECONDS_PER_DAY;
    unsigned long int seconds_since_midnight = *timer % SECONDS_PER_DAY;
    unsigned long int temp;

    temp = 4 * (TagN + DAYS_PER_100YEARS + 1) / DAYS_PER_400YEARS - 1;
    t.tm_year = 100 * temp;
    TagN -= DAYS_PER_100YEARS * temp + temp / 4;

    temp = 4 * (TagN + DAYS_PER_YEAR + 1) / DAYS_PER_4YEARS - 1;
    t.tm_year += temp;
    TagN -= DAYS_PER_YEAR * temp + temp / 4;
    t.tm_mon = (5 * TagN + 2) / 153;
    t.tm_mday = TagN - (t.tm_mon * 153 + 2) / 5 + 1;
    t.tm_mon += 3;
    if (t.tm_mon > 12)
    {
        t.tm_mon -= 12;
        ++t.tm_year;
    }

    t.tm_hour  = seconds_since_midnight / 3600;
    t.tm_min = seconds_since_midnight % 3600 / 60;
    t.tm_sec = seconds_since_midnight        % 60;

    return &t;
}