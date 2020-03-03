@isTest
public class TESTRestRetailerContacts {
    private static testMethod void testRetailerContats(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT); 
                       
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('TestLocation Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'yes';
        update acc;
        
        Contact cont = new Contact(LastName='Test Contact',Internal_Id__c=1,Email='test@gmail.com',AccountId=acc.Id,Contact_Code__c='testCode',Experience__c=2,MobilePhone='12345',Signature__c='',Privacy__c=true,Social_Media_Id__c='media');
        insert cont;
        
        set<Id> accids = new Set<Id>{acc.Id};
         RetailerContactService.getContactRoleMap(accids);
        
        Test.startTest();
        RestRetailerContacts.getRetailerAdressInfo(); 
        Test.stopTest();
        
    }

}