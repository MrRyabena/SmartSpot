#include "settings.h"


#include <shs_DTP.h>
#include <shsL_GRGB_API.h>
#include <shs_ControlWiFi.h>
#include <shs_ByteCollector.h>
#include <shs_ByteCollectorIterator.h>

#include <shs_ControlWiFi.h>

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
  Serial.begin(115200);
  analogWriteResolution(8);
  analogWriteFreq(10000);
  //  Serial.println();
  //  WiFi.begin(WiFiSSID, WiFiPASS);
  //  while (WiFi.status() != WL_CONNECTED) {
  //   delay(500);
  //   Serial.print('.');
  //   if (millis() >= 30000) ESP.restart();
  // }
  shs::ControlWiFi::connectWiFiWait();
  Serial.println();
  Serial.print("WiFi status: ");
  Serial.println(shs::ControlWiFi::WiFiConnected());


  //shs::ControlWiFi::connectWiFi(WiFiSSID, WiFiPASS);

  pinMode(fan_p, OUTPUT);

  pinMode(therm_p, INPUT);

  // pinMode(RSp, OUTPUT);
  // pinMode(GSp, OUTPUT);

  chip.setBrightness(0);
  chip.setRGB(0, 50, 0);

  //client.start();
}

void loop() {
  temperatureControl();
  //client.tick();



  if (client.connected()) dtp.tick(); 
  else if (client.connect(SERVER_IP, PORT)) client.write((uint8_t*)&THIS_ID, 4);
 

  // static uint32_t tmr{};
  // if (millis() - tmr >= 200) {
  //   static uint8_t value{};
  //   chip.setWheel8(value++);
  //   tmr = millis();
  // }
}




// temperature from the thermistor
float getTemp(int resistance)
{

  float thermistor;
  thermistor = resist_10k / ((float)1023 / resistance - 1);
  thermistor /= resist_base;                       // (R/Ro)
  thermistor = log(thermistor) / B_coef;           // 1/B * ln(R/Ro)
  thermistor += (float)1.0 / (temp_base + 273.15); // + (1/To)
  thermistor = (float)1.0 / thermistor - 273.15;   // invert and convert to degrees Celsius

  return thermistor;
}

void temperatureControl()
{

  static uint32_t tmr;
  if (millis() - tmr >= 2000)
  {

    // analogReference(DEFAULT);
    float temp = getTemp(analogRead(therm_p));
    //  analogReference(EXTERNAL);
    // Serial.println(temp);

    // if (temp >= 47) settings.mode = 0;
    // if (temp >= critTemp)
    // {
    //   int value = map(int(temp), critTemp, critTemp + 20, 40, 255);
    //   chip.setBrightness(value);
    // }
    // else
    //   chip.setBrightness(255);
    int fanPower = map(int(temp), minTemp, maxTemp, 170, 255);
    fanPower = constrain(fanPower, 170, 255);
    analogWrite(fan_p, fanPower);
    
    //Serial.print(temp); Serial.print(' ');
   // Serial.println(fanPower);
    tmr = millis();
  }
}
