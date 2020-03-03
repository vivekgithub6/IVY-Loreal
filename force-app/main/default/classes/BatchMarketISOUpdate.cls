global class BatchMarketISOUpdate implements Database.Batchable<sObject> {

    public string sObj;
    public BatchMarketISOUpdate(String sobj1) {
        sObj = sobj1;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query='SELECT Id, Name, Market_ISO__c FROM ' + sObj + ' WHERE Market_ISO__c = null';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<SObject> scope) {
    
        for(SObject obj : scope) {
            obj.put('Market_ISO__c', 'PH');
        }
        update scope;
    }
    global void finish(Database.BatchableContext bc){
    }
}