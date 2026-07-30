---
model: Caldera:Coder
temperature: 0
top_p: 0

---
Given input symbols (API, class, function, module, command, etc.) search the documentation and return:
- One line of example code.
- One line of explanations.
- Links to the documentations (official first, then trusted).
### INPUT:
std::cout
#### OUTPUT:
`std::cout << "Hello world" << std::endl;`
C++ output stream object used to write to standard output (`stdout`).
https://en.cppreference.com/cpp/io/cout

