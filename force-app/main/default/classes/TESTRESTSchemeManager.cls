@isTest
public class TESTRESTSchemeManager {
    public static testMethod void method1() {
        Id userId = UserInfo.getUserId();
        
         UserwiseCountryValues__c settings = UserwiseCountryValues__c.getOrgDefaults();
      settings.Market_ISO__c = 'MY';
        settings.SetupOwnerId= userinfo.getUserId();
       insert settings;
        
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Resource',Market_ISO__c = 'MY',ivybase__Related_User__c=userId,ivybase__Resource_Type__c=resType.Id);
        insert resource;
        
        Id territory = [Select Id from RecordType Where DeveloperName='Territory' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = 'MY',RecordTypeId=territory,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert location;
        
        Id national = [Select Id from RecordType Where DeveloperName='National' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c nationallocation = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',RecordTypeId=national,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert nationallocation;
        
        Division__c div = new Division__c(Name='Test Div',Market_ISO__c = 'MY');
        insert div;
        
        DivisionLocation__c divLoc = new DivisionLocation__c(Division__c=div.Id,Market_ISO__c = 'MY',Location_Hierarchy__c=location.Id);
        insert divLoc;
       
        Contact con = new Contact();
        con.Lastname = 'Testscheme';
        con.ivybase__Related_User__c = UserInfo.getUserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;
        
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Channel';
        slm1.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm1;
        
        ivybase__Store_Hierarchy__c sh = new ivybase__Store_Hierarchy__c();
        sh.Name = 'TestSchemeHie';
        sh.ivybase__Active__c = 'Yes';
       // sh.Store_Number__c = 0000091538;
        sh.Market_ISO__c = 'MY';
        insert sh;
        
        /*ivybase__Store_Hierarchy__c sh1 = new ivybase__Store_Hierarchy__c();
        sh1.Name = 'ur';
        sh1.ivybase__Active__c = 'Yes';
        sh1.Store_Number__c = '0000091538';
        sh1.Market_ISO__c = 'MY';
        insert sh1;*/
        
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
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Store_Hierarchy__c = node4.Id;
        insert acc;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Internal_Id__c = 1;
        update acc;
        
        System.debug('Account in Test:: '+acc.ivybase__Internal_Id__c);
        
        StoreDivisionMapping__c storeDivMap = new StoreDivisionMapping__c(Account__c=acc.Id,Store_Hierarchy__c=node4.Id,Market_ISO__c = 'MY');
        insert storeDivMap;
        
        ivydsd__Scheme__c sch = new ivydsd__Scheme__c();
        sch.Name = 'Testscheme';
        sch.ivydsd__Active__c = 'Yes';
        sch.ivydsd__Code__c = 'Test code';
        sch.ivydsd__Description__c = 'test desc';
        sch.ivydsd__From__c = System.Today().addDays(-1);
        sch.ivydsd__To__c = System.Today().addDays(1);
        sch.ivydsd__Scheme_Buy_Logic__c = 'Any'; 
        sch.ivydsd__Scheme_Get_Logic__c = 'Any';
        sch.ivydsd__Scheme_Type__c = 'QTY';
        sch.Market_ISO__c = 'MY';
        insert sch;
        
        ivydsd__Scheme_Mapping__c sm = new ivydsd__Scheme_Mapping__c();
        sm.ivydsd__Store_Hierarchy__c = node4.Id;
        sm.ivydsd__Scheme__c = sch.Id;
        sm.Division__c = div.Id;
        insert sm;
        
        ivydsd__Scheme_Slab__c sl = new ivydsd__Scheme_Slab__c();
        sl.ivydsd__Scheme__c = sch.Id;
        insert sl;
        
        ivydsd__Scheme_Group__c sg2 = new ivydsd__Scheme_Group__c();
        sg2.Name = 'TestSchemegrp';
        sg2.ivydsd__Scheme__c = sch.Id;
        sg2.ivydsd__Group_Type__c = 'Get';
        insert sg2;
        
        ivydsd__Scheme_Group__c sg = new ivydsd__Scheme_Group__c();
        sg.Name = 'TestSchemegroup';
        sg.ivydsd__Scheme__c = sch.Id;
        sg.ivydsd__Group_Type__c = 'Get';
        insert sg;
        
        ivydsd__Scheme_Group__c sg1 = new ivydsd__Scheme_Group__c();
        sg1.Name = 'TestSchgrp';
        sg1.ivydsd__Scheme__c = sch.Id;
        sg1.ivydsd__Group_Type__c = 'Buy';
        insert sg1;
        
        ivydsd__Scheme_Slab_Target__c sst = new ivydsd__Scheme_Slab_Target__c();
        sst.Name ='TestSchemeSlabTarget';
        sst.ivydsd__Scheme_Slab__c = sl.Id;
        sst.ivydsd__Scheme_Group__c = sg1.Id;
        sst.ivydsd__UOM__c = 'PIECE';
        insert sst;
        
        ivybase__Product_Hierarchy__c ph = new ivybase__Product_Hierarchy__c();
        ph.Name = 'Prod Hie';
        ph.ivybase__Active__c = 'Yes';
        ph.RecordTypeId =  Schema.SObjectType.ivybase__Product_Hierarchy__c.getRecordTypeInfosByName().get('Sub Brand').getRecordTypeId();
        insert ph;
        
        ivybase__Product__c p = new ivybase__Product__c();
        p.Name = 'TestProduct';
        p.ivybase__Parent__c = ph.Id;
        p.ivybase__Is_Competitor__c = false;
        p.ivybase__Active__c = 'Yes';
        p.ivybase__Short_Description__c = 'Testdesc';
        insert p;
        
        
        ivydsd__Scheme_Group_Product__c sgp = new ivydsd__Scheme_Group_Product__c();
        sgp.ivydsd__Scheme_Group__c = sg1.Id;
        sgp.ivydsd__Product1__c = p.Id;
        insert sgp;
        
        ivydsd__Scheme_Group_Product__c sgp1 = new ivydsd__Scheme_Group_Product__c();
        sgp1.ivydsd__Scheme_Group__c = sg.Id;
        sgp1.ivydsd__Product1__c = p.Id;
        insert sgp1;
        
        ivydsd__Scheme_Free_Detail__c sfd = new ivydsd__Scheme_Free_Detail__c();
        sfd.ivydsd__Scheme_Slab__c = sl.Id;
        sfd.ivydsd__Scheme_Group__c = sg.Id;
        insert sfd;
        
        ivydsd__Scheme_Free_Detail__c sfd1 = new ivydsd__Scheme_Free_Detail__c();
        sfd1.ivydsd__Scheme_Slab__c = sl.Id;
        sfd1.ivydsd__Scheme_Group__c = sg2.Id;
        sfd1.ivydsd__Free_Quantity__c = 5;
        sfd1.ivydsd__Free_Quantity_UOM__c = 'PIECE';
        sfd1.ivydsd__Maximum_Percentage_Discount__c = 5;
        sfd1.ivydsd__Maximum_Price_Discount__c = 5;
        sfd1.ivydsd__Maximum_Rate_Discount__c = 5;
        sfd1.ivydsd__Percentage_Discount__c = 5;
        sfd1.ivydsd__Price_Discount__c = 5;
        sfd1.ivydsd__Rate_Discount__c = 5;
        insert sfd1;
        
        Promotion_Package_Capping__c promotionPackageCapping = new Promotion_Package_Capping__c();
        promotionPackageCapping.Division__c = div.Id;
        promotionPackageCapping.Start_Date__c = System.today();
        promotionPackageCapping.End_Date__c = System.today().addDays(5);
        promotionPackageCapping.Is_Package__c = true;
        promotionPackageCapping.Active__c = 'Yes';
        promotionPackageCapping.Promotion__c = sch.Id;
        promotionPackageCapping.Market_ISO__c = 'MY';
        promotionPackageCapping.Package_Count__c = 10;
        promotionPackageCapping.Store__c = acc.Id;
        insert promotionPackageCapping;
        
        ivybase__Standard_List_Master__c slm = new ivybase__Standard_List_Master__c();
        slm.ivybase__List_Type__c = 'PRODUCT_UOM';
        slm.ivybase__List_Name__c = 'Outer';
        insert slm;
        
        ivybase__Standard_List_Master__c slm2 = new ivybase__Standard_List_Master__c();
        slm2.ivybase__List_Type__c = 'DIVISION_TYPE';
        slm2.ivybase__List_Name__c = 'Loreal Professional';
        slm2.ivybase__Location_Hierarchy__c = nationallocation.Id;
        slm2.ivybase__Resource_Type__c = resType.Id;
        insert slm2;
        
        ivybase__Standard_List_Master__c slm3 = new ivybase__Standard_List_Master__c();
        slm3.ivybase__List_Type__c = 'DIVISION_TYPE';
        slm3.ivybase__List_Name__c = 'Kerastase';
        slm3.ivybase__Location_Hierarchy__c = nationallocation.Id;
        slm3.ivybase__Resource_Type__c = resType.Id;
        insert slm3;
        
        RExAPIResponseDomain.MultipleResponseInfo schememan = RESTSchemeManager.getSchemeInfo();
        System.Assert(schememan != null);
        
        Set<String> slabIntIdSet = new Set<String>();
        slabIntIdSet.add(sl.ivydsd__Internal_Id__c);
        
        Set<String> schemeIntIdSet = new Set<String>();
        schemeIntIdSet.add(sch.ivydsd__Internal_Id__c);
        
        Test.startTest();
        RESTSchemeManager.getSchemeInfo();
        StoreHierarchyService ss = new StoreHierarchyService();
        SchemeService.getSchemeSlabMapUsingInternalIds(slabIntIdSet);
        SchemeService.getSchemeMapUsingInternalIds(schemeIntIdSet);
        //StoreHierarchyService.getStoreHierarchyFromStoreCode();
        Test.stopTest();  
        
    }
public static testMethod void method2() {
        Id userId = UserInfo.getUserId();
        
         UserwiseCountryValues__c settings = UserwiseCountryValues__c.getOrgDefaults();
      settings.Market_ISO__c = 'PH';
        settings.SetupOwnerId= userinfo.getUserId();
       insert settings;
        
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Resource',Market_ISO__c = 'MY',ivybase__Related_User__c=userId,ivybase__Resource_Type__c=resType.Id);
        insert resource;
        
        Id territory = [Select Id from RecordType Where DeveloperName='Territory' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = 'MY',RecordTypeId=territory,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert location;
        
        Id national = [Select Id from RecordType Where DeveloperName='National' 
                                                  AND SobjectType='ivybase__Location_Hierarchy__c'].Id;
        ivybase__Location_Hierarchy__c nationallocation = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',RecordTypeId=national,ivybase__Resource_Type__c=resType.Id,ivybase__Primary_Resource__c=resource.Id);
        insert nationallocation;
        
        Division__c div = new Division__c(Name='Test Div',Market_ISO__c = 'MY');
        insert div;
        
        DivisionLocation__c divLoc = new DivisionLocation__c(Division__c=div.Id,Market_ISO__c = 'MY',Location_Hierarchy__c=location.Id);
        insert divLoc;
       
        Contact con = new Contact();
        con.Lastname = 'Testscheme';
        con.ivybase__Related_User__c = UserInfo.getUserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;
        
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Channel';
        slm1.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm1;
        
        ivybase__Store_Hierarchy__c sh = new ivybase__Store_Hierarchy__c();
        sh.Name = 'TestSchemeHie';
        sh.ivybase__Active__c = 'Yes';
       // sh.Store_Number__c = 0000091538;
        sh.Market_ISO__c = 'MY';
        insert sh;
        
        /*ivybase__Store_Hierarchy__c sh1 = new ivybase__Store_Hierarchy__c();
        sh1.Name = 'ur';
        sh1.ivybase__Active__c = 'Yes';
        sh1.Store_Number__c = '0000091538';
        sh1.Market_ISO__c = 'MY';
        insert sh1;*/
        
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
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Store_Hierarchy__c = node4.Id;
        insert acc;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Internal_Id__c = 1;
        update acc;
        
        System.debug('Account in Test:: '+acc.ivybase__Internal_Id__c);
        
        StoreDivisionMapping__c storeDivMap = new StoreDivisionMapping__c(Account__c=acc.Id,Store_Hierarchy__c=node4.Id,Market_ISO__c = 'MY');
        insert storeDivMap;
        
        ivydsd__Scheme__c sch = new ivydsd__Scheme__c();
        sch.Name = 'Testscheme';
        sch.ivydsd__Active__c = 'Yes';
        sch.ivydsd__Code__c = 'Test code';
        sch.ivydsd__Description__c = 'test desc';
        sch.ivydsd__From__c = System.Today().addDays(-1);
        sch.ivydsd__To__c = System.Today().addDays(1);
        sch.ivydsd__Scheme_Buy_Logic__c = 'Any'; 
        sch.ivydsd__Scheme_Get_Logic__c = 'Any';
        sch.ivydsd__Scheme_Type__c = 'QTY';
        sch.Market_ISO__c = 'MY';
        insert sch;
        
        ivydsd__Scheme_Mapping__c sm = new ivydsd__Scheme_Mapping__c();
        sm.ivydsd__Store_Hierarchy__c = node4.Id;
        sm.ivydsd__Scheme__c = sch.Id;
        sm.Division__c = div.Id;
        insert sm;
        
        ivydsd__Scheme_Slab__c sl = new ivydsd__Scheme_Slab__c();
        sl.ivydsd__Scheme__c = sch.Id;
        insert sl;
        
        ivydsd__Scheme_Group__c sg2 = new ivydsd__Scheme_Group__c();
        sg2.Name = 'TestSchemegrp';
        sg2.ivydsd__Scheme__c = sch.Id;
        sg2.ivydsd__Group_Type__c = 'Get';
        insert sg2;
        
        ivydsd__Scheme_Group__c sg = new ivydsd__Scheme_Group__c();
        sg.Name = 'TestSchemegroup';
        sg.ivydsd__Scheme__c = sch.Id;
        sg.ivydsd__Group_Type__c = 'Get';
        insert sg;
        
        ivydsd__Scheme_Group__c sg1 = new ivydsd__Scheme_Group__c();
        sg1.Name = 'TestSchgrp';
        sg1.ivydsd__Scheme__c = sch.Id;
        sg1.ivydsd__Group_Type__c = 'Buy';
        insert sg1;
        
        ivydsd__Scheme_Slab_Target__c sst = new ivydsd__Scheme_Slab_Target__c();
        sst.Name ='TestSchemeSlabTarget';
        sst.ivydsd__Scheme_Slab__c = sl.Id;
        sst.ivydsd__Scheme_Group__c = sg1.Id;
        sst.ivydsd__UOM__c = 'PIECE';
        insert sst;
        
        ivybase__Product_Hierarchy__c ph = new ivybase__Product_Hierarchy__c();
        ph.Name = 'Prod Hie';
        ph.ivybase__Active__c = 'Yes';
        ph.RecordTypeId =  Schema.SObjectType.ivybase__Product_Hierarchy__c.getRecordTypeInfosByName().get('Sub Brand').getRecordTypeId();
        insert ph;
        
        ivybase__Product__c p = new ivybase__Product__c();
        p.Name = 'TestProduct';
        p.ivybase__Parent__c = ph.Id;
        p.ivybase__Is_Competitor__c = false;
        p.ivybase__Active__c = 'Yes';
        p.ivybase__Short_Description__c = 'Testdesc';
        insert p;
        
        
        ivydsd__Scheme_Group_Product__c sgp = new ivydsd__Scheme_Group_Product__c();
        sgp.ivydsd__Scheme_Group__c = sg1.Id;
        sgp.ivydsd__Product1__c = p.Id;
        insert sgp;
        
        ivydsd__Scheme_Group_Product__c sgp1 = new ivydsd__Scheme_Group_Product__c();
        sgp1.ivydsd__Scheme_Group__c = sg.Id;
        sgp1.ivydsd__Product1__c = p.Id;
        insert sgp1;
        
        ivydsd__Scheme_Free_Detail__c sfd = new ivydsd__Scheme_Free_Detail__c();
        sfd.ivydsd__Scheme_Slab__c = sl.Id;
        sfd.ivydsd__Scheme_Group__c = sg.Id;
        insert sfd;
        
        ivydsd__Scheme_Free_Detail__c sfd1 = new ivydsd__Scheme_Free_Detail__c();
        sfd1.ivydsd__Scheme_Slab__c = sl.Id;
        sfd1.ivydsd__Scheme_Group__c = sg2.Id;
        sfd1.ivydsd__Free_Quantity__c = 5;
        sfd1.ivydsd__Free_Quantity_UOM__c = 'PIECE';
        sfd1.ivydsd__Maximum_Percentage_Discount__c = 5;
        sfd1.ivydsd__Maximum_Price_Discount__c = 5;
        sfd1.ivydsd__Maximum_Rate_Discount__c = 5;
        sfd1.ivydsd__Percentage_Discount__c = 5;
        sfd1.ivydsd__Price_Discount__c = 5;
        sfd1.ivydsd__Rate_Discount__c = 5;
        insert sfd1;
        
        Promotion_Package_Capping__c promotionPackageCapping = new Promotion_Package_Capping__c();
        promotionPackageCapping.Division__c = div.Id;
        promotionPackageCapping.Start_Date__c = System.today();
        promotionPackageCapping.End_Date__c = System.today().addDays(5);
        promotionPackageCapping.Is_Package__c = true;
        promotionPackageCapping.Active__c = 'Yes';
        promotionPackageCapping.Promotion__c = sch.Id;
        promotionPackageCapping.Market_ISO__c = 'MY';
        promotionPackageCapping.Package_Count__c = 10;
        promotionPackageCapping.Store__c = acc.Id;
        insert promotionPackageCapping;
        
        ivybase__Standard_List_Master__c slm = new ivybase__Standard_List_Master__c();
        slm.ivybase__List_Type__c = 'PRODUCT_UOM';
        slm.ivybase__List_Name__c = 'Outer';
        insert slm;
        
        ivybase__Standard_List_Master__c slm2 = new ivybase__Standard_List_Master__c();
        slm2.ivybase__List_Type__c = 'DIVISION_TYPE';
        slm2.ivybase__List_Name__c = 'Loreal Professional';
        slm2.ivybase__Location_Hierarchy__c = nationallocation.Id;
        slm2.ivybase__Resource_Type__c = resType.Id;
        insert slm2;
        
        ivybase__Standard_List_Master__c slm3 = new ivybase__Standard_List_Master__c();
        slm3.ivybase__List_Type__c = 'DIVISION_TYPE';
        slm3.ivybase__List_Name__c = 'Kerastase';
        slm3.ivybase__Location_Hierarchy__c = nationallocation.Id;
        slm3.ivybase__Resource_Type__c = resType.Id;
        insert slm3;
        
        RExAPIResponseDomain.MultipleResponseInfo schememan = RESTSchemeManager.getSchemeInfo();
        System.Assert(schememan != null);
        
        Set<String> slabIntIdSet = new Set<String>();
        slabIntIdSet.add(sl.ivydsd__Internal_Id__c);
        
        Set<String> schemeIntIdSet = new Set<String>();
        schemeIntIdSet.add(sch.ivydsd__Internal_Id__c);
        
        Test.startTest();
        RESTSchemeManager.getSchemeInfo();
        StoreHierarchyService ss = new StoreHierarchyService();
        SchemeService.getSchemeSlabMapUsingInternalIds(slabIntIdSet);
        SchemeService.getSchemeMapUsingInternalIds(schemeIntIdSet);
        //StoreHierarchyService.getStoreHierarchyFromStoreCode();
        Test.stopTest();  
        
    }
}