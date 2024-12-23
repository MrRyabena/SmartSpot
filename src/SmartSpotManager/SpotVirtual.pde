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
//    tick,
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


  void setCooling(byte val)
  {
    byte[] buf = new byte[3];

    buf[0] = 3;
    buf[1] = 4;
    buf[2] |= val;


    if (spot != null) spot.write(buf);
  }


  void setBright(int val)
  {
    byte[] buf = new byte[4];

    buf[0] = 4;
    buf[1] = 1;
    buf[2] = 13;
    buf[3] |= val;


    if (spot != null) spot.write(buf);
  }

  void setColor(color col)
  {
    byte[] buf = new byte[7];

    buf[0] |= 7;
    buf[1] = 1;
    buf[2] |= 3;
    buf[3] |= int(red(col));
    buf[4] |= int(green(col));
    buf[5] |= int(blue(col));
    buf[6] |= 255;


    if (spot != null) spot.write(buf);
  }

  void setFadeMode(boolean fade)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 1;
    buf[2] |= 16;
    buf[3] |= int(fade);

    if (spot != null) spot.write(buf);
  }

  void setFadePeriod(int T)
  {
    byte[] buf = new byte[7];



    buf[0] = 7;
    buf[1] = 1;
    buf[2] = 17;
    buf[3] = (byte)(T & 0xFF);
    buf[4] = (byte)((T >> 8) & 0xFF);
    buf[5] = (byte)((T >> 16) & 0xFF);
    buf[6] = (byte)((T >> 24) & 0xFF);


    if (spot != null) spot.write(buf);
  }

  void setMusicEffect(byte mode)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 2;
    buf[2] = 2;
    buf[3] |= mode;

    if (spot != null) spot.write(buf);
  }


  void setDt(int val)
  {
    byte[] buf = new byte[5];

    buf[0] = 5;
    buf[1] = 3;
    buf[2] = 0;
    buf[3] |= val >> 8;
    buf[4] |= val;

    if (spot != null) spot.write(buf);
  }

  void setWindow(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 1;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setTrsh(int val)
  {
    byte[] buf = new byte[5];

    buf[0] |= 5;
    buf[1] = 3;
    buf[2] = 2;
    buf[3] |= val >> 8;
    buf[4] |= val;

    if (spot != null) spot.write(buf);
  }

  void setVolDt(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 3;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setVolK(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 4;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setVolMin(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 5;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setVolMax(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 6;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setAmpliDt(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 7;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setAmpliK(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 8;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setPulseMax(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 9;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setPulseMin(byte val)
  {
    byte[] buf = new byte[4];

    buf[0] |= 4;
    buf[1] = 3;
    buf[2] = 10;
    buf[3] |= val;

    if (spot != null) spot.write(buf);
  }

  void setPulseTimeout(int val)
  {
    byte[] buf = new byte[5];

    buf[0] |= 5;
    buf[1] = 3;
    buf[2] = 11;
    buf[3] |= val >> 8;
    buf[4] |= val;

    if (spot != null) spot.write(buf);
  }
}
