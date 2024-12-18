import processing.sound.*;

import java.io.File;
import processing.core.*;

import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

public class AutoPlayerClass {

    PApplet parent;
    SoundFile current_file;
    SoundFile next_file;
    float volume = 0;

    String folderPath = "";
    ArrayList<String> list_files;
    int ind = 0;

    public AutoPlayerClass() {
        this(new PApplet(), new String());
    }

    public AutoPlayerClass(PApplet set_parent, String folder) {
        parent = set_parent;
        list_files = new ArrayList<>();

        folderPath = folder;
        getFiles();

        if (!list_files.isEmpty()) {
            current_file = new SoundFile(parent, list_files.get(ind));
            if (++ind >= list_files.size())
                ind = 0;
        } else {
            parent.println("The file list is empty. Check the folder: " + folderPath);
        }
    }

    public void play() {
        current_file.amp(0);
        current_file.play();
        flag_high = true;
        flag_pause = false;
    }

    public void pause() {
        flag_low = true;
        flag_pause = true;
    }
    
    public boolean isPlaying()
    {
       return !flag_pause; 
    }

    private long tick_tmr;
    private boolean flag_low = false;
    private boolean flag_high = false;
    private boolean flag_pause = true;
    private boolean flag_change = false;

    public int T = 25;

    public void tick() {
        if (parent.millis() - tick_tmr >= T) {
            if (flag_low) {
                if (volume <= 0.005) {
                    flag_low = false;
                    if (flag_pause)
                        current_file.pause();
                    return;
                }

                volume -= 0.005;
                current_file.amp(volume);
            }

            else if (flag_high) {
                if (volume >= 1) {
                    flag_high = false;
                    return;
                }

                volume += 0.005;
                current_file.amp(volume);
            }

            if (flag_low == false && flag_change == true) {
                current_file = new SoundFile(parent, list_files.get(ind));
                play();
                flag_change = false;

                if (++ind >= list_files.size())
                    ind = 0;

            }

            if (current_file.duration() - current_file.position() < 10 && flag_change == false) {
                flag_low = true;
                flag_change = true;
            }

            tick_tmr = parent.millis();
        }
    }

    void getFiles() {
        File folder = new File(folderPath);
        if (folder.isDirectory()) {

            File[] files = folder.listFiles();

            if (files != null) {
                for (File file : files) {
                    list_files.add(file.getName());
                }
                Collections.shuffle(list_files);
            }
        }
    }

}
