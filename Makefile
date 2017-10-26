TARGET = blink

MCU = atmega32u4
F_CPU = 16000000UL

CC = avr-gcc
OBJ-COPY = avr-objcopy

SRC = $(wildcard src/*.c)
OBJ = $(SRC:src/%.c=obj/%.o)
TARGET_OBJ = obj/$(TARGET).o
TARGET_HEX = bin/$(TARGET).hex

CFLAGS = -Wall -O2 -DF_CPU=$(F_CPU) -mmcu=$(MCU)
LDFLAGS = -lm

all: $(TARGET_HEX)

# Compile all c files
$(OBJ): $(SRC)
	$(CC) $(CFLAGS) -o $@ -c $^

# Link all c files into target.o file
$(TARGET_OBJ): $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

# Produce target.hex file
$(TARGET_HEX): obj/$(TARGET).o
	$(OBJ-COPY) -j .text -j .data -O ihex $^ $@

.PHONY: program clean
program:
	avrdude -p $(MCU) -c avr109 -P /dev/ttyACM0 -U flash:w:$(TARGET_HEX)

clean:
	rm -f $(OBJ) $(TARGET_OBJ) $(TARGET_HEX)
