# Makefile for RSA Project

# Compiler and tools
AS = as
CC = gcc
LD = gcc

# Files
RSALIB = rsalib.o
MAIN = main.o
TARGET = rsa_program

# Default rule
all: $(TARGET)

$(RSALIB): rsalib.s
        $(AS) -o $(RSALIB) rsalib.s

$(MAIN): main.s
        $(AS) -o $(MAIN) main.s

$(TARGET): $(MAIN) $(RSALIB)
        $(LD) -o $(TARGET) $(MAIN) $(RSALIB)

# Clean up object files and executable
clean:
        rm -f *.o $(TARGET) encrypted.txt plaintext.txt