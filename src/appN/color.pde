void addColors() {
  cp5
    .addButton("b_red")
    .setCaptionLabel("")
    .setPosition(480, 550)
    .setSize(50, 30)
    .setColorBackground(color(#ff0000))
    .setColorForeground(color(#B40000))
    .setColorActive(color(#B40000))
    ;

  cp5
    .addButton("b_pink")
    .setCaptionLabel("")
    .setPosition(480, 600)
    .setSize(50, 30)
    .setColorBackground(color(#FF6481))
    .setColorForeground(color(#B4475B))
    .setColorActive(color(#B4475B))
    ;

  cp5
    .addButton("b_deep_pink")
    .setCaptionLabel("")
    .setPosition(480, 650)
    .setSize(50, 30)
    .setColorBackground(color(#ff1493))
    .setColorForeground(color(#B40F6A))
    .setColorActive(color(#B40F6A))
    ;

  cp5
    .addButton("b_yellow")
    .setCaptionLabel("")
    .setPosition(550, 550)
    .setSize(50, 30)
    .setColorBackground(color(#ffff00))
    .setColorForeground(color(#B4B200))
    .setColorActive(color(#B4B200))
    ;
  cp5
    .addButton("b_orange")
    .setCaptionLabel("")
    .setPosition(550, 600)
    .setSize(50, 30)
    .setColorBackground(color(#FFA500))
    .setColorForeground(color(#B47300))
    .setColorActive(color(#B47300))
    ;

  cp5
    .addButton("b_white")
    .setCaptionLabel("")
    .setPosition(550, 650)
    .setSize(50, 30)
    .setColorBackground(color(#FFFFFF))
    .setColorForeground(color(#B4B4B4))
    .setColorActive(color(#B4B4B4))
    ;

  cp5
    .addButton("b_green")
    .setCaptionLabel("")
    .setPosition(620, 550)
    .setSize(50, 30)
    .setColorBackground(color(#00ff00))
    .setColorForeground(color(#00B400))
    .setColorActive(color(#00B400));
  ;

  cp5
    .addButton("b_light_green")
    .setCaptionLabel("")
    .setPosition(620, 600)
    .setSize(50, 30)
    .setColorBackground(color(#B6FF00))
    .setColorForeground(color(#81B400))
    .setColorActive(color(#81B400));
  ;

  cp5
    .addButton("b_blue_green")
    .setCaptionLabel("")
    .setPosition(620, 650)
    .setSize(50, 30)
    .setColorBackground(color(#17FF8D))
    .setColorForeground(color(#0FB463))
    .setColorActive(color(#0FB463));
  ;
  cp5
    .addButton("b_blue")
    .setCaptionLabel("")
    .setPosition(690, 550)
    .setSize(50, 30)
    .setColorBackground(color(#0000ff))
    .setColorForeground(color(#0000B4))
    .setColorActive(color(#0000B4));
  ;

  cp5
    .addButton("b_cyan")
    .setCaptionLabel("")
    .setPosition(690, 600)
    .setSize(50, 30)
    .setColorBackground(color(#00ffff))
    .setColorForeground(color(#00B4B3))
    .setColorActive(color(#00B4B3))
    ;

  cp5
    .addButton("b_purpure")
    .setCaptionLabel("")
    .setPosition(690, 650)
    .setSize(50, 30)
    .setColorBackground(color(#A020F0))
    .setColorForeground(color(#7819B4))
    .setColorActive(color(#7819B4))
    ;


  cp5
    .addSlider("R")
    .setCaptionLabel("R")
    .setPosition(770, 550)
    .setSize(200, 30)
    .setRange(0, 255)
    .lock()
    ;

  cp5
    .addSlider("G")
    .setCaptionLabel("G")
    .setPosition(770, 600)
    .setSize(200, 30)
    .setRange(0, 255)
    .lock()
    ;

  cp5
    .addSlider("B")
    .setCaptionLabel("B")
    .setPosition(770, 650)
    .setSize(200, 30)
    .setRange(0, 255)
    .lock()
    ;

  //  cp5
  //.addButton("b_color")
  //.setCaptionLabel("")
  //.setPosition(480, 460)
  //.setSize(500, 50)
  //;
}


//void updateColor(color col) {
//  cp5.get(Button.class, "b_color")
//    .setColorBackground(col)
//    .setColorForeground(col)
//    .setColorActive(col);

//   updateColorRGB(col);
//}



void updateColorRGB(color col) {
  cp5.get(Slider.class, "R").setValue(red(col)).setColorForeground(color(red(col), 0, 0)).setColorActive(color(red(col), 0, 0));
  cp5.get(Slider.class, "G").setValue(green(col)).setColorForeground(color(0, green(col), 0)).setColorActive(color(0, green(col), 0));
  cp5.get(Slider.class, "B").setValue(blue(col)).setColorForeground(color(0, 0, blue(col))).setColorActive(color(0, 0, blue(col)));
}

void updateColorPicker(color col) {
  cp5.get(ColorWheel.class, "picker").setRGB(col);
}

void updateColorSpot(color col) {
  String str = "2,";
  str += int(red(col));
  str += ',';
  str += int(green(col));
  str += ',';
  str += int(blue(col));
  str += ';';
  println(str);

  if (spot != null) spot.write(str);
}


void picker(int col) {
  print("piker: ");
  // updateColor(col);
  updateColorRGB(col);
  updateColorSpot(col);
}


void b_red() {
  color col = #ff0000;

  updateColorPicker(col);
}

void b_pink() {
  color col = #FF6481;

  //updateColorRGB(col);
  updateColorPicker(col);
  // updateColorSpot(col);
}

void b_deep_pink() {
  color col = #ff1493;

  // updateColorRGB(col);
  updateColorPicker(col);
  // updateColorSpot(col);
}

void b_yellow() {
  color col =  #ffff00;
  // updateColorRGB(col);
  updateColorPicker(col);
  // updateColorSpot(col);
}

void b_orange() {
  color col =  #FFA500;
  // updateColorRGB(col);
  updateColorPicker(col);
  // updateColorSpot(col);
}

void b_white() {
  color col =  #FFFFFF;
  // updateColorRGB(col);
  updateColorPicker(col);
  //updateColorSpot(col);
}

void b_green() {
  color col = #00ff00;

  //updateColorRGB(col);
  updateColorPicker(col);
  //updateColorSpot(col);
}

void b_light_green() {
  color col = #B6FF00;

  // updateColorRGB(col);
  updateColorPicker(col);
  //updateColorSpot(col);
}

void b_blue_green() {
  color col = #17FF8D;

  // updateColorRGB(col);
  updateColorPicker(col);
  //updateColorSpot(col);
}

void b_blue() {
  color col = #0000ff;

  // updateColorRGB(col);
  updateColorPicker(col);
  // updateColorSpot(col);
}

void b_cyan() {
  color col = #00ffff;

  //updateColorRGB(col);
  updateColorPicker(col);
  //updateColorSpot(col);
}

void b_purpure() {
  color col = #A020F0;

  //  updateColorRGB(col);
  updateColorPicker(col);
  //  updateColorSpot(col);
}
