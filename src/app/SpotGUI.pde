
color[] guiColors = {
  color(40), // background
  color(80), // ColorBackground
  color(170), // ColorActive
  color(100), // ColorCaptionLabel
  color(120), // ColorForeground
  color(100), // ColorLabel
  color(100), // ColorValue
  color(100)    // ColorValueLabel
  }
  ;


public class SpotGUI
{
  SpotVirtual spot_virtual;
  String pannel_name;
  float shift_x;
  float shift_y;
  ControlP5 cp5;
  SpotGUI[] syncing;
  boolean syncing_flag;

  public SpotGUI(float x, float y, SpotVirtual spot, ControlP5 cp, String pannel_name)
  {
    this.shift_x = x;
    this.shift_y = y;
    this.pannel_name = pannel_name;
    this.spot_virtual = spot;
    this.cp5 = cp;
    this.syncing_flag = false;
  }

/*
  -----------------Color----------------
*/
  void setColor(color col)
  {
    updateColorRGB(col);
    updateColorPicker(col);
    if (syncing_flag) for (SpotGUI x : syncing) x.setColor(col);
  }

  void updateColorRGB(color col) {

    cp5.get(Slider.class, pannel_name + "R").setValue(red(col)).setColorForeground(color(red(col), 0, 0)).setColorActive(color(red(col), 0, 0));
    cp5.get(Slider.class, pannel_name + "G").setValue(green(col)).setColorForeground(color(0, green(col), 0)).setColorActive(color(0, green(col), 0));
    cp5.get(Slider.class, pannel_name + "B").setValue(blue(col)).setColorForeground(color(0, 0, blue(col))).setColorActive(color(0, 0, blue(col)));
    spot_virtual.setColor(col);

  }

  void updateColorPicker(color col) {
    cp5.get(ColorWheel.class, pannel_name + "picker").setRGB(col);
  }

  void handlePicker(CallbackEvent event) {
    color col = color(cp5.get(ColorWheel.class, pannel_name + "picker").getRGB());
    setColor(col);
  }

