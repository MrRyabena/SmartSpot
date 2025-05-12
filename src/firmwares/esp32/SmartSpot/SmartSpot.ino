
#include "settings.h"

#include <memory>

#include <shs_SmartSpot.h>
#include <shs_SmartSpotConfig.h>

#include <shs_DTP.h>
#include <shs_lib_GRGB_API.h>

#include <shs_ControlWiFi.h>
#include <shs_TcpSocket.h>

#define SHS_SF_DEBUG
#define DEBUG
#include <shs_debug.h>


shs::SmartSpot spot(config);

// shs::TcpSocket client(config.SERVER_IP, config.PORT, config.ID.getModuleID(), nullptr, 25);

// shs::GRGB_API grgb_api(*spot.getGRGB(), shs::t::shs_ID_t(config.ID).setComponentID(1));
shs::DTP dtp(config.ID.getModuleID());


void setup()
{
    dinit();
    shs::ControlWiFi::connectWiFiWait();

    spot.start();


    dtp.attachAPI(std::move(std::make_unique<shs::GRGB_API>(*spot.getGRGB(), config.ID)));
    dtp.attachBus(std::move(std::make_unique<shs::TcpSocket>(config.SERVER_IP, config.PORT, config.ID.getModuleID())));
    dtp.start();
}

void loop()
{
    spot.tick();
    dtp.tick();
   // client.tick();

    //if (client.client.connected()) dtp.tick();
  //  else if (client.reconnect()) client.sendPacket(shs::DTP_APIpackets::getInitialPacket(config.ID.getModuleID()));

}
