@isTest
public class TestBatchCreateSalesKPITargetActual {
    public static testmethod void createKPIRecords()
    {
        Test.startTest();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT.get('Sales_KPI').getRecordTypeId());
        //sales kpi record type
        Id salesKPIRecordTypeId = RT.get('Sales_KPI').getRecordTypeId();
        Date todayDate = system.today();
        //this month in integer
        Integer thisMonth=todayDate.month();
        system.debug('d.month'+thisMonth);
        
        BatchCreateSalesKPITargetActual saleskpi = new BatchCreateSalesKPITargetActual();
        database.executeBatch(saleskpi);
        Test.stopTest();
        List<Target_Actual__c> targetActual  = [select id,name from Target_Actual__c where RecordTypeId=:salesKPIRecordTypeId and Month__c=:thisMonth];
        system.assertEquals(1, targetActual.size());           
    }
    public static testmethod void exisitingKPIRecords()
    {
        Test.startTest();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT.get('Sales_KPI').getRecordTypeId());
        //sales kpi record type
        Id salesKPIRecordTypeId = RT.get('Sales_KPI').getRecordTypeId();
        Date todayDate = system.today();
        //this month in integer
        Integer thisMonth=todayDate.month();
        system.debug('d.month'+thisMonth);
        Target_Actual__c ta = new Target_Actual__c();
        ta.Month__c=thisMonth;
        ta.RecordTypeId=salesKPIRecordTypeId;
        ta.Resource__c=res.id;
        ta.Market_ISO__c = 'PH';
        ta.Target__c=0;
        insert ta;
        BatchCreateSalesKPITargetActual saleskpi = new BatchCreateSalesKPITargetActual();
        database.executeBatch(saleskpi);
        Test.stopTest();
        List<Target_Actual__c> targetActual  = [select id,name from Target_Actual__c where RecordTypeId=:salesKPIRecordTypeId and Month__c=:thisMonth];
        system.assertEquals(1, targetActual.size());
        
    }
}