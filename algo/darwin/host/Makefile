.PHONY: all clean
.DEFAULT_GOAL := all

CXX = clang++
BUILD_DIR = out
EXE = mac_algohost
INC = -I../../native_host/inc -I../../native_host

ifndef ARCH
  ARCH = $(shell uname -m)
endif

ifeq ($(ARCH), x86_64)
  TRIPLE = x86_64-apple-darwin-macho
  LD_PATH = ./native_host/libs/x86_64
  $(info architecture is x64)
else ifeq ($(ARCH), aarch64)
  TRIPLE = arm64v8-apple-darwin-macho
  LD_PATH = ./native_host/libs/aarch64
  $(info architecture is arm64)
else
  $(error unsupported architecture)
endif

CXXFLAGS = -Wall -g3 -O0 --std=c++17 $(INC)
LIBS = -lnethost
LDFLAGS = -framework Foundation -L$(LD_PATH) $(LIBS) -Wl,-rpath,@loader_path
SOURCES = main.mm ../../native_host/nativehost.cc
OBJECTS = $(BUILD_DIR)/main.o $(BUILD_DIR)/nativehost.o

_ := $(shell mkdir -p $(BUILD_DIR))

$(BUILD_DIR)/main.o: main.mm
	$(CXX) --target=$(TRIPLE) $(CXXFLAGS) -c $^ -o $@

$(BUILD_DIR)/nativehost.o: ../../native_host/nativehost.cc
	$(CXX) --target=$(TRIPLE) $(CXXFLAGS) -c $^ -o $@

$(EXE): $(OBJECTS)
	$(CXX) --target=$(TRIPLE) $(LDFLAGS) $^ -o $(BUILD_DIR)/$@

testing_app: ../../linux/testing_app/testing_app.csproj
	$(info $(shell mkdir -p $(BUILD_DIR)/testing_app))
	dotnet build ../../linux/testing_app/testing_app.csproj -o out/testing_app

all: $(EXE) testing_app
	cp -fv $(LD_PATH)/* $(BUILD_DIR)/

clean: $(BUILD_DIR)
	rm -rf $</
