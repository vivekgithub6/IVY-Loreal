public class RouteService {
    public static List<ivybase__Route__c> getCurrentUserRoutes(List<ivybase__Location_Hierarchy__c> currentuserTerritoryList,String uid) {
        
        String[] routeFields = new String[] {'Name', 'ivybase__Description__c', 'ivybase__Active__c','Location_Hierarchy_Territory__c','ivybat__Resources__c'}; 
        Set<Id> LocationHierarchyId = new Set<Id>();
        set<Id> RouteId = new Set<Id>();
        Set<Id> accountId = new Set<Id>();
        List<account> accountList = new List<Account>();
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        for(ivybase__Location_Hierarchy__c u:userTerritory)
        {
            LocationHierarchyId.add(u.id);  
        }
        system.debug('LocationHierarchyId'+LocationHierarchyId);
        List<Territory_Routing__c> territoryRouting = [ select Location_Hierarchy__c,Route__c from Territory_Routing__c where Location_Hierarchy__c=:LocationHierarchyId];
        for(Territory_Routing__c t:territoryRouting)
        {
            RouteId.add(t.Route__c); 
        }
        system.debug('RouteId'+RouteId);
        system.debug('RouteService::currentuserTerritoryList::'+currentuserTerritoryList +'uid:::'+uid);
        if (SecurityUtility.checkIsAccessible('ivybase__Route__c', routeFields)) { 
            return [
                    SELECT
                        Id,
                        Name,
                        ivybase__Description__c,
                        ivybase__Active__c
                    FROM
                        ivybase__Route__c WHERE ivybase__Active__c = 'Yes' 
                       AND Id IN:RouteId
            ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }

}
    public static Set<String> getUserRelatedRoutes()
    {
        Set<Id> LocationHierarchyId = new Set<Id>();
        set<String> RouteId = new Set<String>();
        Set<Id> accountId = new Set<Id>();
        List<account> accountList = new List<Account>();
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        for(ivybase__Location_Hierarchy__c u:userTerritory)
        {
            LocationHierarchyId.add(u.id);  
        }
        system.debug('LocationHierarchyId'+LocationHierarchyId);
        List<Territory_Routing__c> territoryRouting = [ select Location_Hierarchy__c,Route__c,Route__r.Name from Territory_Routing__c where Location_Hierarchy__c=:LocationHierarchyId];
        for(Territory_Routing__c t:territoryRouting)
        {
            RouteId.add(t.Route__r.Name); 
        }
        system.debug('RouteId'+RouteId);
		return   RouteId;      
    }
}