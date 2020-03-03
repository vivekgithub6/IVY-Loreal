trigger SurveyQuestionTrigger on ivybase__Survey_Question__c (before insert, before update,after insert,after update,after delete) {
    
    //Boolean hasPermission = CustomPermissionService.getByPassTriggerValue();
    Boolean hasPermission = CustomSettingService.getTriggeroffValue();
    
    if(hasPermission == false) {
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck2(new Set<String>{'Survey_Question_Duplication','Survey_Question_Validation','Survey_Question_weight_Calculation'});
        
        if(Trigger.isBefore) {
            
            if(Trigger.isInsert) {
                if(triggerLogicMap.get('Survey_Question_Duplication') == Null 
                        || triggerLogicMap.get('Survey_Question_Duplication') == false) {
                    
                    SurveyQuestionTriggerHandler.checkDup(Trigger.new, NULL);
                }
                if(triggerLogicMap.get('Survey_Question_Validation') == Null 
                        || triggerLogicMap.get('Survey_Question_Validation') == false) {
                    
                    SurveyQuestionTriggerHandler.checkQuestion(Trigger.new, NULL);
                }
            }
            
            if(Trigger.isUpdate) {
                if(triggerLogicMap.get('Survey_Question_Duplication') == Null 
                        || triggerLogicMap.get('Survey_Question_Duplication') == false) {
                    
                    SurveyQuestionTriggerHandler.checkDup(Trigger.new, Trigger.oldMap);
                }
                if(triggerLogicMap.get('Survey_Question_Validation') == Null 
                        || triggerLogicMap.get('Survey_Question_Validation') == false) {
                
                    SurveyQuestionTriggerHandler.checkQuestion(Trigger.new, Trigger.oldMap);
                }
            }
        }
        
        
        if(triggerLogicMap.get('Survey_Question_weight_Calculation') == Null 
                    || triggerLogicMap.get('Survey_Question_weight_Calculation') == false) {
            if(Trigger.isAfter){
                
                if(Trigger.isInsert){
                    SurveyQuestionTriggerHandler.getsurveyIds(Trigger.new, NULL);
                }
                if(Trigger.isUpdate){
                    SurveyQuestionTriggerHandler.getsurveyIds(Trigger.new, Trigger.oldMap);
                }
                if(Trigger.isDelete){
                    SurveyQuestionTriggerHandler.getsurveyIds(Trigger.old, NULL);
                }
            }
        }
    }
}