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

byte LEFT_ID_1 = 11;
byte LEFT_ID_2 = 12;
byte RIGHT_ID_1 = 14;
byte RIGHT_ID_2 = 15;

// =========================================================================================

SpotVirtual sv_l1;
SpotVirtual sv_l2;
SpotVirtual sv_r1;
SpotVirtual sv_r2;
SpotGUI spg1;
SpotGUI spg2;

void setup() {

  size(1800, 750);
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
  

  println("Server started: ", server.ip());

  
  sv_l1 = new SpotVirtual(LEFT_ID_1);
  sv_l2 = new SpotVirtual(LEFT_ID_2);
  sv_r1 = new SpotVirtual(RIGHT_ID_1);
  sv_r2 = new SpotVirtual(RIGHT_ID_2);
  spg1 = new SpotGUI(0, 0, sv_l1, cp5, "spg1");
  spg2 = new SpotGUI(900, 0,sv_r1, cp5, "spg2");
  
  spg1.syncing = new SpotGUI[2];
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
}


long tmr1, tmr2, tmr3, tmr4 = 0;
void checkConnection()
{
  
  //if (sv_l1.spot != null && (!sv_l1.spot.active() || millis() - tmr1 > 10000)) { sv_l1.spot.stop(); sv_l1.spot = null; println("Connection lost: LEFT_1"); }
  if (sv_r1.spot != null && (!sv_r1.spot.active() || millis() - tmr2 > 10000)) { sv_r1.spot.stop(); sv_r1.spot = null; println("Connection lost: RIGHT_1"); }
    if (sv_l2.spot != null && (!sv_l2.spot.active() || millis() - tmr3 > 10000)) { sv_l2.spot.stop(); sv_l2.spot = null; println("Connection lost: LEFT_2"); }
  if (sv_r2.spot != null && (!sv_r2.spot.active() || millis() - tmr4 > 10000)) { sv_r2.spot.stop(); sv_r2.spot = null; println("Connection lost: RIGHT_2"); }
  
  Client cl = server.available();
  if (cl != null) {
    if (cl.available() > 0) {
    byte buf[] = cl.readBytes();
    
    int index = 5; // 3;
    
    for (int i = 0; i < buf.length; i++) println(buf[i]);

    if (buf[index] == LEFT_ID_1){
      if (sv_l1.spot == null) { sv_l1.spot = cl; println("Connected spot LEFT_1:  ", cl.ip()); }
      if (buf.length > 11 && buf[11] == 4) { spg1.setFan(int(buf[12])); spg1.setTemp(int(buf[13])); }
      tmr1 = millis();
    }

    else if (buf[index] == RIGHT_ID_1) {
      if (sv_r1.spot == null) { sv_r1.spot = cl; println("Connected spot RIGHT_1: ", cl.ip()); }
      if (buf.length > 11 && buf[11] == 4) { spg1.setFan(int(buf[12])); spg1.setTemp(int(buf[13])); }
      tmr2 = millis();
    }

    else if (buf[index] == LEFT_ID_2)
    {
      if (sv_l2.spot == null) { sv_l2.spot = cl; println("Connected spot LEFT_2: ", cl.ip());}
      tmr3 = millis();
    }

    else if (buf[index] == RIGHT_ID_2)
    {
      if (sv_r2.spot == null) { sv_r2.spot = cl; println("Connected spot RIGHT_2: ", cl.ip());}
      tmr4 = millis();
    }
  }
  }

}

// ========================================================================================

void draw() {
   
  background(guiColors[0]);
  checkConnection();
  spg1.tick();
  spg2.tick();

}
