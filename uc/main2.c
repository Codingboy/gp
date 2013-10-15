#ifdef DEBUG
#include "debug.h"

extern u8 DEBUGMODE;
extern u8 DEBUGSTATE;
extern Led* DEBUGLED;
extern Gpio* DEBUGGPIO;

ISR(TIMER0_OVF_vect)//each 10 ms
{
	DEBUGSTATE++;
	switch (DEBUGMODE)
	{
		case 0:
			switch (DEBUGSTATE)
			{
				case 190:
					onLed(DEBUGLED);
					break;
				case 200:
					offLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break:
		default:
			break;
	}
	TCNT0 = 256-157;//each 10 ms
}
#endif

int main()
{
#ifdef DEBUG
	initDebug();
#endif
	
}