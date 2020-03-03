/*********************************************************************************
Trigger Name    : JourneyPlanApprovalTrigger
Description     : Used to send Journey plan records for Approval and craete visits
Created By      : NagaSai
Created Date    : June-2018
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
trigger JourneyPlanApprovalTrigger on JourneyPlan__c (after insert,after update) {
     list<JourneyPlan__c> JourneyPlanList=new list<JourneyPlan__c>();
    list<JourneyPlan__c> JourneyPlanListUpdateComments=new list<JourneyPlan__c>();
   set<id> JourneyPlanIds=new set<id>();
    set<id> LocationIds=new set<id>();
    Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'JourneyPlanApprovalTrigger'});
    if(triggerLogicMap.get('JourneyPlanApprovalTrigger') == Null || triggerLogicMap.get('JourneyPlanApprovalTrigger') == false){
    if(trigger.isAfter && trigger.isInsert){
         for(JourneyPlan__c j:trigger.new){
            if(j.Status__c=='Submitted')
                JourneyPlanList.add(j);
        }
    
   }
    if(trigger.isAfter && trigger.isUpdate){
        for(JourneyPlan__c j:trigger.new){
            if(trigger.oldmap.get(j.id).Status__c!='Submitted' && j.Status__c=='Submitted')
                  JourneyPlanList.add(j);
               if(trigger.oldmap.get(j.id).Status__c=='Submitted' && (j.Status__c=='Rejected'||j.status__c=='Approved'))
                  JourneyPlanListUpdateComments.add(j);
        }
    }
    system.debug('JourneyPlanList'+JourneyPlanList); 
    for(JourneyPlan__c j:JourneyPlanListUpdateComments){
        JourneyPlanIds.add(j.id);
        LocationIds.add(j.Territory__c);
    }
    if(JourneyPlanList.size()>0)
        JourneyPlanApprovalTriggerHandler.SubmitPlanForApproval(JourneyPlanList); 
    if(JourneyPlanListUpdateComments.size()>0)
        JourneyPlanApprovalTriggerHandler.UpdateApproverComments(JourneyPlanListUpdateComments);
    if(JourneyPlanIds.size()>0 && LocationIds.size()>0)
        JourneyPlanApprovalTriggerHandler.CreateVisits(JourneyPlanIds,LocationIds);
    }
}