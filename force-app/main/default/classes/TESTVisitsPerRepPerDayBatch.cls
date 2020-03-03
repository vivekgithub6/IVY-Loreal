@isTest
private class TESTVisitsPerRepPerDayBatch {
    private static testMethod void testVisit(){
        ivybase__Resource_Type__c restype= TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,resType.id);   
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        ivybase__Visit__c visit = TestUtility.createTestVisit(Date.today(), acc.Id ,''); 
        visit.ivybase__Status__c = 'Completed';
        visit.ivybase__Resource__c = res.Id;
        insert visit;
        
        Map<String, Schema.RecordTypeInfo> targetRT = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
        
        
        Target_Actual__c target = new Target_Actual__c(Resource__c=res.Id,Actual__c=2000,Market_ISO__c = 'MY',Achievement__c=300,Month__c=date.today().month(), Parameter_type__c='Avg No Of Visits');
        target.RecordTypeId = targetRT.get('Sales_KPI').getRecordTypeId();
        insert target;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='AverageTurnoverPerRepBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        VisitsPerRepPerDayBatch batch = new VisitsPerRepPerDayBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
    }

}