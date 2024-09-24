#include "settings.h"

#include <shs_FastDTP.h>
#include <shs_ControlWiFi.h>
#include <shs_ByteCollector.h>
#include <shs_ByteCollectorIterator.h>

#include <ESP8266WiFi.h>


void dtp_handler(shs::ByteCollectorReadIterator<> &it);

// #include <GRGB.h>
// GRGB chip(COMMON_CATHODE, Rp, Gp, Bp);

WiFiClient client;
shs::FastDTP dtp(client, dtp_handler, 10);


// get temperature from the thermister
//float getTemp(int resistance);

// control temperature and manage fan's power
//void temperatureControl();

void setup()
{
   Serial.begin(115200);

   Serial.println();
  WiFi.begin(WiFiSSID, WiFiPASS);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print('.');
    if (millis() >= 30000) ESP.restart();
  }


  //shs::ControlWiFi::connectWiFi(WiFiSSID, WiFiPASS);
 
  // pinMode(fan_p, OUTPUT);

  // pinMode(therm_p, INPUT);

  // pinMode(RSp, OUTPUT);
  // pinMode(GSp, OUTPUT);

  // chip.setBrightness(0);
  // // chip.setRGB(0, 50, 0);

  Serial.println(client.connect(SERVER_IP, PORT));
  Serial.println(client.connected());

   if (client.connected()) client.write("Hello");

}

void loop()
{
  //temperatureControl();
 
  if (client.connected())  dtp.tick();

  // static uint32_t tmr{};
  // if (millis() - tmr >= 200) {
  //   static uint8_t value{};
  //   chip.setWheel8(value++);
  //   tmr = millis();
  // }
}

void dtp_handler(shs::ByteCollectorReadIterator<> &it)
{
  uint8_t value{};
  Serial.print("Command:  ");
  it.get(value);
  Serial.println(value);

if (value == 1) {
Serial.print("Value:  ");
  it.get(value);
  Serial.println(value);
}

else
{
  
  Serial.print("Value:  ");
  for (uint8_t i = 0; i < 3; i++) Serial.print(*it); ++it; Serial.print("  ");
}

Serial.println('\n');
  

  

}


// // temperature from the thermistor
// float getTemp(int resistance)
// {

//   float thermistor;
//   thermistor = resist_10k / ((float)1023 / resistance - 1);
//   thermistor /= resist_base;                       // (R/Ro)
//   thermistor = log(thermistor) / B_coef;           // 1/B * ln(R/Ro)
//   thermistor += (float)1.0 / (temp_base + 273.15); // + (1/To)
//   thermistor = (float)1.0 / thermistor - 273.15;   // invert and convert to degrees Celsius

//   return thermistor;
// }

// void temperatureControl()
// {

//   static uint32_t tmr;
//   if (millis() - tmr >= 2000)
//   {

//     // analogReference(DEFAULT);
//     float temp = getTemp(analogRead(therm_p));
//     //  analogReference(EXTERNAL);
//     // Serial.println(temp);

//     // if (temp >= 47) settings.mode = 0;
//     // if (temp >= critTemp)
//     // {
//     //   int value = map(int(temp), critTemp, critTemp + 20, 40, 255);
//     //   chip.setBrightness(value);
//     // }
//     // else
//     //   chip.setBrightness(255);
//     int fanPower = map(int(temp), minTemp, maxTemp, 170, 255);
//     fanPower = constrain(fanPower, 170, 255);
//     analogWrite(fan_p, fanPower);
//     String str = "3,";
//     str += temp;
//     str += ',';
//     str += fanPower;
        
//     Serial.println(str);
//     tmr = millis();
//   }
// }

