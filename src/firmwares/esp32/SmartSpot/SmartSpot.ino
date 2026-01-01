#include "settings.h"

#include <memory>

#include <shs_SmartSpot.h>
#include <shs_SmartSpotConfig.h>
#include <shs_SmartSpotConfigReader.h>
#include <shs_SmartSpot_API.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include <shs_lib_RGBmusic.h>
#include <shs_lib_RGBmusic_API.h>

#include <shs_DTP.h>
#include <shs_lib_GRGB_API.h>

#include <shs_ControlWiFi.h>
#include <shs_TcpSocket.h>

#define SHS_SF_DEBUG
#define DEBUG
#include <shs_debug.h>

#include <AutoOTA.h>


std::shared_ptr<shs::SmartSpot> spot;
std::shared_ptr<shs::RGBmusic> rgb_music;

shs::DTP dtp(config.ID.getModuleID());

TaskHandle_t handle_rgbMusicTick;

void checkUpdate();
void rgbMusicTick(void *);


void setup()
{
    dinit();

    doutln(shs::ControlWiFi::connectWiFiWait() ? "WiFi connected" : "WiFi connection faild");

    shs::SmartSpotConfigReader::initFS();
    shs::SmartSpotConfigReader::getConfig(config);
    
    
    spot = std::make_shared<shs::SmartSpot>(config);
    rgb_music = std::make_shared<shs::RGBmusic>(*(spot->getGRGB()), RGB_MUSIC_PIN);

    //analogReadResolution(10);

    spot->start();
    rgb_music->start();
    // rgb_music->analyzer.setDt(5000);
    //spot->getGRGB()->setBrightness(255);
    //rgb_music->setEffect(shs::RGBmusic::Effects::SHIFT_151);

    xTaskCreatePinnedToCore(rgbMusicTick, "rgbMusicTick", 2048, nullptr, 0, &handle_rgbMusicTick, 0);

    doutln(analogRead(config.TEMP_SENSOR_PIN));
    doutln(spot->getTemperature());

    //checkUpdate();


    dtp.attachAPI(std::move(std::make_unique<shs::GRGB_API>(*spot->getGRGB(), config.ID)));
    dtp.attachAPI(std::move(std::make_unique<shs::SmartSpot_API>(*spot, shs::ID(config.ID.getModuleID(), 2, 0))));
    dtp.attachAPI(std::move(std::make_unique<shs::RGBmusic_API>(*rgb_music, shs::ID(config.ID.getModuleID(), 3, 0))));
    doutln(config.ID.getModuleID());
    auto client = std::make_unique<shs::TcpSocket>(config.SERVER_IP, config.PORT, config.ID.getModuleID());
    client->setReconnectingTimeout(UINT32_MAX);
    dtp.attachBus(std::move(client));
    dtp.start();
}


void loop()
{
    spot->tick();
    dtp.tick();
    // rgb_music->tick();
}


void rgbMusicTick(void *)
{
  while (true)
  {
      rgb_music->tick();
      // vTaskDelay(pdMS_TO_TICKS(10)); 
  }
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


