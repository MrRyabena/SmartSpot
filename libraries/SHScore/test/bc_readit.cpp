#include <stdint.h>
#include <iostream>

#include "../shs_ByteCollector.h"
#include "../shs_ByteCollectorIterator.h"


int main()
{
   shs::ByteCollector<> bc(10);
   
   for (uint8_t i = 0; i < 10; i++) bc.push_back(i);

   auto it = bc.getReadIt();
   uint8_t v{};
   for (auto i = 0; i < it.size(); i++, ++it) {  std::cout << static_cast<int>(*it) << ' '; }
   std::cout << std::endl;

   return 0;
}
