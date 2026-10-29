#pragma once

#include <memory>

#include <stdint.h>

#include <shs_Sensor.h>

#include <shs_lib_Color_RgbManager.h>


namespace shs
{
    class SmartSpotInterface;
}


class shs::SmartSpotInterface
{
public:
    virtual ~SmartSpotInterface() = default;

    [[nodiscard]] virtual std::shared_ptr<shs::lib::Color::RgbManager> getManager() = 0;
    [[nodiscard]] virtual std::shared_ptr<shs::Sensor> getTemperatureSensor() = 0;
    [[nodiscard]] virtual uint8_t getFanPower() = 0;
    [[nodiscard]] virtual uint8_t getFanMode() = 0;
    virtual void setFan(uint8_t value, uint8_t mode = 0) = 0;
};
