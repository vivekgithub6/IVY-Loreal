@RestResource(UrlMapping='/v1/BeatMaster/Masters/*')
global with sharing class RESTBeatManager{

    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getBeatInfo () {
        
        RExAPIResponseDomain.ResponseInfo beatResponse = new RExAPIResponseDomain.ResponseInfo();
        try {
           // Id resourceId = ResourceService.getLoginSellerId();
            ivybase__Resource__c resource= ResourceService.getSellerId(userInfo.getUserId());

            system.debug('resource:::'+resource);
            
            List<ivybase__Location_Hierarchy__c> currentuserTerritoryList = LocationMasterService.getCurrentUserTerritory(resource.Id);
            system.debug('currentuserTerritoryList:::'+currentuserTerritoryList);
            
            List<ivybase__Route__c> routeList = RouteService.getCurrentUserRoutes(currentuserTerritoryList,resource.Id); 
            system.debug('routeList:::'+routeList);
            
            beatResponse = RouteTranslator.objectToBeatMaster(routeList, null);        
        } catch (SecurityUtility.SFDCAccessControlException ex) {
            
            beatResponse = RouteTranslator.objectToBeatMaster(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
        }
        return beatResponse;
    }
}