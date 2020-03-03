@isTest
public class testOrderLineItemTriggerhandler {
    
    public static DataInfo createTestData(String CountryCode){
        DataInfo userData = new DataInfo();
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Supervisor');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        res.Market_ISO__c=CountryCode;
        insert res;

        
        List<ivybase__Store_Hierarchy__c> storeHierarchy = new List<ivybase__Store_Hierarchy__c>(); 
        List<Account> account = new List<Account>();
        List<ivybase__Product__c> product = new List<ivybase__Product__c>();
        List<ivybase__Product_Hierarchy__c> productHierarchy = new List<ivybase__Product_Hierarchy__c>();
        
        //Function Call: ivybase__Store_Hierarchy__c store = TestUtility.createTestStoreHierarchy('Green Trends' , 'Yes' ,ParentStoreId , DivisionId ,'Node4| Sub Channel | Node3 | Channel');
        ivybase__Store_Hierarchy__c ChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Channel' , 'Yes' ,null,null,'Channel');
        ChannelStore.Market_ISO__c=CountryCode;
        insert ChannelStore;
        storeHierarchy.add(ChannelStore);
        ivybase__Store_Hierarchy__c SubChannelStore = TestUtility.createTestStoreHierarchy('Green Trends Sub Channel' , 'Yes' ,ChannelStore.Id,null,'Sub Channel');
                SubChannelStore.Market_ISO__c=CountryCode;
        insert SubChannelStore;
        storeHierarchy.add(SubChannelStore);
        ivybase__Store_Hierarchy__c Node3Store = TestUtility.createTestStoreHierarchy('Green Trends Node3' , 'Yes' ,SubChannelStore.Id,null,'Node3');
        Node3Store.Market_ISO__c=CountryCode;
        insert Node3Store;
        storeHierarchy.add(Node3Store);
        ivybase__Store_Hierarchy__c Node4Store = TestUtility.createTestStoreHierarchy('Green Trends Node4' , 'Yes' ,Node3Store.Id,null,'Node4');
        Node4Store.Market_ISO__c=CountryCode;
        insert Node4Store;
        storeHierarchy.add(Node4Store);
        userData.StoreHierarchy=storeHierarchy;
        
        //Function Call: Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Outlet' , 'Yes' );
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , null , 'Retail_Account' , 'Yes' );
        acc.ivybase__Store_Hierarchy__c=Node4Store.Id;
        acc.Converted_to_Normal_Saloon__c = true;
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
        bom1.Market_ISO__c=CountryCode;
        insert bom1;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom2 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom2.ivybase__Bill_Of_Material_SKU__c = p2.id;
        bom2.ivybase__Product__c=p1.id;
        bom2.ivybase__Quantity__c=1;
        bom2.Market_ISO__c=CountryCode;
        insert bom2;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom3 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom3.ivybase__Bill_Of_Material_SKU__c = p4.id;
        bom3.ivybase__Product__c=p3.id;
        bom3.ivybase__Quantity__c=1;
        bom3.Market_ISO__c=CountryCode;
        insert bom3;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom4 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom4.ivybase__Bill_Of_Material_SKU__c = p4.id;
        bom4.ivybase__Product__c=p1.id;
        bom4.ivybase__Quantity__c=1;
        bom4.Market_ISO__c=CountryCode;
        insert bom4;
        
