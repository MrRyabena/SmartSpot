import processing.net.*;


Client spot;

//58-BF-25-DC-47-09

import controlP5.*;
ControlP5 cp5;

String portName;

int potVal;
int fillVal = 0;

int speed = 115200;

// =========================================================================================

void setup() {

  size(1000, 700);
  spot = new Client(this, "192.168.1.6", 50);
  
  
  guiSetup();
  
}

// ========================================================================================

void draw() {
  background(guiColors[0]);
  thread("br_tick");
  thread("ef_tick");
  fill(255);
  if (spot != null && spot.available() > 0) {
    if (spot.available() < 7) return; 
    //println(spot.readString());
    String str = spot.readStringUntil('\n');
    str = str.trim();
    String data[] = str.split(",");
    if (data.length < 3) return;
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
