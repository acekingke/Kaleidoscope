# Kaleidoscope
llvm example.
usage 
$ ./toy
ready> def average(x y) (x + y) * 0.5;
^D
Wrote output.o

We have an object file! To test it, let’s write a simple program and link it with our output. Here’s the source code:

#include <iostream>

extern "C" {
    double average(double, double);
}

int main() {
    std::cout << "average of 3.0 and 4.0: " << average(3.0, 4.0) << std::endl;
}
We link our program to output.o and check the result is what we expected:

$ clang++ main.cpp output.o -o main
$ ./main
average of 3.0 and 4.0: 3.5