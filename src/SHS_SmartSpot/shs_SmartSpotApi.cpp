#include "shs_SmartSpotApi.h"

#include <shs_debug.h>
#include <shs_Sensor_API.h>

#include <shs_lib_Color_RgbManagerApi.h>

shs::SmartSpotApi::SmartSpotApi(std::shared_ptr<shs::SmartSpotInterface> spot, shs::t::shs_ID_t id)
    : API(id), m_spot(spot)
{}
void shs::SmartSpotApi::attachComponentsApi(std::shared_ptr<shs::DTP> dtp, std::shared_ptr<shs::SmartSpotInterface> spot, shs::t::shs_ID_t id)
{
    if (!dtp || !spot) return;

    dtp->attachAPI(std::make_unique<shs::SmartSpotApi>(spot, id));
    dtp->attachAPI(std::make_unique<shs::lib::Color::RgbManagerApi>(spot->getManager(), id));
    dtp->attachAPI(std::make_unique<shs::Sensor_API>(*spot->getTemperatureSensor(), id, *dtp));
}

shs::DTPpacket shs::SmartSpotApi::handle(shs::ByteCollectorReadIterator<>& it)
{
    it.set_position(shs::DTPpacket::get_dataBeg(it));

    switch (static_cast< Commands >(it.read()))
    {

    case Commands::GET_FAN:
    {
        if (!m_spot) return shs::DTPpacket{};
        shs::ByteCollector<> buf(3);
        buf.push_back(Commands::FAN, 1);
        buf.push_back(m_spot->getFanPower(), 1);
        buf.push_back(m_spot->getFanMode(), 1);

        return shs::DTPpacket(API_ID, shs::DTPpacket::get_senderID(it), std::move(buf));
    }
    break;
    case Commands::SET_FAN:
    {
        if (!m_spot) return shs::DTPpacket{};
        m_spot->setFan(it.read(), it.read());
    }
    break;
    }

    return shs::DTPpacket{};
}
