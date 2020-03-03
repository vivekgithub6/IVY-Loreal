@isTest
private class TESTRESTDiscountManager {
    private static testMethod void testDiscountManager(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Test Resource',userId,restype.id);
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
        
        
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'MY'),
            new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'MY'),
            new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'MY') 
        };
                    insert shyList;
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DT', ivybase__List_Name__c = 'Bill', ivybase__List_Type__c = 'DISCOUNT_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DAT', ivybase__List_Name__c = 'Item', ivybase__List_Type__c = 'DISCOUNT_APPLY_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'INVOICE', ivybase__List_Name__c = 'Invoice', ivybase__List_Type__c = 'DISCOUNT_MODULE_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
           
        }; 
        insert stdMasterList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Is_Conquest__c = true, Market_ISO__c = 'MY', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id);
        insert acc;
        Contact con = new Contact();
        con.Lastname = 'Testcon';
        con.Email = 'Test@gmail.com';
        con.ivybase__Related_User__c = UserInfo.getuserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Market_ISO__c = 'MY',Division__c = div.Id,ivybase__Active__c='Yes');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',Market_ISO__c = 'MY',ivybase__Parent__c=channel.Id,ivybase__Active__c='Yes');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',Market_ISO__c = 'MY',ivybase__Parent__c=subChannel.Id,ivybase__Active__c='Yes');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',Market_ISO__c = 'MY',ivybase__Parent__c=node3.Id,ivybase__Active__c='Yes');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        insert node4;
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Is_Conquest__c = true;
        update acc; 
       
        
        StoreDivisionMapping__c divMap = new StoreDivisionMapping__c(Account__c = acc.Id,Store_Hierarchy__c=node4.Id,Market_ISO__c = 'MY');
        insert divMap;
        
        DateTime TDate = System.now();
        Date todayDate = Date.newinstance(TDate.year(), TDate.month(), TDate.day());
        
        ivydsd__Discount__c discount = new ivydsd__Discount__c(Name='Test Discount',Market_ISO__c = 'MY',ivydsd__Apply_Type__c='Item & Bill',ivydsd__Discount_Type__c='Bill',ivydsd__Effective_From__c=todayDate,ivydsd__Module_Type__c='Invoice',Type__c= 'test');
        insert discount;
        
        ivydsd__Discount_Mapping__c disMapping = new ivydsd__Discount_Mapping__c(ivydsd__Location_Hierarchy__c=locHr.Id,Market_ISO__c = 'MY',ivydsd__Account__c=acc.Id,ivydsd__Discount__c=discount.Id,ivydsd__Store_Hierarchy__c=node4.Id);
        insert disMapping;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivydsd__Discount_Detail__c disDetail = new ivydsd__Discount_Detail__c(ivydsd__Discounts__c=discount.Id,Market_ISO__c = 'MY',ivydsd__Max_Slab__c=1000,ivydsd__Min_Slab__c=100,ivydsd__Product__c=p1.Id,ivydsd__Product_Hierarchy__c=ph.Id);
        insert disDetail;
        
        RestRequest req = new RestRequest(); 
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        req.addHeader('HeaderInformation','application/json');
        RestContext.request = req;
        List<ivybase__Location_Hierarchy__c> territoryList = [SELECT Id, Name FROM ivybase__Location_Hierarchy__c 
                                                   WHERE ivybase__Primary_Resource__r.Name =:res.Name];
        DivisionLocation__c divloc = new DivisionLocation__c(Division__c = div.Id, Location_Hierarchy__c = territoryList[0].Id);
        insert divloc;
        Id territory_id = territoryList[0].Id;
        List<DivisionLocation__c> divisionList = [SELECT Id, Division__c, Name, Location_Hierarchy__c FROM DivisionLocation__c WHERE Location_Hierarchy__c =:territoryList[0].Id];
        
        System.debug('+++divisionList++'+divisionList);
        DiscountService.CheckIfValidDiscounMappingIsPresent(node4.Id,discount.Id);
        DiscountService.CheckIfValidDiscountListIsPresent('test');
        System.debug('+++territoryList++'+territoryList);
        /*ivydsd__Discount_Detail__c discountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product__c =p1.Id,ivydsd__Product_Hierarchy__c = ph.Id,ivydsd__Discounts__c = discount.Id);
        insert discountDetail;*/
        
        DiscountService.CheckIfDiscountDetailCombinationExist(p1.Id,new SET<Id>(),ph.Id);
        DiscountService.CheckIfDiscoutMappingExistWithValidDiscountList('Test',new SET<Id>());
        
        DiscountService.getAllDiscountDetail_List_GrandChild(new SET<Id>{discount.Id},new SET<Id>());
        Test.startTest();
        RESTDiscountManager.getDiscount();
        Database.executeBatch(new BatchTempDiscount(res.Name));
        Test.stopTest();
    }
    
 @isTest
    private static void  testDiscountManagerException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
                RESTDiscountManager.getDiscount();
            }Catch(Exception ex) {
            }
        }
        Test.stoptest();
    }
}