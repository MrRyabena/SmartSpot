#pragma once

/*
 TX -- green
 RX -- yellow
*/

// RGB:
#define Rp 10
#define Gp 9
#define Bp 3

#define frequency_9_10 31       // 62.5 kHz (62); 31.4 kHz (31); 7.8 kHz (8); 4 kHz (4); 976 Hz (1); no changes (490 Hz) (0)
#define frequency_3_11 31


#define fan_p 11

#define maxTemp 40
#define minTemp 30
#define critTemp 50


#define therm_p A0
#define resist_10k 9700          // the exact resistance of the 10k resistor (Om)
#define resist_base 10000        // resistance at TEMP_BASE degrees Celsius (Om)
#define temp_base 25             // the temperature at which RESIST_BASE is measured (degrees Celsius)
#define B_coef 4300              // temperature sensitivity coefficient (3000-4000)


#define RSp 4
#define GSp 7