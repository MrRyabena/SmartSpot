public class shs_ID {
    int id;

    shs_ID(int set_id) {
        id = set_id;
    }

    shs_ID(int module_id, int device_id, int component_id) {
        setID(module_id, device_id, component_id);
    }

    void setID(int module_id, int device_id, int component_id) {
        id = ((module_id & 0xff) << 24) | ((device_id & 0xff) << 16) | (component_id & 0xffff);
    }

    int getModuleID() {
        return id >> 24;
    }

    int getDeviceID() {
        return (id >> 16) & 0xff;
    }

    int getComponentID() {
        return id & 0xffff;
    }
}
