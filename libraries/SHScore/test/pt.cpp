#include <iostream>
#include <chrono>
#include <thread>

#include "../shs_ProgramTime.h"

void print(shs::ProgramTime &pt) 
{
    std::cout << pt.seconds() << ' ' << pt.milliseconds() 
    << ' ' << pt.microseconds() << std::endl;
}

void print() 
{
    std::cout << shs::ProgramTime::s_seconds() << ' ' << shs::ProgramTime::s_milliseconds() 
    << ' ' << shs::ProgramTime::s_microseconds() << std::endl;
}

int main()
{
    //print(pt);
    shs::ProgramTime pt;
    std::this_thread::sleep_for(std::chrono::milliseconds(234));
    print(pt);
    print();
    print();

}
