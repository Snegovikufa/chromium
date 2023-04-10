.DEFAULT_GOAL := all

CXX = g++
BUILD_DIR = out
EXE = mac_algohost
INC = -I../../native_host/inc -I../../native_host
LD_PATH = ./native_host/libs
CXXFLAGS = -Wall -g3 -O0 --std=c++17 $(INC)
LIBS = -lnethost
LDFLAGS = -framework Foundation -L$(LD_PATH) $(LIBS) -Wl,-rpath,@loader_path
SOURCES = main.mm ../../native_host/nativehost.cc
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/nativehost.o

$(BUILD_DIR)/main.o: main.mm
	$(CXX) $(CXXFLAGS) -c $^ -o $@

$(BUILD_DIR)/nativehost.o: ../../native_host/nativehost.cc
	$(CXX) $(CXXFLAGS) -c $^ -o $@

$(EXE): $(OBJECTS)
	$(CXX) $(LDFLAGS) $^ -o $(BUILD_DIR)/$@

all: $(EXE)
	cp -fv $(LD_PATH)/* $(BUILD_DIR)/

clean:
	rm -f $(BUILD_DIR)/*.o $(BUILD_DIR)/$(EXE)
