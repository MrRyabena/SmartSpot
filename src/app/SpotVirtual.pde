//class commands
//{
//    enable,
//    disable,
//    setPower,
//    setRGB,
//    setHSVfast,
//    setHSV,
//    setWheel,
//    setWheel8,
//    setKelvin,
//    setKelvinFast,
//    setHEX,
//    setHEX16,
//    setColor,
//    setBrightness,
//    setCRT,
//    tick,t
//    fadeMode,
//    setFadePeriod
//};

class SpotVirtual
{


  int id;
  Client spot;

  SpotVirtual(int set_ID)
  {
    this.id = set_ID;
    //this.spot = set_client;
  }

  void setBright(int val)
  {
    byte[] buf = new byte[3];

    buf[0] = 3;
    buf[1] = 13;
    buf[2] |= val;


    println(spot == null);
    //println(spotL == null);
    println(val);

    if (spot != null) spot.write(buf);
  }

  void setColor(color col)
  {
    byte[] buf = new byte[6];

    buf[0] |= 6;
    buf[1] |= 3;
    buf[2] |= int(red(col));
    buf[3] |= int(green(col));
    buf[4] |= int(blue(col));
    buf[5] |= 255;


    if (spot != null) spot.write(buf);
  }


  //static enum Commands { no_command, setBright, setColor };
}
