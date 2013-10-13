#include "button.h"

void initLed(Button* but, Gpio* gpio, u8 port, u8 bit, u8 pressedState)
{
	initGpio(gpio, port, bit);
	but->gpio = gpio;
	but->pressedState = pressedState;
	
	ctlGpioIn(gpio);
}

u8 checkButton(Button* but)
{
	return getGpioIn(but->gpio);
}