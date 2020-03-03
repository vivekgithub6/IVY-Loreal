/*
 * Block comments with details of changes
 * last Modified by pranav on 2/12/2018 in  dev org
 */
global class ActiveListOfCustomersBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc){
        Integer month = date.Today().month();
        string query='Select id,Resource__c,Actual__c,Achievement__c from Target_Actual__c where Resource__c != null AND Parameter_type__c=\'Active No Of Customers\' AND Month__c ='+month+'';
        return Database.getQueryLocator(query);
    } 
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> targets){
        system.debug('targets::'+targets);
        
        Map<Id,Set<Account>> AllAccountResourceMap= AccountService.get_All_Retailer_For_All_Resource();
        for(Target_Actual__c target : targets){
            if(AllAccountResourceMap != null && AllAccountResourceMap.containskey(target.Resource__c) && AllAccountResourceMap.get(target.Resource__c) != null)
                target.Actual__c=AllAccountResourceMap.get(target.Resource__c).size(); 
        }
        update targets;
        
    }
    global void finish(Database.BatchableContext bc){ 
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('GainOfClientsBatch') && vMapNameCustomSett.get('GainOfClientsBatch').SwitchOff__c==false){
            GainOfClientsBatch batch = new GainOfClientsBatch();
        Database.executeBatch(batch); 
        }
    }

}