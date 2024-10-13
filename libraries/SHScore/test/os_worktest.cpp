#include "../shs_Process.h"
#include "../shs_OS.h"
#include "../shs_ProcessTask.h"
#include "../shs_Timer.h"
#include "../shs_CreateProcess.h"
#include "../shs_TaskManager.h"
#include "../shs_Task.h"

#include <iostream>
#include <mutex>
#include <chrono>

std::mutex mtx;



class PrintProcess : public shs::Process
{
public:
    PrintProcess(const unsigned ID) : m_ID(ID) {}

    void start() override
    {
        std::unique_lock<std::mutex> lock(mtx);
        std::cout << "started  " << m_ID << std::endl;
    }

    void tick() override
    {
        static int tmr{};
        std::unique_lock<std::mutex> lock(mtx);
        std::cout << "tick  " << m_ID << std::endl;
        lock.unlock();
        //std::this_thread::sleep_for(std::chrono::seconds(2));
    }

    void stop() override
    {
        std::unique_lock<std::mutex> lock(mtx);
        std::cout << "end  " << m_ID << std::endl;
    }

private:
    const unsigned m_ID;
};

template <>
struct shs::TaskData<PrintProcess>
{
    static constexpr shs::task::stack_size_t stack_size = 100;   // In words
    static constexpr shs::task::priority_t   priority = 0;       // 0 is the highest priority
    static constexpr shs::task::complexy_t   complexy = 1;       // 1 is the lowest complexity
};

void f(void* ptr)
{
    for (auto i = 0; i < 10; i++)
    {
        std::unique_lock<std::mutex> lock(mtx);
        std::cout << std::this_thread::get_id() << std::endl;
        lock.unlock();

        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
}

void test_TM()
{
    shs::TaskManager tm;

    for (auto i = 0; i < 10; i++)
    {
        shs::Task t(f);
        tm.addTask<shs::Task>(t);
    }

    std::this_thread::sleep_for(std::chrono::seconds(1));
    std::cout << '\n'
        << tm.getTaskCount() << std::endl;
    tm.checkCompleted();
    std::cout << '\n'
        << tm.getTaskCount() << std::endl;
}

void test_TM_process()
{
    shs::TaskManager tm;

    PrintProcess p(2);
    shs::ProcessTask task(&p);
    tm.addTask<PrintProcess>(task);

    for (;;);

}

void test_OS()
{
        shs::OS os(1, 4);
        std::vector<std::unique_ptr<shs::Process>> vp;
        std::vector<std::unique_ptr<shs::Timer>> vt;

        for (auto i = 0; i < 8; i++)
        {
            vp.push_back(std::make_unique<PrintProcess>(i));
            vt.push_back(std::make_unique<shs::Timer>(1000, vp.back().get()));
        }

        for (auto & x : vt) os.addProcess(x.get());

        std::this_thread::sleep_for(std::chrono::seconds(20));

        //std::cout << os.m_tm.getTaskCount() << std::endl;

        os.stop();
        std::this_thread::sleep_for(std::chrono::seconds(5));

        //os.m_tm.checkCompleted();
        //std::cout << os.m_tm.getTaskCount() << std::endl;


}

int main()
{
    try
    {
        //test_TM();
       // test_TM_process();
       test_OS();


    }
    catch (const std::exception& e)
    {
        std::cout << "Exception: " << e.what() << std::endl;
        std::cout.flush();
    }
    catch (...)
    {
        std::cout << "Error!" << std::endl;
    }
}
