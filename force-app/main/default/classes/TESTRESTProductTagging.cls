@isTest
public class TESTRESTProductTagging {
    @testSetUp static void setUp() { 
        
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
        Division__c div = TestUtility.createdivision('Loreal Professional');
        insert div;
        insert TestUtility.createdivisionLocation(div.Id, locHr.Id);
        List<Account> accList = new List<Account>();
        List<Account> accListUpdate = new List<Account>();
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        acc.Progress_Percentage__c = 100;
        accList.add(acc);
        insert accList;
        acc.ivybase__Active__c = 'Yes';
        acc.Last_Visit_Date__c = Date.today();
        acc.SecondLastInvoiceDate__c = Date.today().addMonths(-12);
        acc.LastInvoiceDate__c = Date.today();
        accListUpdate.add(acc);
        update accListUpdate;
        
        List<ivybase__Standard_List_Master__c> stmList = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Test', ivybase__List_Name__c = 'Counter', ivybase__List_Type__c = 'PRODUCT_TAGGING', ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'Best Seller', ivybase__List_Type__c = 'PRODUCT_TAGGING', ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'Best Seller', ivybase__List_Type__c = 'STORE_AST', ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id)
        };        
        insert stmList;
        
        ivybase__Territory__c ter = new ivybase__Territory__c();
        ter.Name = 'testter';
        ter.ivybase__Primary_Resource__c = res.Id;
        ter.ivybase__Active__c = 'Yes';
        insert ter;
        
        ivybase__Store_Hierarchy__c sh = new ivybase__Store_Hierarchy__c(Name = 'Test', ivybase__Active__c  = 'Yes',Market_ISO__c='MY');
        insert sh;
        
        ivybase__Product_Hierarchy__c ph = new ivybase__Product_Hierarchy__c();
        ph.Name = 'Pd Hie';
        ph.ivybase__Active__c = 'Yes';
        ph.Market_ISO__c='MY';
        ph.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sub_Axe' LIMIT 1].Id;
        insert ph;
        
