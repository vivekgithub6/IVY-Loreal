@isTest
public class TestVisitTrigger {
    private static testMethod void testLastVisit(){
          ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        list<ivybase__Visit__c> Visitlist=new  list<ivybase__Visit__c>();
       ivybase__Visit__c visit1=TestUtility.createTestVisit(Date.today(),acc.id,'Completed');
         ivybase__Visit__c visit2=TestUtility.createTestVisit(Date.today(),acc.id,'Completed');
        Visitlist.add(visit1);
        Visitlist.add(visit2);
   insert Visitlist;
        
        
        ivybase__Visit__c visit3=TestUtility.createTestVisit(Date.today(),acc.id,'Completed');
        visit3.ivybase__Type__c = 'New';
        insert visit3;
    }
}