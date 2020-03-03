@isTest
public class TestPricingAndDiscountCreation {
   
    public static DataInfo createTestData(){
        DataInfo userData = new DataInfo();
        List<ivybase__Store_Hierarchy__c> storeHierarchy = new List<ivybase__Store_Hierarchy__c>(); 
        List<Account> account = new List<Account>();
        List<ivybase__Product__c> product = new List<ivybase__Product__c>();
        List<ivybase__Product_Hierarchy__c> productHierarchy = new List<ivybase__Product_Hierarchy__c>();
        
       	//Function Call: ivybase__Store_Hierarchy__c store = TestUtility.createTestStoreHierarchy('Green Trends' , 'Yes' ,ParentStoreId , DivisionId ,'Node4| Sub Channel | Node3 | Channel');
        ivybase__Store_Hierarchy__c ChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Channel' , 'Yes' ,null,null,'Channel');
        ChannelStore.Store_Number__c='1';
        insert ChannelStore;
        storeHierarchy.add(ChannelStore);
        ivybase__Store_Hierarchy__c SubChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Sub Channel' , 'Yes' ,ChannelStore.Id,null,'Sub Channel');
        SubChannelStore.Store_Number__c='12';
        insert SubChannelStore;
        storeHierarchy.add(SubChannelStore);
        ivybase__Store_Hierarchy__c Node3Store = TestUtility.createTestStoreHierarchy('Green Trends Node3' , 'Yes' ,SubChannelStore.Id,null,'Node3');
        Node3Store.Store_Number__c='123';
        insert Node3Store;
        storeHierarchy.add(Node3Store);
        ivybase__Store_Hierarchy__c Node4Store = TestUtility.createTestStoreHierarchy('Green Trends Node4' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4Store.Store_Number__c='1234';
        insert Node4Store;
        storeHierarchy.add(Node4Store);
		
        ivybase__Store_Hierarchy__c Node4StoreA = TestUtility.createTestStoreHierarchy('Green Trends Node4A' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4StoreA.Store_Number__c='1234A';
        insert Node4StoreA;
        storeHierarchy.add(Node4StoreA);
		
        
       
        ivybase__Store_Hierarchy__c Node4StoreB = TestUtility.createTestStoreHierarchy('Green Trends Node4B' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4StoreA.Store_Number__c='1234B';
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
        
        Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '124556789' , '113422333' , null , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Store_Hierarchy__c=Node4Store.Id;
        acc2.Sold_To_Party_Number__c='12346';
        acc2.Is_Conquest__c = true;
        insert acc2;
        account.add(acc2);
        
        
        StoreDivisionMapping__c map1 = new StoreDivisionMapping__c();
        map1.Store_Hierarchy__c=Node4Store.Id;
        map1.Account__c=acc.Id;
        insert map1;
        
        StoreDivisionMapping__c map2 = new StoreDivisionMapping__c();
        map2.Store_Hierarchy__c=Node4Store.Id;
        map2.Account__c=acc2.Id;
        insert map2;
        
        
        
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
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',functionPH.Id,'Testdesc', false ,'Yes');
        p1.External_Code__c='123456789A';
        insert p1;
        product.add(p1);
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadtwo',functionPH.Id,'Testdesc', false ,'Yes');
        p2.External_Code__c='123456789B';
        insert p2;
        product.add(p2);
        
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadthree',functionPH.Id,'Testdessdc', false ,'Yes');
        p3.External_Code__c='123456789BD';
        insert p3;
        product.add(p3);  
        

        
        userData.product=product;
        
        
        return userData;
    }
@isTest
    public static void TestForStandardPrice()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='YPR0',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/PMATN';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       
       ivybase__Price_List__c standardPriceList= [SELECT Id FROM ivybase__Price_List__c WHERE ivybase__Is_Standard__c = true AND ivybase__Active__c = 'Yes'];
       ivybase__Price_List_Entrie__c priceListEntry = [select id,name,ivybase__UOM_1_Price__c from ivybase__Price_List_Entrie__c where ivybase__Product__c=:userData.product[0].id and ivybase__Price_List__c=:standardPriceList.Id];
       if(priceListEntry!=null)
       {
       	system.assertEquals(priceListEntry.ivybase__UOM_1_Price__c,value);
       }
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStandardPriceBOMProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='YPR0',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/UPMAT';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       
       ivybase__Price_List__c standardPriceList= [SELECT Id FROM ivybase__Price_List__c WHERE ivybase__Is_Standard__c = true AND ivybase__Active__c = 'Yes'];
       ivybase__Price_List_Entrie__c priceListEntry = [select id,name,ivybase__UOM_1_Price__c from ivybase__Price_List_Entrie__c where ivybase__Product__c=:userData.product[0].id and ivybase__Price_List__c=:standardPriceList.Id];
       if(priceListEntry!=null)
       {
       	system.assertEquals(priceListEntry.ivybase__UOM_1_Price__c,value);
       }
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStandardPriceNegativeCondition()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='YPR0',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/HIENR01';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Pending',record.Status__c);
       
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStandardPriceNegativeConditionWithProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='YPR0',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/2323232323232';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/UPMAT';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Pending',record.Status__c);
       
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStructuralPriceHierarchyProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[0].Store_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/PMATN';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Completed',record.Status__c);
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       system.assertNotEquals(null,acc.Price_List__c);
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStructuralPriceAccountBOMProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/UPMAT/PMATN';	 
       insert record;
        
        ivybase__Bill_Of_Material_SKU_Detail__c billDetails = new ivybase__Bill_Of_Material_SKU_Detail__c();
        billDetails.ivybase__Bill_Of_Material_SKU__c=userData.product[0].id;
        billDetails.ivybase__Product__c=userData.product[1].Id;
        billDetails.ivybase__Quantity__c=20;
        insert billDetails;
        
       ivybase__Bill_Of_Material_SKU_Detail__c billDetails1 = new ivybase__Bill_Of_Material_SKU_Detail__c();
        billDetails1.ivybase__Bill_Of_Material_SKU__c=userData.product[0].id;
        billDetails1.ivybase__Product__c=userData.product[2].Id;
        billDetails1.ivybase__Quantity__c=20;
        insert billDetails1;
      
        
        
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+userData.account[0].Name+' Price List';
        priceList.ivybase__Valid_To__c=record.Valid_To_Date__c;
        priceList.ivybase__Valid_From__c=record.Valid_From_Date__c;
        priceList.ivybase__Active__c='Yes';
        insert priceList;
        
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=priceList.id;
        priceListEntry.ivybase__UOM_1_Price__c=330;
        priceListEntry.ivybase__Product__c=userData.product[0].id; 
        priceListEntry.RelatedCustomerCode__c='HIENR04';
        priceListEntry.Type__c='ZPN2';
        
        insert priceListEntry;
        
         
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       acc.Price_List__c=priceList.id;
		update acc;
       
        
        
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Completed',record.Status__c);
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStructuralPriceAccountBOMProductNopriceList()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/UPMAT/PMATN';	 
       insert record;
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Completed',record.Status__c);
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStructuralPriceAccountBOMProductFailCondition()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/3232323232/2323232323';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/UPMAT/PMATN';	 
       insert record;
       
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+userData.account[0].Name+' Price List';
        priceList.ivybase__Valid_To__c=record.Valid_To_Date__c;
        priceList.ivybase__Valid_From__c=record.Valid_From_Date__c;
        priceList.ivybase__Active__c='Yes';
        insert priceList;
        
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=priceList.id;
        priceListEntry.ivybase__UOM_1_Price__c=330;
        priceListEntry.ivybase__Product__c=userData.product[0].id; 
        priceListEntry.RelatedCustomerCode__c='HIENR04';
        priceListEntry.Type__c='ZPN2';
        insert priceListEntry;
         
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       acc.Price_List__c=priceList.id;
		update acc;
       
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Pending',record.Status__c);
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStructuralPriceHierarchyBOMProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[0].Store_Number__c+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/UPMAT/PMATN';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Completed',record.Status__c);
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       system.assertNotEquals(null,acc.Price_List__c);
       
