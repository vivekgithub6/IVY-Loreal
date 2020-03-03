/*
BatchDeletePricingStage3 will delete all Pricing_Stage_3__c records
*/
global class BatchDeletePricingStage3 implements Database.Batchable<sObject>{
    public Set<string> countryCode=new Set<string>() ;
    public BatchDeletePricingStage3(set<String> code)
    {
        countryCode.addAll(code); 
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select Id from Pricing_Stage_3__c where Market_ISO__c IN :countryCode';
        return Database.getQueryLocator(query);
    }
    //scope 5000 records
    global void execute(Database.BatchableContext bc, List<Pricing_Stage_3__c> scope){
        delete scope;
    }
    global void finish(Database.BatchableContext bc){ }
}