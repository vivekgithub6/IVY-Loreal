/**
 * Covered Classes : PricingMasterStageBatch, PricingMapToSFEntity, TriggerLogicService
*/
@isTest
private class TESTPricingMasterStageBatch {
    public class DataInfo{
        public List<Account> account;
        public List<ivybase__Store_Hierarchy__c> StoreHierarchy;
        public List<ivybase__Product__c> product;
        public List<ivybase__Product_Hierarchy__c> produtHierarchy;
    }
    public static DataInfo createTestData(String countryCode){
        DataInfo userData = new DataInfo();
        List<ivybase__Store_Hierarchy__c> storeHierarchy = new List<ivybase__Store_Hierarchy__c>(); 
        List<Account> account = new List<Account>();
        List<ivybase__Product__c> product = new List<ivybase__Product__c>();
        List<ivybase__Product_Hierarchy__c> productHierarchy = new List<ivybase__Product_Hierarchy__c>();
        //not used we are master
        //Function Call: ivybase__Store_Hierarchy__c store = TestUtility.createTestStoreHierarchy('Green Trends' , 'Yes' ,ParentStoreId , DivisionId ,'Node4| Sub Channel | Node3 | Channel');
        ivybase__Store_Hierarchy__c ChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Channel' , 'Yes' ,null,null,'Channel');
        ChannelStore.Store_Number__c='1';
        ChannelStore.Market_ISO__c=countryCode;
        insert ChannelStore;
        storeHierarchy.add(ChannelStore);
        ivybase__Store_Hierarchy__c SubChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Sub Channel' , 'Yes' ,ChannelStore.Id,null,'Sub Channel');
        SubChannelStore.Store_Number__c='12';
        SubChannelStore.Market_ISO__c=countryCode;
        insert SubChannelStore;
        storeHierarchy.add(SubChannelStore);
        ivybase__Store_Hierarchy__c Node3Store = TestUtility.createTestStoreHierarchy('Green Trends Node3' , 'Yes' ,SubChannelStore.Id,null,'Node3');
        Node3Store.Store_Number__c='123';
        Node3Store.Market_ISO__c=countryCode;
        insert Node3Store;
        storeHierarchy.add(Node3Store);
        ivybase__Store_Hierarchy__c Node4Store = TestUtility.createTestStoreHierarchy('Green Trends Node4' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4Store.Store_Number__c='1234';
        Node4Store.Market_ISO__c=countryCode;
        insert Node4Store;
        storeHierarchy.add(Node4Store);
        
        ivybase__Store_Hierarchy__c Node4StoreA = TestUtility.createTestStoreHierarchy('Green Trends Node4A' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4StoreA.Store_Number__c='1234A';
        Node4StoreA.Market_ISO__c=countryCode;
        insert Node4StoreA;
        storeHierarchy.add(Node4StoreA);
        
        
        
        ivybase__Store_Hierarchy__c Node4StoreB = TestUtility.createTestStoreHierarchy('Green Trends Node4B' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4StoreB.Store_Number__c='1234B';
        Node4StoreB.Market_ISO__c=countryCode;
        insert Node4StoreB;
        storeHierarchy.add(Node4StoreB);
        
        
        userData.StoreHierarchy=storeHierarchy;
        
        //Function Call: Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Outlet' , 'Yes' );
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , null , 'Retail_Account' , 'Yes' );
        acc.ivybase__Store_Hierarchy__c=Node4Store.Id;
        acc.Sold_To_Party_Number__c='12345';
        acc.Is_Conquest__c = true;
        insert acc;
        account.add(acc);
        
        
        
        StoreDivisionMapping__c map1 = new StoreDivisionMapping__c();
        map1.Store_Hierarchy__c=Node4Store.Id;
        map1.Account__c=acc.Id;
        map1.Market_ISO__c=countryCode;
        insert map1;
        
        userData.account=account;
        
        // ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        
        ivybase__Product_Hierarchy__c SignaturePH  = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');
        SignaturePH.Code__c='1';
        insert SignaturePH;
        productHierarchy.add(SignaturePH);
        
        ivybase__Product_Hierarchy__c BrandPH  = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes');
        BrandPH.Code__c='12';
        BrandPH.ivybase__Parent__c=SignaturePH.Id;
        insert BrandPH;
        productHierarchy.add(BrandPH);
        
        ivybase__Product_Hierarchy__c SubBrandPH  = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');
        SubBrandPH.Code__c='123';
        SubBrandPH.ivybase__Parent__c=BrandPH.Id;
        insert SubBrandPH;
        productHierarchy.add(SubBrandPH);
        
        ivybase__Product_Hierarchy__c ReferencePH  = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');
        ReferencePH.Code__c='1234';
        ReferencePH.ivybase__Parent__c=SubBrandPH.Id;
        insert ReferencePH;
        productHierarchy.add(ReferencePH);
        
        ivybase__Product_Hierarchy__c NuancePH  = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');
        NuancePH.Code__c='12345';
        NuancePH.ivybase__Parent__c=ReferencePH.Id;
        insert NuancePH;
        productHierarchy.add(NuancePH);
        
        ivybase__Product_Hierarchy__c AxePH  = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');
        AxePH.Code__c='123456';
        AxePH.ivybase__Parent__c=NuancePH.Id;
        insert AxePH;
        productHierarchy.add(AxePH);
        
        ivybase__Product_Hierarchy__c SubAxePH  = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');
        SubAxePH.Code__c='1234567';
        SubAxePH.ivybase__Parent__c=AxePH.Id;
        insert SubAxePH;
        productHierarchy.add(SubAxePH);
        
        ivybase__Product_Hierarchy__c ClassPH  = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');
        ClassPH.Code__c='12345678';
        ClassPH.ivybase__Parent__c=SubAxePH.Id;
        insert ClassPH;
        productHierarchy.add(ClassPH);
        
        ivybase__Product_Hierarchy__c functionPH  = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');
        functionPH.Code__c='123456789';
        functionPH.ivybase__Parent__c=ClassPH.Id;
        insert functionPH;
        productHierarchy.add(functionPH);
        
        userData.produtHierarchy=productHierarchy;
        
        //Function Call:  ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        
        ivybase__Product__c p0 = TestUtility.createTestProduct('Testdsduploadone',functionPH.Id,'Testdesc', false ,'Yes');
        p0.External_Code__c='123456789A';
        p0.Customer_Material__c='5000'; 
        insert p0;
        product.add(p0);
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadtwo',functionPH.Id,'Testdesc', false ,'Yes');
        p1.External_Code__c='123456789B';
        p1.Customer_Material__c='5000'; 
        insert p1;
        product.add(p1);
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadthree',functionPH.Id,'Testdessdc', false ,'Yes');
        p2.External_Code__c='123456789BD';
        insert p2;
        product.add(p2);  
        
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadthree',functionPH.Id,'Testdessdc', false ,'Yes');
        p3.External_Code__c='123456789BE';
        insert p3;
        product.add(p3);  
        
        
        userData.product=product;
        
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom1 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom1.ivybase__Bill_Of_Material_SKU__c = p2.id;
        bom1.ivybase__Product__c=p1.id;
        bom1.ivybase__Quantity__c=1;
        bom1.Market_ISO__c = countryCode;
        insert bom1;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom2 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom2.ivybase__Bill_Of_Material_SKU__c = p2.id;
        bom2.ivybase__Product__c=p3.id;
        bom2.ivybase__Quantity__c=1;
        bom2.Market_ISO__c = countryCode;
        insert bom2;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom3 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom3.ivybase__Bill_Of_Material_SKU__c = p0.id;
        bom3.ivybase__Product__c=p1.id;
        bom3.ivybase__Quantity__c=1;
        bom3.Market_ISO__c = countryCode;
        insert bom3;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom4 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom4.ivybase__Bill_Of_Material_SKU__c = p0.id;
        bom4.ivybase__Product__c=p3.id;
        bom4.ivybase__Quantity__c=1;
        bom4.Market_ISO__c = countryCode;
        insert bom4;
        
        
        Division__c  div = new Division__c ();
        div.Market_ISO__c = countryCode;
        div.Division_Code__c='32';
        insert div;
        
        return userData;
    } 

    private static testMethod void testPricingMaster1(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/PMATN',Variable_Key__c='P300/02/'+userData.product[0].External_Code__c);
        insert pricing;
        Test.startTest();
        Set<String> s = new set<String>();
        s.add(CountryCode);
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster1bad1(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/UPMAT/PMATN',Variable_Key__c='232/2323/32/1/123456789B/123456789BD');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster1bad2(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/PMATN',Variable_Key__c='P300/02/234df4rsdfvsfvf');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster1bad3(){
        
       String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG',Variable_Key__c='P300/02');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster1update(){
       
       String CountryCode='PH';
        String currencyCode='PHP';
         DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        ivybase__Price_List__c stdList = PricingMapToSFEntity.createPriceList('standard',null,null,CountryCode,currencyCode);        
        stdList.ivybase__Is_Standard__c=true;
        insert stdList;
        ivybase__Price_List_Entrie__c entry = PricingMapToSFEntity.createPriceListEntry(stdList.id,userData.product[0].id,500,'YPR0',CountryCode,currencyCode);
        insert entry;
        
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='YPR0',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/PMATN',Variable_Key__c='P300/02/'+userData.product[0].External_Code__c);
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster2(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='ZSA1',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH1',Variable_Key__c='232/2323/32/12345/1');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster3(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='ZPNB',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/UPMAT/PMATN',Variable_Key__c='232/2323/32/1/123456789B/123456789BD');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster4(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='ZSA1',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR',Variable_Key__c='232/2323/32/12345');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster5(){
        
        String CountryCode='PH';
       DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=-1000,Pricing_Condition_Type__c='ZSA1',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR',Variable_Key__c='232/2323/32/12345');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMaster6(){
        
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=-1000,Pricing_Condition_Type__c='ZSA1',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/PMATN',Variable_Key__c='232/2323/32/12345/123456789A');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    private static testMethod void testPricingMasterMaterial1(){
        
        String CountryCode='PH';
       DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='ZSA1',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH1/ZZPRODH2/ZZPRODH3/MVGR1',Variable_Key__c='232/2323/32/12345/1/12/123/5000');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    private static testMethod void testPricingbad(){
        
       String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        Set<String> s = new set<String>();
        s.add(CountryCode);
        Pricing_Master_Stage__c pricing = new Pricing_Master_Stage__c(Market_ISO__c=CountryCode,Price__c=1000,Pricing_Condition_Type__c='ZSA1',Status__c='Pending',Valid_From_Date__c=Date.today(),Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH1/ZZPRODH2/ZZPRODH3/MVGR1',Variable_Key__c='232/2323/32342/12345324234/1/23412/123423/5000');
        insert pricing;
        Test.startTest();
        PricingMasterStageBatch batch = new PricingMasterStageBatch(s);
        Database.executeBatch(batch);
        Test.stopTest();
    }

    
    
}