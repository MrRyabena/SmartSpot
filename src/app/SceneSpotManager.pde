import processing.serial.*;
Serial spot;

import controlP5.*;
ControlP5 cp5;

String portName;

int potVal;
int fillVal = 0;

int speed = 115200;

// =========================================================================================

void setup() {

  size(1000, 700);

  guiSetup();
}

// ========================================================================================

void draw() {
  background(guiColors[0]);
  fill(255);
  if (spot != null && spot.available() > 0) {
    String str = spot.readStringUntil('\n');
    str = str.trim();
    String data[] = str.split(",");

    switch (int(data[0])) {
    case 3:
      colorMode(HSB);
      cp5.get(Slider.class, "temp")
        .setValue(float(data[1]))
        .setColorForeground(color(100 - map(cp5.get(Slider.class, "temp").getValue(), 20, 50, 0, 100), 255, 255))
        .setColorActive(color(100 - map(cp5.get(Slider.class, "temp").getValue(), 20, 50, 0, 100), 255, 255));

      cp5.get(Slider.class, "fan").setValue(float(data[2]));
      colorMode(RGB);
      break;
    }
  }
}
