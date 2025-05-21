#include "shs_SmartSpotConfigReader.h"

bool shs::SmartSpotConfigReader::initFS()
{
    return LittleFS.begin(true);
}


bool shs::SmartSpotConfigReader::getConfig(shs::SmartSpotConfig& config)
{
    m_checkAndCreateDirectory(CONFIG_PATH);

    if (LittleFS.exists(CONFIG_PATH))
    {
        auto file = LittleFS.open(CONFIG_PATH, FILE_READ);

        file.read(reinterpret_cast< uint8_t* >(&config), sizeof(config));
        file.close();

        return true;
    }

    saveConfig(config);

    return false;
}


void shs::SmartSpotConfigReader::saveConfig(const shs::SmartSpotConfig& config)
{
    auto file = LittleFS.open(CONFIG_PATH, FILE_WRITE);
    file.write(reinterpret_cast< const uint8_t* >(&config), sizeof(config));
    file.close();
}


void shs::SmartSpotConfigReader::m_checkAndCreateDirectory(const shs::t::shs_string_t& dir_name)
{
    auto i = dir_name.indexOf('/', 1);
    auto sub_dir = dir_name.substring(0, i);
    sub_dir.reserve(dir_name.length());

    if (!LittleFS.exists(sub_dir))
    {
        LittleFS.mkdir(sub_dir);
    }


    for (i; i < dir_name.length() - 1; )
    {
        auto new_i = dir_name.indexOf('/', i + 1);
        if (new_i == -1) new_i = dir_name.length() - 1;
        sub_dir += dir_name.substring(i, new_i);
        i = new_i;

        if (!LittleFS.exists(sub_dir))
        {
            LittleFS.mkdir(sub_dir);
        }
    }
}

