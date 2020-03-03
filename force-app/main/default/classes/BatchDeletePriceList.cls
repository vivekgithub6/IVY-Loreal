/*
Starting Batch Class for Pricing and Discount Record Creation
This batch will delete All Price list Data
*/
global class BatchDeletePriceList implements Database.Batchable<sObject>{
    public Set<string> countryCode=new Set<string>() ;
    public BatchDeletePriceList(set<String> code)
    {
        countryCode.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        string query='Select id,name from ivybase__Price_List__c where Market_ISO__c IN :countryCode';
        system.debug('countryCode'+countryCode+'='+query);
        return Database.getQueryLocator(query);
    }
    //Scope 5000 records
    global void execute(Database.BatchableContext bc, List<ivybase__Price_List__c> scope){
        delete scope;
    }
    global void finish(Database.BatchableContext bc){
        system.debug('countryCode'+countryCode);
        BatchDeleteDiscount batch = new BatchDeleteDiscount(countryCode);
        Database.executeBatch(batch,5000);
      
    }

}