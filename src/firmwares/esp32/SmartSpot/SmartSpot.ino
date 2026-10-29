#include "settings.h"

#include <memory>

#include <shs_SmartSpot.h>
#include <shs_SmartSpotConfig.h>
#include <shs_SmartSpotConfigReader.h>
#include <shs_SmartSpotApi.h>

#include "freertos/FreeRTOS.h"
#include "freertos/task.h"

#include <shs_DTP.h>
#include <shs_ControlWiFi.h>
#include <shs_TcpServer.h>
#include <shs_debug.h>


std::shared_ptr<shs::SmartSpot> spot;

std::shared_ptr<shs::DTP> dtp;
std::shared_ptr<shs::TcpServer> tcp_server;

void setup()
{
    dinit();

    doutln(shs::ControlWiFi::connectWiFiWait() ? "WiFi connected" : "WiFi connection faild");

    shs::SmartSpotConfigReader::initFS();
    shs::SmartSpotConfigReader::getConfig(config);

    spot = std::make_shared<shs::SmartSpot>(config);
    spot->start();

    dtp = std::make_shared<shs::DTP>(config.ID.getModuleID());
    shs::SmartSpotApi::attachComponentsApi(dtp, spot, config.ID);

    dtp->start();

    tcp_server = std::make_shared<shs::TcpServer>(config.PORT, *dtp);
    tcp_server->start();
}


void loop()
{
    spot->tick();
    dtp->tick();
    tcp_server->tick();
}
