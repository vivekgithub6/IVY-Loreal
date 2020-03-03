@isTest
private class TESTSchemeApplydetail {

    private static testMethod void testSchemeApplyDetail(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes');     
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        insert order;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 100 , 100 , 100 , 10 , 10 , 10 );
        insert oli;

        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        insert schemeSlab;
            
        
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c(ivydsd__Group_Logic__c='ANY',ivydsd__Group_Type__c='BUY',
                                                                         ivydsd__Scheme__c=scheme.Id,Name='Scheme Group');
        insert schemeGroup;
        
        Test.startTest();
        
        ivybase__Price_List__c priceListTrue2 = TestUtility.createTestPriceList('Yes','Test PriceList True1',Date.today(),Date.today().addDays(2));   
        insert priceListTrue2;
        
        ivybase__Price_List_Mapping__c priceListMap = TestUtility.createTestPriceListMapping(priceListTrue2.Id,'Test PriceListMap1',null);   
        insert priceListMap;
        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceListTrue2.Id,'YPR0',200.30);   
        insert priceListEntry;
        
        ivydsd__Scheme_Group_Product__c schemeGrpProduct = new ivydsd__Scheme_Group_Product__c(ivydsd__Product1__c=p1.Id,ivydsd__Scheme_Group__c=schemeGroup.Id);
        insert schemeGrpProduct;
        update schemeGrpProduct;
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Date__c=Date.today(),Month__c =string.valueof(date.today().month()),Year__c=string.valueof(date.today().year()),Target__c=1000.0,Territory__c=locHr.Id,Status__c='Draft',SuperVisorComments__c='Test Comments');
        insert salesForecast;
        
        Sales_Forecast_Detail__c SFCDetailNewLaunch  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=function1.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailNewLaunch.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'New_Launch' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailNewLaunch;
        
        Sales_Forecast_Detail__c SFCDetailPromotion  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=function1.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailPromotion.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Promotion' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailPromotion;
        
        ivydsd__Scheme_Apply_Detail__c schemeApply = new ivydsd__Scheme_Apply_Detail__c(ivydsd__Order__c=order.Id,ivydsd__Order_Line_Item__c=oli.Id,
                                                                                       ivydsd__Scheme__c=schemeSlab.Id);
        insert schemeApply;
                
        Test.stopTest();        
        
    }
    
    private static testMethod void testSchemeApplyDetail1(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c= 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes');     
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        insert order;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 100 , 100 , 100 , 10 , 10 , 10 );
        insert oli;

        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        insert schemeSlab;
            
        
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c(ivydsd__Group_Logic__c='ANY',ivydsd__Group_Type__c='BUY',
                                                                         ivydsd__Scheme__c=scheme.Id,Name='Scheme Group');
        insert schemeGroup;
        
        Test.startTest();
        
        ivybase__Price_List__c priceListTrue2 = TestUtility.createTestPriceList('Yes','Test PriceList True1',Date.today(),Date.today().addDays(2));   
        insert priceListTrue2;
        
        ivybase__Price_List_Mapping__c priceListMap = TestUtility.createTestPriceListMapping(priceListTrue2.Id,'Test PriceListMap1',null);   
        insert priceListMap;
        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceListTrue2.Id,'YPR0',200.30);   
        insert priceListEntry;
        
        ivydsd__Scheme_Group_Product__c schemeGrpProduct = new ivydsd__Scheme_Group_Product__c(ivydsd__Product1__c=p1.Id,ivydsd__Scheme_Group__c=schemeGroup.Id);
        insert schemeGrpProduct;
        update schemeGrpProduct;
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Date__c=Date.today(),Month__c =string.valueof(date.today().month()),Year__c=string.valueof(date.today().year()),Target__c=1000.0,Territory__c=locHr.Id,Status__c='Approved',SuperVisorComments__c='Test Comments');
        insert salesForecast;
        
        Sales_Forecast_Detail__c SFCDetailNewLaunch  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=function1.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailNewLaunch.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'New_Launch' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailNewLaunch;
        
        Sales_Forecast_Detail__c SFCDetailPromotion  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=function1.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailPromotion.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Promotion' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailPromotion;
        
        ivydsd__Scheme_Apply_Detail__c schemeApply = new ivydsd__Scheme_Apply_Detail__c(ivydsd__Order__c=order.Id,ivydsd__Order_Line_Item__c=oli.Id,
                                                                                       ivydsd__Scheme__c=schemeSlab.Id);
        insert schemeApply;
               
        Test.stopTest();        
        
    }

}