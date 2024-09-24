


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
        byte[] buf = new byte[2];
        
        buf[0] = 1;
        buf[1] = byte(val);

        if (spot != null) spot.write(buf);
    }

    void setColor(color col)
    {
        byte[] buf = new byte[4];
        
        buf[0] = 2;
        buf[1] = byte(red(col));
        buf[2] = byte(green(col));
        buf[3] = byte(blue(col));

        if (spot != null) spot.write(buf);

    }


    //static enum Commands { no_command, setBright, setColor };
}
