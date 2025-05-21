import processing.net.*;
import controlP5.*;


ControlP5 cp5;



Server server;

// -----------------------------------------------------------------------------

shs_ID[] spot_ids = {
  new shs_ID(11, 0, 0),
  new shs_ID(12, 0, 0),
  new shs_ID(14, 0, 0),
  new shs_ID(15, 0, 0) }; 

int[][] spot_pb = {
  {50, 255},
  {50, 255},
  {50, 255},
  {50, 255}
};


SpotVirtual[] spots;

SpotGUI sp_left, sp_right;

// -----------------------------------------------------------------------------

void setup() {
  // ---------------------------------------------------------------------------
  size(1800, 900);

  cp5 = new ControlP5(this);

  cp5
    .setColorBackground(guiColors[1])
    .setColorActive(guiColors[2])
    //.setColorCaptionLabel(guiColors[3]))
    .setColorForeground(guiColors[4])
    //  .setColorLabel(guiColors[5])
    //  .setColorValue(guiColors[6])
    //  .setColorValueLabel(guiColors[7])

    .setFont(createFont("Calibri", 18));

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
  );

  // ---------------------------------------------------------------------------

  server = new Server(this, 10002);

  println("Server started: ", server.ip());

  // ---------------------------------------------------------------------------

  spots = new SpotVirtual[spot_ids.length];
  for (int i = 0; i < spot_ids.length; i++) spots[i] = new SpotVirtual(spot_ids[i], spot_pb[i][0], spot_pb[i][1]);


  sp_left = new SpotGUI(this, 0, 0, "sp_left");
  sp_right = new SpotGUI(this, 900, 0, "sp_right");

  sp_left.virtual_spots = new SpotVirtual[2];
  for (int i = 0; i < 2; i++) sp_left.virtual_spots[i] = spots[i];

  sp_right.virtual_spots = new SpotVirtual[2];
  for (int i = 0; i < 2; i++) sp_right.virtual_spots[i] = spots[2 + i];


  sp_left.syncing = new SpotGUI[1];
  sp_left.syncing[0] = sp_right;

  sp_left.guiSetup();
  sp_right.guiSetup();
  //   sp_left.cp5.getController("sp_leftbr_maxBr").setValue(210);
  sp_left.cp5.getController("sp_leftbright").setValue(0);
  sp_right.cp5.getController("sp_rightbr_maxBr").setValue(210);
  sp_right.cp5.getController("sp_rightbright").setValue(0);
}

void s_sync(int val) {
   sp_left.setSyncing(!boolean(val));
   if (val == 0) cp5.get(Toggle.class, "sync").setColorActive(color(#00ff00));
   else cp5.get(Toggle.class, "sync").setColorActive(color(#ff0000));
}
long[] tmrs = new long[spot_ids.length];

void checkConnection() {

  Client client = server.available();

  for (int i = 0; i < spot_ids.length; i++) {
    if (spots[i].spot != null &&(!spots[i].spot.active() || millis() - tmrs[i] >= 20000)) {
      spots[i].spot.stop();
      spots[i].spot = null;
      
      if (i < 2) { cp5.get(Button.class, "sp_leftSP_" + i).setColorBackground(#ff0000); }
      else { cp5.get(Button.class, "sp_rightSP_" + i).setColorBackground(#ff0000); }

      println("Connection list: spot: ", spot_ids[i].getModuleID());
    }
  }

  if (client != null) {

    if (client.available() > 0) {
      byte buf[] = client.readBytes();

      for (int i = 0; i < spot_ids.length; i++)
      {
        if (buf[5] == spot_ids[i].getModuleID())
        {
          if (spots[i].spot == null)
          {
            spots[i].spot = client;
            println("Connected spot # ", i, client.ip());
            if (i < 2) sp_left.updateSpot();
            else sp_right.updateSpot();
          }

          tmrs[i] = millis();
          if (i < 2) { cp5.get(Button.class, "sp_leftSP_" + i).setColorBackground(#00ff00); }
          else { cp5.get(Button.class, "sp_rightSP_" + i).setColorBackground(#00ff00); }
          
          //print(i);
          // for (byte x : buf) print(int(x), ' ');

          if (buf.length > 11) {
            //println(buf[10]);
            switch(buf[10]) {
            case 6:
              if (i < 2) {
                sp_left.setTemp(int(buf[11]), i + 1);
                sp_left.setFan(int(buf[12]), i + 1);
              } else {
                sp_right.setTemp(int(buf[11]), i - 2 + 1);
                sp_right.setFan(int(buf[12]), i - 2 + 1);
              }
              break;
            }
          }
        }
      }
    }
  }
}

// -----------------------------------------------------------------------------

void draw() {
  background(guiColors[0]);
  checkConnection();
  sp_left.tick();
  sp_right.tick();
}
