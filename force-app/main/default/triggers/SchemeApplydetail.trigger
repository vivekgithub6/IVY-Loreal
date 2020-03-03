trigger SchemeApplydetail on ivydsd__Scheme_Apply_Detail__c (after insert,after Update) {
    Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'SchemeApplydetail'});
    if(triggerLogicMap.get('SchemeApplydetail') == Null || triggerLogicMap.get('SchemeApplydetail') == false){
        SchemeApplyDetailTriggerHandler.getschemeappliedvalue(Trigger.new);
    }
}