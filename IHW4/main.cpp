#include <iostream>
#include <map>
#include <string>
#include <thread>
#include <vector>
#include <mutex>
#include <random>

std::map<char, std::string> cipher_table = {
    {'A', "01"}, {'B', "02"}, {'C', "03"}, {'D', "04"}, {'E', "05"},
    {'F', "06"}, {'G', "07"}, {'H', "08"}, {'I', "09"}, {'J', "10"},
    {'K', "11"}, {'L', "12"}, {'M', "13"}, {'N', "14"}, {'O', "15"},
    {'P', "16"}, {'Q', "17"}, {'R', "18"}, {'S', "19"}, {'T', "20"},
    {'U', "21"}, {'V', "22"}, {'W', "23"}, {'X', "24"}, {'Y', "25"},
    {'Z', "26"}, {' ', "00"}
};

std::mutex mtx;
std::vector<std::pair<int, std::string>> encodedFragments;

void encodeFragment(const std::string& fragment, int index) {
  std::string encoded;

  for (char ch : fragment) {
    char upperCh = std::toupper(ch);
    if (cipher_table.find(upperCh) != cipher_table.end()) {
      encoded += cipher_table[upperCh] + " ";
    }
  }

  {
    std::lock_guard<std::mutex> lock(mtx);
    encodedFragments.emplace_back(index, encoded);
    std::cout << "Fragment " << index << " encoded: " << encoded << std::endl;
  }
}

int main() {
  std::cout << "Введите текст: ";
  std::string text;
  std::getline(std::cin, text);

  int NUM_THREADS = 4;
  std::vector<std::thread> threads;
  std::vector<std::string> fragments;

  int fragmentSize = text.size() / NUM_THREADS;
  int i = 0;
  while (i < text.size()) {
    int subStrSize = std::min(fragmentSize, text.size() - i);
  }
  return 0;
}
