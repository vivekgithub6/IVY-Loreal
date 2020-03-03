trigger LocationTrigger on ivybase__Location__c (before insert,before update) {
    
    if((trigger.isBefore && trigger.isInsert) || (trigger.isBefore && trigger.isUpdate)){        
        LocationTriggerHandler.populateResource(trigger.new);
    }
}