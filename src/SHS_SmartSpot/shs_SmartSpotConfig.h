#pragma once

#include <stdint.h>
#include <shs_types.h>
#include <shs_Sensor.h>
#include <shs_version.h>


namespace shs
{
    struct SmartSpotConfig;
}


struct shs::SmartSpotConfig
{
    shs::version::Version version{ "v1.0.0" };
    shs::t::shs_ID_t ID;
    shs::t::shs_IP_t SERVER_IP;
    shs::t::shs_port_t PORT;

    // chip
    shs::t::shs_pin_t RED_PIN{ 33 };
    shs::t::shs_pin_t GREEN_PIN{ 19 };
    shs::t::shs_pin_t BLUE_PIN{ 23 };


    // fan
    shs::t::shs_pin_t FAN_PIN{ 5 };

    // PWM
    uint32_t PWM_FREQUENCY{ 32'000 };

    // temperature sensor
    shs::Sensor::Type TEMP_SENSOR_TYPE{};
    uint32_t THERMISTOR_resR{ 9'800 };
    uint16_t THERMISTOR_B{ 4300 };
    shs::t::shs_pin_t TEMP_SENSOR_PIN{};

    // cooling
    uint8_t MIN_TEMP{ 30 };
    uint8_t MAX_TEMP{ 50 };
    uint8_t MIN_FAN_POWER{ 150 };
    uint8_t MAX_FAN_POWER{ 255 };

    // power
    uint16_t CHIP_POWER{ 50 };
    uint16_t MAX_POWER{ 25 };
};

