#include "led.h"

void initLed(Led* led, Gpio* gpio, u8 port, u8 bit, u8 onState)
{
	initGpio(gpio, port, bit);
	led->gpio = gpio;
	led->onState = onState;
	
	ctlGpioOut(gpio);
	offLed(led);
}

void onLed(Led* led)
{
	if (led->onState)
	{
		setGpioOut(led->gpio);
	}
	else
	{
		clearGpioOut(led->gpio);
	}
}

void offLed(Led* led)
{
	if (led->onState)
	{
		clearGpioOut(led->gpio);
	}
	else
	{
		setGpioOut(led->gpio);
	}
}

void toggleLed(Led* led)
{
	toggleGpioOut(led);
}

u8 checkLed(Led* led)
{
	return getGpioOut(led->gpio);
}