       Test.stopTest();
    }
    
    @isTest
    public static void TestForStructuralPriceStoreHierarchyProductHierarchy()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[0].Store_Number__c+'/'+userData.produtHierarchy[0].Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR01/ZZPRODH2';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Pending',record.Status__c);
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       system.assertEquals(null,acc.Price_List__c);
       
       Test.stopTest();
    }
    @isTest
    public static void TestForStructuralPriceAccountProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/MATNR';	 
       insert record;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Completed',record.Status__c);
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       system.assertNotEquals(null,acc.Price_List__c);
       Test.stopTest();
    }
     @isTest
    public static void TestForStructuralPricestoreProductNoAccount()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+'1234B'+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/MATNR';	 
       insert record;
        
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c from Pricing_Master_Stage__c where id=:record.id];
       system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForAccountwithPriceList()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[1].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/MATNR';	 
       insert record;
       ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+userData.account[1].Name+' Price List';
        priceList.ivybase__Valid_To__c=record.Valid_To_Date__c;
        priceList.ivybase__Valid_From__c=record.Valid_From_Date__c;
        priceList.ivybase__Active__c='Yes';
        insert priceList;
         
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[1].id];
       acc.Price_List__c=priceList.id;
		update acc;
        
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=priceList.id;
        priceListEntry.ivybase__UOM_1_Price__c=330;
        priceListEntry.ivybase__Product__c=userData.product[0].id; 
        insert priceListEntry;
        
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
		system.debug('record. ErrorMessage__c '+record.ErrorMessage__c);
        system.assertEquals('Completed',record.Status__c);
        system.debug('ErrorMessage__c'+record.ErrorMessage__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForStorewithPriceList()
    {
       
       DataInfo userData = createTestData();
       Test.startTest();
        Decimal value = Decimal.valueOf(500);
	   Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR03/MATNR';	 
       insert record; 
       
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+userData.account[0].Name+' Price List';
        priceList.ivybase__Valid_To__c=record.Valid_To_Date__c;
        priceList.ivybase__Valid_From__c=record.Valid_From_Date__c;
        priceList.ivybase__Active__c='Yes';
        insert priceList;
        
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=priceList.id;
        priceListEntry.ivybase__UOM_1_Price__c=330;
        priceListEntry.ivybase__Product__c=userData.product[0].id; 
        priceListEntry.RelatedCustomerCode__c='HIENR04';
        priceListEntry.Type__c='ZPN2';
        
        insert priceListEntry;
        
         
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       acc.Price_List__c=priceList.id;
		update acc;
       
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.debug('record.ErrorMessage__c'+record.ErrorMessage__c);
        system.assertEquals('Completed',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForStorewithPriceListBOMProduct()
    {
       
       DataInfo userData = createTestData();
       Test.startTest();
        Decimal value = Decimal.valueOf(500);
	   Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/UPMAT/PMATN';	 
       insert record; 
       
        ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+userData.account[0].Name+' Price List';
        priceList.ivybase__Valid_To__c=record.Valid_To_Date__c;
        priceList.ivybase__Valid_From__c=record.Valid_From_Date__c;
        priceList.ivybase__Active__c='Yes';
        insert priceList;
        
        ivybase__Price_List_Entrie__c priceListEntry = new ivybase__Price_List_Entrie__c();
        priceListEntry.ivybase__Price_List__c=priceList.id;
        priceListEntry.ivybase__UOM_1_Price__c=330;
        priceListEntry.ivybase__Product__c=userData.product[0].id; 
        priceListEntry.RelatedCustomerCode__c='HIENR04';
        priceListEntry.Type__c='ZPN2';
        
        insert priceListEntry;
        
         
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       acc.Price_List__c=priceList.id;
		update acc;
       
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.debug('record.ErrorMessage__c'+record.ErrorMessage__c);
        system.assertEquals('Completed',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForException()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/MATNR';	 
       insert record;
       ivybase__Price_List__c priceList = new ivybase__Price_List__c();
        priceList.Name=''+userData.account[0].Name+''+userData.account[0].Sold_To_Party_Number__c+' Price List';  //acc.Name+''+acc.Sold_To_Party_Number__c
        priceList.ivybase__Valid_To__c=record.Valid_To_Date__c;
        priceList.ivybase__Valid_From__c=record.Valid_From_Date__c;
        priceList.ivybase__Active__c='Yes';
        insert priceList;
         
       Account acc = [select id,name,Price_List__c from Account where id=:userData.account[0].id];
       acc.Price_List__c=priceList.id;
       PricingAndDiscountCreation.getStagingRecordAndProcess(record);
       record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
		system.debug('record. ErrorMessage__c '+record.ErrorMessage__c);
        system.assertEquals('Pending',record.Status__c);
        system.debug('ErrorMessage__c'+record.ErrorMessage__c);
       Test.stopTest();
    }
	@isTest
    public static void TestForDiscountAccountProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/MATNR';	 
       insert record;
        
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.account[0].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Account__c=userData.account[0].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product__c=userData.product[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50);
		insert  DiscountDetail;    
       	
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Completed',record.Status__c);
        ivydsd__Discount_Detail__c detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product__c=:userData.product[0].id];
        system.assertNotEquals(null, detail);
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountAccountProductHierarchy()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.produtHierarchy[0].Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH3';	 
       insert record;

        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.debug('record.Status__c'+record.Status__c);
                system.debug('record.ErrorMessage__c'+record.ErrorMessage__c);
        system.assertEquals('Completed',record.Status__c);
        ivydsd__Discount_Detail__c detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product_Hierarchy__c=:userData.produtHierarchy[0].id];
        system.assertNotEquals(null, detail);
        
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountAccountProductHierarchyUpdate()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.produtHierarchy[0].Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH3';	 
       insert record;
		
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.account[0].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Account__c=userData.account[0].Id;
                        DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product_Hierarchy__c=userData.produtHierarchy[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50);
		insert  DiscountDetail; 
        
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.debug('record.Status__c'+record.Status__c);
                system.debug('record.ErrorMessage__c'+record.ErrorMessage__c);
        system.assertEquals('Completed',record.Status__c);
        ivydsd__Discount_Detail__c detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product_Hierarchy__c=:userData.produtHierarchy[0].id];
        system.assertNotEquals(null, detail);
        
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountAccountBOMProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/UPMAT/PMATN';	 
       insert record;
       	
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.StoreHierarchy[3].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Account__c=userData.account[0].Id;
                        DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product__c=userData.product[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50,RelatedCustomerCode__c='HIENR02');
		insert  DiscountDetail; 
        
       	PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Completed',record.Status__c);
        List<ivydsd__Discount_Detail__c> detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product__c=:userData.product[0].Id];
        system.assertNotEquals(0, detail.size());
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountAccountProductHighPriority()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[0].Sold_To_Party_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/PMATN';	 
       insert record;
       	
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.StoreHierarchy[3].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Account__c=userData.account[0].Id;
                        DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product__c=userData.product[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50,RelatedCustomerCode__c='HIENR02');
		insert  DiscountDetail; 
        
       	PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Completed',record.Status__c);
        List<ivydsd__Discount_Detail__c> detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product__c=:userData.product[0].Id];
        system.assertNotEquals(0, detail.size());
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountStoreHierarchyProductHierarchy()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c+'/'+userData.produtHierarchy[0].Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/ZZPRODH3';	 
       insert record;
       	
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.StoreHierarchy[3].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Account__c=userData.account[0].Id;
                DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product_Hierarchy__c=userData.produtHierarchy[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50);
		insert  DiscountDetail;    
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Completed',record.Status__c);
        List<ivydsd__Discount_Detail__c> detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product_Hierarchy__c=:userData.produtHierarchy[0].id];
        system.assertNotEquals(0, detail.size());
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountStoreHierarchyBOMProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/UPMAT/PMATN';	 
       insert record;
       	
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.StoreHierarchy[3].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Account__c=userData.account[0].Id;
                        DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product__c=userData.product[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50);
		insert  DiscountDetail; 
        
       	PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Completed',record.Status__c);
        List<ivydsd__Discount_Detail__c> detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product__c=:userData.product[0].Id];
        system.assertNotEquals(0, detail.size());
       Test.stopTest();
    }
    @isTest
    public static void TestForDiscountStoreHierarchyProduct()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c+'/'+userData.product[0].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/MATNR';	 
       insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Completed',record.Status__c);
        List<ivydsd__Discount_Detail__c> detail = [select id,name from ivydsd__Discount_Detail__c where ivydsd__Product__c=:userData.product[0].id];
        system.assertNotEquals(0, detail.size());
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData1()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='YPR0',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/34534534';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/PMATN';	 
       insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData2()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	  Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/ABDCEDF/39393839';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/MATNR';	 
      insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData3()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	  Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/39393839';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/MATNR';	 
      insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData4()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	  Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/2w2w2w2w/g7f8d9s8';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH3';	 
       insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData5()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/3r5ff4f4f4f/dsdsd4fd';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/MATNR';	 
       insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData6()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/dsdsd4fd';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/MATNR';	 
       insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData7()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04';	 
     
        insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData8()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='S300/02/30/'+userData.StoreHierarchy[3].Store_Number__c+'/UP00131123232/44018140';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/UPMAT/PMATN';	 
     
        insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData9()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(-500);
	Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='S300/02/30/'+userData.StoreHierarchy[3].Store_Number__c+'/UP00131123232/44018140';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/UPMAT/PMATN';	 
     
        insert record;
        
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData10()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+'43434343434'+'/'+userData.product[0].External_Code__c+'/'+userData.product[1].External_Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/UPMAT/PMATN';	 
       insert record;
       	
        ivydsd__Discount__c discount = PricingAndDiscountCreation.createDiscountList('ZSA1',record.Valid_From_Date__c,record.Valid_To_Date__c,userData.StoreHierarchy[3].Name);
        insert discount;
        
        ivydsd__Discount_Mapping__c DiscountMapping = new ivydsd__Discount_Mapping__c();
        DiscountMapping.ivydsd__Store_Hierarchy__c=userData.StoreHierarchy[3].Id;
        DiscountMapping.ivydsd__Discount__c=discount.Id;
        insert DiscountMapping;
        
        ivydsd__Discount_Detail__c DiscountDetail = new ivydsd__Discount_Detail__c(ivydsd__Product__c=userData.product[0].Id,ivydsd__Discounts__c=discount.id,ivydsd__Value__c=50);
		insert  DiscountDetail; 
        
       	PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
         Test.stopTest();
    }
    @isTest
    public static void TestForBadData11()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZPNB',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.account[1].Sold_To_Party_Number__c+'/2323232ewewe23';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/KUNNR/MATNR';	 
        insert record;
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData12()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/'+userData.StoreHierarchy[3].Store_Number__c+'/23232323';
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/ZZPRODH1';	 
        insert record;
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    @isTest
    public static void TestForBadData13()
    {
       Test.startTest();
       DataInfo userData = createTestData();
       Decimal value = Decimal.valueOf(500);
	 Pricing_Master_Stage__c record = new Pricing_Master_Stage__c(Price__c=value,Pricing_Condition_Type__c='ZSA1',Valid_To_Date__c=Date.newInstance(2038,10,18),Valid_From_Date__c=Date.newInstance(2018,05,18));
       record.Variable_Key__c='P300/02/31/23232ewewe2'+'/'+userData.produtHierarchy[0].Code__c;
       record.Variable_Key_Fields_Name__c='VKORG/VTWEG/SPART/HIENR04/ZZPRODH1';	 
        insert record;
        PricingAndDiscountCreation.getStagingRecordAndProcess(record);
        record = [select id,name,Status__c,ErrorMessage__c from Pricing_Master_Stage__c where id=:record.id];
        system.assertEquals('Pending',record.Status__c);
       Test.stopTest();
    }
    
    
    
    public class DataInfo{
        public List<Account> account;
        public List<ivybase__Store_Hierarchy__c> StoreHierarchy;
        public List<ivybase__Product__c> product;
        public List<ivybase__Product_Hierarchy__c> produtHierarchy;
    }
}