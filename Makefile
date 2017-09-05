TARGET = blink
MCU = atmega32u4
F_CPU = 16000000UL

CC = avr-gcc
OBJ-COPY = avr-objcopy

SRC = main.c
OBJS = $(SRC:.c=.o)

CFLAGS = -Wall -O2 -DF_CPU=$(F_CPU) -mmcu=$(MCU)
LDFLAGS = -lm

all: $(TARGET).hex

%.o: %.c
	$(CC) $(CFLAGS) -o $@ -c $^

$(TARGET).o: $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)

$(TARGET).hex : $(TARGET).o
	$(OBJ-COPY) -j .text -j .data -O ihex $^ $@

program:
	avrdude -p $(MCU) -c avr109 -P /dev/ttyACM0 -U flash:w:$(TARGET).hex

clean:
	rm -f $(OBJS) $(TARGET) *.o *.bin *.hex
