#pragma once

#include <memory>

#include <shs_API.h>
#include <shs_utils.h>
#include <shs_ByteCollector.h>
#include <shs_DTPpacket.h>
#include <shs_types.h>

#include "shs_SmartSpot.h"
#include "shs_SmartSpotConfig.h"

#define SHS_SF_DEBUG
#define DEBUG
#include <shs_debug.h>

namespace shs
{
    class SmartSpot_API;
}

class shs::SmartSpot_API : public shs::API
{
public:
    enum class Commands : uint8_t { NO_COMMAND, GET_FAN, SET_FAN, GET_TEMPERATURE, TEMPERATURE, GET_INFO, INFO };
    SmartSpot_API(shs::SmartSpot& spot, shs::t::shs_ID_t id) : API(id), m_spot(spot) { dout(id.getModuleID()); doutln(id.getDeviceID()); }

    shs::DTPpacket handle(shs::ByteCollectorReadIterator<>& it) override
    {
        it.set_position(shs::DTPpacket::get_dataBeg(it));

        doutln("has data");

        switch (it.read())
        {
        case shs::etoi(Commands::GET_TEMPERATURE):
        {
            uint8_t temp = m_spot.getTemperature();

            shs::ByteCollector<> buf(2);
            buf.push_back(shs::etoi(Commands::TEMPERATURE), 1);
            buf.push_back(temp, 1);

            return shs::DTPpacket(API_ID, shs::DTPpacket::get_senderID(it), std::move(buf));
        }
        break;

        case shs::etoi(Commands::GET_INFO):
        {
            doutln("info");
            shs::ByteCollector<> buf(4);
            buf.push_back(shs::etoi(Commands::INFO), 1);
            buf.push_back(m_spot.getTemperature(), 1);
            buf.push_back(m_spot.getFanPower(), 1);
            buf.push_back(m_spot.getSensorStatus(), 1);

            return shs::DTPpacket(API_ID, shs::DTPpacket::get_senderID(it), std::move(buf));
        }
        break;

        case shs::etoi(Commands::SET_FAN):
        {
    
            m_spot.setFan(it.read(), it.read());
        }
        break;
        }



        return shs::DTPpacket();
    }

private:
    shs::SmartSpot& m_spot;

};
