#!/usr/bin/env zsh

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export COMPlus_EnableDiagnostics=0

export __CT_PRODUCT_PATH=./out
export __CT_HOSTFXR_PATH=/usr/local/share/dotnet/host/fxr/6.0.15/libhostfxr.dylib

export __CT_ALGOHOST_ENDPOINT_DIR=testing_app
export __CT_ALGOHOST_ENDPOINT_ASM=testing_app.dll
export __CT_ALGOHOST_ENDPOINT_CONFIG=testing_app.runtimeconfig.json
export __CT_ALGOHOST_ENDPOINT_TYPE=testing_app.Program, testing_app
export __CT_ALGOHOST_ENDPOINT_METHOD=ReverseLine
