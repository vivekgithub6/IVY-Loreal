@isTest
public class TESTJourneyPlanMarketVisitTranslator {
    private static testMethod void testJouPlanMarketVisit(){
        ivybase__Resource_Type__c resourceType=TestUtility.createTestResourceType('Test');
        insert resourceType;
                system.debug('curUserId'+userinfo.getUserId());
        ivybase__Resource__c resource = TestUtility.createTestResource('Test Resource',userInfo.getUserId(),resourceType.id);
        insert resource;
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
            
         Account a = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        Account a1 = TestUtility.createTestAccount('2' , 'Test Acc2' , '223456789' , '211222333' , resource.id , 'Retail_Account' , 'Yes' );
        
        
        List<ivybase__Standard_List_Master__c> assets=TestRestJourneyPlan.createTestStandardListMasterATSM(locationHierarchy.id,resourceType.id);
        
        Date d=Date.newInstance(2018,6,17);
        JourneyPlan__c journeyPlan = new JourneyPlan__c(Year__c=2018,Tid__c='555',Territory__c=locationHierarchy.id,
                                                        Status__c='Draft',Month__c=06,SupervisorComments__c='Test Comments',
                                                       Date__c=Date.today(), Market_ISO__c = 'MY');
        
        insert journeyPlan;
        
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c();
        journeyPlan2.Year__c=2018;
        journeyPlan2.Tid__c='535';
        journeyPlan2.Territory__c=locationHierarchy.id;
        journeyPlan2.Status__c='Draft';
        journeyPlan2.Month__c=10;
        journeyPlan2.SupervisorComments__c='Test Comments';
        journeyPlan2.Market_ISO__c = 'MY';
        Date d2=Date.newInstance(2018,10,27);
        journeyPlan2.Date__c=Date.today();
        insert journeyPlan2;
        
        JourneyPlanActivity__c journeyPlanActivty = new JourneyPlanActivity__c();
        journeyPlanActivty.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty.Date__c=Date.today();
        journeyPlanActivty.JourneyPlan__c=journeyPlan.id;
        journeyPlanActivty.Name=journeyPlan.Tid__c;
        journeyPlanActivty.TypeId__c=assets[0].id;
        journeyPlanActivty.Store__c = a.Id;
        journeyPlanActivty.Market_ISO__c = 'MY';
        insert journeyPlanActivty;
        
        JourneyPlanActivity__c journeyPlanActivty2 = new JourneyPlanActivity__c();
        journeyPlanActivty2.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty2.Date__c=Date.today();
        journeyPlanActivty2.JourneyPlan__c=journeyPlan2.id;
        journeyPlanActivty2.Name=journeyPlan.Tid__c;
        journeyPlanActivty2.TypeId__c=assets[0].id;
        journeyPlanActivty2.Store__c = a1.Id;   
        journeyPlanActivty2.Market_ISO__c = 'MY';
        insert journeyPlanActivty2;
        
        JourneyPlanMarket_Visit__c marketVisit = new JourneyPlanMarket_Visit__c();
        marketVisit.name=journeyPlan.Tid__c;
        marketVisit.Date__c=d;
        marketVisit.JourneyPlan__c=journeyPlan.id;
        marketVisit.Store__c=a.id;
        marketVisit.Market_ISO__c = 'MY';
        insert marketVisit;
        
        JourneyPlanMarket_Visit__c marketVisit2 = new JourneyPlanMarket_Visit__c();
        marketVisit2.name=journeyPlan.Tid__c;
        marketVisit2.Date__c=d;
        marketVisit2.JourneyPlan__c=journeyPlan.id;
        marketVisit2.Store__c=a1.id;
        marketVisit2.Market_ISO__c = 'MY';
        insert marketVisit2;
        
        JourneyPlanMarket_Visit__c marketVisit3 = new JourneyPlanMarket_Visit__c();
        marketVisit3.name=journeyPlan2.Tid__c;
        marketVisit3.Date__c=d2;
        marketVisit3.JourneyPlan__c=journeyPlan2.id;
        marketVisit3.Store__c=a.id;
        marketVisit3.Market_ISO__c = 'MY';
        insert marketVisit3;
        
        JourneyPlanMarket_Visit__c marketVisit4 = new JourneyPlanMarket_Visit__c();
        marketVisit4.name=journeyPlan2.Tid__c;
        marketVisit4.Date__c=d2;
        marketVisit4.JourneyPlan__c=journeyPlan2.id;
        marketVisit4.Store__c=a1.id;
        marketVisit4.Market_ISO__c = 'MY';
        insert marketVisit4;
    }

}