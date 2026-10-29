#include "shs_SmartSpotVirtual.h"

#include <shs_ByteCollector.h>

#include "shs_SmartSpotApiCommands.h"

shs::SmartSpotVirtual::SmartSpotVirtual(std::shared_ptr<shs::DTP> dtp, shs::t::shs_ID_t id, shs::t::shs_ID_t remote_id)
    : API(id), m_dtp(dtp),
    m_manager(nullptr), m_temperature_sensor(nullptr),
    m_request_timer(REQUEST_TIMEOUT), m_remote_id(remote_id)
{}

void shs::SmartSpotVirtual::requestFanPower()
{
    shs::ByteCollector<> buf(1);
    buf.push_back(shs::SmartSpotApiCommands::GET_FAN, 1);

    m_dtp->sendPacket(shs::DTPpacket(API_ID, m_remote_id, std::move(buf)));
}

void shs::SmartSpotVirtual::tick()
{
    if (m_request_timer.check())
    {
        requestFanPower();
        m_request_counter++;
    }
}

shs::DTPpacket shs::SmartSpotVirtual::handle(shs::ByteCollectorReadIterator<>& it)
{
    it.set_position(shs::DTPpacket::get_dataBeg(it));
    switch (static_cast< shs::SmartSpotApiCommands >(it.read()))
    {
    case shs::SmartSpotApiCommands::FAN:
    {
        m_fan_power = it.read();
        m_fan_mode = it.read();
        m_request_counter = 0;
    }
    break;
    }
    return shs::DTPpacket{};
}

std::shared_ptr<shs::lib::Color::RgbManager> shs::SmartSpotVirtual::getManager()
{
    if (m_manager) return m_manager;

    m_manager = std::make_shared<shs::lib::Color::RgbManagerVirtual>(m_dtp, API_ID, m_remote_id);
    return m_manager;
}

std::shared_ptr<shs::Sensor> shs::SmartSpotVirtual::getTemperatureSensor()
{
    if (m_temperature_sensor) return m_temperature_sensor;

    m_temperature_sensor = std::make_shared<shs::SensorVirtual>(API_ID, m_remote_id, *m_dtp);
    return m_temperature_sensor;
}

void shs::SmartSpotVirtual::setFan(uint8_t value, uint8_t mode)
{
    shs::ByteCollector<> buf(3);
    buf.push_back(shs::SmartSpotApiCommands::SET_FAN, 1);
    buf.push_back(value, 1);
    buf.push_back(mode, 1);

    m_dtp->sendPacket(shs::DTPpacket(API_ID, m_remote_id, std::move(buf)));
}