        List<ivybase__Product__c> proList = new List<ivybase__Product__c>{
            new ivybase__Product__c(Name = 'Test product',Market_ISO__c='MY', ivybase__Parent__c = ph.id, ivybase__Short_Description__c = 'Testdesc', ivybase__Is_Competitor__c = false, ivybase__Active__c = 'Yes'),
            new ivybase__Product__c(Name = 'Test product', ivybase__Parent__c = ph.id,Market_ISO__c='MY', ivybase__Short_Description__c = 'Testdesc', ivybase__Is_Competitor__c = false, ivybase__Active__c = 'Yes', Division__c = div.Id)};
                insert proList; 
        Id newlaunch = Schema.SObjectType.ivybase__Product_Group__c.getRecordTypeInfosByDeveloperName().get('New_Launch').getRecordTypeId();
        List<ivybase__Product_Group__c> pgList = new List<ivybase__Product_Group__c>{
            new ivybase__Product_Group__c(RecordTypeId = newlaunch, Market_ISO__c='MY',Name = 'Test', ivybase__Grouping_Type__c = 'New Launch', ivybase__Active__c = 'Yes'),
            new ivybase__Product_Group__c(RecordTypeId = newlaunch, Name = 'Test', ivybase__Grouping_Type__c = 'New Launch',Market_ISO__c='MY', ivybase__Active__c = 'Yes'),
            new ivybase__Product_Group__c(RecordTypeId = newlaunch, Name = 'Test', ivybase__Grouping_Type__c = 'New Launch',Market_ISO__c='MY', ivybase__Active__c = 'Yes'),
            new ivybase__Product_Group__c(Name = 'Test', Market_ISO__c='MY', ivybase__Active__c = 'Yes'),
            new ivybase__Product_Group__c(Name = 'Test', Market_ISO__c = 'MY', ivybase__Active__c = 'Yes', RecordTypeId = Schema.SObjectType.ivybase__Product_Group__c.getRecordTypeInfosByDeveloperName().get('Top20sku').getRecordTypeId())};
                insert pgList;
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>{new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c = pgList[3].Id, Market_ISO__c='MY', ivybase__Category__c = 'Priority',ivybase__Target_Price__c = 100, ivybase__Standard_List_Master__c = stmList[0].Id, ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[0].Id, ivybase__Target_Price__c = 100, ivybase__Category__c = 'Priority', ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[0].Id, ivybase__Category__c = 'Priority', ivybase__Product__c = proList[1].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[1].Id, ivybase__Target__c = 10, ivybase__Category__c = 'Priority', ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[1].Id, ivybase__Product__c = proList[1].Id, ivybase__Category__c = 'Priority'),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[2].Id, ivybase__Target__c = 10, ivybase__Category__c = 'Priority', ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[2].Id, ivybase__Product__c = proList[1].Id, ivybase__Category__c = 'Priority'),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[3].Id, ivybase__Product__c = proList[1].Id, ivybase__Category__c = 'Priority'),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgList[4].Id, ivybase__Product__c = proList[1].Id, ivybase__Category__c = 'Priority')
            
            };
                insert pgdList;
        
        List<ivybase__Product_Group_Mapping__c> pgmList = new List<ivybase__Product_Group_Mapping__c>{new ivybase__Product_Group_Mapping__c(ivybase__Product_Group__c = pgList[0].Id, ivybase__Distributor__c = null, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Store_Hierarchy__c = sh.Id),
            new ivybase__Product_Group_Mapping__c(ivybase__Product_Group__c = pgList[0].Id, ivybase__Distributor__c = accListUpdate[0].Id, ivybase__Location_Hierarchy__c = locHr.id, ivybase__Store_Hierarchy__c = sh.Id),
            new ivybase__Product_Group_Mapping__c(ivybase__Product_Group__c = pgList[1].Id, ivybase__Distributor__c = accListUpdate[0].Id, ivybase__Location_Hierarchy__c = locHr.id, ivybase__Store_Hierarchy__c = sh.Id),
            new ivybase__Product_Group_Mapping__c(ivybase__Product_Group__c = pgList[1].Id, ivybase__Distributor__c = accListUpdate[0].Id, ivybase__Store_Hierarchy__c = sh.Id),
            new ivybase__Product_Group_Mapping__c(ivybase__Product_Group__c = pgList[0].Id, ivybase__Distributor__c = null)                                                    
        };
        insert pgmList;        
    }
    
    static testMethod void testMethod1() {
        
        Test.StartTest();
        
        RESTProductTagging.getProductTagging();
        string recname='New_Launch';
        ProductGroupService.getAllProductBasedOnGroupRecordType(recname);
        Set<Id> producGrpIds = new Set<Id>();
        
        try{
            
            for(ivybase__Product_Group_Mapping__c pgm : ProductGroupService.getProductgroupMappping_List()) {
                producGrpIds.add(pgm.ivybase__Product_Group__c);
            }
            
        }
        catch(Exception ex){
            system.debug('*****'+ex);
        }
        
        try{
            RESTProductTagging.getProductTagging();
        }
        catch(Exception ex){
            system.debug('*****'+ex);
            // System.assertEquals('INSUFFICIENT_PERMISSIONS',ex.getMessage());
        }
        try{
            ProductGroupService.getAllProductGroupDetail_List(producGrpIds);
        }
        catch(Exception ex){
            system.debug('*****'+ex);
        }
        RExAPIResponseDomain.MultipleResponseInfo ProductTagging = RESTProductTagging.getProductTagging();
        System.assert(ProductTagging != null);
        Set<String> setofId = new Set<String>();
        for(ivybase__Store_Hierarchy__c ics :[select id,name,ivybase__Active__c  from ivybase__Store_Hierarchy__c]) {
            setofId.add(ics.Id);
        }
        
        Set<id> storeSet = new set<id>();
        List<account> acclist=[select id,ivybase__Store_Hierarchy__c from account where id IN:storeSet];
        
        set<id> storehirid = new set<id>();
        list<ivybase__Store_Hierarchy__c> sthdetails= new list<ivybase__Store_Hierarchy__c>();
        sthdetails=[select id,Division__c,ivybase__Internal_Id__c,ivybase__Level__c,RecordType.name,ivybase__Parent__c,Name,Store_Number__c
                    from ivybase__Store_Hierarchy__c where ID IN:storehirid];
        
        map<id,ivybase__Store_Hierarchy__c> sthidSthMap = new map<id,ivybase__Store_Hierarchy__c>();
        for(ivybase__Store_Hierarchy__c sth:sthdetails){
            sthidSthMap.put(sth.id,sth); 
        }
        Set<String> parentStoreHieIdsSet = new Set<String>();
        for(ivybase__Store_Hierarchy__c sh : [SELECT Id,ivybase__Parent__c FROM ivybase__Store_Hierarchy__c WHERE Id IN :parentStoreHieIdsSet ]){
            
            parentStoreHieIdsSet.add(sh.ivybase__Parent__c);
            
        }
        
        set<String> st1 = new set<String>();
        List<ivybase__Store_Hierarchy__c> st = [select id,name,
                                                ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                                
                                                from ivybase__Store_Hierarchy__c where 
                                                id=:st1];
        
        List<ivybase__Store_Hierarchy__c> ss1 = StoreHierarchyService.getStoreHierarchyFromStoreCode(setofId);
        set<string> ss2 = StoreHierarchyService.getparentStorehieIds(parentStoreHieIdsSet); 
        set<string> ss4 = StoreHierarchyService.getchildStorehieIds(setofId);
        List<account> ss5 = StoreHierarchyService.getNode4ForThisAccount(storeSet);
        List<ivybase__Store_Hierarchy__c> ss6 = StoreHierarchyService.getStoreHierarchyFromStoreCode(setofId); 
        set<string> ss7 = StoreHierarchyService.getAllParentStoreHierarchy(st1);
        set<id> ss8 = StoreHierarchyService.getStoreHierarchyAndRelatedChildFromStoreCode(setofId);
        map<id,ivybase__Store_Hierarchy__c> ss3= StoreHierarchyService.getstoreHierarchyRecords(storehirid);
        Test.stoptest();
    }
    static testMethod void testMethod2() {
        
        List<ivybase__Product_Group__c> pgList = new List<ivybase__Product_Group__c>([SELECT Id, RecordTypeId FROM ivybase__Product_Group__c]);
        for(ivybase__Product_Group__c pg : pgList) {
            pg.RecordTypeId = Schema.SObjectType.ivybase__Product_Group__c.getRecordTypeInfosByDeveloperName().get('Top20sku').getRecordTypeId();
        }
        update pgList;
        Test.StartTest();
        
        RESTProductTagging.getProductTagging();
        ProductGroupService.getAllProductBasedOnGroupRecordType('Top20sku');
        Set<Id> producGrpIds = new Set<Id>();
        
        try{
            
            for(ivybase__Product_Group_Mapping__c pgm : ProductGroupService.getProductgroupMappping_List()) {
                producGrpIds.add(pgm.ivybase__Product_Group__c);
            }
            
        }
        catch(Exception ex){
            system.debug('*****'+ex);
        }
        
        try{
            RESTProductTagging.getProductTagging();
        }
        catch(Exception ex){
            system.debug('*****'+ex);
            // System.assertEquals('INSUFFICIENT_PERMISSIONS',ex.getMessage());
        }
        try{
            ProductGroupService.getAllProductGroupDetail_List(producGrpIds);
        }
        catch(Exception ex){
            system.debug('*****'+ex);
        }
        RExAPIResponseDomain.MultipleResponseInfo ProductTagging = RESTProductTagging.getProductTagging();
        System.assert(ProductTagging != null);
        Test.stoptest();
    }
    
    @isTest
    private static void  testProductTaggingException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
                RExAPIResponseDomain.MultipleResponseInfo ProductTagging = RESTProductTagging.getProductTagging();
            }Catch(Exception ex) {
            }
        }
        Test.stoptest();
    }
}