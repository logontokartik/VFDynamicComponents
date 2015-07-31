public with sharing class ComponentEditNewCon {
	
	
	public List<Component_Attribute__c> attributes 	{get;set;}
	public String selComponent 						{get;set;}
	public List<ConfigItem> configs 				{get;set;}
	public String messageTitle                      {get;set;}
    public String message                           {get;set;}
    public Boolean hasError                         {get;set;}

	public Component__c component  					{get;set;}
	
	private List<Component__c> components;
	private ComponentSettings compSettings;
	private ApexPages.StandardController con;
	private String returnURL;
    private String order;
    private String parentId;

    // Constructor to initialize the various components.
	public ComponentEditNewCon(ApexPages.StandardController con) {
		
		// Initialize
		this.con 	= con;
		returnURL 	= ApexPages.currentPage().getParameters().get('retURL');
		order 		= ApexPages.currentPage().getParameters().get('order');
		parentId 	= ApexPages.currentPage().getParameters().get('parentid');
		con.addFields(new List<String>{'Page__c','Order__c','Name','Is_Active__c'});

		// Check to see if page is rendered because of an override
        if (String.isBlank(parentId)) {
            Map<String,String> pageParams = ApexPages.currentPage().getParameters();
            for (String s : pageParams.keySet()) {
                if (s.contains('_lkid')) {
                    parentId = pageParams.get(s);
                    break;
                }
            }
        }

        this.component = (Component__c)con.getRecord(); // Get the Record.
       	
        if (component.Id != null) {
        // Edit Mode
        	attributes 			= [Select Id, Name, Type__c, Value__c, Key__c, Component__c 
        						   from Component_Attribute__c 
        						   where Component__c = :component.Id];
        	selComponent 		= component.Name;
        } else {
        // New Mode.	
        	attributes = new List<Component_Attribute__c>();
        }

        if (this.component.Id != null)
            getTheAttributes();
        else 
            initializeAttributes();
        
        // Get the Component Settings.
        compSettings = new ComponentSettings(this.component,this.attributes);

        if (component.Page__c == null)
        	component.Page__c = parentId;

	}

	// Get the Attributes 
	private void getTheAttributes() {
        
        if (attributes.size() == 0 && selComponent != null) {
            initializeAttributes(); // If there are no Attributes, initialize
        } else {
        	// Get all existing attributes
            configs = new List<ConfigItem>();
            
            Map<String,Component_Attribute__c> attrMap = new Map<String,Component_Attribute__c>();
            
            for (Component_Attribute__c pea : attributes)
                attrMap.put(pea.Key__c,pea);
            
            if (selComponent != null) {    
	            
	            IAvailableForVisualforce compImpl = getComponentInstance();
	            
	            if (compImpl != null) {
	                for (ComponentSettings.Options cco : compImpl.getOptions()) {
	                    Component_Attribute__c pea = attrMap.get(cco.name);
	                    System.debug('pead' + pea);	
	                    if (pea == null) {
	                        pea = new Component_Attribute__c();
	                        pea.Key__c = cco.name;
	                        pea.Value__c = cco.defaultValue;
	                        pea.Component__c = this.component.Id;
	                        pea.Type__c = cco.attrType.getName();
	                    }
	                    configs.add(new ConfigItem(cco,pea));
	                }
	            }
        	}
        }
    }

    // Initialize the Attributes

    private void initializeAttributes() {
        
        configs = new List<ConfigItem>();
        
        if (selComponent != null) {
	        IAvailableForVisualforce compImpl = getComponentInstance();
	        
	        for (ComponentSettings.Options cco : compImpl.getOptions()) {
	            Component_Attribute__c pea = new Component_Attribute__c();
	            pea.Key__c = cco.name;
	            pea.Value__c = cco.defaultValue;
	            pea.Component__c = this.component.Id;
	            pea.Type__c = cco.attrType.getName();
	            attributes.add(pea); 
	            configs.add(new ConfigItem(cco,pea));
	        }
    	}
        
    }

    // Get the Component Instance based on Component Name
    private IAvailableForVisualforce getComponentInstance() {
        Type configClass = null;
        configClass = Type.forName(selComponent);
        return (IAvailableForVisualforce) configClass.newInstance();
    }

    // Get all the available components that are registered.
	public List<SelectOption> getAvailableComponents() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('','-- Choose a Component --'));
		
		for (ApexClass cls : [Select Id, Name, Body from ApexClass where Name != 'IAvailableForVisualforce' AND Name != 'ComponentEditNewCon']) {
			if (cls.Body.contains('implements IAvailableForVisualforce'))
				options.add(new SelectOption(cls.Name,cls.Name));
		}

		return options;
	}

	void deleteElementAttributes() {
        Component_Attribute__c[] sobjectsToDelete = new List<Component_Attribute__c>();
        for (Component_Attribute__c pea : attributes)
        if (pea.Id != null)
            sobjectsToDelete.add(pea);
        if (sobjectsToDelete.size() > 0)
            delete sobjectsToDelete;
    }

      public void onComponentChange() {
        deleteElementAttributes();
        initializeAttributes();
        
    }

    public PageReference saveRecords() {
        
        hasError = false;

        // Upsert the Component. If already present, otherwise create new
        try {
            
            component.Name = selComponent;
            
            if (order != null)
            	component.Order__c = Integer.valueOf(order);
            else
            	component.Order__c = 99;

            component.Is_Active__c = true;
            	
            upsert component;

            attributes = new List<Component_Attribute__c>();
            
            for (ConfigItem ci : configs) {
                if (ci.pea.Component__c == null)
               		ci.pea.Component__c = this.component.Id;
                
                attributes.add(ci.pea);
            }
            
            upsert attributes;

        } catch (Exception ex) {
            messageTitle = 'Issue with Saving Component';
            System.debug(ex.getMessage());
            hasError = true;   
        }

        if (hasError)
        	return null;

        PageReference saveRedirect; 
        
        if (String.isBlank(returnURL)) {
            saveRedirect = new PageReference('/' + parentId);
        } else {
            saveRedirect = new PageReference(returnURL);
        }
        saveRedirect.setRedirect(true);

        return saveRedirect;	
    }

     public PageReference cancel() {
        PageReference cancel;
        if (String.isBlank(returnURL)) {
            cancel = new PageReference('/' + parentId);
        } else {
            cancel = new PageReference(returnURL);
        }
        cancel.setRedirect(true);
        return cancel;
    }

    public class ConfigItem {
        public Component_Attribute__c pea    { get; set; }
        public ComponentSettings.Options cco        { get; set; }

        public ConfigItem(ComponentSettings.Options cco, Component_Attribute__c pea) {
            this.cco = cco;
            this.pea = pea;
        }

        public Boolean getIsPicklist() {
            if (this.cco.options == null)
                return false;
            return this.cco.options.size() > 0;
        }

        public Boolean getIsNumber() {
            Set<Type> typeSet = new Set<Type> {
                Integer.class,
                Decimal.class,
                Long.class,
                Double.class
            };
            return typeSet.contains(this.cco.attrType);
        }
    }
}