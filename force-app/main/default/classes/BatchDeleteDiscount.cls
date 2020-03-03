/*
BatchDeleteDiscount will delete all the discount mapping
*/
global class BatchDeleteDiscount implements Database.Batchable<sObject>{
    public Set<string> countryCode=new Set<string>() ;
    public BatchDeleteDiscount(set<String> code)
    {
        countryCode.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select id,name,ivydsd__Discount__c  from ivydsd__Discount_Mapping__c where Market_ISO__c IN :countryCode';
        return Database.getQueryLocator(query);
    }
    //scope 5000
    global void execute(Database.BatchableContext bc, List<ivydsd__Discount_Mapping__c> scope){
       	
        delete scope;
         
    }
    global void finish(Database.BatchableContext bc){
        BatchDeleteDiscountMaster batch = new BatchDeleteDiscountMaster(countryCode);
        Database.executeBatch(batch,50);
    }

}