global class DatatableCon extends ComponentBase {
     
    // Defines structure of JSON response - very specific to Datatables
    // 
    global class DataTableResponse {

        public Integer sEcho;
        public Integer iTotalRecords;
        public Integer iTotalDisplayRecords;
        public SObject[] data;

        DataTableResponse(Integer echo, Integer total, SObject[] sobs) {
            this.sEcho                  = echo;
            this.iTotalRecords          =  total;
            this.iTotalDisplayRecords   = total;
            this.data                 = sobs;
        }
    }
    
     /*
     * Datatable input structure that contains all options required to do the search
     */

    global class DataTable {

      global Integer iDisplayStart;
      global Integer iDisplayLength;
      global List<String> columns;
      global List<Integer> sortColumns;
      global List<String> sortDirections;
      global String searchString;

   }
    
    @RemoteAction
    global static DataTableResponse invokeSearch(DataTable request, String sobjectName) {

        DataTableResponse response;

        try {

            List<SObject> result = new List<SObject>();

            // Build a SOQL or SOSL based on the Search (global for now)

            String query = ''
                    + ' select ' + String.join(request.columns, ', ')
                    + ' from '   + sobjectName;

            String orderByClause = String.join(orderBys(request), ', ');

            // Check if any order by
            if (String.isNotBlank(orderByClause)) {
                query  += ' order by ' + orderByClause;
            }

            query   += ' limit :length'
                    +  ' offset :start';

            Integer totalNumberOfRecords = Database.countQuery('Select Count() from ' + sobjectName + ' LIMIT 40000'); //TO-DO check with Mac if any utility to get the total number of

            if (request.searchString != null && request.searchString.length() > 2) {
                query = 'find \''
                    + String.escapeSingleQuotes(request.searchString) +'*\''
                    + 'in all fields returning ' + sobjectName + '('
                    + String.join(request.columns, ', ');

                query = query.removeEnd(','); // Remove trailing ','

                if (String.isNotBlank(orderByClause)) {
                    query  += ' order by ' + orderByClause;
                }

                query = query.removeEnd(','); // Remove trailing ','

                // add limits and offsets
                query += ' limit :length'
                      + ' offset :start)';

            }

            Integer start  = request.iDisplayStart;
            Integer length = request.iDisplayLength;

            if (query.contains('find')) {
                result = Search.query(query)[0];
                totalNumberOfRecords = result.size();
            }else {
                result = Database.query(query);
            }

            response =  new DataTableResponse(
                    0,
                    totalNumberOfRecords,
                    result
                    );

        } catch (Exception e) {
            response = new DataTableResponse(0,0,new List<SObject>()); // Send back the empty response if exception
        }

        return response;
    }

    // Get the Order By from the Params , this for either ASC or DESC on columns for DataTables
    private static String[] orderBys(DataTable p) {

        Map<String, String> soqlDirections = new Map<String, String>{
                                                                        'asc' => 'asc nulls last',
                                                                        'desc' => 'desc nulls first'
                                                                    };
        String[] orderBys                  = new String[] {};
        Integer min                        = Math.min(p.sortColumns.size(), p.sortDirections.size());

        for (Integer i = 0; i < min; i++) {
            orderBys.add(''
                    + p.columns[p.sortColumns[i]]
                    + ' '
                    + soqlDirections.get(p.sortDirections[i])
                    );
        }

        return orderBys;

    }
    
    public class DatatableConfig extends Base {
        
        public String   sobjectName             {get;set;}
        public String   fieldSetName            {get;set;}
        public String   fieldCsv                {get;set;}
        public Boolean  searchable              {get;set;}
        public Boolean  sortable                {get;set;}
        public String   tableHeading            {get;set;}
        public String   defaultSortColumns      {get;set;}
        public String   defaultSortOrder        {get;set;}
        public Integer  defaultPageSize         {get;set;}
        public Boolean  editable                {get;set;}
        
    }
    
    // constructors for controller class.

    public DatatableCon() {
        super(new DatatableConfig());
    }

    public DatatableCon(DatatableConfig config) {
        super(config);
    }

    public DatatableConfig getConfig() {
        return (DatatableConfig)config;
    }
    
    public Map<String,String> getfieldLabelMap() {

        return getFieldLabelMap(getConfig().sobjectName); // returns the Map of Field Labels.
    }

    public String getfieldTypeMapJSON() {
        return JSON.serialize(getFieldTypeMap(getConfig().sobjectName));
    }
    
     // Get all the fields from the given Sobject in FieldCSV or FieldSet
    public List<String> getFields() {

        List<String> fields = new List<String>();

        if (String.isNotBlank(getConfig().fieldSetName)) {
            Schema.FieldSet fieldSet;

            for (Schema.FieldSet fSet : Schema.getGlobalDescribe().get(getConfig().sobjectName).getDescribe().fieldSets.getMap().values()) {
                if (fSet.getLabel().equalsIgnoreCase(getConfig().fieldSetName)) {
                    fieldSet = fSet;
                    break;
                }
            }

            if(fieldSet == null) {
                return null;
            }

            for (Schema.FieldSetMember fm : fieldSet.getFields()) {
                fields.add(fm.getFieldPath());
            }


        }
        else if (String.isNotBlank(getConfig().fieldCsv)) {
            for (String s : getConfig().fieldCsv.split(',')) {
                fields.add(s.trim());
            }

        }
        else {
            return null;
        }

        return fields;
    }
    
    @RemoteAction
    global static Map<String,String> getFieldLabelMap(String sobjectName) {
        Map<String, String> fieldLabelMap       = new Map<String, String>();
        Map<String, Schema.SObjectField> FsMap  = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap();

        for (String field : FsMap.keySet()) {
                fieldLabelMap.put(
                FsMap.get(field).getDescribe().getName(),
                FsMap.get(field).getDescribe().getLabel());
        }

        return fieldLabelMap;
    }
    
    @RemoteAction
    global static Map<String,String> getFieldTypeMap(String sobjectName) {
        Map<String, String> fieldTypeMap        = new Map<String, String>();
        Map<String, Schema.SObjectField> FsMap  = Schema.getGlobalDescribe().get(sobjectName).getDescribe().fields.getMap();

        for (String field : FsMap.keySet()) {
                fieldTypeMap.put(
                FsMap.get(field).getDescribe().getName(),
                FsMap.get(field).getDescribe().getType().name());
        }

        return fieldTypeMap;
    }

}