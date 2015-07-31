public with sharing class ComponentSettings {
	
	private Component__c component;
	private List<Component_Attribute__c> componentAttributes;
	private Map<String,Object> attributes;

	public ComponentSettings() {

	}

	public ComponentSettings(Component__c component, List<Component_Attribute__c> componentAttributes) {
		this.component = component;
		this.componentAttributes = componentAttributes;
		this.attributes = buildMap(componentAttributes);
	}

	public Map<String,Object> buildMap(List<Component_Attribute__c> componentAttributes) {
		Map<String,Object> attmap = new Map<String, Object>();

		for (Component_Attribute__c ca : componentAttributes) {
			if (ca.Type__c == 'Boolean') {
				attmap.put(ca.Key__c,Boolean.valueOf(ca.Value__c));
			} else if (ca.Type__c == 'Integer') {
				attmap.put(ca.Key__c,Integer.valueOf(ca.Value__c));
			} else if (ca.Type__c == 'Decimal') {
				attmap.put(ca.Key__c,Decimal.valueOf(ca.Value__c));
			} else if (ca.Type__c == 'Double') {
				attmap.put(ca.Key__c,Double.valueOf(ca.Value__c));
			} else if (ca.Type__c == 'Date') {
				attmap.put(ca.Key__c,Date.valueOf(ca.Value__c));
			} else if (ca.Type__c == 'DateTime') {
				attmap.put(ca.Key__c,DateTime.valueOf(ca.Value__c));
			} else if (ca.Type__c == 'Id') {
				attmap.put(ca.Key__c,Id.valueOf(ca.Value__c));
			} else {
				attmap.put(ca.Key__c,ca.Value__c);
			}
		}
		return attmap;
	}

	public Map<String,Object> getAttributes() {
		return this.attributes;
	}

	public void setAttributes(Map<String,Object> values) {
		this.attributes = values;
	}

	// The options available for each component attribute.

	public class Options {

		public String label {get;set;}
		public String name {get;set;}
		public Boolean isRequired {get;set;}
		public String description {get;set;}
		public String defaultValue {get;set;}
		public Type attrType {get;set;} 
		public List<SelectOption> options {get;set;}

	}






























}