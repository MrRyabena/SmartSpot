#include "settings.h"


#include <shs_DTP.h>
#include <shsL_GRGB_API.h>
#include <shs_ControlWiFi.h>
#include <shs_ByteCollector.h>
#include <shs_ByteCollectorIterator.h>


#include <ESP8266WiFi.h>
#include <shs_TcpClient.h>


void dtp_handler(shs::ByteCollectorReadIterator<> &it);

#include <GRGB.h>
GRGB chip(COMMON_CATHODE, Rp, Gp, Bp);

shs::TcpClient client(S_IP, PORT, THIS_ID);

shs::GRGB_API grgb_api(chip, THIS_ID);
shs::DTP dtp(client, grgb_api, THIS_ID);


// get temperature from the thermister
float getTemp(int resistance);

// control temperature and manage fan's power
void temperatureControl();

void setup() {
 
  analogWriteResolution(8);
  analogWriteFreq(10000);
  
  shs::ControlWiFi::connectWiFiWait();

  pinMode(fan_p, OUTPUT);
  pinMode(therm_p, INPUT);

  chip.setBrightness(0);

}

void loop() {
  chip.tick();
  temperatureControl();

  if (client.connected()) dtp.tick();
  else if (client.connect(SERVER_IP, PORT)) client.write(&THIS_ID - 1, 2);

}


// temperature from the thermistor
float getTemp(int resistance) {

  float thermistor;
  thermistor = resist_10k / ((float)1023 / resistance - 1);
  thermistor /= resist_base;                        // (R/Ro)
  thermistor = log(thermistor) / B_coef;            // 1/B * ln(R/Ro)
  thermistor += (float)1.0 / (temp_base + 273.15);  // + (1/To)
  thermistor = (float)1.0 / thermistor - 273.15;    // invert and convert to degrees Celsius

  return thermistor;
}

void temperatureControl() {

  static uint32_t tmr;
  if (millis() - tmr >= 2000) {

    float temp = getTemp(analogRead(therm_p));

    int fanPower = map(int(temp), minTemp, maxTemp, 170, 255);
    fanPower = constrain(fanPower, 170, 255);
    analogWrite(fan_p, fanPower);

    shs::ByteCollector<> bc(4);
    bc.push_back(4, 1);
    bc.push_back(THIS_ID, 1);
    bc.push_back(fanPower, 1);
    bc.push_back((uint8_t)temp, 1);
    if (client.connected()) dtp.sendRAW(bc);

    
    tmr = millis();
  }
}
