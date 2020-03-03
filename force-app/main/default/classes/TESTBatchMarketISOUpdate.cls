@isTest
private class TESTBatchMarketISOUpdate {

    private static testMethod void testBatchMarketISO(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c = '';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        ph.Market_ISO__c = '';
        insert ph;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = '';
        insert locNational;
        
        ivybase__Location_Hierarchy__c locNational1= TestUtility.createTestLocationHierarchy('Test Location Hierarchy1',res.Id); 
        locNational1.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational1.ivybase__Resource_Type__c = restype.id;
        locNational1.Market_ISO__c = '';
        insert locNational1;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        Test.startTest();
        BatchMarketISOUpdate bat = new BatchMarketISOUpdate('ivybase__Location_Hierarchy__c');
        Database.executeBatch(bat);
        test.stopTest();
        
        List<ivybase__Location_Hierarchy__c> loclist = [SELECT Id, Market_ISO__c FROM ivybase__Location_Hierarchy__c];
        System.debug('loclist===>'+loclist);
    }
}