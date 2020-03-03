@isTest
public class TestRestActualWorkingDaysKPI {

    public static testMethod void testMethodOne() {
        
        ivybase__Resource_Type__c  resourceType = TestUtility.createTestResourceType('Sales Rep');
        insert resourceType;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,resourceType.id);
        res.SAP_Id__c = '1234578';
        insert res;
        
        
        Market_Visit_Calculation__c mvc = new Market_Visit_Calculation__c();
        mvc.Month__c = '2';
        mvc.Year__c = '2020';
        mvc.Number_Of_Working_Days__c = 0.5;
        mvc.Resource__c = res.id;
        insert mvc;
        
        Test.starttest();
        RestActualWorkingDaysKPI.getWorkingDaysKPI();
        Test.stopTest();
        
    }
}