        return userData;
    }
    @isTest
    public static void TestForNormalProductCTypePrice()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'ZPNA',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'ZPNA',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
    @isTest
    public static void TestForNormalProductATypePriceAnd_D_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'ZSNP',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'ZSNP',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
    @isTest
    public static void TestForNormalProductATypePrice_NO_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'ZSNP',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'ZSNP',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
       @isTest
    public static void TestForNormalProduct_YRPO_TypePriceAnd_B_D_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',null,null);   
        priceList.ivybase__Is_Standard__c=True; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivydsd__Discount__c d3 = TestUtility.createTestDiscount('DiscoutName3','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        d3.Market_ISO__c=CountryCode;
        insert d3;
        ivydsd__Discount_Detail__c  discountdetail3 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d3.Id,500);
        discountdetail3.Market_ISO__c=CountryCode;
        insert discountdetail3; 
        ivydsd__Discount_Mapping__c discountMapping3 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d3.Id);
        discountMapping3.Market_ISO__c=CountryCode;
        insert discountMapping3; 
        
        ivydsd__Discount__c d4 = TestUtility.createTestDiscount('DiscoutName4','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA2');
        d4.Market_ISO__c=CountryCode;
        insert d4;
        ivydsd__Discount_Detail__c  discountdetail4 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d4.Id,500);
        discountdetail4.Market_ISO__c=CountryCode;
        insert discountdetail4; 
        ivydsd__Discount_Mapping__c discountMapping4 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d4.Id);
        discountMapping4.Market_ISO__c=CountryCode;
        insert discountMapping4; 
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
       @isTest
    public static void TestForNormalProduct_YRPO_TypePriceAnd_D_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',null,null);   
        priceList.ivybase__Is_Standard__c=True; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
    @isTest
    public static void TestForNormalProduct_YPRO_TypePrice_NO_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',null,null);   
        priceList.ivybase__Is_Standard__c=True; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
    @isTest
    public static void TestForBOM_C_PriceList_NO_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZPNA',null);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        insert pleEntry;
        
        ivybase__Price_List__c priceListorphan = TestUtility.createTestPriceList('Yes','Test PriceList orphan',Date.today(),Date.today().addDays(10));   
        priceListorphan.Market_ISO__c=CountryCode;
        insert priceListorphan;
        List<ivybase__Price_List_Entrie__c> pleEntryGrand = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,priceListorphan.Id,'ZPNA',500);   
        priceListEntry3.Parent__c=priceListEntry1.id;
        priceListEntry3.Market_ISO__c=CountryCode;
        pleEntryGrand.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceListorphan.Id,'ZPNA',600);   
        priceListEntry4.Parent__c=priceListEntry1.id;
        priceListEntry4.Market_ISO__c=CountryCode;
        pleEntryGrand.add(priceListEntry4); 
        insert pleEntryGrand;
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[2].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        
            
        Test.stopTest();
    }
    @isTest
    public static void TestForBOM_A_PriceList_NO_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZSNP',null);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        insert pleEntry;
        
        ivybase__Price_List__c priceListorphan = TestUtility.createTestPriceList('Yes','Test PriceList orphan',Date.today(),Date.today().addDays(10));   
        priceListorphan.Market_ISO__c=CountryCode;
        insert priceListorphan;
        List<ivybase__Price_List_Entrie__c> pleEntryGrand = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,priceListorphan.Id,'ZSNP',500);   
        priceListEntry3.Parent__c=priceListEntry1.id;
        priceListEntry3.Market_ISO__c=CountryCode;
        pleEntryGrand.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceListorphan.Id,'ZSNP',600);   
        priceListEntry4.Parent__c=priceListEntry1.id;
        priceListEntry4.Market_ISO__c=CountryCode;
        pleEntryGrand.add(priceListEntry4); 
        insert pleEntryGrand;
        
        
        
        
        
        
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[2].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
           
        Test.stopTest();
    }
    @isTest
    public static void TestForBOM_A_PriceList_D_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZSNP',null);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        insert pleEntry;
        
        ivybase__Price_List__c priceListorphan = TestUtility.createTestPriceList('Yes','Test PriceList orphan',Date.today(),Date.today().addDays(10));   
        priceListorphan.Market_ISO__c=CountryCode;
        insert priceListorphan;
        List<ivybase__Price_List_Entrie__c> pleEntryGrand = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry3 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,priceListorphan.Id,'ZSNP',500);   
        priceListEntry3.Parent__c=priceListEntry1.id;
        priceListEntry3.Market_ISO__c=CountryCode;
        pleEntryGrand.add(priceListEntry3);
        ivybase__Price_List_Entrie__c priceListEntry4 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceListorphan.Id,'ZSNP',600);   
        priceListEntry4.Parent__c=priceListEntry1.id;
        priceListEntry4.Market_ISO__c=CountryCode;
        pleEntryGrand.add(priceListEntry4); 
        insert pleEntryGrand;
        
        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.RelatedCustomerCode__c='VKORG/VTWEG/KUNNR/PMATN';
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail2.RelatedCustomerCode__c='VKORG/VTWEG/KUNNR/PMATN';
        discountdetail2.Market_ISO__c=CountryCode;
        insert discountdetail2; 
        
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        discountdetail1.RelatedCustomerCode__c='VKORG/VTWEG/KUNNR/PMATN';
        
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[2].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
           
        Test.stopTest();
    }
   @isTest
    public static void TestForBOM_YPRO_PriceList_NO_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c standpriceList = TestUtility.createTestPriceList('Yes','std Test PriceList',null,null);   
        standpriceList.ivybase__Is_Standard__c=True; 
        standpriceList.Market_ISO__c=CountryCode;
        insert standpriceList;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,standpriceList.Id,'YPR0',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,standpriceList.Id,'YPR0',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry1 = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZSNP',null);   
        priceListEntry.Market_ISO__c=CountryCode;
        pleEntry1.add(priceListEntry);
        insert pleEntry1;
        
     
        
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[2].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
           
        Test.stopTest();
    }
    @isTest
    public static void TestForBOM_YPRO_PriceList_D_Discount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c standpriceList = TestUtility.createTestPriceList('Yes','std Test PriceList',null,null);   
        standpriceList.ivybase__Is_Standard__c=True; 
        standpriceList.Market_ISO__c=CountryCode;
        insert standpriceList;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[3].Id,standpriceList.Id,'YPR0',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,standpriceList.Id,'YPR0',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;
        
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry1 = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZSNP',null);   
        priceListEntry.Market_ISO__c=CountryCode;
        pleEntry1.add(priceListEntry);
        insert pleEntry1;
        
        
        
        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail2.Market_ISO__c=CountryCode;
        insert discountdetail2; 
        
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        
        ivydsd__Discount_Detail__c  discountdetail11 = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail11.Market_ISO__c=CountryCode;
        insert discountdetail11; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivydsd__Discount__c d3 = TestUtility.createTestDiscount('DiscoutName3','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        d3.Market_ISO__c=CountryCode;
        insert d3;
        ivydsd__Discount_Detail__c  discountdetail5 = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d3.Id,500);
        discountdetail5.Market_ISO__c=CountryCode;
        insert discountdetail5; 
        
        ivydsd__Discount_Detail__c  discountdetail6 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d3.Id,500);
        discountdetail6.Market_ISO__c=CountryCode;
        insert discountdetail6; 
        
        
        ivydsd__Discount_Mapping__c discountMapping3 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d3.Id);
        discountMapping3.Market_ISO__c=CountryCode;
        insert discountMapping3;
        
        ivydsd__Discount__c d4 = TestUtility.createTestDiscount('DiscoutName4','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA2');
        d4.Market_ISO__c=CountryCode;
        insert d4;
        ivydsd__Discount_Detail__c  discountdetail8 = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d4.Id,500);
        discountdetail8.Market_ISO__c=CountryCode;
        insert discountdetail8; 
        
        ivydsd__Discount_Detail__c  discountdetail7 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d4.Id,500);
        discountdetail7.Market_ISO__c=CountryCode;
        insert discountdetail7; 
        
        
        ivydsd__Discount_Mapping__c discountMapping4 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d4.Id);
        discountMapping4.Market_ISO__c=CountryCode;
        insert discountMapping4;
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[2].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
           
        Test.stopTest();
    }
    @isTest
    public static void TestForPOSMandMultipleProduct()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry1 = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZSNP',null);   
        priceListEntry.Market_ISO__c=CountryCode;
        pleEntry1.add(priceListEntry);
        insert pleEntry1;
        
        
        
        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail2.Market_ISO__c=CountryCode;
        insert discountdetail2; 
        
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivybase__Product__c p = userData.product[3];
        p.ivybase__Non_Saleable__c=true;
        update p;
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[3].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        oliList.add(oli);
        ivydsd__Order_Line_item__c oli1 = TestUtility.createTestOrderLineItem(o.id , userData.product[4].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        oliList.add(oli1);
        
        insert oliList;
        
        Test.stopTest();
    }
    @isTest
    public static void TestForDeleteAllLineItem()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(10));   
        priceList.ivybase__Is_Standard__c=false; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        Account a = userData.account[0];
        a.Price_List__c=priceList.id;
        update a;
        
        List<ivybase__Price_List_Entrie__c> pleEntry1 = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',userData.product[2].Id,priceList.Id,'ZSNP',null);   
        priceListEntry.Market_ISO__c=CountryCode;
        pleEntry1.add(priceListEntry);
        insert pleEntry1;
        
        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail2.Market_ISO__c=CountryCode;
        insert discountdetail2; 
        
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivybase__Product__c p = userData.product[3];
        p.ivybase__Non_Saleable__c=true;
        update p;
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[3].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        oliList.add(oli);
        ivydsd__Order_Line_item__c oli1 = TestUtility.createTestOrderLineItem(o.id , userData.product[4].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        oliList.add(oli1);
        
        insert oliList;
        delete oliList;
        Test.stopTest();
    }
    @isTest
    public static void TestForNormalProduct_YRPO_TypePriceAnd_B_D_DiscountAndNegativeDiscount()
    {
        Test.startTest();
        String CountryCode='PH';
        DataInfo userData = createTestData(CountryCode);
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',null,null);   
        priceList.ivybase__Is_Standard__c=True; 
        priceList.Market_ISO__c=CountryCode;
        insert priceList;
        
        List<ivybase__Price_List_Entrie__c> pleEntry = new List<ivybase__Price_List_Entrie__c>();        
        ivybase__Price_List_Entrie__c priceListEntry1 = TestUtility.createTestPriceListEntry('Yes',userData.product[0].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry1.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry1);
        ivybase__Price_List_Entrie__c priceListEntry2 = TestUtility.createTestPriceListEntry('Yes',userData.product[1].Id,priceList.Id,'YPR0',200.30);   
        priceListEntry2.Market_ISO__c=CountryCode;
        pleEntry.add(priceListEntry2); 
        insert pleEntry;

        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA1');
        d2.Market_ISO__c=CountryCode;
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d2.Id,500);
        discountdetail.Market_ISO__c=CountryCode;
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d2.Id);
        discountMapping.Market_ISO__c=CountryCode;
        insert discountMapping; 
        
        ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZPA2');
        d1.Market_ISO__c=CountryCode;
        insert d1;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        discountdetail1.Market_ISO__c=CountryCode;
        insert discountdetail1; 
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        discountMapping1.Market_ISO__c=CountryCode;
        insert discountMapping1; 
        
        ivydsd__Discount__c d3 = TestUtility.createTestDiscount('DiscoutName3','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        d3.Market_ISO__c=CountryCode;
        insert d3;
        ivydsd__Discount_Detail__c  discountdetail3 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d3.Id,500);
        discountdetail3.Market_ISO__c=CountryCode;
        insert discountdetail3; 
        ivydsd__Discount_Mapping__c discountMapping3 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d3.Id);
        discountMapping3.Market_ISO__c=CountryCode;
        insert discountMapping3; 
        
        ivydsd__Discount__c d4 = TestUtility.createTestDiscount('DiscoutName4','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA2');
        d4.Market_ISO__c=CountryCode;
        insert d4;
        ivydsd__Discount_Detail__c  discountdetail4 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d4.Id,500);
        discountdetail4.Market_ISO__c=CountryCode;
        insert discountdetail4; 
        ivydsd__Discount_Mapping__c discountMapping4 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d4.Id);
        discountMapping4.Market_ISO__c=CountryCode;
        insert discountMapping4; 
        
        ivydsd__Discount__c d5 = TestUtility.createTestDiscount('DiscoutName5','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZS07');
        d5.Market_ISO__c=CountryCode;
        insert d5;
        ivydsd__Discount_Detail__c  discountdetail5 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d5.Id,5);
        discountdetail5.Market_ISO__c=CountryCode;
        insert discountdetail5; 
        ivydsd__Discount_Mapping__c discountMapping5 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d5.Id);
        discountMapping5.Market_ISO__c=CountryCode;
        insert discountMapping5; 
        
        
        ivydsd__Order__c o = TestUtility.createTestOrder(userData.account[0].id,'Ordered',null,'1');       
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , userData.product[0].Id, 0 , 0 , 0 , 0 , 0 , 0 );
        insert oli;
        
        Test.stopTest();
    }
    
    public class DataInfo{
        public List<Account> account;
        public List<ivybase__Store_Hierarchy__c> StoreHierarchy;
        public List<ivybase__Product__c> product;
        public List<ivybase__Product_Hierarchy__c> produtHierarchy;
    }
}