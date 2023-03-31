CC = g++
OBJECTS = out/main.o out/nativehost.o
EXE = mac_algohost
INC = -I../../native_host/inc -I../../native_host
LIB_INC = -L./native_host/libs
CPPFLAGS = -Wall --std=c++17 $(INC)
LIB = -lnethost
LINKFLAGS = -framework Foundation $(LIB_INC) $(LIB)

all: $(EXE)

out/main.o: main.mm
	$(CC) $(CPPFLAGS) -c main.mm -o out/main.o
out/nativehost.o: ../../native_host/nativehost.cc
	$(CC) $(CPPFLAGS) -c ../../native_host/nativehost.cc -o out/nativehost.o

$(EXE): $(OBJECTS)
	$(CC) $(LINKFLAGS) $(OBJECTS) -o out/$(EXE)

clean:
	rm -f out/*.o out/$(EXE)
