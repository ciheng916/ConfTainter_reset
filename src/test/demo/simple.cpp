#include "test.h"

int config_var = 10;

int simple_function(int x) {
    int result = config_var + x;
    return result;
}

int main() {
    int value = simple_function(5);
    return value;
}

