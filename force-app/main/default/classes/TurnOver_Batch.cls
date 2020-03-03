// Batch Job for Processing the Records
global class TurnOver_Batch implements Database.Batchable<sobject> {
    
    
    // Start Method
    global Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator('Select id,Market_ISO__c from Account where  ivybase__Active__c=\'Yes\'');//Market_ISO__c=\'SG\' AND id=\'0010k00000oQlenAAC\' AND
        
    }
    
    // Execute method
    global void execute (Database.BatchableContext BC, List<Account> scope) {
        if(scope[0].Market_ISO__c!=null){
            string market=scope[0].Market_ISO__c;
            CreateTurnOverRecords.createTurnOvers(scope,market);
        }
    }
    
    // Finish Method
    global void finish(Database.BatchableContext BC) {
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
       if(vMapNameCustomSett.containsKey('BatchSalonInvoice_Resource') && vMapNameCustomSett.get('BatchSalonInvoice_Resource').SwitchOff__c==False){
            BatchSalonInvoice_Resource BSR= new BatchSalonInvoice_Resource();
            database.executebatch(BSR,1);
        }
    }
}