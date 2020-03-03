@isTest
public class TESTRESTRetailerContact {
    private static testMethod void testRetialerContact(){
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
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'yes';
        update acc;
        
        List<Account> accList = new List<Account>();
        accList.add(TestUtility.createTestAccount('1' , 'BillTest Acc' , '123456789' , '111222333' , res.Id, 'Retail_Account' , 'Yes'));
        accList.add(TestUtility.createTestAccount('1' , 'ShipTest Acc' , '123456789' , '111222333' , res.Id, 'Retail_Account' , 'Yes'));
        
        for(Account ac : accList){
            ac.ivybase__Active__c = 'yes';
            ac.ivybase__Resource__c = null;
            ac.Converted_to_Normal_Saloon__c = true;
            ac.ivybase__StoreCode__c  = null;
        }
        insert accList;
        for(Account ac : accList){
           ac.ivybase__Active__c = 'yes'; 
        }
        update accList;
        
        List<Partner_Function__c> partner = new List<Partner_Function__c>{
           new  Partner_Function__c(Account__c=acc.Id,Type__c='Bill To',Partner__c=accList[0].Id,Market_ISO__c ='MY'),
           new  Partner_Function__c(Account__c=acc.Id,Type__c='Ship To',Partner__c=accList[1].Id,Market_ISO__c ='MY')
        };
        insert partner;
            
        Test.startTest();
        RESTRetailerContact.getRetailerContactInfo();
        Test.stopTest();
        
    }

}