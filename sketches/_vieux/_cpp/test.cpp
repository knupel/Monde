#include <iostream>
#include <vector>

using std::cin;
using std::cout;
using std::endl;
using std::vector;

int main() {
  int max = 20;
  for (size_t i = 0; i < max; i++) {
    if(i%2 == 0) printf("modulo %zu\n", i);
  }
  cout << endl;

  return EXIT_SUCCESS;
}