#ifndef LED_H
#define LED_H

#include "gpio.h"

typedef struct
{
	Gpio* gpio;
	u8 pressedState;
} Button;

/**
 * Initialises a Button.
 * @param[out] but Button that shall be initialised
 * @param[out] gpio gpio used by but
 * @param[in] port port
 * @param[in] bit specifies the used pin
 * @param[in] pressedState the state that is equivalent to the state when the button is pressed
 * @pre the pin you specified by \ port and \p bit should exist
 * @pre a Button should be connected correctly to the pin you specified by \ port and \p bit
 * @post \p but is initialised
 */
void initLed(Button* but, Gpio* gpio, u8 port, u8 bit, u8 pressedState);

/**
 * Checks if a Button is pressed.
 * @param[in] but used Button
 * @pre \p but is initialised
 * @return 0 if \p but is not pressed, 1 if \p but is pressed
 */
u8 checkButton(Button* but);

#endif