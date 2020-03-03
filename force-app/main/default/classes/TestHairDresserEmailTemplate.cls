@isTest
public class TestHairDresserEmailTemplate {
public static testmethod void contact1()
{
    ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
    Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
    Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '1234567892' , '1112223332' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        update acc2;
    
    Contact c = TestUtility.createTestContact('Test','Contact', userId , 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
    c.AccountId=acc2.id;
    insert c;
    HairDresserEmailTemplate email = new HairDresserEmailTemplate();
    email.contactId=c.id;
    email.getContactDetails();
    
}
}