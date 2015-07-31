global abstract class ComponentBase {

    protected Base config;

    global ComponentBase() {}
    
    global ComponentBase(Base config) {
        this.config = config;
    }

    global virtual String getConfigJson() {
        String configStr = JSON.serialize(config);
        return configStr;
    }

    /**
     *   Generate a random String for a given component. This provides uniqueness for JS variables using same component multiple times
     */
    global virtual String getComponentId() {

        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < 5) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), 62);
           randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
    
}