public class GoogleMap implements IAvailableForVisualforce {
    
    public ApexPages.Component getComponent(ComponentSettings config) {
        
        Component.GoogleMap comp = new Component.GoogleMap();
        Map<String,Object> attribs = config.getAttributes();
        if (attribs.get('address') != null)
			comp.address = (String) attribs.get('address');
		if (attribs.get('info') != null)
			comp.info = (String) attribs.get('info');
		if (attribs.get('title') != null)
			comp.title = (String) attribs.get('title');
        
        return comp;
        
    }
    
    public ComponentSettings.Options[] getOptions() {
		ComponentSettings.Options[] results = new List<ComponentSettings.Options>();
        // address
		ComponentSettings.Options address_config = new ComponentSettings.Options();
		address_config.label='Address for Map';
		address_config.name='address';
		address_config.description='Enter the address separated by comma';
		address_config.attrType=String.class;
		address_config.options=new List<SelectOption>();
		address_config.isRequired=true;
		address_config.defaultValue='1 Market St #300, San Francisco, CA 94105';
		results.add(address_config);
        
        // info
		ComponentSettings.Options info_config = new ComponentSettings.Options();
		info_config.label='Info for Map';
		info_config.name='info';
		info_config.description='Enter the Information';
		info_config.attrType=String.class;
		info_config.options=new List<SelectOption>();
		info_config.isRequired=true;
		info_config.defaultValue='Visualforce Demo';
		results.add(info_config);
        
        // title
		ComponentSettings.Options title_config = new ComponentSettings.Options();
		title_config.label='Title';
		title_config.name='title';
		title_config.description='Enter the Title';
		title_config.attrType=String.class;
		title_config.options=new List<SelectOption>();
		title_config.isRequired=true;
		title_config.defaultValue='Salesforce.com';
		results.add(title_config);
    	return results;
        
    }

}