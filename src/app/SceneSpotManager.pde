import processing.net.*;


Server server;
Client spotL;

//58-BF-25-DC-47-09

import controlP5.*;
ControlP5 cp5;

String portName;

int potVal;
int fillVal = 0;

int speed = 115200;

// =========================================================================================

SpotVirtual sv1;
SpotGUI spg1;
SpotGUI spg2;

void setup() {

  size(2000, 700);
  cp5 = new ControlP5(this);
  
  cp5
      .setColorBackground(guiColors[1])
      .setColorActive(guiColors[2])
      //.setColorCaptionLabel(guiColors[3]))
      .setColorForeground(guiColors[4])
      //  .setColorLabel(guiColors[5])
      //  .setColorValue(guiColors[6])
      //  .setColorValueLabel(guiColors[7])
      .setFont(createFont("Calibri", 18))  // сделаем шрифт побольше
      ;
      
  server = new Server(this, 10002);
  
  println(server.ip());
  
  sv1 = new SpotVirtual(10, spotL);
  spg1 = new SpotGUI(0, 0, sv1, cp5, "spg1");
  spg2 = new SpotGUI(1000, 0, sv1, cp5, "spg2");
  
  spg1.syncing = new SpotGUI[1];
  spg1.syncing[0] = spg2;

  cp5
      .addToggle("sync")
      .setCaptionLabel("sync")
      .setValue(!false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10, 100)
      .setSize(80, 30)      
    ;
  
  spg1.guiSetup();
  spg2.guiSetup();
  
}

void sync(int val)
{
 spg1.syncing_flag = !boolean(val); 
 println(!boolean(val));
}

void checkConnection()
{
  if (spotL != null && !spotL.active()) { spotL.stop(); spotL = null; }
  if (spotL == null) {
  Client cl = server.available();
  if (cl != null) {
    spotL = cl;
    sv1.spot = spotL;
    println(spotL.ip());
  }
  }
}

// ========================================================================================

void draw() {
   
  background(guiColors[0]);
  checkConnection();
  spg1.tick();
  spg2.tick();

  //thread("br_tick");
  //thread("ef_tick");
  //fill(255);
  //if (spot != null && spot.available() > 0) {
  //  if (spot.available() < 7) return;
  //  //println(spot.readString());
  //  String str = spot.readStringUntil('\n');
  //  str = str.trim();
  //  String data[] = str.split(",");
  //  if (data.length < 3) return;
  //  switch (int(data[0])) {
  //  case 3:
  //    colorMode(HSB);
  //    cp5.get(Slider.class, "temp")
  //      .setValue(float(data[1]))
  //      .setColorForeground(color(100 - map(cp5.get(Slider.class, "temp").getValue(), 20, 50, 0, 100), 255, 255))
  //      .setColorActive(color(100 - map(cp5.get(Slider.class, "temp").getValue(), 20, 50, 0, 100), 255, 255));

  //    cp5.get(Slider.class, "fan").setValue(float(data[2]));
  //    colorMode(RGB);
  //    break;
  //  }
  //}
}
