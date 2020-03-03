/*
PricingMasterStageBatch wil query Pricing_Master_Stage__c records and create Pricing_Stage_2__c records which are mapped to salesforce 
*/

global class PricingMasterStageBatch implements Database.Batchable<sObject>{
   public Set<string> countryCode=new Set<string>() ;
    public PricingMasterStageBatch(set<String> code)
    {
        countryCode.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select Name,Price__c,Pricing_Condition_Type__c,Status__c,Valid_From_Date__c,Valid_To_Date__c,Variable_Key__c,Variable_Key_Fields_Name__c,Market_ISO__c,CurrencyIsoCode  from Pricing_Master_Stage__c where Market_ISO__c IN :countryCode';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Pricing_Master_Stage__c> scope){
       	//scope will be 1 
       	for(Pricing_Master_Stage__c sc:scope){
            system.debug('sc'+sc);
				 PricingMapToSFEntity.getEntityMappedRecord(sc,sc.Market_ISO__c,sc.CurrencyIsoCode);
       	   }
    }
    global void finish(Database.BatchableContext bc){
        PricingMasterStage3Batch batch = new PricingMasterStage3Batch(CountryCode);
        Database.executeBatch(batch,1);
    }

}