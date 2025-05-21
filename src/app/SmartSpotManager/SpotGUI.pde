import controlP5.*;

import processing.core.PApplet;


public class SpotGUI {
  SpotVirtual[] virtual_spots;
  String panel_name;
  float shift_x;
  float shift_y;
  ControlP5 cp5;
  SpotGUI[] syncing;
  boolean syncing_flag;
  PApplet parent;
  //VolAnalyzerGUI va_gui;

  public SpotGUI(PApplet parent, float x, float y, String panel_name) {

    this.parent = parent;
    this.shift_x = x;
    this.shift_y = y;
    this.panel_name = panel_name;
    this.cp5 = new ControlP5(parent);

    cp5
      .setColorBackground(guiColors[1])
      .setColorActive(guiColors[2])
      .setColorForeground(guiColors[4])
      .setFont(createFont("Calibri", 18));

    this.syncing_flag = false;

    //va_gui = new VolAnalyzerGUI(parent, cp5, panel_name, 480 + shift_x, 600 + shift_y, spot);
  }
  
  

  public void updateSpot()
  {
    int val;

    // set bright
    val = int(cp5.get(Knob.class, panel_name + "bright").getValue());
    updateBrightSpot(val);

    // set colot
    color col = color(cp5.get(ColorWheel.class, panel_name + "picker").getRGB());
    setColor(col);

    // set fade
    val = int(cp5.get(Toggle.class, panel_name + "fade").getValue());
    for (SpotVirtual spot : virtual_spots) spot.setFadeMode(int(val));

    val = int(cp5.get(Slider.class, panel_name + "fd_time").getValue());
    for (SpotVirtual spot : virtual_spots) spot.setFadePeriod(val);

    // set fan
    val = int(cp5.get(Toggle.class, panel_name + "fan_b").getValue());
    for (SpotVirtual spot : virtual_spots) spot.setCooling((byte)(val != 0 ? 255 : 0));

    // set music
    //for (SpotVirtual spot : virtual_spots) spot.setMusicEffect(byte(cp5.getController(panel_name + "RGBmusic").getValue()));
    //va_gui.update();
  }

  public void setSyncing(boolean flag) {
    syncing_flag = flag;
    int i = 0;

    //if (flag) {
    //  va_gui.spots = new SpotVirtual[syncing.length + 1];
    //  va_gui.spots[0] = spot_virtual;
    //}
    //for (SpotGUI x : syncing) {
      //x.setEnabled(!flag);
      //if (flag) va_gui.spots[i + 1] = x.spot_virtual;
     // i++;
   // }
    //if (!flag) {
    //  va_gui.spots = new SpotVirtual[1];
    //  va_gui.spots[0] = this.spot_virtual;
    //}
  //}
}

  void hide() {
    for (ControllerInterface c : cp5.getAll()) {
      if (c.getName().startsWith(panel_name))
        c.hide();
    }
  }

  public void setEnabled(boolean flag) {
    for (ControllerInterface c : cp5.getList()) {
      if (c.getName().startsWith(panel_name))
        cp5.getController(c.getName()).setLock(flag); // .setOpen(flag);
      // cp5
      // .setColorBackground(flag ? color(255, 0, 0, 50) : guiColors[1]);
      // .setColorActive(guiColors[2] - ( flag ? 20 : 0))
      // .setColorForeground(guiColors[4] - ( flag ? 20 : 0));
    }
    // }
  }

  /*
   * -----------------Color----------------
      */
  void setColor(color col) {
    updateColorRGB(col);
    updateColorPicker(col);
    if (syncing_flag) for (SpotGUI x : syncing) x.setColor(col);
  }

  void updateColorRGB(color col) {

    cp5.get(Slider.class, panel_name + "R").setValue(red(col)).setColorForeground(color(red(col), 0, 0))
      .setColorActive(color(red(col), 0, 0));
    cp5.get(Slider.class, panel_name + "G").setValue(green(col)).setColorForeground(color(0, green(col), 0))
      .setColorActive(color(0, green(col), 0));
    cp5.get(Slider.class, panel_name + "B").setValue(blue(col)).setColorForeground(color(0, 0, blue(col)))
      .setColorActive(color(0, 0, blue(col)));
    for (SpotVirtual spot : virtual_spots) spot.setColor(int(red(col)), int(green(col)), int(blue(col)));
  }

