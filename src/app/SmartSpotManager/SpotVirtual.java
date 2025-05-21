import processing.net.Client;


class SpotVirtual {
  shs_ID id;
  Client spot;
  byte r, g, b;
  byte brightness;


  int color_power = 17;

  int max_power;
  int max_brightness;

  SpotVirtual(shs_ID set_ID) {
    this.id = set_ID;
    this.r = 0;
    this.g = 0;
    this.b = 0;
    this.brightness = 0;
  }

  SpotVirtual(shs_ID set_ID, int max_power, int max_brightness) {
    this.id = set_ID;
    this.r = 0;
    this.g = 0;
    this.b = 0;
    this.max_power = max_power;
    this.max_brightness = max_brightness;
  }

  void m_send(byte[] data) {
    m_send(data, (byte) 1);
  }

  void m_send(byte[] data, byte device_id) {
    int OFFSET = 10;
    byte[] buf = new byte[OFFSET + data.length + 1];

    buf[0] |= OFFSET + data.length;
    buf[1] = 1;

    buf[2] = 0;
    buf[3] = 0;
    buf[4] = 0;
    buf[5] = 0;

    buf[6] = 0;
    buf[7] = 0;
    buf[8] = device_id;
    buf[9] |= id.getModuleID();

    for (int i = 0; i < data.length; i++)
      buf[OFFSET + i] = data[i];

    if (spot != null) spot.write(buf);

  //for (int i = 0; i < buf.length; i++) System.out.print((int)buf[i]); System.out.println();

  }

  void requestTemperature() 
  {
    byte[] buf = new byte[1];

    buf[0] = 4;
    m_send(buf, (byte) 2);
  }

  void requestInfo()
  {
    byte[] buf = new byte[2];
    buf[0] = 5;
    m_send(buf, (byte) 2);
  }

   void setCooling(byte val) {
    byte[] buf = new byte[3];

   buf[0] = 2;
   buf[1] |= val;
   if (val != 0) buf[2] = 1;
   else buf[2] = 0;
   
   m_send(buf, (byte)2);
  }

  void setBright(int val) {
    byte buf[] = new byte[2];

    brightness = (byte) (val < max_brightness ? val : max_brightness);
    buf[0] = 13;
    buf[1] |= brightness;

    m_send(buf);
  }

  void setColor(int r, int g, int b) {
    byte[] buf = new byte[5];

    this.r = (byte) r;
    this.g = (byte) g;
    this.b = (byte) b;

    int power = (r + g + b) / 255 * color_power;
    power = power < max_power ? power : max_power;

    buf[0] = 3;
    buf[1] |= r;
    buf[2] |= g;
    buf[3] |= b;
    buf[4] |= (byte) power;    

    m_send(buf);
  }

  void setFadeMode(int fade) {
    byte[] buf = new byte[2];

    buf[0] |= 16;
    buf[1] |= fade;

    m_send(buf);
  }

  void setFadePeriod(int T) {
    byte[] buf = new byte[5];

    buf[0] = 17;
    buf[1] = (byte) (T & 0xFF);
    buf[2] = (byte) ((T >> 8) & 0xFF);
    buf[3] = (byte) ((T >> 16) & 0xFF);
    buf[4] = (byte) ((T >> 24) & 0xFF);

    m_send(buf);
  }

  // void setMusicEffect(byte mode) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 2;
  // buf[2] = 2;
  // buf[3] |= mode;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setDt(int val) {
  // byte[] buf = new byte[5];

  // buf[0] = 5;
  // buf[1] = 3;
  // buf[2] = 0;
  // buf[3] |= val >> 8;
  // buf[4] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setWindow(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 1;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setTrsh(int val) {
  // byte[] buf = new byte[5];

  // buf[0] |= 5;
  // buf[1] = 3;
  // buf[2] = 2;
  // buf[3] |= val >> 8;
  // buf[4] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setVolDt(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 3;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setVolK(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 4;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setVolMin(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 5;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setVolMax(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 6;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setAmpliDt(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 7;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setAmpliK(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 8;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setPulseMax(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 9;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setPulseMin(byte val) {
  // byte[] buf = new byte[4];

  // buf[0] |= 4;
  // buf[1] = 3;
  // buf[2] = 10;
  // buf[3] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

  // void setPulseTimeout(int val) {
  // byte[] buf = new byte[5];

  // buf[0] |= 5;
  // buf[1] = 3;
  // buf[2] = 11;
  // buf[3] |= val >> 8;
  // buf[4] |= val;

  // if (spot != null)
  // spot.write(buf);
  // }

}
