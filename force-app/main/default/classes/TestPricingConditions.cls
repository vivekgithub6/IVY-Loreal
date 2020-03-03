@isTest
public class TestPricingConditions {
    
    public static DataInfo createTestData(){
        DataInfo userData = new DataInfo();
        List<ivybase__Store_Hierarchy__c> storeHierarchy = new List<ivybase__Store_Hierarchy__c>(); 
        List<Account> account = new List<Account>();
        List<ivybase__Product__c> product = new List<ivybase__Product__c>();
        List<ivybase__Product_Hierarchy__c> productHierarchy = new List<ivybase__Product_Hierarchy__c>();
        
        //Function Call: ivybase__Store_Hierarchy__c store = TestUtility.createTestStoreHierarchy('Green Trends' , 'Yes' ,ParentStoreId , DivisionId ,'Node4| Sub Channel | Node3 | Channel');
        ivybase__Store_Hierarchy__c ChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Channel' , 'Yes' ,null,null,'Channel');
        insert ChannelStore;
        storeHierarchy.add(ChannelStore);
        ivybase__Store_Hierarchy__c SubChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Sub Channel' , 'Yes' ,ChannelStore.Id,null,'Sub Channel');
        insert SubChannelStore;
        storeHierarchy.add(SubChannelStore);
        ivybase__Store_Hierarchy__c Node3Store = TestUtility.createTestStoreHierarchy('Green Trends Node3' , 'Yes' ,SubChannelStore.Id,null,'Node3');
        insert Node3Store;
        storeHierarchy.add(Node3Store);
        ivybase__Store_Hierarchy__c Node4Store = TestUtility.createTestStoreHierarchy('Green Trends Node4' , 'Yes' ,Node3Store.Id,null,'Node4');
        insert Node4Store;
        storeHierarchy.add(Node4Store);
        userData.StoreHierarchy=storeHierarchy;
        
        //Function Call: Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Outlet' , 'Yes' );
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , null , 'Retail_Account' , 'Yes' );
        acc.ivybase__Store_Hierarchy__c=Node4Store.Id;
        acc.Is_Conquest__c = true;
        insert acc;
        account.add(acc);
        userData.account=account;
        
       // ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        
        ivybase__Product_Hierarchy__c SignaturePH  = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');
        insert SignaturePH;
        productHierarchy.add(SignaturePH);
        
        ivybase__Product_Hierarchy__c BrandPH  = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes');
        BrandPH.ivybase__Parent__c=SignaturePH.Id;
        insert BrandPH;
        productHierarchy.add(BrandPH);
        
        ivybase__Product_Hierarchy__c SubBrandPH  = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');
        SubBrandPH.ivybase__Parent__c=BrandPH.Id;
        insert SubBrandPH;
        productHierarchy.add(SubBrandPH);
        
        ivybase__Product_Hierarchy__c ReferencePH  = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');
        ReferencePH.ivybase__Parent__c=SubBrandPH.Id;
        insert ReferencePH;
        productHierarchy.add(ReferencePH);
        
        ivybase__Product_Hierarchy__c NuancePH  = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');
        NuancePH.ivybase__Parent__c=ReferencePH.Id;
        insert NuancePH;
        productHierarchy.add(NuancePH);
        
        ivybase__Product_Hierarchy__c AxePH  = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');
        AxePH.ivybase__Parent__c=NuancePH.Id;
        insert AxePH;
        productHierarchy.add(AxePH);
        
        ivybase__Product_Hierarchy__c SubAxePH  = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');
        SubAxePH.ivybase__Parent__c=AxePH.Id;
        insert SubAxePH;
        productHierarchy.add(SubAxePH);
        
        ivybase__Product_Hierarchy__c ClassPH  = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');
        ClassPH.ivybase__Parent__c=SubAxePH.Id;
        insert ClassPH;
        productHierarchy.add(ClassPH);
        
        ivybase__Product_Hierarchy__c functionPH  = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');
        functionPH.ivybase__Parent__c=ClassPH.Id;
        insert functionPH;
        productHierarchy.add(functionPH);
        
        userData.produtHierarchy=productHierarchy;
        
