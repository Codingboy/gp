#ifndef EZ3_H
#define EZ3_H

#include "gpio.h"

typedef struct
{
	Gpio* rx;
	Gpio* an;
	Gpio* tx;
} Ez3;

/**
 * Initialises an EZ3 sensor.
 * When this function is called, the range between EZ3 sensor and objects in front of it shall be minimum 17.78 cm, optimum 35.56 cm or greater.
 */
void initEz3(Ez3* ez3, Gpio* rx, u8 portRx, u8 bitRx, Gpio*an, u8 portAn, u8 bitAn, Gpio* tx, u8 portTx, u8 bitTx);

/**
 * Measures the range between EZ3 sensor and an object.
 * EZ3 sensor detects objects in between range from 15.24 up to 645 cm.
 * Resolution is 2.54 cm.
 * Objects nearer than 15.24 cm will be detected as if they were in a range of 15.24 cm.
 */
u16 measureEz3(Ez3* ez3);

#endif
