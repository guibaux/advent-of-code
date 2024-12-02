#include <iostream>
#include <string>
#include <sstream>
#include <vector>

auto main() -> int {
    int x, y;
    
    std::string line;
    int sum = 0;
    while (std::getline(std::cin, line))  {
        
        std::vector<int> reps;
        std::istringstream iss(line);
        
        int num;
        while (iss >> num) reps.push_back(num);
        
        int inc = reps[0] > reps[1] ? -1 : 1;
        bool safe = true;
        for(int i = 0; i < reps.size()-1; i++) {
            int jump = reps[i+1] - reps[i];

            if(jump == 0 || std::abs(jump) > 3 || (jump*inc) < 1){
                safe = false;
                break;
            }
        }

        if(safe) sum++;
    }

    std::cout << sum << '\n';
}
