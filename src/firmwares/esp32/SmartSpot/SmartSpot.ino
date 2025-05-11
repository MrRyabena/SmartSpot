
#include "settings.h"

#include <shs_SmartSpot.h>
#include <shs_SmartSpotConfig.h>

#include <shs_DTP.h>
#include <shs_lib_GRGB_API.h>

#include <shs_ControlWiFi.h>
// #include <shs_TcpSocket.h>


shs::SmartSpot spot(config);

// shs::TcpSocket client(config.SERVER_IP, config.PORT, config.ID);

// shs::GRGB_API grgb_api(*spot.getGRGB(), config.ID);
// shs::DTP dtp(client, grgb_api, config.ID);


void setup()
{
    shs::ControlWiFi::connectWiFi();

    spot.start();

}

void loop()
{
    spot.tick();

    // if (client.connected()) dtp.tick();
    // else if (client.connect(config.SERVER_IP, config.PORT)) clinet.write(&config.THIS_ID - 1, 2);

}