        //Function Call:  ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        
        ivybase__Product__c p0 = TestUtility.createTestProduct('Testdsduploadone',functionPH.Id,'Testdesc', false ,'Yes');
        insert p0;
        product.add(p0);
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadtwo',functionPH.Id,'Testdesc', false ,'Yes');
        insert p1;
        product.add(p1);
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadthree',functionPH.Id,'Testdesc', false ,'Yes');
        insert p2;
        product.add(p2);
        
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadfour',functionPH.Id,'Testdesc', false ,'Yes');
        insert p3;
        product.add(p3);
        
        ivybase__Product__c p4 = TestUtility.createTestProduct('Testdsduploadfive',functionPH.Id,'Testdesc', false ,'Yes');
        insert p4;
        product.add(p4);
        
        userData.product=product;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom1 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom1.ivybase__Bill_Of_Material_SKU__c = p2.id;
        bom1.ivybase__Product__c=p3.id;
        bom1.ivybase__Quantity__c=1;
        bom1.Market_ISO__c = 'MY';
        insert bom1;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom2 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom2.ivybase__Bill_Of_Material_SKU__c = p2.id;
        bom2.ivybase__Product__c=p1.id;
        bom2.ivybase__Quantity__c=1;
        bom2.Market_ISO__c = 'MY';
        insert bom2;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom3 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom3.ivybase__Bill_Of_Material_SKU__c = p4.id;
        bom3.ivybase__Product__c=p3.id;
        bom3.ivybase__Quantity__c=1;
        bom3.Market_ISO__c = 'MY';
        insert bom3;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom4 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom4.ivybase__Bill_Of_Material_SKU__c = p4.id;
        bom4.ivybase__Product__c=p1.id;
        bom4.ivybase__Quantity__c=1;
        bom4.Market_ISO__c = 'MY';
        insert bom4;
        
