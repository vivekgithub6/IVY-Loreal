trigger SurveyTrigger on ivybase__Survey__c(before insert, before update) {
    
    //Boolean hasPermission = CustomPermissionService.getByPassTriggerValue();
    Boolean hasPermission = CustomSettingService.getTriggeroffValue();
    
    if(hasPermission == false){
    
        //Added metadata switch SFDC-704
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck2(new Set<String>{ 'Skip_Survey_Duplication_Check_Logic' });
        
        if(triggerLogicMap.get('Skip_Survey_Duplication_Check_Logic') == NULL || triggerLogicMap.get('Skip_Survey_Duplication_Check_Logic') == FALSE) {
        
            if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
                    
                SurveyTriggerHandler.checkDup(Trigger.new, Trigger.oldMap);
            }
        }
    }
}