trigger SalesforecastingTrigger on Sales_Forecast__c (after insert,after update,before insert,before update) {
    
    if(trigger.isBefore && trigger.isInsert ){        
        SalesforecastingTriggerHandler.populateResource(trigger.new);
        SalesforecastingTriggerHandler.salesforecastValidation(trigger.new,null);
    }
    if(trigger.isBefore && trigger.isUpdate) {        
        SalesforecastingTriggerHandler.populateResource(trigger.new);
        SalesforecastingTriggerHandler.salesforecastValidation(trigger.new, trigger.oldMap);
    }    
    
    set<id> SalesforecastIds=new set<id>();
    list<Sales_Forecast__c> SalesforecastListUpdateComments=new list<Sales_Forecast__c>();
      Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'SalesforecastingTrigger'});
    if(triggerLogicMap.get('SalesforecastingTrigger') == Null || triggerLogicMap.get('SalesforecastingTrigger') == false){
    if(trigger.isAfter && trigger.isInsert){
        for(Sales_Forecast__c s:trigger.new){
            if(s.Status__c=='Submitted')
                SalesforecastIds.add(s.id);     
        }
    }
    if(trigger.isAfter && trigger.isUpdate){
        for(Sales_Forecast__c s:trigger.new){
            if(trigger.oldmap.get(s.id).Status__c!='Submitted' && s.Status__c=='Submitted')
                SalesforecastIds.add(s.id);
            //if(trigger.oldmap.get(s.id).Status__c=='Submitted' && (s.Status__c=='Rejected'||s.status__c=='Approved'))
               // SalesforecastListUpdateComments.add(s);
             if((trigger.oldmap.get(s.id).DummyUpdate__c != s.DummyUpdate__c ) && (s.DummyUpdate__c=='Approved'|| s.DummyUpdate__c=='Rejected'))
                SalesforecastListUpdateComments.add(s);
            
        }
    }
    if(SalesforecastIds.size()>0)
        SalesforecastingTriggerHandler.SubmitForApproval(SalesforecastIds);
    if(SalesforecastListUpdateComments.size()>0)
        //System.enqueuejob(new Salesforecastsubmiited(SalesforecastListUpdateComments));

        SalesforecastingTriggerHandler.UpdateApproverComments(SalesforecastListUpdateComments);
    }  
}