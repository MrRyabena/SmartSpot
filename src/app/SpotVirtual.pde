class SpotVirtual {
  int id;
  Client spot;

  SpotVirtual(int set_ID) {
    this.id = set_ID;
  }

  void setBright(int val) {
    byte buf[] = new byte[2];

    buf[0] = 13;
    buf[1] |= val;

    m_send(buf);
  }

  void setColor(color col) {
    byte[] buf = new byte[5];

    buf[0] = 3;
    buf[1] |= int(red(col));
    buf[2] |= int(green(col));
    buf[3] |= int(blue(col));
    buf[4] |= 255;

    m_send(buf);
  }

  void setFadeMode(boolean fade) {
    byte[] buf = new byte[2];

    buf[0] |= 16;
    buf[1] |= int(fade);

    m_send(buf);
  }

  void setFadePeriod(int T) {
    byte[] buf = new byte[5];

    buf[0] = 17;
    buf[1] =(byte)(T & 0xFF);
    buf[2] =(byte)((T >> 8) & 0xFF);
    buf[3] =(byte)((T >> 16) & 0xFF);
    buf[4] =(byte)((T >> 24) & 0xFF);

    m_send(buf);
  }
  void m_send(byte[] data) {
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
    buf[8] = 1;
    buf[9] |= id;

    for(int i = 0; i < data.length; i++) buf[OFFSET + i] = data[i];

    if (spot != null) spot.write(buf);
    
    //for (int i = 0; i < buf.length; i++) println(int(buf[i]));
    //println();
  }
}
