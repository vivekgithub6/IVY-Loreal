@RestResource(urlMapping='/v1/RetailerMaster/Masters/')
global with sharing class RESTRetailerManager {
    
    @HttpGet
    global static RExAPIResponseDomain.ResponseInfo getDistributorMasters() {
       
        RExAPIResponseDomain.ResponseInfo accInfo;
        
        Set<Id> storeHierachySet = new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> locationHierarcyIdSet = new Set<Id>();
        Map<Id,ivybase__Location_Hierarchy__c > locationIdMap = new Map<Id,ivybase__Location_Hierarchy__c>();
        Map<Id,ivybase__Store_Hierarchy__c> storeHierarchyMap = new  Map<Id,ivybase__Store_Hierarchy__c>();
        Map<Id,List<String>> storeAndRouteListMap = new Map<Id,List<String>>();
        
        Map<Id, Map<String, Boolean>> accIdwithSetOfTerritoryInternalIdMap = new Map<Id, Map<String, Boolean>>();
        
        try {
            /*ivybase__Global_Configuration__mdt  gc = ivybase.GlobalConfigurationService.getGlobalConfig();
            Boolean isCustomTerritory = false;
            Boolean isStoreMultiTerritory = false;
            if (gc != null) {
                if (gc.ivybase__Active_Custom_Territory__c) {
                    isCustomTerritory = true;
                }
                if (gc.ivybase__Active_Store_Multi_Territory__c) {
                    isStoreMultiTerritory = true;
                }
            }*/
            System.debug('Calling Account Service');
            List< Account > accRouteList = AccountService.getAllRetailerMaster_List_for_Resource();
            System.debug('accRouteList::'+accRouteList.size());
            Set<Account> setOFAccount = new Set<Account>();
            //setOFAccount.addAll(ac);
            setOFAccount.addAll(accRouteList);
            List<Account> accList= new List<Account>();
            accList.addAll(setOFAccount);
            system.debug('accList  '+accList.size());
            //system.debug(':::isCustomTerritory::::'+isCustomTerritory);
            
            for(Account acc :accList){
                if(acc.ivybase__Store_Hierarchy__c != null) {
                    storeHierachySet.add(acc.ivybase__Store_Hierarchy__c);
                }
                if(acc.Location_Hierarchy__c != null) {
                    locationHierarcyIdSet.add(acc.Location_Hierarchy__c);
                }
                accIdSet.add(acc.Id);
            }
            //if (!isCustomTerritory && !isStoreMultiTerritory) {
            system.debug('locationHierarcyIdSet'+locationHierarcyIdSet);
                locationIdMap = LocationMasterService.getAllLocationMasterMapByLocId(locationHierarcyIdSet);
            
            /*} else {
                system.debug(':::::accIdSet::::'+accIdSet);
                accIdwithSetOfTerritoryInternalIdMap = ivybase.TerritoryFacade.getStoreRelatedTerritory(accIdSet);
                system.debug('::::accIdwithSetOfTerritoryInternalIdMap::1:::'+accIdwithSetOfTerritoryInternalIdMap);
            }*/
            
            storeAndRouteListMap  = ivybase.RouteFacade.getRoutenamewithStoreId_Map(accIdSet);
            Set<String> userRelatedRoute=RouteService.getUserRelatedRoutes();
            system.debug('storeAndRouteListMap'+storeAndRouteListMap);
	system.debug('storeAndRouteListMap size '+storeAndRouteListMap.keyset().size());
            storeHierarchyMap = ivybase.StoreHierarchyFacade.getChannelIdByStoreHieIds(storeHierachySet);
            system.debug(':::accIdwithSetOfTerritoryInternalIdMap::'+accIdwithSetOfTerritoryInternalIdMap);
            accInfo = RetailerMasterTranslator.objectToRetailerInfo(accList,storeHierarchyMap,storeAndRouteListMap,locationIdMap,userRelatedRoute, null);
            
        } catch (SecurityUtility.SFDCAccessControlException ex) {
        
            accInfo = RetailerMasterTranslator.objectToRetailerInfo(null, null, null, null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
        }
        return accInfo ;
    }
}