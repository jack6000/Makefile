TARGET = blink

MCU   = atmega32u4
F_CPU = 16000000UL

CC       = avr-gcc
OBJ-COPY = avr-objcopy
SIZE     = avr-size

BUILD_DIR = build
BIN_DIR   = bin

SRC = main.c toto.c
OBJ = $(SRC:%.c=$(BUILD_DIR)/%.o)

TARGET_OBJ = $(BUILD_DIR)/$(TARGET).o
TARGET_HEX = $(BIN_DIR)/$(TARGET).hex

CFLAGS  = -Wall -O2 -DF_CPU=$(F_CPU) -mmcu=$(MCU)
LDFLAGS = -lm

all: $(TARGET_HEX)

# Compile all c files
$(BUILD_DIR)/%.o: %.c
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -o $@ -c $<

# Link all .o files into target.o file
$(TARGET_OBJ): $(OBJ)
	@echo "\r\nLinking..."
	$(CC) -o $@ $^ $(LDFLAGS)

# Produce target.hex file and show usefull informations
$(TARGET_HEX): $(TARGET_OBJ)
	@echo "\r\nMaking $(TARGET_HEX) file..."
	$(OBJ-COPY) -j .text -j .data -O ihex $^ $@
	@echo ""
	@$(SIZE) --format=avr $(TARGET_OBJ)

.PHONY: program clean
program:
	avrdude -p $(MCU) -c avr109 -P /dev/ttyACM0 -U flash:w:$(TARGET_HEX)

clean:
	rm -f $(OBJ) $(TARGET_OBJ) $(TARGET_HEX)
