#pragma once

#include <stdint.h>

#undef DEBUG

inline constexpr auto SERVER_IP = "192.168.1.10";
inline constexpr auto PORT = 10002;

inline constexpr uint8_t THIS_ID = 10; //12;

// RGB:
#define Rp 15 //13 
#define Gp 13 //12
#define Bp 12 //14


#define fan_p 14 //15

#define maxTemp 40
#define minTemp 30
#define critTemp 50


#define therm_p A0
#define resist_10k 9800          // the exact resistance of the 10k resistor (Om)
#define resist_base 10000        // resistance at TEMP_BASE degrees Celsius (Om)
#define temp_base 25             // the temperature at which RESIST_BASE is measured (degrees Celsius)
#define B_coef 4300              // temperature sensitivity coefficient (3000-4000)
