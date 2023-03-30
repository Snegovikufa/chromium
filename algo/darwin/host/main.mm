#include <string>

#include <errno.h>
#include <nethost.h>
#include <stdio.h>
#include <stdlib.h>

#include "nativehost.h"

#define STR_EMPTY ""
#define STR_DOT '.'
#define PATH_DELIMITER "\\"
#define PATH_MAX 1024

#define HOSTFXR_LIB L"hostfxr.dll"

int main(int argc, char** argv) {
    char host_fxr_path[PATH_MAX];
    size_t host_fxr_path_size = sizeof(host_fxr_path) / sizeof(char);
    int rc = get_hostfxr_path(host_fxr_path, &host_fxr_path_size, nullptr);
    if (rc) {
        fprintf(stderr, "unable to get hostfxr path\n");
        return EXIT_FAILURE;
    }

    if (!setenv("DOTNET_gcServer", "1", 1)) {
        return -1;
    }
    if (!setenv("DOTNET_gcConcurrent", "1", 1)) {
        return -1;
    }
    if (!setenv("DOTNET_GCCpuGroup", "1", 1)) {
        return -1;
    }
    if (!setenv("DOTNET_Thread_UseAllCpuGroups", "1", 1)) {
        return -1;
    }

    const std::string product_path = std::string(getenv("__CT_PRODUCT_PATH"));
    const std::string dotnet_path = std::string(getenv("__CT_DOTNET_PATH"));
    const std::string hostfxr_path = std::string(getenv("__CT_HOSTFXR_PATH"));

    const std::string endpoint_dir = std::string(getenv("__CT_ALGOHOST_ENDPOINT_DIR"));
    const std::string endpoint_asm = std::string(getenv("__CT_ALGOHOST_ENDPOINT_ASM"));
    const std::string endpoint_config = std::string(getenv("__CT_ALGOHOST_ENDPOINT_CONFIG"));
    const std::string endpoint_type = std::string(getenv("__CT_ALGOHOST_ENDPOINT_TYPE"));
    const std::string endpoint_method = std::string(getenv("__CT_ALGOHOST_ENDPOINT_METHOD"));
    const std::string preload_endpoint_method = std::string(getenv("__CT_ALGOHOST_ENDPOINT_PRELOAD_METHOD"));

    const std::string endpoint_dir_path = product_path + PATH_DELIMITER + endpoint_dir;
    const std::string endpoint_asm_path = endpoint_dir_path + PATH_DELIMITER + endpoint_asm;
    const std::string endpoint_config_path = endpoint_dir_path + PATH_DELIMITER + endpoint_config;

    const char *config = "algo/testing_app/DotNetLib.runtimeconfig.json";
    const char *dotnet_asm_path = "algo/testing_app/testing_app.dll";
    const char *dotnet_type = "testing_app.Program, testing_app";
    const char *dotnet_type_method = "ReverseLine";

    component_entry_point_fn entry_fn;
    entry_fn = launch_dotnet(dotnet_asm_path, dotnet_type, dotnet_type_method, config);

    struct lib_args
    {
        const char *message;
        int number;
    };

    lib_args args = 
    {
        .message = "from host!",
        .number = 1
    };

    entry_fn(&args, sizeof(args));
}
