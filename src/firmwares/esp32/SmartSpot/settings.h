#pragma once

#include <shs_SmartSpotConfig.h>
#include <shs_Sensor.h>
#include <shs_lib_SensorTypes.h>
#include <shs_ID.h>

constexpr shs::SmartSpotConfig config {
    .ID = shs::ID(11, 1, 0),
    .SERVER_IP = "192.168.1.10",
    .PORT = 10002,
    .TEMP_SENSOR_TYPE = shs::Sensor::Type::THERMISTOR,
    .TEMP_SENSOR_PIN = 35,
};
