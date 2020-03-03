@isTest
public class TESTRetailerEditUploadTranslator {
    private static testMethod void testConquest(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c='MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c='MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.ivybase__Resource__c = res.Id;
        acc.Dream_List_Status__c ='Test';
        acc.Tid__c = '12432455235';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = division.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Store_Number__c = 'NODE4';
        insert node4;
        
        System.debug('node4===>'+node4);
        System.debug('node4.ivybase__Internal_Id__c====>'+node4.ivybase__Internal_Id__c);
        
        List<ivybase__Store_Hierarchy__c> node4List = [SELECT Id, ivybase__Internal_Id__c 
                                                       FROM ivybase__Store_Hierarchy__c
                                                       WHERE RecordTypeId =: Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId()];
        List<ivybase__HHTMenu_Master__c> hhtMenuList = new List<ivybase__HHTMenu_Master__c>();
        
        ivybase__HHTMenu_Master__c hhtmenu11 = new ivybase__HHTMenu_Master__c();
        hhtmenu11.Name = 'PROFILE_LO_05';
        hhtmenu11.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu11.ivybase__Flex__c = 'ivybase__Store_Hierarchy__c';
        hhtmenu11.ivybase__Flag__c = 1;
        hhtmenu11.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu11);
        
        ivybase__HHTMenu_Master__c hhtmenu1 = new ivybase__HHTMenu_Master__c();
        hhtmenu1.Name = 'PROFILE_LO_06';
        hhtmenu1.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu1.ivybase__Flex__c = 'ivybase__Location_Hierarchy__c';
        hhtmenu1.ivybase__Flag__c = 1;
        hhtmenu1.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu1);
        
        ivybase__HHTMenu_Master__c hhtmenu2 = new ivybase__HHTMenu_Master__c();
        hhtmenu2.Name = 'PROFILE_LO_10';
        hhtmenu2.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu2.ivybase__Flex__c = 'Billing_Address__c';
        hhtmenu2.ivybase__Flag__c = 1;
        hhtmenu2.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu2);
        
        ivybase__HHTMenu_Master__c hhtmenu3 = new ivybase__HHTMenu_Master__c();
        hhtmenu3.Name = 'PROFILE_LO_09';
        hhtmenu3.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu3.ivybase__Flex__c = 'Shipping_Address__c';
        hhtmenu3.ivybase__Flag__c = 1;
        hhtmenu3.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu3);
        
        ivybase__HHTMenu_Master__c hhtmenu4 = new ivybase__HHTMenu_Master__c();
        hhtmenu4.Name = 'PROFILE_LO_07';
        hhtmenu4.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu4.ivybase__Flex__c = 'Store_Address__c';
        hhtmenu4.ivybase__Flag__c = 1;
        hhtmenu4.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu4);
        
        ivybase__HHTMenu_Master__c hhtmenu5 = new ivybase__HHTMenu_Master__c();
        hhtmenu5.Name = 'PROFILE_LO_08';
        hhtmenu5.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu5.ivybase__Flex__c = 'ivybase__Customer_Category__c';
        hhtmenu5.ivybase__Flag__c = 1;
        hhtmenu5.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu5);
        
        ivybase__HHTMenu_Master__c hhtmenu6 = new ivybase__HHTMenu_Master__c();
        hhtmenu6.Name = 'PROFILE_LO_01';
        hhtmenu6.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu6.ivybase__Flex__c = 'Kerastase_Luxury_Mag__c';
        hhtmenu6.ivybase__Flag__c = 1;
        hhtmenu6.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu6);
        
        ivybase__HHTMenu_Master__c hhtmenu7 = new ivybase__HHTMenu_Master__c();
        hhtmenu7.Name = 'PROFILE_LO_02';
        hhtmenu7.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu7.ivybase__Flex__c = 'Mode_of_Payment__c';
        hhtmenu7.ivybase__Flag__c = 1;
        hhtmenu7.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu7);
        
        ivybase__HHTMenu_Master__c hhtmenu8 = new ivybase__HHTMenu_Master__c();
        hhtmenu8.Name = 'PROFILE_LO_03';
        hhtmenu8.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu8.ivybase__Flex__c = 'Legal_Entity_Type__c';
        hhtmenu8.ivybase__Flag__c = 1;
        hhtmenu8.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu8);
 
        
        insert hhtMenuList;
               
        List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id)  
                };
        
        insert standardmaster;
        
        List<ivybase__Standard_List_Master__c> standardmasterList = [SELECT Id, Name 
                                                                     FROM ivybase__Standard_List_Master__c
                                                                     WHERE ivybase__List_Code__c =: 'AS_HOST'];
       
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        
        
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        
        Test.startTest();
        List<LorealUploadclass.HairDresserInfo> hairdresserList = new List<LorealUploadclass.HairDresserInfo>();
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = tdydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        hairdresserList.add(hairDresser);
        
        List<LorealUploadclass.NewRetailerEditHeaderInfo> retailerHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>();
        LorealUploadclass.NewRetailerEditHeaderInfo retailer = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailer.Tid='12432455235';
        retailer.RetailerId='';
        retailer.Date_x=tdydate;
        retailer.isNew='1';
        retailerHeader.add(retailer);
        
        List<LorealUploadclass.NewRetailerEditDetailInfo> detailList = new List<LorealUploadclass.NewRetailerEditDetailInfo>();
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail1 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail1.Tid='12432455235';
        retailerDetail1.Code='PROFILE_LO_05';
        retailerDetail1.Value=node4List[0].ivybase__Internal_Id__c;
        retailerDetail1.RefId = '';
        retailerDetail1.RetailerId='';
        detailList.add(retailerDetail1);
        
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail2 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail2.Tid='12432455235';
        retailerDetail2.Code='PROFILE_LO_10';
        retailerDetail2.Value=node4List[0].ivybase__Internal_Id__c;
        retailerDetail2.RefId = '';
        retailerDetail2.RetailerId='';
        detailList.add(retailerDetail2);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail3 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail3.Tid='12432455235';
        retailerDetail3.Code='PROFILE_LO_09';
        retailerDetail3.Value=node4List[0].ivybase__Internal_Id__c; 
        retailerDetail3.RefId = '';
        retailerDetail3.RetailerId='';
        detailList.add(retailerDetail3);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail4 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail4.Tid='12432455235';
        retailerDetail4.Code='PROFILE_LO_06';
        retailerDetail4.Value=standardmasterList[1].Name;
        retailerDetail4.RefId = '';
        retailerDetail4.RetailerId='';
        detailList.add(retailerDetail4);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail5 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail5.Tid='12432455235';
        retailerDetail5.Code='PROFILE_LO_07';
        retailerDetail5.Value=standardmasterList[0].Name;
        retailerDetail5.RefId = '';
        retailerDetail5.RetailerId='';
        detailList.add(retailerDetail5);
        
        
        RetailerEditUploadTranslator.translate(retailerHeader,detailList,hairdresserList);
        
        
        Test.stopTest();
    }
    
    private static testMethod void testConquest2(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c='MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c='MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.ivybase__Resource__c = res.Id;
        acc.Dream_List_Status__c ='Test';
        acc.Tid__c = '12432455235';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = division.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Store_Number__c = 'NODE4';
        insert node4;
        
        System.debug('node4===>'+node4);
        System.debug('node4.ivybase__Internal_Id__c====>'+node4.ivybase__Internal_Id__c);
        
        List<ivybase__Store_Hierarchy__c> node4List = [SELECT Id, ivybase__Internal_Id__c 
                                                       FROM ivybase__Store_Hierarchy__c
                                                       WHERE RecordTypeId =: Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId()];
        List<ivybase__HHTMenu_Master__c> hhtMenuList = new List<ivybase__HHTMenu_Master__c>();
        
        ivybase__HHTMenu_Master__c hhtmenu9 = new ivybase__HHTMenu_Master__c();
        hhtmenu9.Name = 'PROFILE_LO_05';
        hhtmenu9.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu9.ivybase__Flex__c = 'Converted_Date__c';
        hhtmenu9.ivybase__Flag__c = 1;
        hhtmenu9.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu9);
        
        ivybase__HHTMenu_Master__c hhtmenu10 = new ivybase__HHTMenu_Master__c();
        hhtmenu10.Name = 'PROFILE_LO_10';
        hhtmenu10.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu10.ivybase__Flex__c = 'Due_Amount__c';
        hhtmenu10.ivybase__Flag__c = 1;
        hhtmenu10.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu10);
        
        ivybase__HHTMenu_Master__c hhtmenu12 = new ivybase__HHTMenu_Master__c();
        hhtmenu12.Name = 'PROFILE_LO_09';
        hhtmenu12.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu12.ivybase__Flex__c = 'AgreedActiveCustomer__c';
        hhtmenu12.ivybase__Flag__c = 1;
        hhtmenu12.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu12);
 
        
        insert hhtMenuList;
               
        List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id)  
                };
        
        insert standardmaster;
        
        List<ivybase__Standard_List_Master__c> standardmasterList = [SELECT Id, Name 
                                                                     FROM ivybase__Standard_List_Master__c
                                                                     WHERE ivybase__List_Code__c =: 'AS_HOST'];
       
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        
        
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        
        Test.startTest();
        List<LorealUploadclass.HairDresserInfo> hairdresserList = new List<LorealUploadclass.HairDresserInfo>();
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = tdydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        hairdresserList.add(hairDresser);
        
        List<LorealUploadclass.NewRetailerEditHeaderInfo> retailerHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>();
        LorealUploadclass.NewRetailerEditHeaderInfo retailer = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailer.Tid='12432455235';
        retailer.RetailerId='';
        retailer.Date_x=tdydate;
        retailer.isNew='1';
        retailerHeader.add(retailer);
        
        List<LorealUploadclass.NewRetailerEditDetailInfo> detailList = new List<LorealUploadclass.NewRetailerEditDetailInfo>();
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail1 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail1.Tid='12432455235';
        retailerDetail1.Code='PROFILE_LO_05';
        retailerDetail1.Value=node4List[0].ivybase__Internal_Id__c;
        retailerDetail1.RefId = '';
        retailerDetail1.RetailerId='';
        detailList.add(retailerDetail1);
        
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail2 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail2.Tid='12432455235';
        retailerDetail2.Code='PROFILE_LO_10';
        retailerDetail2.Value=node4List[0].ivybase__Internal_Id__c;
        retailerDetail2.RefId = '';
        retailerDetail2.RetailerId='';
        detailList.add(retailerDetail2);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail3 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail3.Tid='12432455235';
        retailerDetail3.Code='PROFILE_LO_09';
        retailerDetail3.Value=node4List[0].ivybase__Internal_Id__c; 
        retailerDetail3.RefId = '';
        retailerDetail3.RetailerId='';
        detailList.add(retailerDetail3);
        
        
        RetailerEditUploadTranslator.translate(retailerHeader,detailList,hairdresserList);
        
        
        Test.stopTest();
    }
    
    private static testMethod void testConquest3(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c='MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c='MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.ivybase__Resource__c = res.Id;
        acc.Dream_List_Status__c ='Test';
        acc.Tid__c = '12432455235';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = division.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY',ivybase__Active__c = 'Yes');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Store_Number__c = 'NODE4';
        insert node4;
        
        System.debug('node4===>'+node4);
        System.debug('node4.ivybase__Internal_Id__c====>'+node4.ivybase__Internal_Id__c);
        
        List<ivybase__Store_Hierarchy__c> node4List = [SELECT Id, ivybase__Internal_Id__c 
                                                       FROM ivybase__Store_Hierarchy__c
                                                       WHERE RecordTypeId =: Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId()];
        List<ivybase__HHTMenu_Master__c> hhtMenuList = new List<ivybase__HHTMenu_Master__c>();
        
        ivybase__HHTMenu_Master__c hhtmenu11 = new ivybase__HHTMenu_Master__c();
        hhtmenu11.Name = 'PROFILE_LO_05';
        hhtmenu11.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu11.ivybase__Flex__c = 'Legal_Entity_Type__c';
        hhtmenu11.ivybase__Flag__c = 1;
        hhtmenu11.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu11);
        
        ivybase__HHTMenu_Master__c hhtmenu1 = new ivybase__HHTMenu_Master__c();
        hhtmenu1.Name = 'PROFILE_LO_06';
        hhtmenu1.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu1.ivybase__Flex__c = 'Mode_of_Payment__c';
        hhtmenu1.ivybase__Flag__c = 1;
        hhtmenu1.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu1);
        
        ivybase__HHTMenu_Master__c hhtmenu2 = new ivybase__HHTMenu_Master__c();
        hhtmenu2.Name = 'PROFILE_LO_10';
        hhtmenu2.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu2.ivybase__Flex__c = 'ivybase__Customer_Category__c';
        hhtmenu2.ivybase__Flag__c = 1;
        hhtmenu2.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu2);
        
        ivybase__HHTMenu_Master__c hhtmenu3 = new ivybase__HHTMenu_Master__c();
        hhtmenu3.Name = 'PROFILE_LO_09';
        hhtmenu3.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu3.ivybase__Flex__c = 'Kerastase_Luxury_Mag__c';
        hhtmenu3.ivybase__Flag__c = 1;
        hhtmenu3.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu3);
        
        ivybase__HHTMenu_Master__c hhtmenu4 = new ivybase__HHTMenu_Master__c();
        hhtmenu4.Name = 'PROFILE_LO_07';
        hhtmenu4.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu4.ivybase__Flex__c = 'Mode_of_Payment__c';
        hhtmenu4.ivybase__Flag__c = 1;
        hhtmenu4.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu4);
        
        ivybase__HHTMenu_Master__c hhtmenu5 = new ivybase__HHTMenu_Master__c();
        hhtmenu5.Name = 'PROFILE_LO_08';
        hhtmenu5.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu5.ivybase__Flex__c = 'Legal_Entity_Type__c';
        hhtmenu5.ivybase__Flag__c = 1;
        hhtmenu5.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu5);
        
        ivybase__HHTMenu_Master__c hhtmenu6 = new ivybase__HHTMenu_Master__c();
        hhtmenu6.Name = 'PROFILE_LO_01';
        hhtmenu6.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu6.ivybase__Flex__c = 'Kerastase_Luxury_Mag__c';
        hhtmenu6.ivybase__Flag__c = 1;
        hhtmenu6.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu6);
        
        ivybase__HHTMenu_Master__c hhtmenu7 = new ivybase__HHTMenu_Master__c();
        hhtmenu7.Name = 'PROFILE_LO_02';
        hhtmenu7.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu7.ivybase__Flex__c = 'Mode_of_Payment__c';
        hhtmenu7.ivybase__Flag__c = 1;
        hhtmenu7.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu7);
        
        ivybase__HHTMenu_Master__c hhtmenu8 = new ivybase__HHTMenu_Master__c();
        hhtmenu8.Name = 'PROFILE_LO_03';
        hhtmenu8.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu8.ivybase__Flex__c = 'Legal_Entity_Type__c';
        hhtmenu8.ivybase__Flag__c = 1;
        hhtmenu8.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu8);
 
        
        insert hhtMenuList;
               
        List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test1', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id)  
                };
        
        insert standardmaster;
        
        List<ivybase__Standard_List_Master__c> standardmasterList = [SELECT Id, Name 
                                                                     FROM ivybase__Standard_List_Master__c
                                                                     WHERE ivybase__List_Code__c =: 'AS_HOST'];
       
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        
        
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        
        Test.startTest();
        List<LorealUploadclass.HairDresserInfo> hairdresserList = new List<LorealUploadclass.HairDresserInfo>();
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = tdydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        hairdresserList.add(hairDresser);
        
        List<LorealUploadclass.NewRetailerEditHeaderInfo> retailerHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>();
        LorealUploadclass.NewRetailerEditHeaderInfo retailer = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailer.Tid='12432455235';
        retailer.RetailerId='';
        retailer.Date_x=tdydate;
        retailer.isNew='1';
        retailerHeader.add(retailer);
        
        List<LorealUploadclass.NewRetailerEditDetailInfo> detailList = new List<LorealUploadclass.NewRetailerEditDetailInfo>();
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail1 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail1.Tid='12432455235';
        retailerDetail1.Code='PROFILE_LO_05';
        retailerDetail1.Value=node4List[0].ivybase__Internal_Id__c;
        retailerDetail1.RefId = '';
        retailerDetail1.RetailerId='';
        detailList.add(retailerDetail1);
        
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail2 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail2.Tid='12432455235';
        retailerDetail2.Code='PROFILE_LO_10';
        retailerDetail2.Value=standardmasterList[0].Name;
        retailerDetail2.RefId = '';
        retailerDetail2.RetailerId='';
        detailList.add(retailerDetail2);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail3 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail3.Tid='12432455235';
        retailerDetail3.Code='PROFILE_LO_09';
        retailerDetail3.Value=standardmasterList[1].Name; 
        retailerDetail3.RefId = '';
        retailerDetail3.RetailerId='';
        detailList.add(retailerDetail3);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail4 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail4.Tid='12432455235';
        retailerDetail4.Code='PROFILE_LO_06';
        retailerDetail4.Value=standardmasterList[1].Name;
        retailerDetail4.RefId = '';
        retailerDetail4.RetailerId='';
        detailList.add(retailerDetail4);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail5 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail5.Tid='12432455235';
        retailerDetail5.Code='PROFILE_LO_07';
        retailerDetail5.Value=standardmasterList[0].Name;
        retailerDetail5.RefId = '';
        retailerDetail5.RetailerId='';
        detailList.add(retailerDetail5);
        
        
        RetailerEditUploadTranslator.translate(retailerHeader,detailList,hairdresserList);
        
        
        Test.stopTest();
    }

}