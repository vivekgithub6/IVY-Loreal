global class HandlingInactivatedRecordsInAccountBatch implements Database.Batchable<sObject> {
    public Set<string> countryCode=new Set<string>() ;
    public HandlingInactivatedRecordsInAccountBatch(set<String> code)
    {
        countryCode.addAll(code);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query ='SELECT Id, Name, Last_Updated_Date_Time__c, ivybase__Active__c, ivybase__Status__c, Market_ISO__c FROM Account '
                +'WHERE Last_Updated_Date_Time__c != null AND RecordType.DeveloperName=\'Retail_Account\' AND Market_ISO__c IN :countryCode';
        system.debug('-->'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
    global void execute(Database.BatchableContext BC, List<Account> scope){
        //system.debug('scope->'+scope);
        // Query to get latest interface run deatils of customer master
        Map<String, DateTime> interfaceRunMap = new Map<String, DateTime>();
        for(Interface_Run__c ir : [SELECT Id, Interface_Run_Date_Time__c, Market_ISO__c FROM Interface_Run__c 
                                        WHERE Name ='CustomerMaster' AND Interface_Run_Date_Time__c != null AND Market_ISO__c IN :countryCode AND CreatedDate = TODAY
                                        ORDER BY CreatedDate DESC]) {
            interfaceRunMap.put(ir.Market_ISO__c, ir.Interface_Run_Date_Time__c);                     
        }
        list<account> AccListToBeUpdated = new list<account>();
        for(Account s : scope){
            if(interfaceRunMap != null && interfaceRunMap.containsKey(s.Market_ISO__c) == true && s.Last_Updated_Date_Time__c != interfaceRunMap.get(s.Market_ISO__c)) {
                
                s.ivybase__Active__c = 'No';
                s.ivybase__Status__c = 'Inactive';
                AccListToBeUpdated.add(s);
            }            
        }
        Update AccListToBeUpdated;
        system.debug('AccListToBeUpdated->'+AccListToBeUpdated);
    }
    
    global void finish(Database.BatchableContext BC){
        HandlingClosedInvoicesFromInterfaceBtch invBtch = new HandlingClosedInvoicesFromInterfaceBtch(countryCode);
        Database.executeBatch(invBtch);
    }
    
}