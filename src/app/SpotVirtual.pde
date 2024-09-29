enum commands
{
  enable,
    disable,
    setPower,
    setRGB,
    setHSVfast,
    setHSV,
    setWheel,
    setWheel8,
    setKelvin,
    setKelvinFast,
    setHEX,
    setHEX16,
    setColor,
    setBrightness,
    setCRT,
    tick,
    fadeMode,
    setFadePeriod
};

class SpotVirtual
{


  int id;
  Client spot;

  SpotVirtual(int set_ID, Client set_client)
  {
    this.id = set_ID;
    this.spot = set_client;
  }

  void setBright(int val)
  {
    byte[] buf = new byte[4];

    buf[0] = 4;
    buf[1] = 1;
    buf[2] |= val;


    // println(spot == null);
    // println(spotL == null);
    println(val);

    if (spot != null) spot.write(buf);
  }

  void setColor(color col)
  {
    byte[] buf = new byte[5];

    buf[0] |= 5;
    buf[1] |= 2;
    buf[2] |= int(red(col));
    buf[3] |= int(green(col));
    buf[4] |= int(blue(col));


    if (spot != null) spot.write(buf);
  }


  //static enum Commands { no_command, setBright, setColor };
}
