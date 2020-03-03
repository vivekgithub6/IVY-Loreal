/*********************************************************************************
Trigger Name    : JourneyPlanApprovalTriggerHandler
Description     : Used to send Journey plan records for Approval. 
Created By      : NagaSai
Created Date    : June-2018
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
public class JourneyPlanApprovalTriggerHandler {
    public static void SubmitPlanForApproval(list<JourneyPlan__c> JourneyPlanList){
        map<string,string> JourneyplanIdOwnerIdMap=new map<string,string>();
        List<String> resourceTypeNameList = new List<String>{'Area','Regional','National'};
           // list<JourneyPlan__c> journeyList=[select Territory__r.ivybase__Primary_Resource__c,Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__c from JourneyPlan__c where id in:JourneyPlanList];
        Id submitterId = UserInfo.getUserId();
        Map<String,Id> ApproverIdSet=new Map<String,Id>(); 
        ApproverIdSet=   ApproverIds.getAllLevelApproverIds(submitterId);
        system.debug('ApproverIds'+ApproverIdSet);
        
        string Approverid;
        for(Integer i = 0; i < resourceTypeNameList.size(); i++){
            if(Approverid==Null){
                if(ApproverIdSet.get(resourceTypeNameList[i])!=Null)
                    Approverid=ApproverIdSet.get(resourceTypeNameList[i]);
            }
        }
        set<id> jpid = new set<id>();
        for(JourneyPlan__c j:JourneyPlanList){
            // Create an approval request for the Opportunity
            if(Approverid!=Null){
                if(Approval.isLocked(j.id)==false){
                    jpid.add(j.id);
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval');
            req1.setObjectId(j.id);
            req1.setNextApproverIds(new Id[] {Approverid});
            // Submit the approval request for the Opportunity
            Approval.ProcessResult result = Approval.process(req1); 
                }
            }
        }
        List<Id> OrderIdList = new List<Id>(jpid);
            if(OrderIdList.size()>0){
                Approval.unlock(OrderIdList,false);
            }
    }
   @AuraEnabled
public static string ApproveOrReject(string journeyplanid,string Action,string Comments){
    system.debug('Comments'+Comments);
        Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
        req.setComments(Comments);
        req.setAction(Action);
        //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
        ProcessInstanceWorkitem workItem=[Select p.Id from ProcessInstanceWorkitem p
                                          where p.ProcessInstance.TargetObjectId =: journeyplanid];
        Id workItemId = workItem.id; 
        req.setWorkitemId(workItemId);
        // Submit the request for approval
        Approval.ProcessResult result =  Approval.process(req);
        return Action;
    }
    public static void UpdateApproverComments(list<JourneyPlan__c> JourneyPlanList){
        system.debug('JourneyPlanList'+JourneyPlanList);
        set<id> JourneyPlanIds=new set<id>();
        map<id,string> CommentsMap=new map<id,string>();
        set<id> processInstanceIds=new set<id>();
        for(JourneyPlan__c j:JourneyPlanList)
            JourneyPlanIds.add(j.id);
         list<JourneyPlan__c> journeylistToUpdate=[select id,SupervisorComments__c from JourneyPlan__c where id in:JourneyPlanIds];
     for (JourneyPlan__c a : [SELECT Id,(SELECT ID FROM ProcessInstances  ORDER BY CreatedDate DESC) FROM JourneyPlan__c WHERE ID in:JourneyPlanIds])
{
    for(ProcessInstance pi :a.ProcessInstances)
        processInstanceIds.add(pi.Id);
}
        for (ProcessInstance pi : [SELECT TargetObjectId,(SELECT Id, StepStatus, Comments  FROM Steps  ORDER BY CreatedDate DESC )
                                   FROM ProcessInstance WHERE Id IN :processInstanceIds ORDER BY CreatedDate DESC limit 1]){
                
                                          system.debug('com'+pi.steps); 
                                        
                                       system.debug('pi.Steps[0]'+pi.Steps[0]);
                                       if(pi.Steps[0].Comments!=Null)
                                       CommentsMap.put(pi.TargetObjectId,pi.Steps[0].Comments);

                                   }
         
system.debug('CommentsMap'+CommentsMap);  
        for(JourneyPlan__c j:journeylistToUpdate){
            if(CommentsMap.keyset().contains(j.id))
            j.SupervisorComments__c=CommentsMap.get(j.id);
        }
        update journeylistToUpdate;
}
     public static void CreateVisits(set<id> JourneyPlanIds,set<id> locationids){
        map<string,string> TerritoryResourcemap=new map<string,string>();
        list<JourneyPlanActivity__c> JourneyPlanActivity=[select id,Date__c,Store__c,JourneyPlan__r.Territory__c from JourneyPlanActivity__c where JourneyPlan__c in:JourneyPlanIds  and Store__c!=Null and Date__c!=Null];
     list<ivybase__Location_Hierarchy__c> Terrotrylist=[select ivybase__Primary_Resource__c from ivybase__Location_Hierarchy__c where id in:locationids];
        list<ivybase__Visit__c> VisitList=new list<ivybase__Visit__c>();
        for(ivybase__Location_Hierarchy__c l:Terrotrylist)
           TerritoryResourcemap.put(l.id,l.ivybase__Primary_Resource__c); 
        for(JourneyPlanActivity__c j:JourneyPlanActivity ){
            ivybase__Visit__c visit=new ivybase__Visit__c();
            visit.ivybase__Original_Date__c=j.Date__c;
            visit.ivybase__Store__c=j.Store__c;
            visit.ivybase__Resource__c=TerritoryResourcemap.get(j.JourneyPlan__r.Territory__c);
            visit.ivybase__Type__c='Planned';
            visit.JourneyPlan_Activity__c=j.id;
            
            VisitList.add(visit);
        }
        if(VisitList.size()>0)
            insert VisitList;
    }

}