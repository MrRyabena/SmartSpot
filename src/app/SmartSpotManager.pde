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

byte LEFT_ID = 10;
byte RIGHT_ID = 12;

// =========================================================================================

SpotVirtual sv1;
SpotVirtual sv2;
SpotGUI spg1;
SpotGUI spg2;

void setup() {

  size(1800, 800);
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

  
  sv1 = new SpotVirtual(10);
  sv2 = new SpotVirtual(12);
  spg1 = new SpotGUI(this, 0, 0, sv1, "spg1");
  spg2 = new SpotGUI(this, 900, 0, sv2, "spg2");
  
  spg1.syncing = new SpotGUI[1];
  spg1.syncing[0] = spg2;

  cp5
      .addToggle("sync")
      .setCaptionLabel("sync")
      .setValue(!false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10, 100)
      .setSize(80, 30)    
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        s_sync(int(event.getController().getValue()));
      }
    }
    )
    ;
    ;
  
  spg1.guiSetup();
  spg2.guiSetup();

}

void s_sync(int val)
{
   println(val);
   spg1.setSyncing(boolean(val)); 
}


long tmr1, tmr2 = 0;
void checkConnection()
{
  
  if (sv1.spot != null && (!sv1.spot.active() || millis() - tmr1 > 10000)) { sv1.spot.stop(); sv1.spot = null; println("Connection lost: LEFT_spot"); }
  if (sv2.spot != null && (!sv2.spot.active() || millis() - tmr2 > 10000)) { sv2.spot.stop(); sv2.spot = null; println("Connection lost: RIGHT_spot"); }
  
  
  Client cl = server.available();
  if (cl != null) {
    if (cl.available() > 0) {
    byte buf[] = cl.readBytes();
    if (buf[1] == LEFT_ID){
      if (sv1.spot == null) { sv1.spot = cl; spg1.updateSpot(); println("Connected LEFT_spot:  ", cl.ip()); }
      else if (buf[0] == 4) { spg1.setFan(int(buf[2])); spg1.setTemp(int(buf[3])); }
      tmr1 = millis();
    }
    else if (buf[1] == RIGHT_ID) {
       if (sv2.spot == null) { sv2.spot = cl; spg2.updateSpot(); println("Connected RIGHT_spot: ", cl.ip()); }
      else if (buf[0] == 4) { spg2.setFan(int(buf[2])); spg2.setTemp(int(buf[3])); }
      tmr2 = millis();
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
