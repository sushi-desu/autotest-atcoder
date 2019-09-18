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
  echo;
  echo Download Test Cases...
  curl %URL% -O -#
  if not exist %ID% (
    echo ERROR: invalid URL.
    goto :EOF
  )
  %ROOT%bin\parseTestcase.exe %ID%
  move %ID% test\%ID% > nul
)

if not exist %ID%.cpp (
  echo;
  echo No Source File.
  copy nul %ID%.cpp > nul
  type %ROOT%config\template.txt >> %ID%.cpp
  echo Created "%ID%.cpp"
)
echo;
echo Compile...
g++ -g -std=gnu++14 -O0 %ID%.cpp -o bin\%ID%.exe
echo;

if exist _tmp ( rd /s /q _tmp )
mkdir _tmp
%ROOT%bin\splitTestcase.exe test\%ID%

setlocal enabledelayedexpansion
set pad=0000
set /a i=0
for %%f in (_tmp\in*) do (
  set /a i+=1
  set index=%pad%!i!
  set name=_tmp\out!index:~-2,2!
  type %%f | bin\%ID%.exe >> !name!
)

for /l %%j in (1, 1, !i!) do (
  set index=%pad%%%j
  set output=_tmp\out!index:~-2,2!
  set expect=_tmp\exp!index:~-2,2!
  fc !output! !expect!
)
endlocal

rd /s /q _tmp
