#pragma once

#include <Arduino.h>
#include <LittleFS.h>
#include <memory>

#include <shs_types.h>

#include "shs_SmartSpotConfig.h"


namespace shs
{
    class SmartSpotConfigReader;
}


class shs::SmartSpotConfigReader
{
public:

    static bool initFS();

    static bool getConfig(shs::SmartSpotConfig& config);
    static void saveConfig(const shs::SmartSpotConfig& config);

    static constexpr auto CONFIG_PATH = "/SHS/SHS_SmartSpot/config/config.shsf";


protected:
    static void m_checkAndCreateDirectory(const shs::t::shs_string_t& dir_name);
};
