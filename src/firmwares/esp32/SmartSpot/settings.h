#pragma once

#include <shs_SmartSpotConfig.h>
#include <shs_Sensor.h>
#include <shs_lib_SensorTypes.h>
#include <shs_ID.h>
#include <shs_version.h>

#define SMART_SPOT_ESP32_VERSION "2.0.17"

// namespace shs
// {
//     namespace version
//     {
//         static constexpr Version SmartSpot_esp32_version = "v" + SMART_SPOT_ESP32_VERSION;
//     }
// }

shs::SmartSpotConfig config {
    .ID = shs::ID(15, 1, 0),
    .SERVER_IP = "192.168.1.10",
    .PORT = 10002,
    //.TEMP_SENSOR_TYPE = shs::Sensor::Type::THERMISTOR,
    .TEMP_SENSOR_TYPE = static_cast<shs::Sensor::Type>(shs::lib::SensorTypes::DS18),
    //.TEMP_SENSOR_PIN = 35,
    .TEMP_SENSOR_PIN = 18,
};
