@isTest
private class TESTRestRetailerAddressInfo {
    
    private static testmethod void method1(){     
         ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
         
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',null); 
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
        
       
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        
         List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Billto', ivybase__List_Name__c = 'Billing Address', ivybase__List_Type__c = 'ADDRESS_TYPE',ivybase__Location_Hierarchy__c=locNational.id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Shipo', ivybase__List_Name__c = 'Shipping Adress', ivybase__List_Type__c = 'ADDRESS_TYPE',ivybase__Location_Hierarchy__c=locNational.id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Shipo', ivybase__List_Name__c = 'SoldTo Address', ivybase__List_Type__c = 'ADDRESS_TYPE',ivybase__Location_Hierarchy__c=locNational.id,ivybase__Resource_Type__c=restype.Id)
        }; 
        insert stdMasterList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa', Is_Conquest__c = true,Market_ISO__c = 'MY',recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id,ivybase__Area_Code__c='1234');
        insert acc;
        Account acc2 = new Account(Name='aaa2', Is_Conquest__c = true,Market_ISO__c = 'MY',recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id,ivybase__Area_Code__c='2345');
        insert acc2;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
        DivisionLocation__c divloc = new DivisionLocation__c(Division__c=div.id,Market_ISO__c='MY',Location_Hierarchy__c=locHr.id);
        insert divloc;
        
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
        acc.ivybase__Store_Hierarchy__c=channel.id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.BillingState='test';
        acc.BillingCity='test';
        acc.ivybase__Area_Code__c='1234';
        update acc; 
        acc2.ivybase__Active__c = 'Yes';
        acc2.ivybase__Resource__c = res.Id;
        acc2.ivybase__Store_Hierarchy__c=subChannel.id;
        acc2.Is_Conquest__c = true;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.BillingState='test';
        acc2.BillingCity='test';
        acc.ivybase__Area_Code__c='1234';
        update acc2; 
        
        Contact con = new Contact(Lastname = 'Testcon',Email = 'Test@gmail.com',ivybase__Related_User__c = UserInfo.getuserId());
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;   
        
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
       
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert terrRouting;
        
                List<Partner_Function__c> partnerList = new List<Partner_Function__c>{
            new Partner_Function__c(Partner__c=acc2.Id,Type__c='Bill To',Account__c=acc.Id,Market_ISO__c = 'SG',Active__c=True,Division__c =div.id ),
            new Partner_Function__c(Partner__c=acc2.Id,Type__c='Ship To',Account__c=acc.Id,Market_ISO__c = 'SG',Active__c=True,Division__c =div.id )
                };
        insert partnerList;
        
        
       
        
        
        System.debug('++++'+partnerList);
        Test.startTest();
        RestRetailerAddressInfo.getRetailerAdressInfo();
        Test.stopTest();
        
    }
}