@echo off
set ROOT=%~dp0

if not "%2" == "" (
  echo;
  echo ERROR: Too much arguments.
  goto :EOF
)
if "%1" == "" (
  echo;
  echo Usage: atcoder [contest URL]
  goto :EOF
)

set URL=%1
set ID=%URL:~-8%

if not exist test (
  mkdir test
)
if not exist bin (
  mkdir bin
)
if not exist %ROOT%config (
  mkdir %ROOT%config
)
if not exist %ROOT%config\template.txt (
  echo #include ^<bits/stdc++.h^>>>%ROOT%config\template.txt
  echo using namespace std;>>%ROOT%config\template.txt
  echo.>>%ROOT%config\template.txt
  echo int main^(^) {>>%ROOT%config\template.txt
  echo   cout ^<^< "test\n";>>%ROOT%config\template.txt
  echo.>>%ROOT%config\template.txt
  echo   return 0;>>%ROOT%config\template.txt
  echo }>>%ROOT%config\template.txt
)

if not exist test\%ID% (
  echo Download Test Cases...
  curl %URL% -O -#
  if not exist %ID% (
    echo ERROR: invalid URL.
    goto :EOF
  )
  %ROOT%bin\parseTestcase.exe %ID%
  move %ID% test\%ID% > nul
  echo Downloaded.
  echo;
)

if not exist %ID%.cpp (
  echo No Source File.
  copy nul %ID%.cpp > nul
  type %ROOT%config\template.txt >> %ID%.cpp
  echo Created "%ID%.cpp"
  echo;
)

echo Compile...
@echo on
g++ -g -std=gnu++14 -O0 %ID%.cpp -o bin\%ID%.exe
@echo off
echo;
echo Test Start.
echo;

%ROOT%bin\test.exe test\%ID% bin\%ID%.exe

del __tmp
echo;
echo Finish.
