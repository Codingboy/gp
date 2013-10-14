/**
 * Highlevel API for handling simple LEDs.
 */

#ifndef LED_H
#define LED_H

#include "gpio.h"

typedef struct
{
	Gpio* gpio;
	u8 onState;
} Led;

/**
 * Initialises an Led.
 * @param[out] led Led that shall be initialised
 * @param[out] gpio gpio used by led
 * @param[in] port port
 * @param[in] bit specifies the used pin
 * @param[in] onState defines if Led is on or off when output is set; Set it to 0 if Led has a pullupresistor, otherwise set it to 1
 * @pre the pin you specified by \ port and \p bit should exist
 * @pre an LED should be connected correctly to the pin you specified by \ port and \p bit
 * @post \p led is initialised
 */
void initLed(Led* led, Gpio* gpio, u8 port, u8 bit, u8 onState);

/**
 * Turns on an LED.
 * @param[in] led used Led
 * @pre \p led is initialised
 * @post LED is turned on
 */
void onLed(Led* led);

/**
 * Turns off an LED.
 * @param[in] led used Led
 * @pre \p led is initialised
 * @post LED is turned off
 */
void offLed(Led* led);

/**
 * Toggles an LED.
 * @param[in] led used Led
 * @pre \p led is initialised
 * @post LED is toggled
 */
void toggleLed(Led* led);

/**
 * Checks if an LED is turned on
 * @param[in] led used Led
 * @pre \p led is initialised
 * @return 0 if \p led is turned off, 1 if \p led is turned on
 */
u8 checkLed(Led* led);

#endif
