#pragma once


inline constexpr auto SERVER_IP = "192.168.1.10";
inline constexpr uint32_t S_IP = (192 << 24) | (168 << 16) | (1 << 8) | 10;
inline constexpr auto PORT = 10002;

inline constexpr auto WiFiSSID = "SHS_WiFi_2";
inline constexpr auto WiFiPASS = "28841971";

inline constexpr auto THIS_ID = 0xffffff00 | 12; //10;

/*
 TX -- green
 RX -- yellow
*/

// RGB:
#define Rp 13 //15
#define Gp 12 //13
#define Bp 14 //12


#define fan_p 15 //14

#define maxTemp 40
#define minTemp 30
#define critTemp 50


#define therm_p A0
#define resist_10k 9800          // the exact resistance of the 10k resistor (Om)
#define resist_base 10000        // resistance at TEMP_BASE degrees Celsius (Om)
#define temp_base 25             // the temperature at which RESIST_BASE is measured (degrees Celsius)
#define B_coef 4300              // temperature sensitivity coefficient (3000-4000)


#define RSp 4
#define GSp 7
