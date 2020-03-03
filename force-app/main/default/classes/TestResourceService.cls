@isTest
private class TestResourceService {

    static testMethod void testResourceServiceSuccess() {
    
        List<ivybase__Resource__c> resourceList = new List<ivybase__Resource__c>{new ivybase__Resource__c(Name = 'Test',Market_ISO__c='MY',ivybase__Related_User__c = UserInfo.getUserId())};
        insert resourceList;
        
        Id id = ResourceService.getLoginSellerId();
        ivybase__Resource__c resourceObject = ResourceService.getSellerId(UserInfo.getUserId());
        map<string,string> resourceListing = ResourceService.GetAllResources();
        
        
    }
}