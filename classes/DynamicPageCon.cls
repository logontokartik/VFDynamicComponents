// Controller for Dynamic Page
public with sharing class DynamicPageCon {


	private Set<Id> componentIds;
	
	public DynamicPageCon() {
		
		componentIds = new Set<Id>();
		String pageId = ApexPages.currentPage().getParameters().get('id');

		for (Component__c cmp : [Select Id from Component__c where Page__c = :pageId and Is_Active__c = true order by Order__c])
			componentIds.add(cmp.Id);
	}

	public Component.Apex.OutputPanel getComponents() {
		Component.Apex.OutputPanel thePanel = new Component.Apex.OutputPanel();
		for (ApexPages.Component comp : ComponentService.generate(componentIds)) {
			Component.Apex.OutputPanel innerPanel = new Component.Apex.OutputPanel();
			innerPanel.childComponents.add(comp);
			innerPanel.layout = 'block';
			thePanel.childComponents.add(innerPanel);
		}
		return thePanel;
	}

}