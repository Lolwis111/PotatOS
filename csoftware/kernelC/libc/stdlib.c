#include "stdlib.h"
#include "string.h"
#include "ctype.h"

div_t div(int x, int y)
{
    div_t d;
    d.quot = x / y;
    d.rem = x % y;

    return d;
}

ldiv_t ldiv(long x, long y)
{
    ldiv_t d;
    d.quot = x / y;
    d.rem = x % y;

    return d;
}

double atof(const char* buf)
{
    int l = strlen(buf);
    char c[l + 1];

    int i;
    for(i = 0; i < l; i++)
    {
        c[i] = tolower(buf[i]);
    }
    c[i] = '\0';

    union convert
    {
        float f;
        int i;
    } convertu;
    

    if(strcmp("inf", c) == 0 || strcmp("infiniy", c) == 0)
    {
        convertu.i = 0x7F800000;
        return convertu.f;
    }
    else if(strcmp("nan", c) == 0)
    {
        convertu.i = 0x7FC00000;
        return convertu.f;
    }

    const char* ptr = c;

    while(isspace(*ptr)) ptr++;

    int neg = 1;

    if(*ptr == '-')
    {
        ptr++;
        neg = -1;
    }
    else if(*ptr == '+')
    {
        neg = 1;
        ptr++;
    }

    double val = 0;

    while(1)
    {
        if(*ptr >= '0' && *ptr <= '9')
        {
            val *= 10;
            val += (*ptr - '0');
            ptr++;
        }
        else if(*ptr == '.')
        {
            ptr++;
            break;
        }
        else
        {
            return neg * val;
        }
    }

    double digits = 0;
    long divisor = 1;
    while(1)
    {
        if(*ptr >= '0' && *ptr <= '9')
        {
            val *= 10;
            val += (*ptr - '0');
            divisor *= 10;
        }
        else
        {
            break;
        }

        ptr++;
    }

    val = (val + (digits / divisor));

    return neg * val;
}

int atoi(const char* buf)
{
	while(isspace(*buf)) buf++;

	int neg = 1;
	if(*buf == '-')
	{
		neg = -1;
		buf++;
	}
    else if(*buf == '+')
    {
        neg = 1;
        buf++;
    }

	int i = 0;

	while(*buf)
	{
		if(*buf >= '0' && *buf <= '9')
		{
			i *= 10;
			i += (*buf - '0');
		}
		else
		{
			break;
		}

		buf++;
	}

	return neg * i;
}

long atol(const char* buf)
{
	while(*buf == ' ') buf++;

	long neg = 1;
	if(*buf == '-')
	{
		neg = -1;
		buf++;
	}
    else if(*buf == '+')
    {
        neg = 1;
        buf++;
    }

	long i = 0;

	while(*buf)
	{
		if(*buf >= '0' && *buf <= '9')
		{
			i *= 10;
			i += (*buf - '0');
		}
		else
		{
			break;
		}

		buf++;
	}

	return neg * i;
}