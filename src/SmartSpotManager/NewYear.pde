int times[][] = 
{
  { 9, 32, 9, 48 },
  { 10, 25, 10, 55 },
  { 11, 30, 11, 59 },
  { 12, 35, 13, 5 },
  { 13, 40, 13, 59 },
  { 14, 35, 14, 55 },
};

boolean AutoTime_flag = false;

AutoTime at;
AutoPlayerClass ap;


void newYearSetup()
{

  cp5
    .addToggle("AutoTime")
    .setCaptionLabel("AutoTime")
    .setValue(!AutoTime_flag)
    .setMode(ControlP5.SWITCH)
    .setPosition(100, 100)
    .setSize(80, 30)
    .onChange(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      AutoTime_flag = !boolean(int(event.getController().getValue()));
    }
  }
  );


  cp5
    .addButton("play")
    .setCaptionLabel("play")
    .setPosition(190, 100)
    .setSize(50, 30)
    .onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      ap.play();
    }
  }
  )
  ;

  cp5
    .addButton("pause")
    .setCaptionLabel("pause")
    .setPosition(190, 150)
    .setSize(50, 30)
    .onClick(new CallbackListener() {
    public void controlEvent(CallbackEvent event) {
      ap.pause();
    }
  }
  )
  ;


  at = new AutoTime(this, times);
  //at = new AutoTime(this, generateTestTimes());
  //  println(dataPath(""));
  ap = new AutoPlayerClass(this, dataPath(""));
}

void AutoTime_tick()
{
  ap.tick();

  if (!AutoTime_flag) return;


  if (!at.check())
  {
    if (ap.isPlaying()) ap.pause();
     if (spg1.getBright() != 0) spg1.flag_brOFF = true;
     if (spg1.flag_ny) spg1.flag_ny = false;
     if (spg2.getBright() != 0) spg2.flag_brOFF = true;
     if (spg2.flag_ny) spg2.flag_ny = false;
  } 
  else if (at.check())
  {
     if (!ap.isPlaying()) ap.play();
     if (spg1.getBright() == 0) spg1.flag_brON = true;
     if (!spg1.flag_ny) spg1.flag_ny = true;
     if (spg2.getBright() == 0) spg2.flag_brON = true;
     if (!spg2.flag_ny) spg2.flag_ny = true;
  }
}


int[][] generateTestTimes() {
    int currentHour = hour();
    int currentMinute = minute();
    int[][] testTimes = new int[6][4]; // Массив на 6 интервалов

    for (int i = 0; i < 6; i++) {
        int startMinute = currentMinute + (i * 4);
        int endMinute = startMinute + 2;

        if (endMinute >= 60) {
            endMinute -= 60;
            startMinute -= 60;
            currentHour++;
        }
        
        testTimes[i][0] = currentHour;
        testTimes[i][1] = startMinute % 60; // Обеспечиваем, что минуты в пределах 0-59
        testTimes[i][2] = currentHour;
        testTimes[i][3] = endMinute % 60; // Обеспечиваем, что минуты в пределах 0-59
        
        //println(testTimes[i][0], testTimes[i][1], testTimes[i][2], testTimes[i][3]);
    }
    return testTimes;
 }
