CC = g++
CFLAGS = -Wall
LINKFLAGS = -framework Foundation 
OBJECTS = main.o
OUT = mac_algohost

all: $(OUT)

main.o: main.mm
	$(CC) $(CFLAGS) -c main.mm

$(OUT): $(OBJECTS)
	$(CC) $(LINKFLAGS) $(OBJECTS) -o $(OUT)

clean:
	rm -f *.o $(OUT)
