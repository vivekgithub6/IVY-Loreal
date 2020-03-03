@isTest
public class TestDiscountClass {
    
    public static DataInfo createTestData(){
        DataInfo userData = new DataInfo();
        List<ivybase__Store_Hierarchy__c> storeHierarchy = new List<ivybase__Store_Hierarchy__c>(); 
        List<Account> account = new List<Account>();
        List<ivybase__Product__c> product = new List<ivybase__Product__c>();
        List<ivybase__Product_Hierarchy__c> productHierarchy = new List<ivybase__Product_Hierarchy__c>();
        List<Division__c> div = new List<Division__c>();
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
        
        Division__c  div1 = new Division__c ();
        div1.Division_Code__c='123';
        div1.Market_ISO__c = 'MY';
        insert div1;
        div.add(div1);
        userData.division=div;

        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',functionPH.Id,'Testdesc', false ,'Yes');
        p1.Division__c=div1.id;
        insert p1;
        product.add(p1);
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadtwo',functionPH.Id,'Testdesc', false ,'Yes');
        p2.Division__c=div1.id;
        insert p2;
        
        product.add(p2);
        
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadthree',functionPH.Id,'Testdesc', false ,'Yes');
        p3.Division__c=div1.id;
        insert p3;
        product.add(p3);
        
        ivybase__Product__c p4 = TestUtility.createTestProduct('Testdsduploadfour',functionPH.Id,'Testdesc', false ,'Yes');
        p4.Division__c=div1.id;
        insert p4;
        product.add(p4);
        
        ivybase__Product__c p5 = TestUtility.createTestProduct('Testdsduploadfive',functionPH.Id,'Testdesc', false ,'Yes');
        p5.Division__c=div1.id;
        insert p5;
        product.add(p5);
        
        userData.product=product;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom1 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom1.ivybase__Bill_Of_Material_SKU__c = p3.id;
        bom1.ivybase__Product__c=p4.id;
        bom1.ivybase__Quantity__c=1;
        bom1.Market_ISO__c = 'MY';
        insert bom1;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom2 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom2.ivybase__Bill_Of_Material_SKU__c = p3.id;
        bom2.ivybase__Product__c=p2.id;
        bom2.ivybase__Quantity__c=1;
        bom2.Market_ISO__c = 'MY';
        insert bom2;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom3 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom3.ivybase__Bill_Of_Material_SKU__c = p5.id;
        bom3.ivybase__Product__c=p4.id;
        bom3.ivybase__Quantity__c=1;
        bom3.Market_ISO__c = 'MY';
        insert bom3;
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom4 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom4.ivybase__Bill_Of_Material_SKU__c = p5.id;
        bom4.ivybase__Product__c=p2.id;
        bom4.ivybase__Quantity__c=1;
        bom4.Market_ISO__c = 'MY';
        insert bom4;
        
        return userData;
    }
    @isTest
    public static void TestForBOMGrandChild()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[2].Id,userData.produtHierarchy[5].Id,d.Id,null);
        insert discountdetail; 
        
        ivydsd__Discount__c orphan = TestUtility.createTestDiscount('DiscoutName orphan','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert orphan; 
        
        ivydsd__Discount_Detail__c  grandchilddiscountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,orphan.Id,0.05);
        grandchilddiscountdetail.Parent__c=discountdetail.id;
        insert grandchilddiscountdetail; 
        
        ivydsd__Discount_Detail__c  grandchilddiscountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,orphan.Id,0.05);
        grandchilddiscountdetail1.Parent__c=discountdetail.id;
        insert grandchilddiscountdetail1;
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d.Id);
        insert discountMapping; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
        Test.stopTest();
    }
@isTest
    public static void TestForBOMChild()
    {
        Test.startTest();
       DataInfo userData = createTestData();
       ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d.Id,500);
        discountdetail.RelatedCustomerCode__c='VKORG/VTWEG/SPART/HIENR02/ZZPRODH1';
        
        insert discountdetail; 
        
        ivydsd__Discount_Detail__c  discountdetail5 = TestUtility.createTestDiscountDetail(null,userData.produtHierarchy[5].Id,d.Id,400);
        discountdetail5.RelatedCustomerCode__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH1';
        insert discountdetail5; 
        
        
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d.Id,300);
        insert discountdetail1; 
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(null,null,d.Id,200);
        discountdetail2.Division__c=userData.division[0].id;
        insert discountdetail2; 
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d.Id);
        insert discountMapping; 
        
        
         ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName 2 zsa1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA2');
        insert d1; 
        ivydsd__Discount_Detail__c  discountdetail3 = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d1.Id,null);
        insert discountdetail3; 
      
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        insert discountMapping1; 
        
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
        Test.stopTest();
    }
