#include <iostream>
#include <vector>
#include <functional>

#include "../../shs_algorithm.h"
#include "../../shs_SortedBuf.h"

int algorithms_test()
{
    int values[] = {0, 1, 4, 5, 8, 20};
    int nine{9};

    std::vector<int *> v;

    for (auto i = 0; i < 6; i++)
        v.push_back(&values[i]);

    auto it = shs::binary_search(v.begin(), v.end(), 5, [](const int *v1, const int v2)
                                 { return *v1 < v2; });
    std::cout << it - v.begin() << std::endl;

    shs::insert_sorted(v, &nine, [](const int *v1, const int *v2)
                       { return *v1 < *v2; });

    it = shs::binary_search(v.begin(), v.end(), 9, [](const int *v1, const int v2)
                            { return *v1 < v2; });

    std::cout << it - v.begin() << std::endl;

    return 0;
}

int sb_test()
{
    int values[] = {0, 1, 4, 5, 8, 20};
    int nine{9};
    
 
    
    shs::SortedBuf<int*, std::function<bool(int*, int*)>> buf(std::function([](int *v1, int *v2) { return *v1 < *v2; }));
    for (auto i = 0; i < 6; i++) buf.attach(&values[i]);

    for (auto x : buf) std::cout << *x << ' ';
    std::cout << std::endl;

    buf.attach(&nine);
    for (auto x : buf) std::cout << *x << ' ';
    std::cout << std::endl;

    buf.detach(&nine);
    for (auto x : buf) std::cout << *x << ' ';
    std::cout << std::endl;
    
    return 0;
}

int main()
{
    sb_test();
    return 0;
}
