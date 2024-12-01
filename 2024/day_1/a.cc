#include <algorithm>
#include <numeric>
#include <ranges>
#include <iostream>
#include <set>
#include <vector>

auto main() -> int {
    int x, y;
    
    std::vector<int> u;
    std::vector<int> v;
    while (std::cin >> x >> y) {
        u.push_back(x);
        v.push_back(y);
    }
    std::sort(u.begin(), u.end());
    std::sort(v.begin(), v.end());

    std::multiset<int> vms(v.begin(), v.end());

    auto sum_diff = [](int a, int b){ return std::abs(a - b); };

    auto diffs = std::views::zip_transform(sum_diff, u, v);

    auto sum2 = 0;
    for(const auto& e : u){
        sum2 += e * (int)vms.count(e);
    }

    auto sum = std::accumulate(diffs.begin(), diffs.end(), 0);

    std::cout << sum << '\n';
    std::cout << sum2 << '\n';
}
