#include <stdlib.h>

int hoge() {
    return 11;
}

int main() {
    int i = 10;
    int a = i;
    hoge();
    exit(0);
}