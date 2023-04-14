.PHONY: all clean
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

_ := $(shell mkdir $(BUILD_DIR))

$(BUILD_DIR)/main.o: main.mm
	$(CXX) $(CXXFLAGS) -c $^ -o $@

$(BUILD_DIR)/nativehost.o: ../../native_host/nativehost.cc
	$(CXX) $(CXXFLAGS) -c $^ -o $@

$(EXE): $(OBJECTS)
	$(CXX) $(LDFLAGS) $^ -o $(BUILD_DIR)/$@

testing_app: ../../linux/testing_app/testing_app.csproj
	$(info $(shell mkdir $(BUILD_DIR)/testing_app))
	dotnet build ../../linux/testing_app/testing_app.csproj -o out/testing_app

all: $(EXE) testing_app
	cp -fv $(LD_PATH)/* $(BUILD_DIR)/

clean: $(BUILD_DIR)
	rm -rf $</*
	rmdir $<
