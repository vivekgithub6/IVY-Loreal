/*
Populate Field based on the Given criteria
*/
global class BatchPopulateFieldInObject implements Database.Batchable<sObject>{
    public string ObjectName;
    public string FieldName;
    public string Value;
    public BatchPopulateFieldInObject(String ObjName,String Field,String Val)
    {
        ObjectName=ObjName;
        FieldName=Field;
        Value=Val;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select id,'+FieldName+' from '+ObjectName+' where '+FieldName+'=Null';
        system.debug('query'+query);
        return Database.getQueryLocator(query);
    }
    //scope 5000
    global void execute(Database.BatchableContext bc, List<Sobject> scope){
        
       for(Sobject s:scope)
       {
           s.put(FieldName,Value);
       }
        Database.update(scope, false);
    }
    global void finish(Database.BatchableContext bc){
        
    }
    
}