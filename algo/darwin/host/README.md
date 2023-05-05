# Prerequisits

* Mac OS 12.3.1
* checkout of `spotware/lkgr` branch
* Developer tools, Xcode

# Instructions

### Change to the project dir:
```shell
$ cd algo/darwin/host
```


### Environment variables in code are already set and not need to be changed:

|             Hardcoded env vars            |               Value              |
|-------------------------------------------|----------------------------------|
|   DOTNET_gcServer                         |                  1               |
|   DOTNET_gcConcurrent                     |                  1               |
|   DOTNET_GCCpuGroup                       |                  1               |
|   DOTNET_Thread_UseAllCpuGroups           |                  1               |


### Install dotnet SDK 6.0.15 and find libhostfxr.dylib, e.g.
```shell
$ find /usr/local/share/dotnet -name 'libhostfxr.dylib'
```
Open env.sh in a text editor and set __CT_HOSTFXR_PATH to the path found
Check if ENDPOINT vars belong to the dotnet assembly to be invoked by the host

### Environment variables in env.sh:

|             Env var name             |             Value                     |            Description                |
|--------------------------------------|---------------------------------------|---------------------------------------|
| DOTNET_SYSTEM_GLOBALIZATION_INVARIANT|              1                        |   allows to escape extra dependences  |
| COMPlus_EnableDiagnostics            |              0                        |   allows to escape extra communication|
| __CT_PRODUCT_PATH                    |            ./out                      |   relative path to build directory    |
| __CT_HOSTFXR_PATH                    | /fxr/6.0.15/libhostfxr.dylib          |   absolute path to fxr library        |
| __CT_ALGOHOST_ENDPOINT_DIR           | testing_app                           |   folder with dotnet assembly         |
| __CT_ALGOHOST_ENDPOINT_ASM           | testing_app.dll                       |   name of assembly                    |
| __CT_ALGOHOST_ENDPOINT_CONFIG        | testing_app.runtimeconfig.json        |   name of runtime config              |
| __CT_ALGOHOST_ENDPOINT_TYPE          | testing_app.Program, testing_app      |   class and namespace                 |
| __CT_ALGOHOST_ENDPOINT_METHOD        | ReverseLine                           |   method to be invoked                |

### Source env.sh:
```shell
$ source ./env.sh
```

### Build the project for current host:
```shell
$ make
```

### Build the project for ARM64 on x86_64:
```shell
$ ARCH=aarch64 make
```

### Build the project for x86_64 on ARM64:
```shell
$ ARCH=x86_64 make
```

### Run sandbox:
```shell
$ ./out/mac_algohost
```
