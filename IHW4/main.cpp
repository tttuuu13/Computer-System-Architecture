#include <iostream>
#include <pthread.h>
#include <vector>
#include <unordered_map>
#include <string>
#include <mutex>
#include <fstream>

std::mutex mtx;
std::condition_variable cv;

// Кастомная структура
struct Fragment {
  int index;
  std::string encoded;
};

// Список фрагментов
std::vector<Fragment> fragments;

// Компаратор для фрагментов (для сортировки по индексу)
struct FragmentComparator {
  bool operator()(const Fragment& a, const Fragment& b) {
    return a.index < b.index;
  }
};

// Словарь с кодами для букв
std::unordered_map<char, std::string> code_table = {
    {'A', "01"}, {'B', "02"}, {'C', "03"}, {'D', "04"}, {'E', "05"},
    {'F', "06"}, {'G', "07"}, {'H', "08"}, {'I', "09"}, {'J', "10"},
    {'K', "11"}, {'L', "12"}, {'M', "13"}, {'N', "14"}, {'O', "15"},
    {'P', "16"}, {'Q', "17"}, {'R', "18"}, {'S', "19"}, {'T', "20"},
    {'U', "21"}, {'V', "22"}, {'W', "23"}, {'X', "24"}, {'Y', "25"},
    {'Z', "26"}, {' ', "00"}
};

// Функция для кодирования фрагмента
std::string encode_fragment(const std::string& fragment) {
  std::string encoded;
  for (char c : fragment) {
    c = std::toupper(c);
    if (code_table.count(c)) {
      encoded += code_table[c] + " ";
    }
  }
  return encoded;
}

// Функция для потоков
void* func(void* arg) {
  auto* data = reinterpret_cast<std::pair<int, std::string>*>(arg);
  int index = data->first;
  std::string text = data->second;

  // Кодируем фрагмент
  std::string encoded = encode_fragment(text);

  // Добавляем результат в портфель
  {
    std::lock_guard<std::mutex> lock(mtx);
    fragments.push_back({index, encoded});
  }

  // Сообщаем о том что фрагмент был добавлен
  cv.notify_one();
  delete data;
  return nullptr;
}

std::string generate_random_text(int min_length, int max_length) {
  const std::string charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
  const int charset_size = charset.size();

  int length = min_length + rand() % (max_length - min_length + 1);

  std::string result;
  result.reserve(length);
  for (int i = 0; i < length; ++i) {
    result += charset[rand() % charset_size];
  }

  return result;
}

int main(int argc, char* argv[]) {
  if (argc < 3) {
    std::cerr << "Недостаточно аргументов. Пример использования: ./program <text_or_random> <num_threads>" << std::endl;
    return 1;
  }

  srand(static_cast<unsigned>(time(nullptr)));
  std::string input_text;
  int num_threads = std::stoi(argv[2]);

  // Проверка, если текст был передан через аргумент
  if (std::string(argv[1]) == "random") {
    input_text = generate_random_text(5, 100);
    std::cout << "Сгенерированный текст: " << input_text << std::endl;
  } else {
    input_text = argv[1];
  }

  // Делим текст на фрагменты
  int fragment_size = input_text.size() / num_threads;
  std::vector<std::pair<int, std::string>> tasks;

  for (int i = 0; i < num_threads; ++i) {
    int start = i * fragment_size;
    int end = (i == num_threads - 1) ? input_text.size() : start + fragment_size;
    tasks.emplace_back(i, input_text.substr(start, end - start));
  }

  // Создаем потоки
  std::vector<pthread_t> threads(num_threads);
  for (int i = 0; i < num_threads; ++i) {
    auto* task = new std::pair<int, std::string>(tasks[i]); // Create copy of the task
    pthread_create(&threads[i], nullptr, func, task);
  }

  // Ждем окончания выполнения потоков
  for (pthread_t& thread : threads) {
    pthread_join(thread, nullptr);
  }

  for (auto& fragment : fragments) {
    std::cout << "Закодирован фрагмент " << fragment.index << ": " << fragment.encoded << std::endl;
  }

  // Сортируем закодированные фрагемнты по индексу
  {
    std::lock_guard<std::mutex> lock(mtx);
    std::sort(fragments.begin(), fragments.end(), FragmentComparator());
  }

  std::cout << "\nИтоговый закодированный текст: ";
  for (const auto& fragment : fragments) {
    std::cout << fragment.encoded;
  }
  std::cout << std::endl;

  return 0;
}