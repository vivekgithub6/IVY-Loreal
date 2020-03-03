public class RetailerVisitService {
    public static list<JourneyPlanActivity__c> getRetailervisitmap(){
          Id sellerId = ResourceService.getLoginSellerId();
       set<id> TerritoryIds=new set<id>();
        list<ivybase__Location_Hierarchy__c> TerritoryList=[select id from ivybase__Location_Hierarchy__c where ivybase__Primary_Resource__c=:sellerId];
       system.debug('TerritoryList'+TerritoryList);
        for(ivybase__Location_Hierarchy__c Territory:TerritoryList)
           TerritoryIds.add(Territory.id);
        system.debug('system.today()'+date.today());
    list<JourneyPlanActivity__c> JourneyPlanVisitrecords=[select Store__r.ivybase__Internal_Id__c,Date__c from JourneyPlanActivity__c where JourneyPlan__r.Territory__c in:TerritoryIds and JourneyPlan__r.Status__c='Approved' and Date__c=:system.today() and Store__c!=null];
        system.debug('JourneyPlanVisitrecords'+JourneyPlanVisitrecords);    
        return JourneyPlanVisitrecords;
    }
}