@isTest
    public static void TestForBOMChildBULK()
    {
        Test.startTest();
       DataInfo userData = createTestData();
       ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d.Id,null);
        insert discountdetail; 
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d.Id,null);
        insert discountdetail1; 
        
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d.Id);
        insert discountMapping; 
        
        
         ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName 2 zsa1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA2');
        insert d1; 
        ivydsd__Discount_Detail__c  discountdetail3 = TestUtility.createTestDiscountDetail(userData.product[3].Id,userData.produtHierarchy[5].Id,d1.Id,null);       
        insert discountdetail3; 
      
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        insert discountMapping1; 
        
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        prod.add(userData.product[4].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
        Test.stopTest();
    }

    
@isTest
    public static void TestForBOMChildHierarchy()
    {
        Test.startTest();
       DataInfo userData = createTestData();
       ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(null,userData.produtHierarchy[5].Id,d.Id,null);
        insert discountdetail; 
        
        
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d.Id);
        insert discountMapping; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[2].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
        Test.stopTest();
    }


    @isTest
    public static void TestForAccountProductMatchSimpleOne()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d.Id,500);
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d.Id);
        insert discountMapping; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[0].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
        Test.stopTest();
    }
    @isTest
    public static void TestForAccountProductHierarchyMatchSimpleOne()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(null,userData.produtHierarchy[5].Id,d.Id,500);
        discountdetail.RelatedCustomerCode__c='VKORG/VTWEG/SPART/HIENR02/ZZPRODH1';
        insert discountdetail; 
        
        ivydsd__Discount_Detail__c  discountdetail3 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d.Id,500);
        discountdetail3.RelatedCustomerCode__c='VKORG/VTWEG/SPART/KUNNR/ZZPRODH1';
        insert discountdetail3; 
        
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(null,null,d.Id,500);
        discountdetail2.Division__c=userData.division[0].id;
        discountdetail2.RelatedCustomerCode__c='VKORG/VTWEG/SPART/HIENR02/ZZPRODH1';
        insert discountdetail2; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d.Id);
        insert discountMapping; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[0].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
                Test.stopTest();
    }
    @isTest
    public static void TestForStoreHierarchyProductMatchSimpleOne()
    {
        Test.startTest();
        DataInfo userData = createTestData();
        ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[5].Id,d.Id,500);
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,null,d.Id);
        insert discountMapping; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[0].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
                Test.stopTest();
    }
    @isTest
    public static void TestForStoreHierarchyProductHierarchyMatchSimpleOne()
    {
        Test.startTest();
       DataInfo userData = createTestData();
       ivydsd__Discount__c d = TestUtility.createTestDiscount('DiscoutName','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d; 
        ivydsd__Discount_Detail__c  discountdetail = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d.Id,500);
        insert discountdetail; 
        ivydsd__Discount_Mapping__c discountMapping = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,null,d.Id);
        insert discountMapping; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[0].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
                Test.stopTest();
    }
    @isTest
    public static void TestForAccountProductMatchComplexOne()
    {
        Test.startTest();
       DataInfo userData = createTestData();
       ivydsd__Discount__c d1 = TestUtility.createTestDiscount('DiscoutName1','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA1');
        insert d1;
        ivydsd__Discount__c d2 = TestUtility.createTestDiscount('DiscoutName2','Invoice','Item','Bill',date.newInstance(2018,08,18),456,'ZSA2');
        insert d2;
        ivydsd__Discount_Detail__c  discountdetail1 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d1.Id,500);
        insert discountdetail1; 
        
        ivydsd__Discount_Detail__c  discountdetail3 = TestUtility.createTestDiscountDetail(userData.product[0].Id,userData.produtHierarchy[6].Id,d1.Id,500);
        insert discountdetail3;
        
        ivydsd__Discount_Detail__c  discountdetail2 = TestUtility.createTestDiscountDetail(userData.product[1].Id,userData.produtHierarchy[5].Id,d2.Id,600);
        insert discountdetail2; 
        
        ivydsd__Discount_Mapping__c discountMapping1 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[2].Id,userData.account[0].Id,d1.Id);
        insert discountMapping1; 
        
        ivydsd__Discount_Mapping__c discountMapping2 = TestUtility.createTestDiscountMapping(userData.StoreHierarchy[1].Id,userData.account[0].Id,d2.Id);
        insert discountMapping2; 
        
        Map<Id,Set<Id>> AccountProductMap = new Map<Id,Set<Id>>();
        Set<Id> prod = new Set<Id>();
        prod.add(userData.product[0].Id);
        prod.add(userData.product[1].Id);
        AccountProductMap.put(userData.account[0].Id,prod);
        Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> BOMChildDiscountMap = new Map<id,Map<Id,Map<Id,Map<String,Decimal>>>> ();
        Map<Id,Map<Id,Map<String,Decimal>>> resultMap = DiscountClass.getAccountProductTypeValueMap(AccountProductMap,BOMChildDiscountMap);
        system.debug('resultMap'+resultMap);
                Test.stopTest();
    }
    
    public class DataInfo{
        public List<Account> account;
        public List<ivybase__Store_Hierarchy__c> StoreHierarchy;
        public List<ivybase__Product__c> product;
        public List<ivybase__Product_Hierarchy__c> produtHierarchy;
        public List<Division__c> division;
    }
}