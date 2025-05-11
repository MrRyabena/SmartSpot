#pragma once

#include <shs_SmartSpotConfig.h>
#include <shs_Sensor.h>
#include <shs_lib_SensorTypes.h>


shs::SmartSpotConfig config {
    .ID = 11,
    .SERVER_IP = "192.168.1.10",
    .PORT = 10002,
    .TEMP_SENSOR_TYPE = shs::Sensor::Type::THERMISTOR,
    .TEMP_SENSOR_PIN = 35,
};