  void updateColorPicker(color col) {
    cp5.get(ColorWheel.class, panel_name + "picker").setRGB(col);
  }

  void handlePicker(CallbackEvent event) {
    color col = color(cp5.get(ColorWheel.class, panel_name + "picker").getRGB());
    setColor(col);
  }

  void handleColorButtonClick(CallbackEvent event)
  {
    color col = colors[int(event.getController().getValue())][0];
    updateColorPicker(col);
    setColor(col);
  }

  void setMusicEffect(byte effect) {
    //for (SpotVirtual spot : virtual_spots)
    //  spot.setMusicEffect(effect);
    //if (syncing_flag)
    //  for (SpotGUI x : syncing)
    //    x.setMusicEffect(effect);
  }

  /*
   * -----------------Bright----------------
      */

  int getBright()
  {
    return int(cp5.get(Knob.class, panel_name + "bright").getValue());
  }

  void setBright(int val) {
    cp5.get(Knob.class, panel_name + "bright").setValue(val);
  }

  void updateBrightSpot(int val) {
    int out = int(cp5.get(Slider.class, panel_name + "br_maxBr").getValue());
    if (val <= out) out = val;


    if (int(cp5.get(Toggle.class, panel_name + "switch_b").getValue()) == 0) out = 0;


    for (SpotVirtual spot : virtual_spots) spot.setBright(out);
  }

  void updateBrightMaxBr(int val) {
    cp5.get(Slider.class, panel_name + "br_maxBr").setValue(float(val));
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
      if (millis() - tmr_brOFF >= cp5.get(Slider.class, panel_name + "br_speed").getValue()) {
        int val = min(int(cp5.get(Knob.class, panel_name + "bright").getValue()) - 1, int(cp5.get(Slider.class, panel_name + "br_maxBr").getValue()));
        cp5.get(Knob.class, panel_name + "bright").setValue(val);
        if (val <= 0) flag_brOFF = false;
        tmr_brOFF = millis();
      }
  }

  boolean flag_brON = false;
  long tmr_brON = millis();

  void brightON() {
    if (flag_brON)
      if (millis() - tmr_brON >= cp5.get(Slider.class, panel_name + "br_speed").getValue()) {
        int val  = int(cp5.get(Knob.class, panel_name + "bright").getValue()) + 1;
        cp5.get(Knob.class, panel_name + "bright").setValue(val);
        if (val >= int(cp5.get(Slider.class, panel_name + "br_maxBr").getValue())) flag_brON = false;
        tmr_brON = millis();
      }
  }

