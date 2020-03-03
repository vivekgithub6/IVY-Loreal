trigger TargetIncentiveTrigger on Target_Actual__c (before update, before insert,after insert) {
     Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'TargetIncentiveTrigger'});
    if(triggerLogicMap.get('TargetIncentiveTrigger') == Null || triggerLogicMap.get('TargetIncentiveTrigger') == false){
    list<Target_Actual__c> TargetActualList=new list<Target_Actual__c>();
        list<Target_Actual__c> ConquestTargetActualList=new list<Target_Actual__c>();
     
    if(Trigger.isUpdate && Trigger.isbefore){
        for(Target_Actual__c TargetActual: Trigger.new){
            if(TargetActual.Market_ISO__c.equalsignorecase('ph')  && TargetActual.Actual__c!=trigger.oldmap.get(TargetActual.id).Actual__c || TargetActual.ActualCoverage__c!=trigger.oldmap.get(TargetActual.id).ActualCoverage__c || TargetActual.Sales_Target_Acheivement__c!=trigger.oldmap.get(TargetActual.id).Sales_Target_Acheivement__c || TargetActual.Incentive_Group__c!=trigger.oldmap.get(TargetActual.id).Incentive_Group__c ){
                if(TargetActual.recordtype.developername!='Conquest' && TargetActual.Market_ISO__c.equalsignorecase('ph'))
                TargetActualList.add(TargetActual);
            }
            system.debug('TargetActual.ActualCoverage__c'+TargetActual.Actual__c);
            system.debug('trigger.oldmap.get(TargetActual.id).ActualCoverage__c'+trigger.oldmap.get(TargetActual.id).Actual__c);
       string recordtypename=Schema.SObjectType.Target_Actual__c.getRecordTypeInfosById().get(TargetActual.recordtypeid).getdevelopername();
           
            system.debug('rescordtype'+recordtypename);
            if((TargetActual.Actual__c!=trigger.oldmap.get(TargetActual.id).Actual__c || TargetActual.Incentive_Group__c!=trigger.oldmap.get(TargetActual.id).Incentive_Group__c) && recordtypename=='Conquest' && TargetActual.Market_ISO__c=='PH')
           ConquestTargetActualList.add(TargetActual); 
        }
        system.debug('TargetActualList'+TargetActualList);
        system.debug('ConquestTargetActualList'+ConquestTargetActualList);
        if(TargetActualList!=null && TargetActualList.size()>0)
        TargetIncentiveTriggerHandler.updateAchievement(TargetActualList);
    }
        if(ConquestTargetActualList.size()>0)
            TargetIncentiveTriggerHandler.UpdateAcheievementForConquest(ConquestTargetActualList);
        if(Trigger.isInsert && Trigger.isBefore){
            for(Target_Actual__c TargetActual: Trigger.new){
                //TargetActual.Achievement__c = null;
            } 
        }
    }
}