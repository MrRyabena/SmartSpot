#include "shs_SmartSpot.h"


shs::SmartSpot::SmartSpot(const shs::SmartSpotConfig& config)
    : m_config(config),
    m_chip(std::make_shared<GRGB>(COMMON_CATHODE, config.RED_PIN, config.GREEN_PIN, config.BLUE_PIN)),
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
        ledcAttach(config.RED_PIN, config.PWM_FREQUENCY, 8);
        ledcAttach(config.GREEN_PIN, config.PWM_FREQUENCY, 8);
        ledcAttach(config.BLUE_PIN, config.PWM_FREQUENCY, 8);
        ledcAttach(config.FAN_PIN, config.PWM_FREQUENCY, 8);
    #endif
    }

}


shs::SmartSpot::SmartSpot(std::shared_ptr<GRGB> grgb, std::shared_ptr<shs::Sensor> temp_sensor, std::shared_ptr<shs::Load> fan)
    : m_chip(grgb), m_temp_sensor(temp_sensor), m_fan(fan), m_timer(m_CONTROL_TIMEOUT)
{}


void shs::SmartSpot::start()
{
    if (m_temp_sensor) m_temp_sensor->setup();

    if (m_chip)
    {
        m_chip->setBrightness(0);
        m_chip->setColor(0);
    }
}


void shs::SmartSpot::tick()
{
    if (m_chip) m_chip->tick();
    m_temperatureControl();
}


void shs::SmartSpot::stop()
{}


void shs::SmartSpot::m_temperatureControl()
{
    if (m_timer.check())
    {
        auto fan_power = 255;
        if (m_temp_sensor)
        {
            m_temp_sensor->updateFast();

            fan_power = map(m_temp_sensor->getValueI(), m_config.MIN_TEMP, m_config.MAX_TEMP, m_config.MIN_FAN_POWER, m_config.MAX_FAN_POWER);
            fan_power = constrain(fan_power, m_config.MIN_FAN_POWER, m_config.MAX_FAN_POWER);
        }

        if (m_fan) m_fan->on(fan_power);
    }
}
