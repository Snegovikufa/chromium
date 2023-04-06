.DEFAULT_GOAL := all

CXX = g++
BUILD_DIR = out
EXE = mac_algohost
INC = -I../../native_host/inc -I../../native_host
LIB_INC = ./native_host/libs
CXXFLAGS = -Wall --std=c++17 $(INC)
LIBS = nethost
LDFLAGS = -framework Foundation -L$(LIB_INC) -l$(LIBS)
COPY_FILES = $(LIB_INC)/* $(BUILD_DIR)/
SOURCES = main.mm ../../native_host/nativehost.cc
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/nativehost.o

$(BUILD_DIR)/main.o: main.mm
	$(CXX) $(CXXFLAGS) -c main.mm -o $@

$(BUILD_DIR)/nativehost.o: ../../native_host/nativehost.cc
	$(CXX) $(CXXFLAGS) -c ../../native_host/nativehost.cc -o $(BUILD_DIR)/nativehost.o

$(EXE): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $(BUILD_DIR)/$(EXE)

all: $(EXE)
	@echo all
	cp -fv $(COPY_FILES)

clean:
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/$(EXE)
