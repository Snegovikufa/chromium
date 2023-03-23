#import <Foundation/Foundation.h>
#import <sys/stat.h>

extern "C" {
#import <sandbox.h>
int sandbox_init_with_parameters(const char *profile,
                                 uint64_t flags,
                                 const char *const parameters[],
                                 char **errorbuf);
}

int main(int argc, const char * argv[]) {
  const char profile[] = "(version 1)" \
      "(deny default)" \
      "(allow file-read* (subpath (param \"USER_HOME_DIR\")))";

  const char* home_dir = [NSHomeDirectory() UTF8String];

  // Parameters are passed as an array containing key,value,NULL.
  const char* parameters[] = { "USER_HOME_DIR", home_dir, NULL };

  if (sandbox_init_with_parameters(profile, 0, parameters, NULL))
    exit(1);

  const char* vim_rc =
      [[NSHomeDirectory() stringByAppendingString:@"/.vimrc"] UTF8String];
  printf("vim_rc is %s\n", vim_rc);

  struct stat sb;
  if (stat(vim_rc, &sb) == 0)
    printf(".vimrc file exists\n");
  else
    printf(".vimrc file does not exists\n");
    

  return 0;
}
