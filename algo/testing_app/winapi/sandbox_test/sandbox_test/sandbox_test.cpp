#include <windows.h>
#include <iostream>

int main()
{
  HKEY hKey;
  DWORD dwDisposition;
  LPCWSTR key = L"sandbox_test";
  if (RegCreateKeyEx(HKEY_LOCAL_MACHINE,
                     key, 0,
                     NULL, 0, KEY_WRITE, NULL, &hKey,
                     &dwDisposition) == ERROR_SUCCESS) {
    std::cout << "Key " << key << " has been written successfully" << std::endl;
    RegCloseKey(hKey);
  }
  else {
    std::cout << "Create key " << key << " has failed" << std::endl;
    return -1;
  }

  LPCWSTR file = L"C:\\sandbox_test.txt";
  HANDLE hFile = CreateFile(
      file,
      GENERIC_WRITE,
      FILE_SHARE_WRITE,
      NULL,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      NULL);
  if (hFile == INVALID_HANDLE_VALUE) {
    return -2;
  }
  else {
    std::cout << "File " << file << " has been created successfully" << std::endl;
    CloseHandle(hFile);
  }

  return 0;
}