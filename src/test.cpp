#include <vector>
#include <iostream>
#include <string>
#include <fstream>

std::vector<std::string> getall(std::string filename) {
  std::ifstream file;
  file.open(filename, std::ios::in);

  std::string buf;
  std::vector<std::string> content;
  while(!file.eof()) {
    std::getline(file, buf);
    content.push_back(buf);
  }
  file.close();

  return content;
}

std::string join(std::vector<std::string> str, std::string sp) {
  std::string result;
  int n = str.size();
  for (int i=0; i<n; ++i) {
    if (i!=0) result += sp;
    result += str[i];
  }
  return result;
}

int main(int argc, char** argv) {
  std::string outfile_name = argv[1];
  std::vector<std::string> opt = getall(outfile_name);
  auto output = join(opt, "\n");

  std::string expfile_name = argv[2];
  std::vector<std::string> exp = getall(expfile_name);
  auto expect = join(exp, "\n");

  std::string index = "";
  for (auto &s : outfile_name) {
    if (std::isdigit(s)) {
      index += s;
    }
  }
  std::cout << "[*] sample-" << index << "\n";
  if (output == expect) {
    std::cout << "[+] AC\n";
  } else {
    std::cout << "[-] WA\n";
    std::cout << "output:\n" << output;
    std::cout << "expect:\n" << expect;
  }
}
