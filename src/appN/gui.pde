
color[] guiColors = {
  color(40), // background
  color(80), // ColorBackground
  color(170), // ColorActive
  color(100), // ColorCaptionLabel
  color(120), // ColorForeground
  color(100), // ColorLabel
  color(100), // ColorValue
  color(100)  // ColorValueLabel
  }
  ;


void guiSetup() {

  background(guiColors[0]);

  CColor col = new CColor();
  col.setActive(color(100, 0, 0));

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


  cp5
    .addToggle("switch_b")
    .setCaptionLabel("switch")
    .setValue(!false)
    .setMode(ControlP5.SWITCH)
    .setPosition(10, 50)
    .setSize(80, 30)
    .setColorActive(color(#ff0000));
  ;

  addColors();


  //cp5
  //  .addToggle("smoothing")
  //  .setCaptionLabel("smoothing")
  //  .setValue(!true)
  //  .setMode(ControlP5.SWITCH)
  //  .setPosition(150, 50)
  //  .setSize(80, 30)
  //  .setColorActive(color(#00ff00));
  //  ;

  //  cp5
  //  .addKnob("smothing_k")
  //  .setCaptionLabel("smothing_k")
  //  .setRange(0, 1)
  //  .setRadius(70)
  //  .setPosition(200, 150)
  //  .setValue(0.5);

  cp5
    .addKnob("bright")
    .setCaptionLabel("brightness")
    .setRange(0, 255)
    .setRadius(70)
    .setPosition(10, 150)
    .setValue(255)
    .setColorForeground(color(#ffff00))
    .setColorActive(color(#ffff00));

  cp5
    .addButton("br_off")
    .setCaptionLabel("off")
    .setPosition(10, 320)
    .setSize(50, 30)
    ;

  cp5
    .addButton("br_on")
    .setCaptionLabel("on")
    .setPosition(100, 320)
    .setSize(50, 30)
    ;

  cp5
    .addSlider("br_speed")
    .setCaptionLabel("speed")
    .setPosition(10, 370)
    .setSize(140, 30)
    .setRange(0, 200)
    .setValue(20);
    ;

  cp5
    .addSlider("br_maxBr")
    .setCaptionLabel("Max Brightness")
    .setPosition(10, 420)
    .setSize(140, 30)
    .setRange(0, 255)
    .setValue(255);
  ;

  cp5
    .addColorWheel("picker", 480, 10, 500)
    .setCaptionLabel("")
    ;

  cp5
    .addSlider("temp")
    .setCaptionLabel("temperature")
    .setPosition(250, 10)
    .setSize(40, 350)
    .setRange(20, 50)
    .lock()
    ;

  cp5
    .addSlider("fan")
    .setCaptionLabel("fan")
    .setPosition(400, 10)
    .setSize(40, 350)
    .setRange(0, 255)
    .lock()
    ;
    
     cp5
    .addToggle("splash")
    .setCaptionLabel("splash")
    .setValue(!false)
    .setMode(ControlP5.SWITCH)
    .setPosition(10, 470)
    .setSize(80, 30)
    .setColorActive(color(#ff0000));
  ;
    
    cp5
    .addSlider("sp_speed")
    .setCaptionLabel("speed")
    .setPosition(100, 470)
    .setSize(300, 30)
    .setRange(0, 500)
    .setValue(200);
  ;
  
       cp5
    .addToggle("shift")
    .setCaptionLabel("shift")
    .setValue(!false)
    .setMode(ControlP5.SWITCH)
    .setPosition(10, 520)
    .setSize(80, 30)
    .setColorActive(color(#ff0000));
  ;
    
    cp5
    .addSlider("sh_speed")
    .setCaptionLabel("speed")
    .setPosition(100, 520)
    .setSize(300, 30)
    .setRange(0, 500)
    .setValue(200);
  ;
  
  
    cp5
    .addToggle("wheel")
    .setCaptionLabel("wheel")
    .setValue(!false)
    .setMode(ControlP5.SWITCH)
    .setPosition(10, 570)
    .setSize(80, 30)
    .setColorActive(color(#ff0000));
  ;
    
    cp5
    .addSlider("wl_speed")
    .setCaptionLabel("speed")
    .setPosition(100, 570)
    .setSize(300, 30)
    .setRange(0, 500)
    .setValue(200);
  ;
}

void switch_b(int val) {
  String str = "1,";
  if (val == 0) {
    str += int(cp5.get(Knob.class, "bright").getValue());
    cp5.get(Toggle.class, "switch_b").setColorActive(color(#00ff00));
  } else {
    str += '0';
    cp5.get(Toggle.class, "switch_b").setColorActive(color(#ff0000));
  }
  str += ';';
  println(str);

  if (spot != null) spot.write(str);
}





//void R(int val) {
//  color col = color(val, int(cp5.get(Slider.class, "G").getValue()), int(cp5.get(Slider.class, "B").getValue()));
//  println("R!!!!!");
// // updateColorPicker(col);
//  updateColorSpot(col);
//}

//void G(int val) {
//  color col = color (int(cp5.get(Slider.class, "R").getValue()), val, int(cp5.get(Slider.class, "B").getValue()));

//  //updateColorPicker(col);
//  updateColorSpot(col);
//}

//void B(int val) {
//  color col = color(int(cp5.get(Slider.class, "R").getValue()), int(cp5.get(Slider.class, "G").getValue()), val);

// //updateColorPicker(col);
//  updateColorSpot(col);
//}


//void smoothing(int value) {
//  int x = int(cp5.get(Knob.class, "bright").getValue());
//  long tmr{};
//  while (x != value) {
//    if (millis() - tmr >= cp5.get(Toggle.class, "smoothing_k").getValue()) {
//       if (x < value) cp5.get(Knob.class, "brightness").setValue(x++);
//       else cp5.get(Knob.class, "brightness").setValue(x--);
//     tmr = millis();
//    }
//  }
//}
