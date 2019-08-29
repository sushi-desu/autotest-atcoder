
#include <array>	// array
#include <cstdio>	// _popen
#include <iostream>	// cout
#include <memory>	// shared_ptr
#include <string>	// string
#include <vector>
#include <fstream>

bool ExecCmd(const char* cmd, std::string& stdOut, int& exitCode) {
	std::shared_ptr<FILE> pipe(_popen(cmd, "r"), [&](FILE* p) {exitCode = _pclose(p); });
	if (!pipe) {
		return false;
	}
	std::array<char, 256> buf;
	while (!feof(pipe.get())) {
		if (fgets(buf.data(), buf.size(), pipe.get()) != nullptr) {
			stdOut += buf.data();
		}
	}
	return true;
}

int main(int argc, char** argv)
{
  std::ifstream testfile;
  std::string filename = argv[1];
  testfile.open(filename, std::ios::in);

  std::vector<std::string> input;
  std::vector<std::string> output;
  std::string buf;
  bool is_input = true;
  std::string line;
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

  std::ofstream __tmpfile;
  std::string cmd = "type __tmp | ";
  cmd += argv[2];
  for (int i=0; i < input.size(); ++i) {
    __tmpfile.open("__tmp", std::ios::trunc);
    __tmpfile << input[i];
    __tmpfile.close();

    std::string stdOut;
    int exitCode;
    ExecCmd(cmd.c_str(), stdOut, exitCode);
    std::cout << "[*] sample-" << i+1 << "\n";
    if (stdOut == output[i]) {
      std::cout << "[+] AC\n";
    } else {
      std::cout << "[-] WA\n";
      std::cout << "output:\n" << stdOut;
      std::cout << "expected:\n" << output[i];
    }
    std::cout << "\n";
  }

	return 0;
}
