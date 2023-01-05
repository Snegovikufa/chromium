#include <windows.h>

#include <iostream>
#include <string>

std::string GetLastErrorAsString() {
  DWORD errorMessageID = ::GetLastError();
  std::cerr << "LastError is " << errorMessageID << std::endl;
  if (errorMessageID == 0) {
    return std::string();
  }

  LPSTR messageBuffer = nullptr;
  size_t size = FormatMessageA(
      FORMAT_MESSAGE_ALLOCATE_BUFFER
        | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
      NULL, errorMessageID, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
      (LPSTR)&messageBuffer, 0, NULL);

  std::string message(messageBuffer, size);
  LocalFree(messageBuffer);

  return message;
}

int main()
{
  HKEY hKey;
  DWORD dwDisposition;
  std::wstring key = L"sandbox_test";
  LPCWSTR lpsKey = key.c_str();
  if (RegCreateKeyEx(HKEY_CURRENT_USER,
                     lpsKey, 0,
                     NULL, 0, KEY_WRITE, NULL, &hKey,
                     &dwDisposition) == ERROR_SUCCESS) {
    std::wcout << L"Key " << key << L" has been written successfully" << std::endl;
    RegCloseKey(hKey);
  }
  else {
    std::wcout << L"Create key " << key << L" has failed" << std::endl;
    std::cerr << GetLastErrorAsString() << std::endl;
    return -1;
  }

  std::wstring file = L"C:\\sandbox_test.txt";
  LPCWSTR lpsFile = L"C:\\sandbox_test.txt";
  HANDLE hFile = CreateFile(
      lpsFile,
      GENERIC_WRITE,
      FILE_SHARE_WRITE,
      NULL,
      CREATE_ALWAYS,
      FILE_ATTRIBUTE_NORMAL,
      NULL);
  if (hFile == INVALID_HANDLE_VALUE) {
    std::wcout << L"Failed to create file " << file << std::endl;
    std::cerr << GetLastErrorAsString() << std::endl;
    return -2;
  }
  else {
    std::wcout << L"File " << file << L" has been created successfully" << std::endl;
    CloseHandle(hFile);
  }

  return 0;
}