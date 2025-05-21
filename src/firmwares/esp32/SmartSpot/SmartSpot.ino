#include "settings.h"

#include <memory>

#include <shs_SmartSpot.h>
#include <shs_SmartSpotConfig.h>
#include <shs_SmartSpotConfigReader.h>
#include <shs_SmartSpot_API.h>

#include <shs_DTP.h>
#include <shs_lib_GRGB_API.h>

#include <shs_ControlWiFi.h>
#include <shs_TcpSocket.h>

#define SHS_SF_DEBUG
#define DEBUG
#include <shs_debug.h>

#include <AutoOTA.h>


std::shared_ptr<shs::SmartSpot> spot;

shs::DTP dtp(config.ID.getModuleID());

void checkUpdate();


void setup()
{
    dinit();

    shs::ControlWiFi::connectWiFiWait();

    shs::SmartSpotConfigReader::initFS();
    shs::SmartSpotConfigReader::getConfig(config);
    
    
    spot = std::make_shared<shs::SmartSpot>(config);

    analogReadResolution(10);

    spot->start();

    // doutln(analogRead(config.TEMP_SENSOR_PIN));

    checkUpdate();


    dtp.attachAPI(std::move(std::make_unique<shs::GRGB_API>(*spot->getGRGB(), config.ID)));
    dtp.attachAPI(std::move(std::make_unique<shs::SmartSpot_API>(*spot, shs::ID(config.ID.getModuleID(), 2, 0))));
    dtp.attachBus(std::move(std::make_unique<shs::TcpSocket>(config.SERVER_IP, config.PORT, config.ID.getModuleID())));
    dtp.start();
}


void loop()
{
    spot->tick();
    dtp.tick();
}


void checkUpdate()
{
    AutoOTA ota(SMART_SPOT_ESP32_VERSION, "https://raw.githubusercontent.com/MrRyabena/SmartSpot/v2.x.x/project.json");

    String ver, notes;
    if (ota.checkUpdate(&ver, &notes))
    {
      doutln("has update!");
      doutln(ver);

      doutln(ota.version());
      doutln(notes);
      
      auto& grgb = *(spot->getGRGB());
      
      grgb.setBrightness(80);
      grgb.setColor(0xff0000);
      grgb.tick();
      delay(500);
      grgb.setBrightness(0);
      grgb.tick();
      delay(500);
      grgb.setBrightness(80);
      grgb.setColor(0xff0000);
      grgb.tick();
      delay(500);
      grgb.setBrightness(0);
      grgb.tick();
      
      ota.updateNow();
      doutln("updated!");
    }

    if (ota.hasError())
    {
      doutln((int)ota.getError());
    }

    doutln("no update");

    
}


