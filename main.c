#include <avr/io.h>
#include <util/delay.h>

int main(void)
{
    DDRB = _BV(PB0);
    while(1) {
        PINB |= _BV(PB0);
        _delay_ms(500);
    }
    return 1;
}
