trigger VisitTrigger on ivybase__Visit__c (after insert,after update,before insert) {
    if((trigger.Isinsert || trigger.IsUpdate)&& trigger.isAfter){
          //updating vist date on store    
        UpdateLastVistDdate.UpdateLastVistDdate(trigger.new);//nhave to change later for optimization
        
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'VisitTrigger'});
        if(triggerLogicMap.get('VisitTrigger') == Null || triggerLogicMap.get('VisitTrigger') == false){
            //AccountService.UpdateAccountResourceLastVisitDate(trigger.new);
        }    
    }
    if(trigger.Isinsert && trigger.isBefore)
    {
        VisitTriggerHandler.UpdateSaloonType(trigger.new);
    }
}