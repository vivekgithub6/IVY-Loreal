@isTest
private class TESTRestMinOrderValue {
    private static testMethod void testMinOrder(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        ivybase__Location_Hierarchy__c national=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert national;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Is_Conquest__c = true, recordTypeId=accrecordTypeId, ivybase__Active__c='Yes');
        insert acc;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = div.Id,Market_ISO__c = 'MY');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        insert node4;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        update acc; 
        
        DivisionLocation__c divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.Id,Division__c = div.Id,Market_ISO__c = 'MY');
        insert divLoc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        Minimum_Order_Amount__c minOrder = new Minimum_Order_Amount__c(Product_Hierarchy__c=ph.Id,
                                                                      Store_Hierarchy__c = node4.Id,
                                                                      Division__c = div.Id,Value__c=200,
                                                                      From__c=Date.today(), To__c=Date.today(),
                                                                      Market_ISO__c = 'MY');
        insert minOrder;
        
        Test.startTest();
        RestMinOrderValue.getMinorderDetails();
        Test.stopTest();
    }

}