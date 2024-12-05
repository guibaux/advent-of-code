#include <iostream>

auto enabled = 1;

auto process_line(const std::string& line) -> std::pair<int, int>
{
    auto res1 = 0;
    auto res2 = 0;

    for (size_t i = 0; i < line.size(); i++) {
        if (line.substr(i, 4) == "do()") {
            enabled = 1;
        } else if (line.substr(i, 7) == "don't()") {
            enabled = 0;
        } else if (line.substr(i, 4) == "mul(") {
            int a, b;

            if (std::sscanf(line.c_str() + i, "mul(%d,%d)", &a, &b) == 2) {
                // catch mul(x,y]
                char ch;
                if (std::sscanf(line.c_str() + i, "mul(%d,%d%c", &a, &b, &ch) == 3 && ch == ')') {
                    res1 += a * b;
                    res2 += enabled * (a * b);
                }
            }
        }
    }

    return std::make_pair(res1, res2);
}

auto main() -> int
{
    std::string line;

    auto res1 = 0;
    auto res2 = 0;
    while (std::getline(std::cin, line)) {
        auto [x, y] = process_line(line);
        res1 += x;
        res2 += y;
    }

    std::cout << "a: " << res1 << '\n';
    std::cout << "b: " << res2 << '\n';
}

