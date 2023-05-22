#!/usr/bin/env zsh

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export COMPlus_EnableDiagnostics=0

export __CT_PRODUCT_PATH=/Users/rsafin/dev/ctrader.mac/bin/Debug/osx-arm64/cTrader.Mac.app/Contents/MonoBundle
export __CT_HOSTFXR_PATH=/usr/local/share/dotnet/host/fxr/6.0.15/libhostfxr.dylib

export __CT_ALGOHOST_ENDPOINT_DIR=algohost.netcore
export __CT_ALGOHOST_ENDPOINT_ASM=cTrader.Automate.Host.NetCore.dll
export __CT_ALGOHOST_ENDPOINT_CONFIG=cTrader.Automate.Host.NetCore.runtimeconfig.json
export __CT_ALGOHOST_ENDPOINT_TYPE='cTrader.Automate.Host.NetCore.Endpoint, cTrader.Automate.Host.NetCore'
export __CT_ALGOHOST_ENDPOINT_METHOD=Run
