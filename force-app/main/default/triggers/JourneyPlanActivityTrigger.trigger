trigger JourneyPlanActivityTrigger on JourneyPlanActivity__c (after insert) {
    
    SET<Id> JourneyPlanIdSet = new SET<Id>(); // To store journeyPlan Ids
    // Checking for insert
    if(trigger.isInsert) {
       //SET<Id> JourneyPlanIdSet = new SET<Id>();
        for(JourneyPlanActivity__c jpa : Trigger.new) {
            
            system.debug('market ISO' +jpa.Market_ISO__c);
            /* Chacking if journey plan is not empty */
            if(jpa.JourneyPlan__c != NULL && jpa.Market_ISO__c=='JPN') {
                JourneyPlanIdSet.add(jpa.JourneyPlan__c);
            }
        }
        
    }
    
    /* Calling hanlder methods */
    if(JourneyPlanIdSet.size()>0) {
        
        /* Calling  handler methods */
        JourneyPlanActivityTriggerHandler.handlerMethod(JourneyPlanIdSet);
    }

}