#include <errno.h>
#include <nethost.h>
#include <stdlib.h>

#define STR_EMPTY L""
#define STR_DOT L'.'
#define PATH_DELIMITER L"\\"

#define HOSTFXR_LIB L"hostfxr.dll"

using string_t = std::basic_string<char_t>;


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

    const string_t product_path = getenv(CT_ENV_VAR_PRODUCT_PATH);
    const string_t dotnet_path = getenv(CT_ENV_VAR_DOTNET_PATH);
    const string_t hostfxr_path = getenv(CT_ENV_VAR_HOSTFXR_PATH);

    const string_t endpoint_dir_path = product_path + PATH_DELIMITER + ENDPOINT_DIR;
    const string_t endpoint_asm_path = endpoint_dir_path + PATH_DELIMITER + ENDPOINT_ASM;
    const string_t endpoint_config_path = endpoint_dir_path + PATH_DELIMITER + ENDPOINT_CONFIG;

    const char *config = "algo/testing_app/DotNetLib.runtimeconfig.json";
    const char *dotnet_path = "algo/testing_app/testing_app.dll";
    const char *dotnet_type = "testing_app.Program, testing_app";
    const char *dotnet_type_method = "ReverseLine";

    component_entry_point_fn entry_fn;
    entry_fn = launch_dotnet(dotnet_path, dotnet_type, dotnet_type_method, config);

    struct lib_args
    {
        const char *message;
        int number;
    };

    lib_args args
    {
        "from host!",
        1
    };

    entry_fn(&args, sizeof(args));
}
