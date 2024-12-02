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
       
        for(int j = 0; j < reps.size(); j++){
            std::vector<int> v = reps;

            auto safe = true;
            v.erase(v.begin() + j);
            
            int inc = v[0] > v[1] ? -1 : 1;
            for(int i = 0; i < v.size()-1; i++) {
                int jump = v[i+1] - v[i];

                if(jump == 0 || std::abs(jump) > 3 || (jump*inc) < 1){
                    safe = false;
                }
            }

            if(safe){
                sum++;
                break;
            }
        }

    }

    std::cout << sum << '\n';
}
