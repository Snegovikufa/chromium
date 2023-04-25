#import <Foundation/Foundation.h>

#include <iostream>
#include <string>

#include <errno.h>
#include <nethost.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

#include "nativehost.h"

#define PATH_DELIMITER "/"

extern "C" {
#import <sandbox.h>
int sandbox_init_with_parameters(const char *profile,
                                 uint64_t flags,
                                 const char *const parameters[],
                                 char **errorbuf);
}

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

    const char profile[] = "(version 1)" \
                            "(deny default)" \
                            "(allow file-read* (subpath \"/usr\"))" \
                            "(allow file-read* (subpath (param \"CURRENT_DIR\")))" \
                            "(allow file-write* (subpath (param \"EXE_DIR\")))";

    NSString *exe_directory = [[NSBundle mainBundle] bundlePath];
    const auto fs_manager = [NSFileManager defaultManager];
    const char *home_dir = [NSHomeDirectory() UTF8String];
    const char *current_dir = [[fs_manager currentDirectoryPath] UTF8String];
    const char *exe_dir = [exe_directory UTF8String];
    const char *parameters[] = { "USER_HOME_DIR", home_dir,
        "CURRENT_DIR", current_dir, "EXE_DIR", exe_dir, NULL };

    if (sandbox_init_with_parameters(profile, 0, parameters, NULL))
        exit(1);

    NSString *test_file = [exe_directory stringByAppendingString:@"/test"];
    NSString *content = @"Put this in a file please.";
    NSData *fileContents = [content dataUsingEncoding:NSUTF8StringEncoding];
    [fs_manager createFileAtPath:test_file contents:fileContents attributes:nil];

    [fs_manager changeCurrentDirectoryPath: exe_directory];
    const auto *out_pipe = "out_pipe";
    const auto *in_pipe = "in_pipe";
    if (access(out_pipe, F_OK)) {
        if (mkfifo(out_pipe, 0600) == -1) {
            fprintf(stderr, "unable to create out_pipe");
            return EXIT_FAILURE;
        }
    }
    if (access(in_pipe, F_OK)) {
        if (mkfifo(in_pipe, 0600) == -1) {
            fprintf(stderr, "unable to create in_pipe");
            return EXIT_FAILURE;
        }
    }

    entry_fn(&args, sizeof(args));
}
