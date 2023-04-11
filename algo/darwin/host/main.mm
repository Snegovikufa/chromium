#include <iostream>
#include <string>

#include <errno.h>
#include <nethost.h>
#include <stdlib.h>

#include "nativehost.h"

#define STR_EMPTY ""
#define STR_DOT '.'
#define PATH_DELIMITER "/"
#define PATH_MAX 1024

int main(int argc, char** argv) {
    if (setenv("DOTNET_gcServer", "1", 1)) {
        return EXIT_FAILURE;
    }
    if (setenv("DOTNET_gcConcurrent", "1", 1)) {
        return EXIT_FAILURE;
    }
    if (setenv("DOTNET_GCCpuGroup", "1", 1)) {
        return EXIT_FAILURE;
    }
    if (setenv("DOTNET_Thread_UseAllCpuGroups", "1", 1)) {
        return EXIT_FAILURE;
    }

    auto env_or_empty = [](const char* env) {return getenv(env) ? getenv(env) : "";};

    const auto product_path = std::string(env_or_empty("__CT_PRODUCT_PATH"));
    const auto hostfxr_path = std::string(env_or_empty("__CT_HOSTFXR_PATH"));

    const auto endpoint_dir = std::string(env_or_empty("__CT_ALGOHOST_ENDPOINT_DIR"));
    const auto endpoint_asm = std::string(env_or_empty("__CT_ALGOHOST_ENDPOINT_ASM"));
    const auto endpoint_config = std::string(env_or_empty("__CT_ALGOHOST_ENDPOINT_CONFIG"));
    const auto endpoint_type = std::string(env_or_empty("__CT_ALGOHOST_ENDPOINT_TYPE"));
    const auto endpoint_method = std::string(env_or_empty("__CT_ALGOHOST_ENDPOINT_METHOD"));

    const auto endpoint_dir_path = product_path + PATH_DELIMITER + endpoint_dir;
    const auto endpoint_asm_path = endpoint_dir_path + PATH_DELIMITER + endpoint_asm;
    const auto endpoint_config_path = endpoint_dir_path + PATH_DELIMITER + endpoint_config;

    const char *assembly = endpoint_asm_path.c_str();
    const char *type = endpoint_type.c_str();
    const char *method = endpoint_method.c_str();
    const char *config = endpoint_config_path.c_str();
    const char *fxr = hostfxr_path.c_str();

    if (!strlen(assembly) | !strlen(type) | !strlen(method) | !strlen(config) | !strlen(fxr)) {
        std::cerr << "One of env vars are missing" << std::endl;
        return EXIT_FAILURE;
    }

    component_entry_point_fn entry_fn;
    entry_fn = launch_dotnet(assembly, type, method, config, fxr);

    struct lib_args {
        const char *message;
        int number;
    };

    lib_args args = {
        .message = "from host!",
        .number = 1
    };

    entry_fn(&args, sizeof(args));
}
