#include "ez3.h"
#include <avr/delay.h>

void initEz3(Ez3* ez3, Gpio* rx, u8 portRx, u8 bitRx, Gpio*an, u8 portAn, u8 bitAn, Gpio* tx, u8 portTx, u8 bitTx)
{
	initGpio(rx, portRx, bitRx);
	initGpio(an, portAn, bitAn);
	initGpio(tx, portTx, bitTx);
	ctlGpioIn(pw);
	ctlGpioIn(an);
	ctlGpioOut(rx);
	_delay_ms(250);
	setGpioOut(rx);
	_delay_us(20);
	clearGpioOut(rx);
	_delay_ms(200);
	ez3->rx = rx;
	ez3->tx = tx;
	ez3->an = an;
}

u16 measureEz3(Ez3* ez3)
{
	setGpioOut(ez3->rx);
	_delay_us(20);
	clearGpioOut(ez3->rx);
	while (!getGpioIn(pw))
	{
	}
	timestamp = getTime();
	while (getGpioIn(pw) && getTime() < timestamp+37)
	{
	}
	if (getTime() >= timestamp+37)
	{
		return 0;//no object in range
	}
	else//read value from adc
	{
		//using internal 2.56 V reference for adc
		ADMUX |= 1<<REFS1;
		ADMUX |= 1<<REFS0;

		//left adjusted
		ADMUX |= 1<<ADLAR;

		//select ADC0
		ADCSRB &= ~(1<<MUX5);
		ADMUX &= ~(1<<MUX4);
		ADMUX &= ~(1<<MUX3);
		ADMUX &= ~(1<<MUX2);
		ADMUX &= ~(1<<MUX1);
		ADMUX &= ~(1<<MUX0);

		//disable autoconversion
		ADCSRA &= ~(1<<ADATE);

		//disable adc interrupt
		ADCSRA &= ~(1<<ADIE);

		//set prescaler to 128
		ADCSRA |= 1<<ADPS2;
		ADCSRA |= 1<<ADPS1;
		ADCSRA |= 1<<ADPS0;

		//low speed, low powercosumption
		ADCSRB &= ~(1<<ADHSM);

		//low powerconsumtion, ADC0 not readable manually
		ADCSRB |= ADC0D;

		//enable adc
		ADCSRA |= 1<<ADEN;

		//start conversion
		ADCSRA |= 1<<ADSC;
		while (ADCSRA & 1<<ADSC)
		{
		}
		return (u16)(ADCH*2.5)*x;
	}
}
