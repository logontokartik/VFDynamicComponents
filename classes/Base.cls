global virtual class Base {
	
	private Boolean debug = false; 		
    private String elementId;
    private String jsController; 	 
    private String apexController; 
    private String componentTitle;
    private String styleClass;

    global void setDebug(Boolean value) {
    	this.debug = value;
    }

    public Boolean getDebug() {
    	return debug;
    }

    global void setElementId(String value) {
    	this.elementId = value;
    }

    public String getElementId() {
    	return elementId;
    }

    global void setJsController(String value) {
    	this.jsController = value;
    }

    public String getJsController() {
    	return jsController;
    }

    global void setApexController(String value) {
    	this.apexController = value;
    }

    public String getApexController() {
    	return apexController;
    }
    
    global void setComponentTitle(String value) {
    	this.componentTitle = value;
    }

    public String getComponentTitle() {
    	return componentTitle;
    }

    global void setStyleClass(String value) {
    	this.styleClass = value;
    }

    public String getStyleClass() {
    	return styleClass;
    }


    global class BaseException extends Exception {}
}