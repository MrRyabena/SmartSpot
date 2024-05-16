#include "settings.h"
#include "Parser.h"

#include <GRGB.h>
GRGB chip(COMMON_CATHODE, Rp, Gp, Bp);

// get temperature from the thermister
float getTemp(int resistance);

// control temperature and manage fan's power
void temperatureControl();

void setup()
{
  Serial.begin(115200);
  // analogReference(EXTERNAL);  // instal an external reference voltage source for sound processing
  //  !!! processing of other signals may require modification!

  // PWM frequency for colors and fan
#if (frequency_9_10 == 62) // D9 & D10 — 62.5 kHz
  TCCR1A = 0b00000001;     // 8bit
  TCCR1B = 0b00001001;     // x1 fast pwm

#elif (frequency_9_10 == 31) // D9 & D10 — 31.4 kHz
  TCCR1A = 0b00000001; // 8bit
  TCCR1B = 0b00000001; // x1 phase correct

#elif (frequency_9_10 == 8) // D9 & D10 — 7.8 kHz
  TCCR1A = 0b00000001; // 8bit
  TCCR1B = 0b00001010; // x8 fast pwm

#elif (frequency_9_10 == 4) // D9 & D10 — 4 kHz
  TCCR1A = 0b00000001; // 8bit
  TCCR1B = 0b00000010; // x8 phase correct

#elif (frequency_9_10 == 1) // D9 & D10 — 976 Hz
  TCCR1A = 0b00000001; // 8bit
  TCCR1B = 0b00001011; // x64 fast pwm

#endif

#if (frequency_3_11 == 62) // D3 & D11 — 62.5 kHz
  TCCR2B = 0b00000001;     // x1
  TCCR2A = 0b00000011;     // fast pwm

#elif (frequency_3_11 == 31) // D3 & D11 — 31.4 kHz
  TCCR2B = 0b00000001; // x1
  TCCR2A = 0b00000001; // phase correct

#elif (frequency_3_11 == 8) // D3 & D11 — - 8 kHz
  TCCR2B = 0b00000010; // x8
  TCCR2A = 0b00000011; // fast pwm

#elif (frequency_3_11 == 4) // D3 & D11 — - 4 kHz
  TCCR2B = 0b00000010; // x8
  TCCR2A = 0b00000001; // phase correct

#elif (frequency_3_11 == 1) // D3 & D11 — - 980 Hz
  TCCR2B = 0b00000011; // x32
  TCCR2A = 0b00000001; // phase correct

#endif

  // pinMode(Rp, OUTPUT);
  // pinMode(Gp, OUTPUT);
  // pinMode(Bp, OUTPUT);

  pinMode(fan_p, OUTPUT);

  pinMode(therm_p, INPUT);

  pinMode(RSp, OUTPUT);
  pinMode(GSp, OUTPUT);

  chip.setBrightness(0);
  // chip.setRGB(0, 50, 0);
}

void loop()
{
  temperatureControl();
  parseSerial();

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
    String str = "3,";
    str += temp;
    str += ',';
    str += fanPower;
        
    Serial.println(str);
    tmr = millis();
  }
}

void parseSerial()
{
  if (Serial.available())
  {
    char buf[20];
    int num = Serial.readBytesUntil(';', buf, 20);
    buf[num] = NULL;
    Parser data(buf, ',');
    int ints[10];
    data.parseInts(ints);

    switch (ints[0])
    {
      case 1: chip.setBrightness(ints[1]); break;
      case 2: chip.setRGB(ints[1], ints[2], ints[3]); break;
    }

    
    //Serial.println("ok");
  }
}
