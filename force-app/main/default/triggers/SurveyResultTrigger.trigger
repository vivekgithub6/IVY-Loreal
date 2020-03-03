trigger SurveyResultTrigger on ivybase__Survey_Result__c (before insert) {
    Boolean hasPermission = CustomSettingService.getTriggeroffValue();
    
    if(hasPermission == false){
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'ModuleWise_Last_Visit_Survey_Result'});
        if(triggerLogicMap.get('ModuleWise_Last_Visit_Survey_Result') == NULL || !triggerLogicMap.get('ModuleWise_Last_Visit_Survey_Result')) {
            
            if (Trigger.isAfter && Trigger.isInsert) {
                SurveyResultTriggerHandler.moduleWiseLastVisit(Trigger.new);
            }
            
        }
    }
}