        return userData;
    }
    @isTest
    public static void TestForPriceList()
    {
        Test.startTest();
        DataInfo userData = createTestData();
         ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'ZPNA',200.30);   
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'ZPN2',200.30);   
        pleEntry.add(priceListEntry2); 
        insert pleEntry;
        Map<id,set<id>> accidprodidMap =new Map<id,set<id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[0].Id);
        prod.add(userData.product[1].Id);
        accidprodidMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap =new  Map<id,Map<Id,Map<Id,Map<String,Decimal>>>>();
        Map<Id,Map<Id,Decimal>> BOMParentChildMap = new Map<Id,Map<Id,Decimal>>();
        map<id,id> accountpriceidMapParam = new map<id,id>();
        map<id,map<id,map<string,decimal>>> result = PricingConditions.getprice(accidprodidMap,BOMChildPriceMap,BOMParentChildMap,accountpriceidMapParam);
        system.debug('result'+result);
        
        Test.stopTest();
    }
    @isTest
    public static void TestForBOMGrandPriceList()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZPNA',null);   
        pleEntry.add(priceListEntry1);
        insert pleEntry;
        
        ivybase__Price_List__c priceListorphan = TestUtility.createTestPriceList('Yes','Test PriceList orphan',Date.today(),Date.today().addDays(10));   
        insert priceListorphan;
        
        List<ivybase__Price_List_Entrie__c> pleEntryGrand = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,priceListorphan.Id,'ZPNA',null);   
        priceListEntry3.Parent__c=priceListEntry1.id;
        pleEntryGrand.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceListorphan.Id,'ZPN2',null);   
        priceListEntry4.Parent__c=priceListEntry1.id;
        pleEntryGrand.add(priceListEntry4); 
        insert pleEntryGrand;
        
        
        Map<id,set<id>> accidprodidMap =new Map<id,set<id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        accidprodidMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap =new  Map<id,Map<Id,Map<Id,Map<String,Decimal>>>>();
        Map<Id,Map<Id,Decimal>> BOMParentChildMap = new Map<Id,Map<Id,Decimal>>();
        map<id,id> accountpriceidMapParam = new map<id,id>();
        map<id,map<id,map<string,decimal>>> result = PricingConditions.getprice(accidprodidMap,BOMChildPriceMap,BOMParentChildMap,accountpriceidMapParam);
        system.debug('result'+result);
        
        PricingConditions.isBOMProduct(userData.product[2].Id, BOMParentChildMap);
        
            
        Test.stopTest();
    }
    @isTest
    public static void TestForBOMPriceList()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZPNA',null);   
        pleEntry.add(priceListEntry1);
        insert pleEntry;
        
        
        List<ivybase__Price_List_Entrie__c> pleEntryGrand = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,priceList.Id,'ZPNA',null);   
        priceListEntry3.Parent__c=priceListEntry1.id;
        pleEntryGrand.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'ZPN2',null);   
        priceListEntry4.Parent__c=priceListEntry1.id;
        pleEntryGrand.add(priceListEntry4); 
        insert pleEntryGrand;
        
        
        Map<id,set<id>> accidprodidMap =new Map<id,set<id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        accidprodidMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap =new  Map<id,Map<Id,Map<Id,Map<String,Decimal>>>>();
        Map<Id,Map<Id,Decimal>> BOMParentChildMap = new Map<Id,Map<Id,Decimal>>();
        map<id,id> accountpriceidMapParam = new map<id,id>();
        map<id,map<id,map<string,decimal>>> result = PricingConditions.getprice(accidprodidMap,BOMChildPriceMap,BOMParentChildMap,accountpriceidMapParam);
        system.debug('result'+result);
        
        PricingConditions.isBOMProduct(userData.product[2].Id, BOMParentChildMap);
        
            
        Test.stopTest();
    }
    @isTest
    public static void TestForBOMPriceListStandard()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        
        ivybase__Price_List__c stdpriceList = TestUtility.createTestPriceList('Yes','test standrad',null,null);   
        stdpriceList.ivybase__Is_Standard__c=true; 
        insert stdpriceList;
        
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZPNA',null);   
        pleEntry.add(priceListEntry1);
        insert pleEntry;
        
        
        List<ivybase__Price_List_Entrie__c> pleEntrystd = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,stdpriceList.Id,'YPR0',50);   
        
        pleEntrystd.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,stdpriceList.Id,'YPR0',50);   
        
        pleEntrystd.add(priceListEntry4); 
        insert pleEntrystd;
        
        
        Map<id,set<id>> accidprodidMap =new Map<id,set<id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        accidprodidMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap =new  Map<id,Map<Id,Map<Id,Map<String,Decimal>>>>();
        Map<Id,Map<Id,Decimal>> BOMParentChildMap = new Map<Id,Map<Id,Decimal>>();
        map<id,id> accountpriceidMapParam = new map<id,id>();
        map<id,map<id,map<string,decimal>>> result = PricingConditions.getprice(accidprodidMap,BOMChildPriceMap,BOMParentChildMap,accountpriceidMapParam);
        system.debug('result'+result);
        
        PricingConditions.isBOMProduct(userData.product[2].Id, BOMParentChildMap);
        PricingConditions.isBOMProduct(userData.product[3].Id, BOMParentChildMap);
            PricingConditions.getstandardprice();
        Test.stopTest();
    }
    @isTest
    public static void TestForBOMMultiple()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        
        ivybase__Price_List__c stdpriceList = TestUtility.createTestPriceList('Yes','test standrad',null,null);   
        stdpriceList.ivybase__Is_Standard__c=true; 
        insert stdpriceList;
        
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZPNA',null);   
        pleEntry.add(priceListEntry1);
        
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[4].Id,priceList.Id,'ZPNA',null);   
        pleEntry.add(priceListEntry2);
        
        
        insert pleEntry;
        
        
        List<ivybase__Price_List_Entrie__c> pleEntrystd = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,stdpriceList.Id,'YPR0',50);   
        
        pleEntrystd.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,stdpriceList.Id,'YPR0',50);   
        
        pleEntrystd.add(priceListEntry4); 
        insert pleEntrystd;
        
        
        Map<id,set<id>> accidprodidMap =new Map<id,set<id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        prod.add(userData.product[4].Id);
        accidprodidMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildPriceMap =new  Map<id,Map<Id,Map<Id,Map<String,Decimal>>>>();
        Map<Id,Map<Id,Decimal>> BOMParentChildMap = new Map<Id,Map<Id,Decimal>>();
        map<id,id> accountpriceidMapParam = new map<id,id>();
        map<id,map<id,map<string,decimal>>> result = PricingConditions.getprice(accidprodidMap,BOMChildPriceMap,BOMParentChildMap,accountpriceidMapParam);
        system.debug('result'+result);
        
         Test.stopTest();
    }
    
    public class DataInfo{
        public List<Account> account;
        public List<ivybase__Store_Hierarchy__c> StoreHierarchy;
        public List<ivybase__Product__c> product;
        public List<ivybase__Product_Hierarchy__c> produtHierarchy;
    }
}