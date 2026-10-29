#include "shs_SmartSpot.h"

#include <shs_debug.h>
#include <shs_algorithm.h>

shs::SmartSpot::SmartSpot(const shs::SmartSpotConfig& config)
    : m_config(config),
    m_chip(std::make_shared<shs::lib::Color::RgbDriver>(config.RED_PIN, config.GREEN_PIN, config.BLUE_PIN, shs::lib::Color::RgbDriver::LedType::COMMON_CATHODE)),
    m_manager(std::make_shared<shs::lib::Color::RgbManager>(m_chip)),
    m_temp_sensor(nullptr),
    m_fan(std::make_shared<shs::LoadPWM>(config.FAN_PIN)),
    m_timer(m_CONTROL_TIMEOUT)
{
    switch (shs::etoi(config.TEMP_SENSOR_TYPE))
    {
    case shs::etoi(shs::Sensor::Type::THERMISTOR):
    m_temp_sensor = std::make_shared<shs::Thermistor>(config.TEMP_SENSOR_PIN, config.THERMISTOR_resR, config.THERMISTOR_B);
    break;

    case shs::etoi(shs::lib::SensorTypes::DS18):
    m_temp_sensor = std::make_shared<shs::DS18>(config.TEMP_SENSOR_PIN);
    break;

    default: break;

    #ifdef SHS_SF_ESP32
        analogReadResolution(10);
        ledcAttach(config.RED_PIN, config.PWM_FREQUENCY, 8);
        ledcAttach(config.GREEN_PIN, config.PWM_FREQUENCY, 8);
        ledcAttach(config.BLUE_PIN, config.PWM_FREQUENCY, 8);
        ledcAttach(config.FAN_PIN, config.PWM_FREQUENCY, 8);
    #endif
    }

}



shs::SmartSpot::SmartSpot(std::shared_ptr<shs::lib::Color::RgbDriver> chip, std::shared_ptr<shs::Sensor> temp_sensor, std::shared_ptr<shs::Load> fan)
    : m_chip(chip),
    m_manager(std::make_shared<shs::lib::Color::RgbManager>(chip)),
    m_temp_sensor(temp_sensor), m_fan(fan), m_timer(m_CONTROL_TIMEOUT)
{}


void shs::SmartSpot::start()
{
    if (m_temp_sensor) m_temp_sensor->setup();

    if (m_chip)
    {
    #ifndef SHS_SF_ESP32
        m_chip->setup();
    #endif
        m_chip->setBrightness(0);
        m_chip->setColor(shs::lib::Color::RGB888{});
    }
}


void shs::SmartSpot::tick()
{
    if (m_manager) m_manager->tick();
    m_temperatureControl();
}


void shs::SmartSpot::stop()
{}

uint8_t shs::SmartSpot::getFanPower()
{
    if (m_fan) return m_fan->getValue();
    return 0;
}

void shs::SmartSpot::setFan(const uint8_t value, const uint8_t mode)
{
    m_fan_mode = mode;
    if (m_fan) m_fan->on(value);
}


void shs::SmartSpot::m_temperatureControl()
{

    if (m_temp_sensor && !m_temp_sensor->isUpdated()) m_temp_sensor->update();
    if (m_timer.check())
    {

        uint8_t fan_power{ 255 };
        if (m_temp_sensor)
        {
            auto temp = m_temp_sensor->getValueI();
            if (temp < 15 || temp > 100) return;  // invalid temperature reading, skip control

            fan_power = shs::map(static_cast< uint8_t >(temp), m_config.MIN_TEMP, m_config.MAX_TEMP, m_config.MIN_FAN_POWER, m_config.MAX_FAN_POWER);
            fan_power = shs::clamp(fan_power, m_config.MIN_FAN_POWER, m_config.MAX_FAN_POWER);
        }

        if (!m_fan_mode) if (m_fan) m_fan->on(fan_power);
    }
}
