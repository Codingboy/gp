#include "gpio.h"
#include <avr/io.h>

void initGpio(Gpio* gpio, u8 port, u8 bit)
{
	gpio->port = port;
	gpio->bitmask = 1<<bit;
}

void ctlGpioIn(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			PORTB = PORTB & ~(gpio->bitmask);
			DDRB = DDRB & ~(gpio->bitmask);
			break;
		case 2:
			PORTC = PORTC & ~(gpio->bitmask);
			DDRC = DDRC & ~(gpio->bitmask);
			break;
		case 3:
			PORTD = PORTD & ~(gpio->bitmask);
			DDRD = DDRD & ~(gpio->bitmask);
			break;
		case 4:
			PORTE = PORTE & ~(gpio->bitmask);
			DDRE = DDRE & ~(gpio->bitmask);
			break;
		case 5:
			PORTF = PORTF & ~(gpio->bitmask);
			DDRF = DDRF & ~(gpio->bitmask);
			break;
	}
}

void ctlGpioOut(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			PORTB = PORTB | gpio->bitmask;
			DDRB = DDRB | gpio->bitmask;
			break;
		case 2:
			PORTC = PORTC | gpio->bitmask;
			DDRC = DDRC | gpio->bitmask;
			break;
		case 3:
			PORTD = PORTD | gpio->bitmask;
			DDRD = DDRD | gpio->bitmask;
			break;
		case 4:
			PORTE = PORTE | gpio->bitmask;
			DDRE = DDRE | gpio->bitmask;
			break;
		case 5:
			PORTF = PORTF | gpio->bitmask;
			DDRF = DDRF | gpio->bitmask;
			break;
	}
}

void setGpioOut(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			PORTB = PORTB | gpio->bitmask;
			break;
		case 2:
			PORTC = PORTC | gpio->bitmask;
			break;
		case 3:
			PORTD = PORTD | gpio->bitmask;
			break;
		case 4:
			PORTE = PORTE | gpio->bitmask;
			break;
		case 5:
			PORTF = PORTF | gpio->bitmask;
			break;
	}
}

void clearGpioOut(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			PORTB = PORTB & ~(gpio->bitmask);
			break;
		case 2:
			PORTC = PORTC & ~(gpio->bitmask);
			break;
		case 3:
			PORTD = PORTD & ~(gpio->bitmask);
			break;
		case 4:
			PORTE = PORTE & ~(gpio->bitmask);
			break;
		case 5:
			PORTF = PORTF & ~(gpio->bitmask);
			break;
	}
}

void toggleGpioOut(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			PORTB = PORTB ^ gpio->bitmask;
			break;
		case 2:
			PORTC = PORTC ^ gpio->bitmask;
			break;
		case 3:
			PORTD = PORTD ^ gpio->bitmask;
			break;
		case 4:
			PORTE = PORTE ^ gpio->bitmask;
			break;
		case 5:
			PORTF = PORTF ^ gpio->bitmask;
			break;
	}
}

u8 getGpioOut(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			return PORTB & gpio->bitmask;
		case 2:
			return PORTC & gpio->bitmask;
		case 3:
			return PORTD & gpio->bitmask;
		case 4:
			return PORTE & gpio->bitmask;
		case 5:
			return PORTF & gpio->bitmask;
	}
	return 0;
}

u8 getGpioIn(Gpio* gpio)
{
	switch (gpio->port)
	{
		case 1:
			return PINB & gpio->bitmask;
		case 2:
			return PINC & gpio->bitmask;
		case 3:
			return PIND & gpio->bitmask;
		case 4:
			return PINE & gpio->bitmask;
		case 5:
			return PINF & gpio->bitmask;
	}
	return 0;
}
