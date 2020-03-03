global class ActivityCalculationBatch implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String MarketISo = 'JPN';
        String query = 'SELECT ID,NAME, Market_ISO__c, ivybase__Related_User__c FROM ivybase__Resource__c  WHERE Market_ISO__c =: MarketISo ';
        system.debug('query ** '+ query);
        return database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, LIST<ivybase__Resource__c> resourceList) {
       
        system.debug('resourceList** '+ resourceList);
        ActivityCalculationBatchHandler.CalculateRecords(resourceList);
        
        
    }
    global void finish(Database.BatchableContext bc) {
        
        
    }
    
    
    

}