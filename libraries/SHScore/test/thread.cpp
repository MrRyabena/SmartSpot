#include <thread>
#include <iostream>
#include <chrono>
#include <pthread.h>

void f() 
{
	for (;;)
	{
		std::this_thread::sleep_for(std::chrono::seconds(1));
		std::cout << '.';
	}
}

int main()
{
	std::thread t(f);
	std::this_thread::sleep_for(std::chrono::seconds(5));
	pthread_t p = static_cast<pthread_t>(t.native_handle());
	
    std::this_thread::sleep_for(std::chrono::seconds(5));
	
    t.join();
}
