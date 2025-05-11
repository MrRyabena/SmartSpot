#pragma once


#include <memory>
#include <cassert>

#include <Arduino.h>

#include <GRGB.h>

#include <shs_Process.h>

#include <shs_lib_SensorTypes.h>
#include <shs_lib_Thermistor.h>
#include <shs_lib_DS18.h>


#include <shs_Load.h>
#include <shs_LoadPWM.h>
#include <shs_ProgramTimer.h>

#include <shs_utils.h>

#include <shs_version.h>
static_assert(shs::version::project >= "v2.1.0");

#include <shs_settings_private.h>

#include "shs_SmartSpotConfig.h"

namespace shs
{
    class SmartSpot;
}


class shs::SmartSpot : public shs::Process
{
public:
    SmartSpot(const shs::SmartSpotConfig& config);
    SmartSpot(std::shared_ptr<GRGB> grgb, std::shared_ptr<shs::Sensor> temp_sensor, std::shared_ptr<shs::Load> fan);


    ~SmartSpot() override = default;

    void start() override;
    void tick() override;
    void stop() override;

    std::shared_ptr<GRGB> getGRGB() { return m_chip; }


protected:
    static constexpr auto m_CONTROL_TIMEOUT = 2000;

    std::shared_ptr<GRGB> m_chip;
    std::shared_ptr<shs::Sensor> m_temp_sensor;
    std::shared_ptr<shs::Load> m_fan;

    shs::ProgramTimer m_timer;

    /*
      A smaller version of the struct shs::SmartSpotConfig to save memory
      (unnecessary values are not stored except for initialization)
    */
    struct m_Config
    {
        m_Config() = default;
        m_Config(const shs::SmartSpotConfig& config)
            : MIN_TEMP(config.MIN_TEMP), MAX_TEMP(config.MAX_TEMP),
            MIN_FAN_POWER(config.MIN_FAN_POWER), MAX_FAN_POWER(config.MAX_FAN_POWER),
            CHIP_POWER(config.CHIP_POWER), MAX_POWER(config.MAX_POWER)
        {}

        // cooling
        uint8_t MIN_TEMP{};
        uint8_t MAX_TEMP{};
        uint8_t MIN_FAN_POWER{};
        uint8_t MAX_FAN_POWER{};

        // power
        uint16_t CHIP_POWER{};
        uint16_t MAX_POWER{};
    }
    const m_config
        ;


    void m_temperatureControl();
};
