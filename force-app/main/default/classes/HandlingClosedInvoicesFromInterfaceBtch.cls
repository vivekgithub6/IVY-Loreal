/**
 * Created By : Ivy Mobility(Absyz Team)
 * Purpose : Used to update the Invoice Status to Collected when the Invocies has been updated by the Integration User
 * Test Class : HandlingInactivatedRecInAccountBatchTest
*/
global class HandlingClosedInvoicesFromInterfaceBtch implements Database.Batchable<sObject>{
    public Set<string> countryCodeSet = new Set<string>() ;
    public HandlingClosedInvoicesFromInterfaceBtch(Set<String> code)
    {
        countryCodeSet.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query ='select Id,name,Last_Updated_Date_Time__c,ivydsd__Invoice_Status__c from ivydsd__Invoice__c where Last_Updated_Date_Time__c != null and Market_ISO__c IN :countryCodeSet';
        //      system.debug('-->'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<ivydsd__Invoice__c> scope){
        
        // Query to get latest interface run deatils of aragin
        Interface_Run__c lastrun = [Select id,Interface_Run_Date_Time__c from Interface_Run__c where name ='Araging' and Interface_Run_Date_Time__c !=null  ORDER BY Interface_Run_Date_Time__c DESC limit 1];
        
        list<ivydsd__Invoice__c> InvListToBeUpdated = new list<ivydsd__Invoice__c>();
        for(ivydsd__Invoice__c s : scope){
            if(s.Last_Updated_Date_Time__c != lastrun.Interface_Run_Date_Time__c)
            {
                
                s.ivydsd__Invoice_Status__c = 'Collected';
                InvListToBeUpdated.add(s);
            }            
        }
        Update InvListToBeUpdated;
        //system.debug('InvListToBeUpdated->'+InvListToBeUpdated);
    }
    
    global void finish(Database.BatchableContext BC){
        List<CountryCodeMarketISO__mdt> countryCodeList = [SELECT Id, Country__c FROM CountryCodeMarketISO__mdt 
                                                           WHERE Country__c IN :countryCodeSet AND Pricing_Batch_Disable__c = true];
        for(CountryCodeMarketISO__mdt ccm : countryCodeList) {
            if(countryCodeSet != null && countryCodeSet.isEmpty() == false && countryCodeSet.contains(ccm.Country__c)) {
                countryCodeSet.remove(ccm.Country__c);
            }
        }
        if(countryCodeSet == null || countryCodeSet.isEmpty() == true) {
            upsertSuggestedQuantityBatch batch = new upsertSuggestedQuantityBatch(); 
       		database.executebatch(batch,10);
        } else {
            BatchDeletePriceList tb= new BatchDeletePriceList(countryCodeSet);
            database.executeBatch(tb);
        }
    }
    
}