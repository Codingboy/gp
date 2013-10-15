#ifndef DEBUG_H
#define DEBUG_H

#ifdef DEBUG

/**
 * Initialises the debug LED.
 */
void initDebug();

/**
 * Sets a debugmode.
 * Depending on the mode, the debug LED will blink other.
 */
void setDebug(u8 debugLevel);

#endif

#endif
