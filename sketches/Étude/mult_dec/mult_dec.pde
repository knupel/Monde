

void setup() {
  println(dec_mult(10,1));
}
int dec_mult(int start, int inc) {
  start = abs(start);
  int res = 1;
  for(int i = start ; i > 0 ; i -=inc) {
    res *= i;
    
  }
  return res;
}

int dec_add(int start, int inc) {
  start = abs(start);
  int res = 1;
  for(int i = start ; i > 0 ; i -=inc) {
    res += i;
    
  }
  return res;
}
