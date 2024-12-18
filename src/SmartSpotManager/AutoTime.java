import processing.core.*;

public class AutoTime {
    PApplet parent;

    public AutoTime(PApplet set_parent, int[][] set_times) {
        parent = set_parent;
        times = set_times;
    }

    int times[][];

    public boolean check() {
        for (int i = 0; i < times.length; i++) {
            int startHour = times[i][0];
            int startMinute = times[i][1];
            int endHour = times[i][2];
            int endMinute = times[i][3];
            
           if (isTimeInRange(parent.hour(), parent.minute(), startHour, startMinute, endHour, endMinute))
                return true;
        }
          // if (parent.millis() - tmr >= 10000)     tmr = parent.millis();
        return false;
    }

    boolean isTimeInRange(int currentHour, int currentMinute, int startHour, int startMinute, int endHour,
            int endMinute) {

        int currentTimeInMinutes = currentHour * 60 + currentMinute;
        int startTimeInMinutes = startHour * 60 + startMinute;
        int endTimeInMinutes = endHour * 60 + endMinute;
        
       // if (parent.millis() - tmr >= 10000) {
         // parent.println(startTimeInMinutes, currentTimeInMinutes, endTimeInMinutes);
        //}

        return (currentTimeInMinutes >= startTimeInMinutes && currentTimeInMinutes < endTimeInMinutes);
    }

long tmr;
}
