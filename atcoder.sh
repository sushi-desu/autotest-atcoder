#!/bin/bash
ROOT=${0%/*}
URL=${1%}
ID=${URL##*/}
BIN=${ROOT}/bin/mac

if [ ${#} -eq 0 ]; then
  echo
  echo Usage: atcoder [contest URL]
  exit
fi

if [ ${#} -gt 1 ]; then
  echo
  echo ERROR: Too much arguments.
  exit
fi

if [ ! -d ./test ]; then mkdir 'test'; fi
if [ ! -d ./bin ]; then mkdir bin; fi
if [ ! -d ${ROOT}/config ]; then mkdir ${ROOT}/config; fi

if [ ! -e ${ROOT}/config/template.txt ]; then
  echo '#include <bits/stdc++.h>>' >> template.txt
  echo 'using namespace std;' >> template.txt
  echo >> template.txt
  echo 'int main() {' >> template.txt
  echo >> template.txt
  echo '  cout << "test\n";' >> template.txt
  echo >> template.txt
  echo '}' >> template.txt
fi

if [ ! -e test/${ID} ]; then
  echo
  echo Download Test Cases...
  curl ${URL} -O -#
  if [ ! -e ${ID} ]; then
    echo ERROR: invalid URL.
    exit
  fi
  ${BIN}/parseTestcase.out ${ID}
  mv ${ID} test/${ID}
fi

if [ ! -e ${ID}.cpp ]; then
  echo
  echo No Source File.
  cat ${ROOT}/config/template.txt > ${ID}.cpp
  echo Created "${ID}.cpp"
fi

echo
echo Compile...
g++ -std=gnu++14 -O0 ${ID}.cpp -o bin/${ID}.out
echo

if [ -d ./_tmp ]; then rm -rf ./_tmp; fi
mkdir _tmp
${BIN}/splitTestcase.out test/${ID}

# CRLF -> LF
for file in `\find _tmp -depth 1`; do
  nkf -Lu --overwrite ${file}
done

index=0
for file in `\find _tmp -maxdepth 1 -name 'in*' | sort`; do
  index=`expr $index + 1`
  name=_tmp/out`printf %02d $index`
  cat ${file} | bin/${ID}.out >> ${name}
done

for i in $(seq 1 $index); do
  echo
  idx=`printf %02d $i`
  output=_tmp/out${idx}
  expect=_tmp/exp${idx}
  ${BIN}/test.out ${output} ${expect}
done

if [ -d ./_tmp ]; then rm -rf ./_tmp; fi
