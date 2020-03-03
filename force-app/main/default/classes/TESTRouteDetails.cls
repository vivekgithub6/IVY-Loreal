@isTest
public class TESTRouteDetails {
    private static testMethod void testRouteDetails(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
         
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa', Is_Conquest__c = true,recordTypeId=accrecordTypeId, ivybase__Active__c='Yes');
        insert acc;
        
        Contact con = new Contact();
        con.Lastname = 'Testcon';
        con.Email = 'Test@gmail.com' ;
        con.ivybase__Related_User__c = UserInfo.getuserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;    
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.Sold_To_Party_Number__c = 'SOLD12';
        update acc; 
        Account acc2 = new Account(Name='aaa2', Is_Conquest__c = true,recordTypeId=accrecordTypeId,ivybase__Resource__c = res.Id);
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        acc2.Sold_To_Party_Number__c = 'SOLD123';
        update acc2;
        
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        routeDetail.ivybase__Store__c = acc2.Id;
        update routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert terrRouting;
        
        delete routeDetail;
     }

}