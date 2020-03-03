@isTest
public class TESTVisitService {
    private static testMethod void testVisitService(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'yes';
        update acc;
        Set<Id> accIds = new Set<Id>();
        accIds.add(acc.Id);
        
        
        
        Test.startTest();
        List<ivybase__Visit__c> visitList = new List<ivybase__Visit__c>();
        visitList.add(TestUtility.createTestVisit(Date.today().addDays(-2) , acc.Id ,''));
        visitList.add(TestUtility.createTestVisit(Date.today().addDays(-1) , acc.Id ,''));
        visitList.add(TestUtility.createTestVisit(Date.today() , acc.Id ,''));
        
        insert visitList;
        
        VisitService.getlast4VisitsbyRetailer(accIds);
        Test.stopTest();
    }

}