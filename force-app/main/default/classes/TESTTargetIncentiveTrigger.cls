@isTest
private class TESTTargetIncentiveTrigger {
    private static testMethod void testTargets(){
        Id currentUserId = UserInfo.getUserId();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,resType.id);
        insert res;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        ivybase__Location_Hierarchy__c locNational = new ivybase__Location_Hierarchy__c(Name='India',Market_ISO__c='MY',RecordTypeId = RT.get('National').getRecordTypeId());
        insert locNational;  
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        Incentive_Slab__c incentiveSlab = TestUtility.createTestIncentiveSlab('TestTarget',1000,null,1500,incentiveGrp.Id);   
        insert incentiveSlab;
        Target_Actual__c targetActual = TestUtility.createTestTargetActual('TestTarget',1000,incentiveGrp.Id,res.Id,'');
        targetActual.Market_ISO__c = 'PH';
        targetActual.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert targetActual;
        targetActual.Actual__c=2000;
        update targetActual;
        
    }
    
    /*private static testMethod void testTargetsQuantity(){
        Id currentUserId = UserInfo.getUserId();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,resType.id);
        insert res;
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        ivybase__Location_Hierarchy__c locNational = new ivybase__Location_Hierarchy__c(Name='India',Market_ISO__c='MY',RecordTypeId = RT.get('National').getRecordTypeId());
        insert locNational;  
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        Incentive_Slab__c incentiveSlab = TestUtility.createTestIncentiveSlab('TestTarget',null,2000,1500,incentiveGrp.Id);   
        insert incentiveSlab;
        Target_Actual__c targetActual = TestUtility.createTestTargetActual('TestTarget',1000,incentiveGrp.Id,res.Id,'');
        targetActual.Target__c = 1500;
        targetActual.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Quantity' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert targetActual;
        targetActual.Actual__c=2000;
        
        update targetActual;
        
    }*/
    

}