  void handleColorButtonClick(CallbackEvent event)
  {
    color col = colors[int(event.getController().getValue())][0];
    updateColorPicker(col);
    setColor(col);
  }

/*
  -----------------Bright----------------
*/

void setBright(int val)
{
    cp5.get(Knob.class, pannel_name + "bright").setValue(val);
}

void updateBrightSpot(int val) {
  
  int out =  int(cp5.get(Slider.class, pannel_name + "br_maxBr").getValue());
  if (val <= out) out = val;
  
 
  if (int(cp5.get(Toggle.class, pannel_name + "switch_b").getValue()) == 0) out = 0;

  
  if (spot_virtual != null) spot_virtual.setBright(out);
}

void updateBrightMaxBr(int val) {
  cp5.get(Slider.class, pannel_name + "br_maxBr").setValue(float(val));
}

void handleBright(CallbackEvent event) {
    
    int val = int(event.getController().getValue());
    if (syncing_flag) for (SpotGUI x : syncing) x.setBright(val);
    updateBrightSpot(val);
}

boolean flag_brOFF = false;
long tmr_brOFF = millis();
void brightOFF() {  
  if (flag_brOFF) 
    if (millis() - tmr_brOFF >= cp5.get(Slider.class, pannel_name + "br_speed").getValue()) {
      int val = min(int(cp5.get(Knob.class, pannel_name + "bright").getValue()) - 1, int(cp5.get(Slider.class, pannel_name + "br_maxBr").getValue()));
      cp5.get(Knob.class, pannel_name + "bright").setValue(val);
      if (val <= 0) flag_brOFF = false;
      tmr_brOFF = millis();
    }
}

boolean flag_brON = false;
long tmr_brON = millis();
void brightON() {  
  if (flag_brON)
    if (millis() - tmr_brON >= cp5.get(Slider.class, pannel_name + "br_speed").getValue()) {
      int val  = int(cp5.get(Knob.class, pannel_name + "bright").getValue()) + 1;
      cp5.get(Knob.class, pannel_name + "bright").setValue(val);
      if (val >= int(cp5.get(Slider.class, pannel_name + "br_maxBr").getValue())) flag_brON = false;
      tmr_brON = millis();
    }
}

void handle_switch_b(CallbackEvent event) {
  int set_val = 0;
  int val = int(event.getController().getValue());

  if (val == 1) {
    set_val = int(cp5.get(Knob.class, pannel_name + "bright").getValue());
    cp5.get(Toggle.class, pannel_name + "switch_b").setColorActive(color(#00ff00));
  } else {
    cp5.get(Toggle.class, pannel_name + "switch_b").setColorActive(color(#ff0000));
  }
  
  updateBrightSpot(set_val);
}

void handle_on_off_buttons(CallbackEvent event)
{
    if (int(event.getController().getValue()) == 0)
    { 
        if (!flag_brON) flag_brOFF = true; 
        return;
    }
     if (!flag_brOFF) flag_brON = true; 
}

/*
  -----------------Effects----------------
*/
void ef_tick() {
  ef_splash();
  ef_shift();
  ef_wheel();
}

boolean flag_sp = false;
long tmr_sp;
int sp_br = 0;
void ef_splash() {
  if (flag_sp && millis() - tmr_sp >= cp5.get(Slider.class, pannel_name + "sp_speed").getValue()) {
    sp_br = sp_br == 0 ? 0xff : 0;
    cp5.get(Knob.class, pannel_name + "bright").setValue(sp_br);
    tmr_sp = millis();
  }
}

void handle_ef_splash_toggle(CallbackEvent event) {
   int val = int(event.getController().getValue());
  if (val == 1) {
    cp5.get(Toggle.class, pannel_name + "splash").setColorActive(color(#00ff00));
    flag_sp = true;
  } else {
    flag_sp = false;
    cp5.get(Toggle.class, pannel_name + "splash").setColorActive(color(#ff0000));
  }
}

boolean flag_sh = false;
long tmr_sh;
color col_sh;
void ef_shift() {
  if (flag_sh && millis() - tmr_sh >= cp5.get(Slider.class, pannel_name + "sh_speed").getValue()) {
    colorMode(HSB, 255, 255, 255);
    int H = int(hue(col_sh) + 129);
    H %= 255;
    col_sh = color(H, 255, 255);
    colorMode(RGB);
    
    setColor(col_sh);
    tmr_sh = millis();
  }
}

void handle_ef_shift_toggle(CallbackEvent event) {
    int val = int(event.getController().getValue());
  if (val == 1) {
    cp5.get(Toggle.class, pannel_name + "shift").setColorActive(color(#00ff00));
    flag_sh = true;
  } else {
    flag_sh = false;
    cp5.get(Toggle.class, pannel_name + "shift").setColorActive(color(#ff0000));
  }
}


boolean flag_wl = false;
long tmr_wl;
int H_wl;
void ef_wheel() {
  if (flag_wl && millis() - tmr_wl >= cp5.get(Slider.class, pannel_name + "wl_speed").getValue()) {
    colorMode(HSB, 255, 255, 255);
    H_wl++;
    H_wl %= 255;
    color col = color(H_wl, 255, 255);
    colorMode(RGB);
    
    setColor(col);
    tmr_wl = millis();
  }
}

void handle_ef_wheel_toggle(CallbackEvent event) {
    int val = int(event.getController().getValue());
  if (val == 1) {
    cp5.get(Toggle.class, pannel_name + "wheel").setColorActive(color(#00ff00));
    flag_wl = true;
  } else {
    flag_wl = false;
    cp5.get(Toggle.class, pannel_name + "wheel").setColorActive(color(#ff0000));
  }
}

void handle_ef_fade_toggle(CallbackEvent event)
{
     int val = int(event.getController().getValue());
  if (val == 1) cp5.get(Toggle.class, pannel_name + "fade").setColorActive(color(#00ff00));
  else cp5.get(Toggle.class, pannel_name + "fade").setColorActive(color(#ff0000));
  
  spot_virtual.setFadeMode(boolean(val));
  if (syncing_flag) for (SpotGUI x : syncing) x.spot_virtual.setFadeMode(boolean(val));
}

void handle_ef_fire_toggle(CallbackEvent event)
{
   int val = int(event.getController().getValue());
   if (val == 1) { cp5.get(Toggle.class, pannel_name + "fire").setColorActive(color(#00ff00)); flag_fr = true; }
   else { cp5.get(Toggle.class, pannel_name + "fire").setColorActive(color(#ff0000)); flag_fr = false; }
  
}

  int prevTime, prevTime2;
  byte fireRnd = 0;
  float fireValue = 0;
  
  boolean flag_fr = false;
  
  // настройки пламени
int HUE_START = 0;    // начальный цвет огня (0 красный, 80 зелёный, 140 молния, 190 розовый)
int HUE_GAP = 10;     // коэффициент цвета огня (чем больше - тем дальше заброс по цвету)
float SMOOTH_K = 0.10;  // коэффициент плавности огня
int MIN_BRIGHT = 150;  // мин. яркость огня
int MAX_BRIGHT = 255; // макс. яркость огня
int MIN_SAT = 255;    // мин. насыщенность
int MAX_SAT = 255;    // макс. насыщенность


void fire_tick() {

  if (flag_fr) {
  // задаём направление движения огня
  if (millis() - prevTime > 100) {
    prevTime = millis();
    fireRnd = byte(random(2, 10));
  }
  // двигаем пламя
  if (millis() - prevTime2 > 20) {
    prevTime2 = millis();
    fireValue = (float)fireValue * (1 - SMOOTH_K) + (float)fireRnd * 10 * SMOOTH_K;
    
    colorMode(HSB);
    color col = color(
      constrain(map(fireValue, 20, 60, HUE_START, HUE_START + HUE_GAP), 0, 255),  // H
      constrain(map(fireValue, 20, 60, MAX_SAT, MIN_SAT), 0, 255),                // S
      constrain(map(fireValue, 20, 60, MIN_BRIGHT, MAX_BRIGHT), 0, 255)           // V
    );
    colorMode(RGB);
    
    setColor(col);
  }
    
  }
}

/*
  -----------------Tick----------------
*/
void tick()
{
    brightOFF(); 
    brightON();
    ef_tick();
    fire_tick();
}


/*
  -----------------GUI----------------
*/

void setFan(int fan)
 {
   cp5.get(Slider.class, pannel_name + "fan").setValue(float(fan));
 }
 
 void setTemp(int temp)
 {
   colorMode(HSB);
   cp5.get(Slider.class, pannel_name + "temp").setValue(float(temp))
        .setColorForeground(color(100 - map(cp5.get(Slider.class, pannel_name + "temp").getValue(), 20, 50, 0, 100), 255, 255))
        .setColorActive(color(100 - map(cp5.get(Slider.class, pannel_name + "temp").getValue(), 20, 50, 0, 100), 255, 255));
   colorMode(RGB);
 }
  void guiSetup() {

    cp5
      .addToggle(pannel_name + "switch_b")
      .setCaptionLabel("switch")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 50 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_switch_b(event);
      }
    }
    )
    ;

    addColors();


    cp5
      .addKnob(pannel_name + "bright")
      .setCaptionLabel("brightness")
      .setRange(0, 255)
      .setRadius(70)
      .setPosition(10 + shift_x, 150 + shift_y)
      .setValue(255)
      .setColorForeground(color(#ffff00))
      .setColorActive(color(#ffff00))
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handleBright(event);
      }
    }
    )
    ;

    cp5
      .addButton(pannel_name + "br_off")
      .setCaptionLabel("off")
      .setPosition(10 + shift_x, 320 + shift_y)
      .setSize(50, 30)
      .setValue(0)
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_on_off_buttons(event);
      }
    }
    )
      ;

    cp5
      .addButton(pannel_name + "br_on")
      .setCaptionLabel("on")
      .setPosition(100 + shift_x, 320 + shift_y)
      .setSize(50, 30)
      .setValue(1)
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_on_off_buttons(event);
      }
    }
    )
      ;

    cp5
      .addSlider(pannel_name + "br_speed")
      .setCaptionLabel("speed")
      .setPosition(10 + shift_x, 370 + shift_y)
      .setSize(140, 30)
      .setRange(0, 200)
      .setValue(20);
    ;

    cp5
      .addSlider(pannel_name + "br_maxBr")
      .setCaptionLabel("Max Brightness")
      .setPosition(10 + shift_x, 420 + shift_y)
      .setSize(140, 30)
      .setRange(0, 255)
      .setValue(255);
    ;

    cp5
      .addColorWheel(pannel_name + "picker", 480 + int(shift_x), 10 + int(shift_y), 400)
      .setCaptionLabel("")
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handlePicker(event);
      }
    }
    )
    ;

    cp5
      .addSlider(pannel_name + "temp")
      .setCaptionLabel("temperature")
      .setPosition(250 + shift_x, 10 + shift_y)
      .setSize(40, 350)
      .setRange(20, 50)
      .lock()
      ;

    cp5
      .addSlider(pannel_name + "fan")
      .setCaptionLabel("fan")
      .setPosition(400 + shift_x, 10 + shift_y)
      .setSize(40, 350)
      .setRange(0, 255)
      .lock()
      ;

    cp5
      .addToggle(pannel_name + "splash")
      .setCaptionLabel("splash")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 470 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_splash_toggle(event);
      }
    }
    )
    ;

    cp5
      .addSlider(pannel_name + "sp_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 470 + shift_y)
      .setSize(300, 30)
      .setRange(0, 500)
      .setValue(200);
    ;

    cp5
      .addToggle(pannel_name + "shift")
      .setCaptionLabel("shift")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 520 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_shift_toggle(event);
      }
    }
    )
    ;

    cp5
      .addSlider(pannel_name + "sh_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 520 + shift_y)
      .setSize(300, 30)
      .setRange(0, 500)
      .setValue(200);
    ;


    cp5
      .addToggle(pannel_name + "wheel")
      .setCaptionLabel("wheel")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 570 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_wheel_toggle(event);
      }
    }
    )
    ;

    cp5
      .addSlider(pannel_name + "wl_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 570 + shift_y)
      .setSize(300, 30)
      .setRange(0, 500)
      .setValue(200);
    ;
    
    cp5
      .addToggle(pannel_name + "fade")
      .setCaptionLabel("fade")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 620 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_fade_toggle(event);
      }
    }
    )
    ;

    cp5
      .addSlider(pannel_name + "fd_time")
      .setCaptionLabel("fade T")
      .setPosition(100 + shift_x, 620 + shift_y)
      .setSize(300, 30)
      .setRange(0, 20000)
      .setValue(500)
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        int T = int(event.getController().getValue());
        spot_virtual.setFadePeriod(T);
        if (syncing_flag) for (SpotGUI x : syncing) x.spot_virtual.setFadePeriod(T);
      }
      }
      )
  ;
  
  cp5
      .addToggle(pannel_name + "fire")
      .setCaptionLabel("fire")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 670 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_fire_toggle(event);
      }
    }
    )
    ;
 }

