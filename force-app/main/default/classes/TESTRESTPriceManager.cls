@isTest
private class TESTRESTPriceManager {
    private static testMethod void testPriceManager(){
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
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456781' , '111222334' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Is_Conquest__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        insert acc1;
        
        Account acc2 = TestUtility.createTestAccount('3' , 'Test Acc1' , '123456782' , '111222335' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Is_Conquest__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        insert acc2;
        
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.Division__c = div.Id;
        insert p1;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Market_ISO__c = 'MY',Division__c = div.Id);
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',Market_ISO__c = 'MY',ivybase__Parent__c=channel.Id);
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',Market_ISO__c = 'MY',ivybase__Parent__c=subChannel.Id);
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',Market_ISO__c = 'MY',ivybase__Parent__c=node3.Id);
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        insert node4;
        
        ivybase__Store_Hierarchy__c node41 = new ivybase__Store_Hierarchy__c(Name = 'store Node41',Market_ISO__c = 'MY',ivybase__Parent__c=node3.Id);
        node41.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        insert node41;
        
        ivybase__Store_Hierarchy__c node42 = new ivybase__Store_Hierarchy__c(Name = 'store Node42',Market_ISO__c = 'MY',ivybase__Parent__c=node3.Id);
        node42.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        insert node42;
        
        
        ivybase__Price_List__c priceListTrue = TestUtility.createTestPriceList('Yes','Test PriceList True',Date.today(),Date.today().addDays(2));   
        insert priceListTrue;
        ivybase__Price_List__c priceListTrue2 = TestUtility.createTestPriceList('Yes','Test PriceList True1',Date.today(),Date.today().addDays(2));   
        insert priceListTrue2;
        ivybase__Price_List__c priceListTrue3 = TestUtility.createTestPriceList('Yes','Test PriceList True3',Date.today(),Date.today().addDays(2));   
        insert priceListTrue3;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Price_List__c = priceListTrue.Id;
        update acc; 
        
        acc1.ivybase__Active__c = 'Yes';
        acc1.ivybase__Resource__c = res.Id;
        acc1.ivybase__Store_Hierarchy__c=node4.id;
        acc1.Price_List__c = priceListTrue2.Id;
        update acc1; 
        
        acc2.ivybase__Active__c = 'Yes';
        acc2.ivybase__Resource__c = res.Id;
        acc2.ivybase__Store_Hierarchy__c=node4.id;
        acc2.Price_List__c = priceListTrue3.Id;
        update acc2; 
        
        DivisionLocation__c divLocation = new DivisionLocation__c(Division__c=div.Id,Market_ISO__c = 'MY',Location_Hierarchy__c=locHr.Id);
        insert divLocation;
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(2));   
        insert priceList;
        ivybase__Price_List__c priceList2 = TestUtility.createTestPriceList('Yes','Test PriceList2',Date.today(),Date.today().addDays(2));   
        insert priceList2;
        ivybase__Price_List__c priceList3 = TestUtility.createTestPriceList('Yes','Test PriceList3',Date.today(),Date.today().addDays(2));   
        insert priceList3;
        
        ivybase__Price_List_Mapping__c priceListMap = TestUtility.createTestPriceListMapping(priceList.Id,'Test PriceListMap1',node4.Id);   
        insert priceListMap;
        
        ivybase__Price_List_Mapping__c priceListMap1 = TestUtility.createTestPriceListMapping(priceList2.Id,'Test PriceListMap2',node41.Id);   
        insert priceListMap1;
        
        ivybase__Price_List_Mapping__c priceListMap2 = TestUtility.createTestPriceListMapping(priceList3.Id,'Test PriceListMap3',node42.Id);   
        insert priceListMap2;
        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceListTrue.Id,'YPR0',200.30);   
        insert priceListEntry;
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceListTrue2.Id,'ZSNP',200.30);  
        insert priceListEntry2;
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceListTrue3.Id,'ZPNA',200.30);  
        insert priceListEntry3;
        
        Test.startTest();
        String CountryCode;
        RESTPriceManager.getPriceMasters();
        PriceService.getSTDPriceListId('test');
        Test.stopTest();
        
        
    }
    private static testMethod void testPriceManager2(){
        String CountryCode;
         Test.startTest();
        RESTPriceManager.getPriceMasters();
        PriceService.getSTDPriceListId('test');
        Test.stopTest();
        
    }

}