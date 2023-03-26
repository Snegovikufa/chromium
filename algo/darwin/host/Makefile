CC = g++
OBJECTS = main.o
OUT = mac_algohost
INC = -I../../native_host/inc
LIB_INC = -L../../native_host/libs
CFLAGS = -Wall $(INC)
LIB = -lnethost
LINKFLAGS = -framework Foundation $(LIB_INC) $(LIB)

all: $(OUT)

main.o: main.mm
	$(CC) $(CFLAGS) -c main.mm

$(OUT): $(OBJECTS)
	$(CC) $(LINKFLAGS) $(OBJECTS) -o $(OUT)

clean:
	rm -f *.o $(OUT)
