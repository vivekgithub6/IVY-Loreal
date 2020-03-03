@isTest
public class TestRestSalesTarget {
    private static testMethod void testsalestarget(){
        ivybase__Resource_Type__c restyp = TestUtility.createTestResourceType('Merchandiser');
        id currentUserId=userinfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,restyp.id);
        insert res;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.id);
        lochr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        lochr.ivybase__Resource_Type__c=restyp.id;
        insert locHr;
        Sales_Forecast__c sfc= new Sales_Forecast__c(Target__c=300,Territory__c=locHr.id,Status__c='Draft',Date__c=Date.today().addMonths(1));
        //Name,Date__c,Target__c,Territory__c,Status__c,SuperVisorComments__c,
        //Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c
        insert sfc; 
        Test.startTest();
        RestSalesTarget.getpromotionplanMasterInfo();
        Test.stopTest();
    }
}