  color colors[][] =
    {
    { color(#ff0000), color(#B40000) },
    { color(#FF6481), color(#B4475B) },
    { color(#ff1493), color(#B40F6A) },
    { color(#ffff00), color(#B4B200) },
    { color(#FFA500), color(#B47300) },
    { color(#FFFFFF), color(#B4B4B4) },
    { color(#00ff00), color(#00B400) },
    { color(#B6FF00), color(#81B400) },
    { color(#17FF8D), color(#0FB463) },
    { color(#0000ff), color(#0000B4) },
    { color(#00ffff), color(#00B4B3) },
    { color(#A020F0), color(#7819B4) },
    }
    ;

  void addColors() {


    String names[] =
      {
      "b_red", "b_pink", "b_deep_pink", "b_yellow", "b_orange", "b_white",
      "b_green", "b_light_green", "b_blue_green", "b_blue", "b_cyan", "b_purpure"
      }
      ;



    int x = 0;
    int y = 0;
    for (int i = 0; i < names.length; i++)
    {
      cp5
        .addButton(pannel_name + names[i])
        .setCaptionLabel("")
        .setPosition(480 + x + shift_x, 550 + y + shift_y)
        .setSize(30, 30)
        .setColorBackground(colors[i][0])
        .setColorForeground(colors[i][1])
        .setColorActive(colors[i][1])
        .setValue(i)
        .onClick(new CallbackListener() {
        public void controlEvent(CallbackEvent event) {
          handleColorButtonClick(event);
        }
      }
      )
      ;

      y += 40;

      if (y > 100) {
        y = 0;
        x += 40;
      }
    }



    cp5
      .addSlider(pannel_name + "R")
      .setCaptionLabel("R")
      .setPosition(670 + shift_x, 550 + shift_y)
      .setSize(200, 30)
      .setRange(0, 255)
      .lock()
      ;

    cp5
      .addSlider(pannel_name + "G")
      .setCaptionLabel("G")
      .setPosition(670 + shift_x, 600 + shift_y)
      .setSize(200, 30)
      .setRange(0, 255)
      .lock()
      ;

    cp5
      .addSlider(pannel_name + "B")
      .setCaptionLabel("B")
      .setPosition(670 + shift_x, 650 + shift_y)
      .setSize(200, 30)
      .setRange(0, 255)
      .lock()
      ;
  }
}
