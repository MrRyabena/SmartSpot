#include "../shs_Process.h"
#include "../shs_Timer.h"
#include "../shs_CreateProcess.h"

#include <iostream>



int main()
{
    bool flag = true;

    auto start = []() { std::cout << "Starting..." << std::endl; };
    auto tick = []() { std::cout << "tick!" << std::endl; };
    auto stop = []() { std::cout << "End." << std::endl; };
    shs::CreateProcess p(start, tick, stop);

    shs::CreateProcess p_end([]() {}, [&]() { flag = false; }, []() {});

    shs::Timer timer(shs::timer_resolution::seconds, 2, &p);
    shs::Timer t_end(shs::timer_resolution::seconds, 10, &p_end);

    timer.start();
    t_end.start();
    while (flag)
    {
        timer.tick();
        t_end.tick();
    }

    timer.stop();


}
