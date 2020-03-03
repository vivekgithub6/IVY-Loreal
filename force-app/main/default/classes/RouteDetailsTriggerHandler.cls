public class RouteDetailsTriggerHandler {
    public static void updateAccount(list<ivybase__Route_Details__c> RouteDetailList){
        set<id> RouteIds=new set<id>();
        set<id> AccountIds=new set<id>();
        map<string,string> AccountRouteMap=new map<string,string>();
         map<string,string> AccountTerritoryMap=new map<string,string>();
        for(ivybase__Route_Details__c r:RouteDetailList){
         RouteIds.add(r.ivybase__Route__c);
            AccountIds.add(r.ivybase__Store__c);
            AccountRouteMap.put(r.ivybase__Route__c,r.ivybase__Store__c);
        }
        list<Territory_Routing__c> TerritoryRoutings=[SELECT Id, Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,Route__c FROM Territory_Routing__c WHERE Route__c IN :RouteIds];
        for(Territory_Routing__c Routing : TerritoryRoutings){
            if(AccountRouteMap.keySet().contains(Routing.Route__c))
              AccountTerritoryMap.put(AccountRouteMap.get(Routing.Route__c),Routing.Location_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
        }
      
        list<Account> Accountlist = [SELECT Location_Hierarchy__c FROM Account WHERE Id IN :AccountIds AND Location_Hierarchy__c = null];
        for(Account A:Accountlist) {
            A.Location_Hierarchy__c=AccountTerritoryMap.get(A.id);
        }
        update Accountlist;
    }
}