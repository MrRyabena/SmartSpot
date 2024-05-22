

void ef_tick() {
  ef_splash();
  ef_shift();
  ef_wheel();
}


boolean flag_sp = false;
long tmr_sp;
int sp_br = 0;
void ef_splash() {
  if (flag_sp && millis() - tmr_sp >= cp5.get(Slider.class, "sp_speed").getValue()) {
    sp_br = sp_br == 0 ? 0xff : 0;
    cp5.get(Knob.class, "bright").setValue(sp_br);
    tmr_sp = millis();
  }
}

void splash(int val) {
  if (val == 0) {
    cp5.get(Toggle.class, "splash").setColorActive(color(#00ff00));
    flag_sp = true;
  } else {
    flag_sp = false;
    cp5.get(Toggle.class, "splash").setColorActive(color(#ff0000));
  }
}

boolean flag_sh = false;
long tmr_sh;
color col_sh;
void ef_shift() {
  if (flag_sh && millis() - tmr_sh >= cp5.get(Slider.class, "sh_speed").getValue()) {
    colorMode(HSB, 255, 255, 255);
    int H = int(hue(col_sh) + 129);
    H %= 255;
    col_sh = color(H, 255, 255);
    colorMode(RGB);
    
    updateColorPicker(col_sh);
    tmr_sh = millis();
  }
}

void shift(int val) {
  if (val == 0) {
    cp5.get(Toggle.class, "shift").setColorActive(color(#00ff00));
    flag_sh = true;
  } else {
    flag_sh = false;
    cp5.get(Toggle.class, "shift").setColorActive(color(#ff0000));
  }
}

boolean flag_wl = false;
long tmr_wl;
int H_wl;
void ef_wheel() {
  if (flag_wl && millis() - tmr_wl >= cp5.get(Slider.class, "wl_speed").getValue()) {
    colorMode(HSB, 255, 255, 255);
    H_wl++;
    H_wl %= 255;
    color col = color(H_wl, 255, 255);
    colorMode(RGB);
    
    updateColorPicker(col);
    tmr_wl = millis();
  }
}

void wheel(int val) {
  if (val == 0) {
    cp5.get(Toggle.class, "wheel").setColorActive(color(#00ff00));
    flag_wl = true;
  } else {
    flag_wl = false;
    cp5.get(Toggle.class, "wheel").setColorActive(color(#ff0000));
  }
}
