
void updateBrightMaxBr(int val) {
  cp5.get(Slider.class, "br_maxBr").setValue(float(val));
}

void updateBrightSpot(int val) {
  if (cp5.get(Toggle.class, "switch_b").getValue() != 0) return;

  int max =  int(cp5.get(Slider.class, "br_maxBr").getValue());
  if (val > max) val = max;

  String str = "1," + str(val) + ';';
  println(str);
  if (spot != null) spot.write(str);
}


void bright(int val) {
  updateBrightSpot(val);
}

boolean flag_brOFF = false;
long tmr_brOFF = millis();
void brightOFF() {  
  if (flag_brOFF)
    if (millis() - tmr_brOFF >= cp5.get(Slider.class, "br_speed").getValue()) {
      int val = min(int(cp5.get(Knob.class, "bright").getValue()) - 1, int(cp5.get(Slider.class, "br_maxBr").getValue()));
      cp5.get(Knob.class, "bright").setValue(val);
      if (val <= 0) flag_brOFF = false;
      tmr_brOFF = millis();
    }
}

boolean flag_brON = false;
long tmr_brON = millis();
void brightON() {  
  if (flag_brON)
    if (millis() - tmr_brON >= cp5.get(Slider.class, "br_speed").getValue()) {
      int val  = int(cp5.get(Knob.class, "bright").getValue()) + 1;
      cp5.get(Knob.class, "bright").setValue(val);
      if (val >= int(cp5.get(Slider.class, "br_maxBr").getValue())) flag_brON = false;
      tmr_brON = millis();
    }
}

void br_off() {
  if (!flag_brON) flag_brOFF = true; 
}

void br_on() {
  if (!flag_brOFF) flag_brON = true; 
}

void br_tick() {
 brightOFF(); 
 brightON();
}
