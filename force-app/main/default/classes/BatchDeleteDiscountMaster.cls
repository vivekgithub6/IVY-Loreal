/*
BatchDeleteDiscountMaster will delete all the discount details
*/
global class BatchDeleteDiscountMaster implements Database.Batchable<sObject>{
    public Set<string> countryCode=new Set<string>() ;
    public BatchDeleteDiscountMaster(set<String> code)
    {
        countryCode.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select id,name  from ivydsd__Discount__c where Market_ISO__c IN :countryCode';
        return Database.getQueryLocator(query);
    }
    //scope 50 records
    global void execute(Database.BatchableContext bc, List<ivydsd__Discount__c> scope){
        
        delete scope;
         
    }
    global void finish(Database.BatchableContext bc) {
        PricingMasterStageBatch batch = new PricingMasterStageBatch(CountryCode);
        Database.executeBatch(batch,1);
    }
}