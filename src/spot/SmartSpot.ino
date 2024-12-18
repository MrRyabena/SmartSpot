#include "settings.h"


#include <shs_DTP.h>
#include <shsL_GRGB_API.h>
#include <shs_ControlWiFi.h>
#include <shs_ByteCollector.h>
#include <shs_ByteCollectorIterator.h>


#include <ESP8266WiFi.h>
#include <shs_TcpClient.h>

#include <GyverDS18.h>
#include <GRGB.h>
#include "shsL_RGBmusic.h"
#include "shsL_RGBmusic_API.h"

//shs::TcpClient client();
WiFiClient client;

#include <shs_API.h>
#include <shs_ID.h>


class SpotAPI : public shs::API
{
public:
    SpotAPI(shs::GRGB_API& grgb_api, shs::RGBmusic_API& music_api, const shs::ID id)
        : API(id), m_grgb_api(grgb_api), m_music_api(music_api)
    {
    }

    void handle(shs::ByteCollectorReadIterator<>& it) override
    {
        ++it;
        switch (it.read())
        {
            case 1: it.set_position(1); m_grgb_api.handle(it); break;
            case 2: it.set_position(1); m_music_api.handle(it); break;
        }
    }

private:
    shs::GRGB_API& m_grgb_api;
    shs::RGBmusic_API& m_music_api;
};


GyverDS18Single temp_sensor(TEMP_SENS_PIN);
GRGB chip(COMMON_CATHODE, Rp, Gp, Bp);
shs::RGBmusic rgb_music(chip, MUSICp);
shs::RGBmusic_API music_api(rgb_music, THIS_ID);
shs::GRGB_API grgb_api(chip, THIS_ID);

SpotAPI spot_api(grgb_api, music_api, THIS_ID);

shs::DTP dtp(client, spot_api, THIS_ID);



// control temperature and manage fan's power
void temperatureControl();

void setup() {
    //Serial.begin(115200);
    //analogWriteResolution(8);
    //analogWriteFreq(10000);

    shs::ControlWiFi::connectWiFiWait();

    pinMode(fan_p, OUTPUT);
   // pinMode(therm_p, INPUT);

    chip.setBrightness(0);
    rgb_music.start();
    rgb_music.analyzer.setDt(5000);
    //rgb_music.setEffect(shs::RGBmusic::PULSE_WHEEL);

}

void loop() {
    chip.tick();
    yield();
    temperatureControl();
    yield();
    rgb_music.tick();
    yield();
    if (client.connected()) dtp.tick();
    else if (client.connect(SERVER_IP, PORT)) client.write(&THIS_ID - 1, 2);
}


void temperatureControl() {

    static uint32_t tmr{};
    static int16_t temp{};
    static uint8_t fanPower{};

    if (millis() - tmr >= 4000)
    {
        if (temp_sensor.ready() && temp_sensor.readTemp())
        {
            temp = temp_sensor.getTempInt();
            fanPower = constrain(map(temp, MIN_TEMP, MAX_TEMP, MIN_POWER, MAX_POWER), MIN_POWER, MAX_POWER);
            if (temp <= 28) fanPower = 0;
        }

        

        shs::ByteCollector<> bc(4);
        bc.push_back(4, 1);
        bc.push_back(THIS_ID, 1);
        bc.push_back(fanPower, 1);
        bc.push_back((uint8_t)temp, 1);
        if (client.connected()) dtp.sendRAW(bc);

        if (!temp_sensor.isWaiting()) temp_sensor.requestTemp();

        analogWrite(fan_p, fanPower);

        tmr = millis();
    }

}

