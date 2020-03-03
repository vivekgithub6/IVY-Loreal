/*
 * Created By : Ivy Mobility(Absyz Team)
 * Purpose : Used to delete the Pricing Stage 2 records
 * Test Class : TESTDeletePricingStageScheduler
*/
global class BatchDeletePricingStage2 implements Database.Batchable<sObject>{
    public Set<String> countryCodeSet = new Set<String>() ;
    public BatchDeletePricingStage2(Set<String> code)
    {
        countryCodeSet.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        
         List<CountryCodeMarketISO__mdt> countryCodeList = [SELECT Id, Country__c FROM CountryCodeMarketISO__mdt 
                                                           WHERE Country__c IN :countryCodeSet AND Pricing_Batch_Disable__c = true];
        for(CountryCodeMarketISO__mdt ccm : countryCodeList) {
            if(countryCodeSet != null && countryCodeSet.isEmpty() == false && countryCodeSet.contains(ccm.Country__c)) {
                countryCodeSet.remove(ccm.Country__c);
            }
        }
        
        string query='SELECT Id FROM Pricing_Stage_2__c WHERE Market_ISO__c IN :countryCodeSet';
        return Database.getQueryLocator(query);
    }
    //scope 5000 records
    global void execute(Database.BatchableContext bc, List<Pricing_Stage_2__c> scope){
        delete scope;
    }
    global void finish(Database.BatchableContext bc){
        List<CountryCodeMarketISO__mdt> countryCodeList = [SELECT Id, Country__c FROM CountryCodeMarketISO__mdt 
                                                           WHERE Country__c IN :countryCodeSet AND Pricing_Batch_Disable__c = true];
        for(CountryCodeMarketISO__mdt ccm : countryCodeList) {
            if(countryCodeSet != null && countryCodeSet.isEmpty() == false && countryCodeSet.contains(ccm.Country__c)) {
                countryCodeSet.remove(ccm.Country__c);
            }
        }
        if(countryCodeSet == null || countryCodeSet.isEmpty() == true) {} else {
            BatchDeletePricingStage3 batch = new BatchDeletePricingStage3(countryCodeSet);
            Database.executeBatch(batch,10000);
        }
    }
}