  void handle_switch_b(CallbackEvent event) {
    int set_val = 0;
    int val = int(event.getController().getValue());

    if (val == 1) {
      set_val = int(cp5.get(Knob.class, panel_name + "bright").getValue());
      cp5.get(Toggle.class, panel_name + "switch_b").setColorActive(color(#00ff00));
    } else {
      cp5.get(Toggle.class, panel_name + "switch_b").setColorActive(color(#ff0000));
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

    void setFadeMode(int mode) 
    {
      for (SpotVirtual spot : virtual_spots) spot.setFadeMode(mode);
      if (syncing_flag) for (SpotGUI x : syncing) for (SpotVirtual spot : x.virtual_spots) spot.setFadeMode(mode);
    }

    void setFadePeriod(int period)
    {
      for (SpotVirtual spot : virtual_spots) spot.setFadePeriod(period);
      if (syncing_flag) for (SpotGUI x : syncing) for (SpotVirtual spot : x.virtual_spots) spot.setFadePeriod(period);
    }

  /*
   * -----------------Effects----------------
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
    if (flag_sp && millis() - tmr_sp >= cp5.get(Slider.class, panel_name + "sp_speed").getValue()) {
      sp_br = sp_br == 0 ? 0xff : 0;
      cp5.get(Knob.class, panel_name + "bright").setValue(sp_br);
      tmr_sp = millis();
    }
  }

  void handle_ef_splash_toggle(CallbackEvent event) {
    int val = int(event.getController().getValue());
    if (val == 1) {
      cp5.get(Toggle.class, panel_name + "splash").setColorActive(color(#00ff00));
      flag_sp = true;
    } else {
      flag_sp = false;
      cp5.get(Toggle.class, panel_name + "splash").setColorActive(color(#ff0000));
    }
  }

  boolean flag_sh = false;
  long tmr_sh;
  color col_sh;

  void ef_shift() {
    if (flag_sh && millis() - tmr_sh >= cp5.get(Slider.class, panel_name + "sh_speed").getValue()) {
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
      cp5.get(Toggle.class, panel_name + "shift").setColorActive(color(#00ff00));
      flag_sh = true;
    } else {
      flag_sh = false;
      cp5.get(Toggle.class, panel_name + "shift").setColorActive(color(#ff0000));
    }
  }

  boolean flag_wl = false;
  long tmr_wl;
  int H_wl;

  void ef_wheel() {
    if (flag_wl && millis() - tmr_wl >= cp5.get(Slider.class, panel_name + "wl_speed").getValue()) {
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
      cp5.get(Toggle.class, panel_name + "wheel").setColorActive(color(#00ff00));
      flag_wl = true;
    } else {
      flag_wl = false;
      cp5.get(Toggle.class, panel_name + "wheel").setColorActive(color(#ff0000));
    }
  }

  void handle_ef_fade_toggle(CallbackEvent event)
  {
    int val = int(event.getController().getValue());
    if (val == 1) cp5.get(Toggle.class, panel_name + "fade").setColorActive(color(#00ff00));
    else cp5.get(Toggle.class, panel_name + "fade").setColorActive(color(#ff0000));

    setFadeMode(int(val));
  }

  void handle_ef_fire_toggle(CallbackEvent event)
  {
    int val = int(event.getController().getValue());
    if (val == 1) {
      cp5.get(Toggle.class, panel_name + "fire").setColorActive(color(#00ff00));
      flag_fr = true;
    } else {
      cp5.get(Toggle.class, panel_name + "fire").setColorActive(color(#ff0000));
      flag_fr = false;
    }
  }

  int prevTime, prevTime2;
  byte fireRnd = 0;
  float fireValue = 0;

  boolean flag_fr = false;

  // настройки пламени
  int HUE_START = 0; // начальный цвет огня (0 красный, 80 зелёный, 140 молния, 190 розовый)
  int HUE_GAP = 10; // коэффициент цвета огня (чем больше - тем дальше заброс по цвету)
  float SMOOTH_K = 0.10; // коэффициент плавности огня
  int MIN_BRIGHT = 150; // мин. яркость огня
  int MAX_BRIGHT = 255; // макс. яркость огня
  int MIN_SAT = 255; // мин. насыщенность
  int MAX_SAT = 255; // макс. насыщенность

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
          constrain(map(fireValue, 20, 60, HUE_START, HUE_START + HUE_GAP), 0, 255), // H
          constrain(map(fireValue, 20, 60, MAX_SAT, MIN_SAT), 0, 255), // S
          constrain(map(fireValue, 20, 60, MIN_BRIGHT, MAX_BRIGHT), 0, 255)           // V
          );
        colorMode(RGB);

        setColor(col);
      }
    }
  }

  boolean flag_ny = false;
  long tmr_ny;
  int H_ny;
  int T_ny = 0;
  boolean state_ny = flag_ny;
  color col_ny;

  void NewYear_tick()
  {
    if (state_ny != flag_ny)
    {
      if (!state_ny && flag_ny)
      {
        colorMode(HSB, 255, 255, 255);
        int H = int(random(0, 255));
        col_ny = color(H, 255, 255);
        colorMode(RGB);

        cp5.get(Toggle.class, panel_name + "fade").setValue(true);
        cp5.get(Slider.class, panel_name + "fd_time").setValue(1500);
      }
      state_ny = flag_ny;
    }
    if (flag_ny && millis() - tmr_ny >= T_ny)
    {
      T_ny = int(random(20000, 40000));

      colorMode(HSB, 255, 255, 255);
      int H = int(hue(col_ny) + 151);
      H %= 255;
      col_ny = color(H, 255, 255);
      colorMode(RGB);

      setColor(col_ny);

      tmr_ny = millis();
    }
  }

  boolean flag_rc = false;
  long tmr_rc;
  void RandomColor_tick()
  {
    if (flag_rc && millis() - tmr_rc >= cp5.get(Slider.class, panel_name + "rc_speed").getValue()) {
      
      colorMode(HSB, 255, 255, 255);

      for (SpotVirtual spot : virtual_spots) 
      {
        int H = int(random(0, 255));
        color col = color(H, 255, 255);
        spot.setColor(int(red(col)), int(green(col)), int(blue(col)));
      }

      colorMode(RGB);
      
      tmr_rc = millis();
    }
  }


  void handle_fan_toggle(CallbackEvent event)
  {
    int val = int(event.getController().getValue());
    if (val == 1) {
      cp5.get(Toggle.class, panel_name + "fan_b").setColorActive(color(#00ff00));
      for (SpotVirtual spot : virtual_spots) spot.setCooling(byte(255));
    } else {
      cp5.get(Toggle.class, panel_name + "fan_b").setColorActive(color(#ff0000));
      for (SpotVirtual spot : virtual_spots) spot.setCooling(byte(0));
    }
  }

  /*
   * -----------------Tick----------------
      */
  void tick() {
    NewYear_tick();
    brightOFF();
    brightON();
    ef_tick();
    fire_tick();
    info_tick();
    RandomColor_tick();
  }

  /*
   * -----------------GUI----------------
      */

  long info_tmr;
  void info_tick()
  {
    if (millis() - info_tmr >= 10000)
    {
      info_tmr = millis();
      for (SpotVirtual x : virtual_spots) x.requestInfo();
    }

  }

  void setFan(int fan, int ind)
  {
    cp5.get(Slider.class, panel_name + "fan" + str(ind)).setValue(float(fan));
    //println();
    //println("fan",  str(ind), fan);
  }

  void setTemp(int temp, int ind)
  {
      //  println(panel_name + "temp" + str(ind), temp);
    colorMode(HSB);
    cp5.get(Slider.class, panel_name + "temp" + str(ind)).setValue(float(temp))
      .setColorForeground(color(100 - map(cp5.get(Slider.class,panel_name + "temp" + str(ind)).getValue(), 20, 50, 0, 100), 255, 255))
      .setColorActive(color(100 - map(cp5.get(Slider.class, panel_name + "temp" + str(ind)).getValue(), 20, 50, 0, 100), 255, 255));
    colorMode(RGB);


  }

  void guiSetup() {

    cp5
      .addToggle(panel_name + "switch_b")
      .setCaptionLabel("switch")
      .setValue(true)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 50 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#00ff00))
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_switch_b(event);
      }
    }
    )
    ;

    addColors();


    cp5
      .addKnob(panel_name + "bright")
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
      .addButton(panel_name + "br_off")
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
      .addButton(panel_name + "br_on")
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
      .addSlider(panel_name + "br_speed")
      .setCaptionLabel("speed")
      .setPosition(10 + shift_x, 370 + shift_y)
      .setSize(140, 30)
      .setRange(0, 200)
      .setValue(20);
    ;

    cp5
      .addSlider(panel_name + "br_maxBr")
      .setCaptionLabel("Max Brightness")
      .setPosition(10 + shift_x, 420 + shift_y)
      .setSize(140, 30)
      .setRange(0, 255)
      .setValue(255);
    ;

    cp5
      .addColorWheel(panel_name + "picker", 480 + int(shift_x), 10 + int(shift_y), 400)
      .setCaptionLabel("")
      .setValue(0)
      .setRGB(color(0, 0, 0))      
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handlePicker(event);
      }
    }
    )
    ;

    cp5
      .addSlider(panel_name + "temp1")
      .setCaptionLabel("t1")
      .setPosition(200 + shift_x, 10 + shift_y)
      .setSize(20, 350)
      .setRange(20, 50)
      .lock()
      ;
    
        cp5
      .addSlider(panel_name + "temp2")
      .setCaptionLabel("t2")
      .setPosition(270 + shift_x, 10 + shift_y)
      .setSize(20, 350)
      .setRange(20, 50)
      .lock()
      ;

    cp5
      .addSlider(panel_name + "fan1")
      .setCaptionLabel("f1")
      .setPosition(340 + shift_x, 10 + shift_y)
      .setSize(20, 350)
      .setRange(0, 255)
      .lock()
      ;

          cp5
      .addSlider(panel_name + "fan2")
      .setCaptionLabel("f2")
      .setPosition(400 + shift_x, 10 + shift_y)
      .setSize(20, 350)
      .setRange(0, 255)
      .lock()
      ;

      cp5
        .addButton(panel_name + "SP_1")
        .setCaptionLabel("")
        .setPosition(230 + shift_x,380 + shift_y)
        .setSize(30, 30)
        .setColorBackground(#000000)
        .setColorForeground(#000000)
        .setColorActive(#000000)
        .lock()
      ;

       cp5
        .addButton(panel_name + "SP_2")
        .setCaptionLabel("")
        .setPosition(300 + shift_x, 380 + shift_y)
        .setSize(30, 30)
        .setColorBackground(#000000)
        .setColorForeground(#000000)
        .setColorActive(#000000)
        .lock()
      ;

    cp5
      .addToggle(panel_name + "splash")
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
      .addSlider(panel_name + "sp_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 470 + shift_y)
      .setSize(300, 30)
      .setRange(0, 500)
      .setValue(200);
    ;

    cp5
      .addToggle(panel_name + "shift")
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
      .addSlider(panel_name + "sh_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 520 + shift_y)
      .setSize(300, 30)
      .setRange(0, 500)
      .setValue(200);
    ;


    cp5
      .addToggle(panel_name + "wheel")
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
      .addSlider(panel_name + "wl_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 570 + shift_y)
      .setSize(300, 30)
      .setRange(0, 500)
      .setValue(200);
    ;

    cp5
      .addToggle(panel_name + "fade")
      .setCaptionLabel("fade")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 620 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_fade_toggle(event);
      }
    }
    )
    ;

    cp5
      .addSlider(panel_name + "fd_time")
      .setCaptionLabel("fade T")
      .setPosition(100 + shift_x, 620 + shift_y)
      .setSize(300, 30)
      .setRange(0, 20000)
      .setValue(500)
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        int T = int(event.getController().getValue());
        for (SpotVirtual spot : virtual_spots) spot.setFadePeriod(T);
        if (syncing_flag) for (SpotGUI x : syncing) for (SpotVirtual spot : x.virtual_spots) spot.setFadePeriod(T);
      }
    }
    )
    ;
    cp5
      .addSlider(panel_name + "fd_time_2")
      .setCaptionLabel("fade T")
      .setPosition(100 + shift_x, 670 + shift_y)
      .setSize(300, 30)
      .setRange(0, 1000)
      .setValue(500)
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        cp5.get(Slider.class, panel_name + "fd_time").setValue(event.getController().getValue());
      }
    }
    )
    ;

    cp5
      .addToggle(panel_name + "fire")
      .setCaptionLabel("fire")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 720 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_ef_fire_toggle(event);
      }
    }
    )
    ;

    cp5
      .addToggle(panel_name + "NewYear")
      .setCaptionLabel("New Year")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(100 + shift_x, 720 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        int val = int(event.getController().getValue());
        if (val == 1) {
          cp5.get(Toggle.class, panel_name + "NewYear").setColorActive(color(#00ff00));
          flag_ny = true;
        } else {
          cp5.get(Toggle.class, panel_name + "NewYear").setColorActive(color(#ff0000));
          flag_ny = false;
        }
      }
    }
    )
    ;

    cp5
      .addToggle(panel_name + "RandomColor")
      .setCaptionLabel("Random Color")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(10 + shift_x, 770 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        flag_rc = !flag_rc;
        if (flag_rc) {
          setFadeMode(1);
          setFadePeriod(int(cp5.get(Slider.class, panel_name + "rc_speed").getValue() / 4));
          cp5.get(Toggle.class, panel_name + "RandomColor").setColorActive(color(#00ff00)); 
        } else {
          updateSpot();
          cp5.get(Toggle.class, panel_name + "RandomColor").setColorActive(color(#ff0000));
        }
      }
    }
    )
    ;

    cp5
      .addSlider(panel_name + "rc_speed_2")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 770 + shift_y)
      .setSize(300, 30)
      .setRange(0, 1000)
      .setValue(200)
      .onChange(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        int val = int(event.getController().getValue());
        cp5.get(Slider.class, panel_name + "rc_speed").setValue(val);
      }
    }
    );


    cp5
      .addSlider(panel_name + "rc_speed")
      .setCaptionLabel("speed")
      .setPosition(100 + shift_x, 820 + shift_y)
      .setSize(300, 30)
      .setRange(0, 10000)
      .setValue(200)
    ;
    


    cp5
      .addToggle(panel_name + "fan_b")
      .setCaptionLabel("fan")
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setPosition(100 + shift_x, 10 + shift_y)
      .setSize(80, 30)
      .setColorActive(color(#ff0000))
      .onClick(new CallbackListener() {
      public void controlEvent(CallbackEvent event) {
        handle_fan_toggle(event);
      }
    }
    )
    ;
  }

  color guiColors[] ={color(40), // background
    color(80), // ColorBackground
    color(170), // ColorActive
    color(100), // ColorCaptionLabel
    color(120), // ColorForeground
    color(100), // ColorLabel
    color(100), // ColorValue
    color(100) // ColorValueLabel
  };


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
    { color(#000000), color(#000000) },
    { color(#FAEBD7), color(#FAEBD7) },
    { color(#DCFFFF), color(#DCFFFF) }
    }
    ;

  void addColors() {


    String names[] =
      {
      "b_red", "b_pink", "b_deep_pink", "b_yellow", "b_orange", "b_white",
      "b_green", "b_light_green", "b_blue_green", "b_blue", "b_cyan", "b_purpure", "b_black", "b_cold", "b_warm"
      }
      ;



    int x = 0;
    int y = 0;
    for (int i = 0; i < names.length; i++)
    {
      cp5
        .addButton(panel_name + names[i])
        .setCaptionLabel("")
        .setPosition(480 + x + shift_x, 430 + y + shift_y)
        .setSize(30, 30)
        .setColorBackground(colors[i][0])
        .setColorForeground(colors[i][1])
        .setColorActive(colors[i][1])
        .setValue(i)
        .onChange(new CallbackListener() {
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
      .addSlider(panel_name + "R")
      .setCaptionLabel("R")
      .setPosition(670 + shift_x, 430 + shift_y)
      .setSize(200, 30)
      .setRange(0, 255)
      .lock()
      ;

    cp5
      .addSlider(panel_name + "G")
      .setCaptionLabel("G")
      .setPosition(670 + shift_x, 470 + shift_y)
      .setSize(200, 30)
      .setRange(0, 255)
      .lock()
      ;

    cp5
      .addSlider(panel_name + "B")
      .setCaptionLabel("B")
      .setPosition(670 + shift_x, 510 )
      .setSize(200, 30)
      .setRange(0, 255)
      .lock()
      ;

    cp5
      .addDropdownList(panel_name + "RGBmusic")
      .setPosition(480 + shift_x, 560 + shift_y)
      .setSize(150, 500)
      .setItemHeight(30)
      .setBarHeight(30)
      .addItem("OFF", 0)
      .addItem("SHIFT_151", 1)
      .addItem("SHIFT_129", 2)
      .addItem("PULSE_WHEEL", 3)
      .addItem("FIRE", 4)
      .setValue(0)
      .setOpen(false)
      .onClick(new CallbackListener() {

      public void controlEvent(CallbackEvent event) {
        //if (spot_virtual != null) for (SpotVirtual spot : virtual_spots) spot.setMusicEffect(byte(event.getController().getValue()));
      }
    }
    );
  }
}
