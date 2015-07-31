//Service class.
public with sharing class ComponentService {
	
	public static List<ApexPages.Component> generate(Set<Id> componentIds) {
		List<Component__c> components = new List<Component__c>();
		components = [Select Id, Name, Order__c, Page__c, (Select Id, Name, Value__c, Key__c, Type__c from Component_Attributes__r)
					  from Component__c where Id in :componentIds order by Order__c];

		List<ApexPages.Component> dynamicComponents = new List<ApexPages.Component>();

		// This is where the magic happens.
		// Make sure that Apex class that implements the Interface matches with the Component Name.
		for (Component__c cmp : components) {
			IAvailableForVisualforce inst = (IAvailableForVisualforce) Type.forName(cmp.Name).newInstance();
			ComponentSettings settings = new ComponentSettings(cmp,cmp.Component_Attributes__r);
			dynamicComponents.add(inst.getComponent(settings));
		}

		return dynamicComponents;			  
	}

}