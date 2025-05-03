:# Makefile for rsa.s using fopen/fread/fclose on ARM

AS = as
LD = ld
ASFLAGS = -g
LDFLAGS = -lc -dynamic-linker /lib/ld-linux-armhf.so.3 -L/lib
ld -o rsa rsa.o -lc -lgcc -dynamic-linker /lib/ld-linux-armhf.so.3

TARGET = rsa
SRC = rsa.s
OBJ = rsa.o

all: $(TARGET)

$(TARGET): $(OBJ)
	$(LD) -o $@ $^ $(LDFLAGS)

$(OBJ): $(SRC)
	$(AS) $(ASFLAGS) -o $@ $<

clean:
	rm -f *.o $(TARGET)
