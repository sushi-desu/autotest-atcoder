#include <iostream>
#include <vector>
#include <string>
#include <fstream>
#include <regex>
using namespace std;

string convert(string orig) {
  regex re01("(^<h3>.+<pre>)|(</pre>.*)");
  return regex_replace(orig, re01, "");
}

void add(vector<string>& vc, string s) {
  if (s != "") {
    vc.push_back(convert(s));
  }
}

int main(int argc, char** argv) {
  string START = "<span class=\"lang-en\">";
  string END = "</span>";
  regex re("Sample (In|Out)put \\d+");
  regex endre("</pre>");

  string filename = argv[1];
  ifstream input;
  input.open(filename, ios::in);

  vector<string> result;
  string buf;
  bool is_testsample = false;
  while(!input.eof()) {
    getline(input, buf);
    if (regex_search(buf, re)) is_testsample = true;
    if (is_testsample) {
      add(result, buf);
      if (regex_search(buf, endre)) is_testsample = false;
    }

  }
  input.close();

  ofstream output;
  output.open(filename, ios::trunc);
  int size = result.size();
  for (int i=0; i<size-1; ++i) {
    output << result[i] << "\n";
  }
  return 0;
}
