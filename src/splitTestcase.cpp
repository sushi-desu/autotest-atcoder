#include <fstream>
#include <string>
#include <vector>
#include <iostream>

std::string zpad(std::string str, int length) {
  return std::string(length - str.length(), '0') + str;
}

int main(int argc, char** argv) {
  std::string filename = argv[1];
  std::ifstream testfile;
  testfile.open(filename, std::ios::in);

  std::string buf;
  std::vector<std::string> input;
  std::vector<std::string> output;
  bool is_input = true;
  std::string line = "";
  while(!testfile.eof()) {
    std::getline(testfile, buf);
    if (buf == "") {
      if (is_input) {
        input.push_back(line);
      } else {
        output.push_back(line);
      }
      line = "";
      is_input = !is_input;
      continue;
    }

    line += buf;
    line += "\n";
  }

  int inputcount = input.size();
  int outputcount = output.size();
  if (not inputcount == outputcount) {
    std::cerr << "Error: could not split testcases\n";
    return 0;
  }

  for (int i=0; i<inputcount; ++i) {
    std::ofstream infile;
    std::string name = "_tmp\\in" + zpad(std::to_string(i+1), 2);
    infile.open(name, std::ios::out);
    infile << input[i];
    infile.close();
  }

  for (int i=0; i<outputcount; ++i) {
    std::ofstream expfile;
    std::string name = "_tmp\\exp" + zpad(std::to_string(i+1), 2);
    expfile.open(name, std::ios::trunc);
    expfile << output[i];
    expfile.close();
  }
}
