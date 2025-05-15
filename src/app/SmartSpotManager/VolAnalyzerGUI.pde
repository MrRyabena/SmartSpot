

//class VolAnalyzerGUI
//{
//    float shift_x;
//    float shift_y;
//    ControlP5 cp5;
//    PApplet parent;
//    String pannel_name;
//    SpotVirtual spots[];

//    VolAnalyzerGUI(PApplet par, ControlP5 cp, String pname, float x, float y, SpotVirtual sv)
//    {
//        parent = par;
//        cp5 = cp;
//        pannel_name = pname;
//        shift_x = x;
//        shift_y = y;
//        spots = new SpotVirtual[1];
//        spots[0] = sv;
//        guiSetup();
//    }
    
//    void update()
//    {
//      for (SpotVirtual sv : spots)
//      {
//        for (int i = 0; i < sets.length; i++)
//        handleChange(int(cp5.get(Slider.class, pannel_name + sets[i][0]).getValue()), i); 
//      }
//    }

//    void handleChange(float value, int id)
//    {
//        switch (id)
//        {
//            case 0: for (SpotVirtual sv : spots) sv.setDt(int(value)); break;
//            case 1: for (SpotVirtual sv : spots) sv.setWindow(byte(value)); break;
//            case 2: for (SpotVirtual sv : spots) sv.setTrsh(int(value)); break;
            
//            case 3: for (SpotVirtual sv : spots) sv.setVolDt(byte(value)); break;
//            case 4: for (SpotVirtual sv : spots) sv.setVolK(byte(value)); break;
//            case 5: for (SpotVirtual sv : spots) sv.setVolMin(byte(value)); break;
//            case 6: for (SpotVirtual sv : spots) sv.setVolMax(byte(value)); break;
            
//            case 7: for (SpotVirtual sv : spots) sv.setPulseMax(byte(value)); break;
//            case 8: for (SpotVirtual sv : spots) sv.setPulseMin(byte(value)); break;
//            case 9: for (SpotVirtual sv : spots) sv.setPulseTimeout(int(value)); break;
//        }
//    }

//    void guiSetup()
//    {
//        float x = 0;
//        float y = 0;

//        for (int i = 0; i < sets.length; i++)
//        {
//            cp5
//            .addSlider(pannel_name + sets[i][0])
//            .setCaptionLabel(sets[i][0])
//            .registerTooltip(sets[i][1])
//            .setPosition(x + shift_x, y + shift_y)
//            .setRange(range_value[i][0], range_value[i][1])
//            .setValue(range_value[i][2])
//            .setSize(100, 30)
//            .setId(i)
//            .onChange(new CallbackListener() {
//    public void controlEvent(CallbackEvent event) { handleChange(event.getController().getValue(), event.getController().getId() ); }
//                 }
//                    )
//            ; 
                        
//            y += 40;
//            x = 200 * int((i + 1) / 6);
//            if ((i + 1) % 6 == 0) y = 0;
//        }
//    }


//    String sets[][] = {
//        { "setDt", "uint16_t dt — установить время между опросами АЦП (мкс) (по умолч. 500)" },
//        { "setWindow", "uint8_t window — установка ширины окна выборки (по умолч. 20)" },
//        { "setTrsh", "uint16_t trsh — установить порог громкости в единицах АЦП (умолч 40)" },

//        { "setVolDt", "uint8_t dt установить период фильтрации громкости (умолч 20)" },
//        { "setVolK", "uint8_t vk — установить коэффициент плавности громкости 0-31 (умолч 25)" },
//        { "setVolMin", "uint8_t vol — установить минимальную величину громкости (умолч 0)" },
//        { "setVolMax", "uint8_t vol — установить максимальную величину громкости (умолч 100)" },

//        { "setAmpliDt", "uint8_t dt — установить период фильтрации амплитудных огибающих" },
//        { "setAmpliK", "uint8_t rk — установить коэффициент плавности амплитуды 0-31 (умолч 31)" },

//        { "setPulseMax", "uint8_t maxV — верхний порог срабатывания пульса (по шкале громкости)" },
//        { "setPulseMin", "uint8_t minV — нижний порог перезагрузки пульса (по шкале громкости)" },
//        { "setPulseTimeout", "uint16_t tout — таймаут пульса, мс" }
//    };

//    float range_value[][] = 
//    {
//        { 0, 20000, 5000 },  // setDt
//        { 0, 100, 20 },      // setWindow
//        { 0, 1023, 40 },     // setTrsh

//        { 0, 255, 20 },      // setVolDt
//        { 0, 31, 25 },       // setVolK
//        { 0, 255, 0 },       // setVolMin
//        { 0, 255, 100 },     // setVolMax

//        { 0, 255, 150 },     // setAmpliDt
//        { 0, 31, 30 },       // setAmpliK

//        { 0, 255, 80 },      // setPulseMax
//        { 0, 255, 20 },      // setPulseMin
//        { 0, 1000, 100 }     // setPulseTimeout

//    };
//}
