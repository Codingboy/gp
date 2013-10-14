/**
 * Lowlevel API for handling io with any connected hardware.
 */

#ifndef GPIO_H
#define GPIO_H

#include "typedefs.h"

typedef struct
{
	u8 port;
	u8 bitmask;
} Gpio;

/**
 * Initialises a Gpio.
 * @param[out] gpio Gpio that shall be initialised
 * @param[in] port port
 * @param[in] bit specifies the used pin
 * @pre the pin you specified by \ port and \p bit should exist
 * @post \p gpio is initialised
 */
void initGpio(Gpio* gpio, u8 port, u8 bit);

/**
 * Configures a Gpio to act as input.
 * @param[in] gpio used Gpio
 * @pre \p gpio is initialised
 * @pre \p gpio should support input mode
 * @post \p gpio is in input mode
 */
void ctlGpioIn(Gpio* gpio);

/**
 * Configures a Gpio to act as output.
 * @param[in] gpio used Gpio
 * @pre \p gpio is initialised
 * @pre \p gpio should support output mode
 * @post \p gpio is in output mode
 */
void ctlGpioOut(Gpio* gpio);

/**
 * Sets the output.
 * @param[in] gpio used Gpio
 * @pre \p gpio should be in output mode
 */
void setGpioOut(Gpio* gpio);

/**
 * Clears the output.
 * @param[in] gpio used Gpio
 * @pre \p gpio should be in output mode
 */
void clearGpioOut(Gpio* gpio);

/**
 * Toggles the output.
 * @param[in] gpio used Gpio
 * @pre \p gpio should be in output mode
 */
void toggleGpioOut(Gpio* gpio);

/**
 * Checks idf the output is set or cleared.
 * @param[in] gpio used Gpio
 * @return 0 if clear, 1 if set
 */
u8 getGpioOut(Gpio* gpio);

/**
 * Checks the input.
 * @param[in] gpio used Gpio
 * @pre \p gpio should be in input mode
 * @return 0 if input is clear, 1 if input is set
 */
u8 getGpioIn(Gpio* gpio);

#endif
