#include "settings.h"

#include <shs_SmartSpot.h>

#include <shs_ControlWiFi.h>

#include <GRGB.h>
// #include <shs_lib_DS18.h>
#include <shs_LoadPWM.h>
#include <shs_ProgramTime.h>


shs::SmartSpot spot(std::make_shared<GRGB>(COMMON_CATHODE, Rp, Gp, Bp), nullptr, std::make_shared<shs::LoadPWM>(fan_p));


void setup()
{
    shs::ControlWiFi::connectWiFi();

    spot.start();
    spot.getGRGB()->setBrightness(50);
    delay(1000);
    spot.getGRGB()->setRGB(0xff, 0, 0);
    delay(1000);
    spot.getGRGB()->setRGB(0, 0xff, 0);
    delay(1000);
    spot.getGRGB()->setRGB(0, 0, 0xff);
    delay(1000);
    spot.getGRGB()->setBrightness(100);
    delay(1000);
}


static shs::ProgramTime tmr;
static uint8_t value{};
void loop()
{
    spot.tick();
    
    if (tmr.milliseconds() >= 50)
    {
        spot.getGRGB()->setWheel8(value++);
        tmr.reset();
    }
}
