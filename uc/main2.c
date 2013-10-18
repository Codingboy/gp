#include <stdbool.h>

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
		case 1:
			switch (DEBUGSTATE)
			{
				case 90:
					onLed(DEBUGLED);
					break;
				case 100:
					offLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break;
		case 2:
			switch (DEBUGSTATE)
			{
				case 40:
					onLed(DEBUGLED);
					break;
				case 50:
					offLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break:
		case 3:
			switch (DEBUGSTATE)
			{
				case 190:
					offLed(DEBUGLED);
					break;
				case 200:
					onLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break:
		case 4:
			switch (DEBUGSTATE)
			{
				case 90:
					offLed(DEBUGLED);
					break;
				case 100:
					onLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break;
		case 5:
			switch (DEBUGSTATE)
			{
				case 40:
					offLed(DEBUGLED);
					break;
				case 50:
					onLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break:
		case 6:
			switch (DEBUGSTATE)
			{
				case 100:
					onLed(DEBUGLED);
					break;
				case 200:
					offLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break:
		case 7:
			switch (DEBUGSTATE)
			{
				case 50:
					onLed(DEBUGLED);
					break;
				case 100:
					offLed(DEBUGLED);
					DEBUGSTATE = 0;
					break;
			}
			break;
		case 8:
			switch (DEBUGSTATE)
			{
				case 25:
					onLed(DEBUGLED);
					break;
				case 50:
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
	while (true)
	{
		
	}
}
