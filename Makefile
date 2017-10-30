# Makefile for AVR microcontrollers
# --- Final name of the hex file ---
TARGET = blink

#--- MCU type and speed ---
MCU   = atmega32u4
F_CPU = 16000000UL

#--- AVR GCC binutils ---
CC       = avr-gcc
OBJ-COPY = avr-objcopy
SIZE     = avr-size

#--- Path for generated files ---
BUILD_DIR = build
BIN_DIR   = bin

#--- Configuration ----
# If you have source code in different directory,
# Put the different directory in VPATH, separated by :
VPATH=.:../
SRC = main.c toto.c ../truc.c
SRC2 = $(notdir $(SRC))
OBJ = $(SRC2:%.c=$(BUILD_DIR)/%.o)

TARGET_OBJ = $(BUILD_DIR)/$(TARGET).o
TARGET_HEX = $(BIN_DIR)/$(TARGET).hex

#--- Compiler flags ---
CFLAGS  = -Wall -O2 -DF_CPU=$(F_CPU) -mmcu=$(MCU)

#--- Linker flags ---
LDFLAGS = -lm

#--- Avrdude configuration ---
DUDE_PROGRAMMER = avr109
DUDE_PORT = /dev/ttyACM0

#--- The 'all' target ---
all: $(TARGET_HEX)

# Create 'build' and 'bin' directory if they doesn't exists
$(OBJ): | $(BUILD_DIR) $(BIN_DIR)

# Create 'build' directory if it doesn't exists
$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

# Create 'bin' directory if it doesn't exists
$(BIN_DIR):
	@mkdir -p $(BIN_DIR)

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
	@$(SIZE) --format=avr --mcu=$(MCU) $(TARGET_OBJ)

.PHONY: program clean
program:
	avrdude -p $(MCU) -c $(DUDE_PROGRAMMER) -P $(DUDE_PORT) -U flash:w:$(TARGET_HEX)

clean:
	rm -f $(OBJ) $(TARGET_OBJ) $(TARGET_HEX)
