@isTest
public class TESTRestRetailerVisitMappingMaster {
    private static testMethod void testRetailer(){
        Id userId = UserInfo.getUserId();
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType;
        
        ivybase__Location_Hierarchy__c locHrEndmarket = new ivybase__Location_Hierarchy__c(Name='Jon Area Location2',Market_ISO__c='MY');
        locHrEndmarket.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : 'National' Limit 1].Id;
        insert locHrEndmarket;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Resource',Market_ISO__c='MY',ivybase__Related_User__c=userId,ivybase__Resource_Type__c=resType.Id,ivybase__Location_Hierarchy__c=locHrEndmarket.Id);
        insert resource;
        
        Id territory = [Select Id from RecordType Where DeveloperName='Territory' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c='MY',RecordTypeId=territory,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert location; 
        
        Id retail = [Select Id from RecordType Where DeveloperName='Retail_Account' 
                                                  AND SobjectType='Account'].Id;
        system.debug('retail'+retail);
        
        Account acc = new Account(Name='Test Store',Market_ISO__c='MY',Is_Conquest__c = true,ivybase__Resource__c=resource.Id,RecordTypeId=retail,ivybase__Location_Hierarchy__c=location.Id,ivybase__Active__c='Yes',ivybase__Status__c='Active',Active__c='Yes');
        insert acc;
        acc.Active__c='Yes';
        acc.ivybase__Active__c='Yes'; 
        update acc;
        
        JourneyPlan__c journeyPlan = new JourneyPlan__c(Territory__c=location.Id,Market_ISO__c='MY',Status__c='Approved',Month__c= Date.Today().Month(),Date__c=Date.today(),Year__c=Date.today().Year());
        insert  journeyPlan;
        
        JourneyPlanMarket_Visit__c journeyMarket = new JourneyPlanMarket_Visit__c(Store__c=acc.Id,Market_ISO__c='MY',JourneyPlan__c=journeyPlan.Id,Date__c=System.today());
        insert journeyMarket;
        
        JourneyPlanActivity__c journeyActivity = new JourneyPlanActivity__c(JourneyPlan__c=journeyPlan.Id,Market_ISO__c='MY',Store__c=acc.Id,Date__c=system.today());
        insert journeyActivity;
        System.debug('journeyActivity:: '+journeyActivity);
         
        Test.startTest();
        RestRetailerVisitMappingMaster.getRetailerCleintMappingInfo(); 
        Test.stopTest();
        
    }
    
    @isTest
    private static void  testRetailerVisitMappingException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
                RestRetailerVisitMappingMaster.getRetailerCleintMappingInfo();
            }Catch(Exception ex) {
            }
        }
        Test.stoptest();
    }
}