public with sharing class VFDataTable implements IAvailableForVisualforce{

	public ApexPages.Component getComponent(ComponentSettings config) {
		Component.VFDataTable result = new Component.VFDataTable();
		Map<String,Object> attribs = config.getAttributes();
		if (attribs.get('sobjectName') != null)
			result.sobjectName = (String) attribs.get('sobjectName');
		if (attribs.get('fieldCsv') != null)
			result.fieldCsv = (String) attribs.get('fieldCsv');
		if (attribs.get('styleClass') != null)
			result.styleClass = (String) attribs.get('styleClass');
		if (attribs.get('tableStyleClass') != null)
		    result.tableStyleClass = (String) attribs.get('tableStyleClass');
		if (attribs.get('searchable') != null)
			result.searchable = (Boolean) attribs.get('searchable');
		if (attribs.get('defaultPageSize') != null)
			result.defaultPageSize = (Integer) attribs.get('defaultPageSize');
		if (attribs.get('tableHeading') != null)
			result.tableHeading = (String) attribs.get('tableHeading');
		if (attribs.get('fieldSetName') != null && result.fieldCsv == null) // only allow when fieldCsv is undefined
			result.fieldSetName = (String) attribs.get('fieldSetName');
		if (attribs.get('panelStyle') != null)
			result.panelStyle = (String) attribs.get('panelStyle');
		return result;
	}

	public ComponentSettings.Options[] getOptions() {
		ComponentSettings.Options[] results = new List<ComponentSettings.Options>();

		// sObjectName
		ComponentSettings.Options sobjectName_config = new ComponentSettings.Options();
		sobjectName_config.label='Object Name';
		sobjectName_config.name='sobjectName';
		sobjectName_config.description='Enter Object Name';
		sobjectName_config.attrType=String.class;
		SelectOption[] sobjectName_configOptions = new List<SelectOption>();
		for (String s : Schema.getGlobalDescribe().keyset())
			sobjectName_configOptions.add(new SelectOption(s,s));
		sobjectName_config.options=sobjectName_configOptions;
		sobjectName_config.isRequired=true;
		sobjectName_config.defaultValue='account';
		results.add(sobjectName_config);

		// fieldCsv
		ComponentSettings.Options fieldCsv_config = new ComponentSettings.Options();
		fieldCsv_config.label='Field CSV';
		fieldCsv_config.name='fieldCsv';
		fieldCsv_config.description='Enter the fields separated by comma';
		fieldCsv_config.attrType=String.class;
		fieldCsv_config.options=new List<SelectOption>();
		fieldCsv_config.isRequired=false;
		fieldCsv_config.defaultValue='Name,Type,BillingState,Phone';
		results.add(fieldCsv_config);

		// searchable
		ComponentSettings.Options searchable_config = new ComponentSettings.Options();
		searchable_config.label='Is Searchable';
		searchable_config.name='searchable';
		searchable_config.description='Is the table searchable';
		searchable_config.attrType=Boolean.class;
		searchable_config.options=
			new List<SelectOption> {
				new SelectOption('true','True'),
				new SelectOption('false','False')
			};
		searchable_config.isRequired=false;
		searchable_config.defaultValue='true';
		results.add(searchable_config);


		// tableHeading
		ComponentSettings.Options tableHeading_config = new ComponentSettings.Options();
		tableHeading_config.label='Enter Heading';
		tableHeading_config.name='tableHeading';
		tableHeading_config.description='Enter Heading';
		tableHeading_config.attrType=String.class;
		tableHeading_config.options=new List<SelectOption>();
		tableHeading_config.isRequired=false;
		tableHeading_config.defaultValue='Account Table';
		results.add(tableHeading_config);

		// defaultPageSize
		ComponentSettings.Options defaultPageSize_config = new ComponentSettings.Options();
		defaultPageSize_config.label='Page Size';
		defaultPageSize_config.name='defaultPageSize';
		defaultPageSize_config.description='Enter Page Size';
		defaultPageSize_config.attrType=Integer.class;
		defaultPageSize_config.options=
			new List<SelectOption> {
				new SelectOption('5','5'),
				new SelectOption('10','10'),
				new SelectOption('15','15'),
				new SelectOption('20','20'),
				new SelectOption('25','25'),
				new SelectOption('50','50')
			};
		defaultPageSize_config.isRequired=false;
		defaultPageSize_config.defaultValue='5';
		results.add(defaultPageSize_config);

		return results;
	}
	
}