@isTest
private class TESTRESTDivisionMapping {
    
    
    @isTest
    private static void  testDivisionMapping() {
        
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
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
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
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'PRODUCT_TAGGING'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'LOCATION_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY'),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY'),            
        	new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST',ivybase__Location_Hierarchy__c =locNational.Id, ivybase__Resource_Type__c = restype.Id, ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'DIVISION_TYPE')                
        }; 
        insert stdMasterList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Is_Conquest__c = true, Market_ISO__c = 'MY',recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id);
        insert acc;
        Contact con = new Contact();
        con.Lastname = 'Testcon';
        con.Email = 'Test@gmail.com' ;
        con.ivybase__Related_User__c = UserInfo.getuserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;    
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
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
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Is_Conquest__c = true;
        update acc; 
        
        StoreDivisionMapping__c divMap = new StoreDivisionMapping__c(Account__c = acc.Id,Market_ISO__c = 'MY',Store_Hierarchy__c=node4.Id);
        insert divMap;
        StoreDivisionMapping__c divMap1 = new StoreDivisionMapping__c(Account__c = acc.Id,Market_ISO__c = 'JPN',Store_Hierarchy__c=node4.Id);
       divMap1.Salon_Frequency__c='12';
        insert divMap1;
        DivisionLocation__c divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.Id,Market_ISO__c = 'MY',Division__c = div.Id);
        insert divLoc;
        
        Id id = ResourceService.getLoginSellerId();
        ivybase__Resource__c resourceObject = ResourceService.getSellerId(UserInfo.getUserId());
        map<string,string> resourceListing = ResourceService.GetAllResources();
        
        Test.startTest();
        RESTDivisionMapping.getDivisionMappingInfo();
        Test.stopTest(); 
    }
    @isTest
    private static void  testDivisionMappingException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
            RESTDivisionMapping.getDivisionMappingInfo();
            } catch(Exception e){
                
            }
        }
        Test.stoptest();
    }
}