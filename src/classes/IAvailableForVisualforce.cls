public Interface IAvailableForVisualforce {
	ApexPages.Component getComponent(ComponentSettings settings);
	List<ComponentSettings.Options> getOptions();
}