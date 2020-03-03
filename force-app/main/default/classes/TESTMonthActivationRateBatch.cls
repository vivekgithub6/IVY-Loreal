/**Last edited Pranav @03-05-2019**/

@isTest
private class TESTMonthActivationRateBatch {
    private static testMethod void testMonthlyActivation(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');     
            insert Signature;
            ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
            Brand.ivybase__Parent__c = Signature.Id;
            insert Brand;
            ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
            subBrand.ivybase__Parent__c = Brand.Id;
            insert subBrand;
            ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');     
            reference.ivybase__Parent__c = subBrand.Id;
            insert reference;
            ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
            naunce.ivybase__Parent__c = reference.Id;
            insert naunce;
            ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
            axe.ivybase__Parent__c = naunce.Id;
            insert axe;
            ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
            subAxe.ivybase__Parent__c = axe.Id;
            insert subAxe;
            ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
            classP.ivybase__Parent__c = subAxe.Id;
            insert classP;
            ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');     
            function.ivybase__Parent__c = classP.Id;
            insert function;
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        insert proSKU;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
       insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c =true;
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale1;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Resource__c =res.Id;
        order.Division__c=division.id;
        insert order;

        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = Date.today();
        invoice.ivydsd__Resource__c = res.Id;
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
        
        Target_Actual__c salesKPI = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesKPI.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Activation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        salesKPI.Parameter_type__c ='Monthly Activation Rate';
        salesKPI.Market_ISO__c = 'MY';
        insert salesKPI;
        
        List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
        Date sampleDate = date.today();
        sampleDate=sampleDate.addDays(-48);
        Date secondOldDate = sampleDate.addDays(-90);
        saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,date.today(),res.id,acc.id,null,null));
        saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,date.today(),res.id,acc.id,null,null));
        insert saloonInvoiceList;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='ReactivationRateBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        MonthActivationRateBatch batch = new MonthActivationRateBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    private static testMethod void testMonthlyActivation1(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');     
            insert Signature;
            ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
            Brand.ivybase__Parent__c = Signature.Id;
            insert Brand;
            ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
            subBrand.ivybase__Parent__c = Brand.Id;
            insert subBrand;
            ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');     
            reference.ivybase__Parent__c = subBrand.Id;
            insert reference;
            ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
            naunce.ivybase__Parent__c = reference.Id;
            insert naunce;
            ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
            axe.ivybase__Parent__c = naunce.Id;
            insert axe;
            ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
            subAxe.ivybase__Parent__c = axe.Id;
            insert subAxe;
            ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
            classP.ivybase__Parent__c = subAxe.Id;
            insert classP;
            ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');     
            function.ivybase__Parent__c = classP.Id;
            insert function;
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        insert proSKU;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
       insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c =true;
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale1;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Resource__c =res.Id;
        order.Division__c=division.id;
        insert order;

        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = Date.today();
        invoice.ivydsd__Resource__c = res.Id;
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
        
        Target_Actual__c salesKPI = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Actual__c=0,Resource__c=res.Id,Month__c=Date.today().Month());
        salesKPI.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Activation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        salesKPI.Parameter_type__c ='Monthly Activation Rate';
        salesKPI.Market_ISO__c = 'MY';
        insert salesKPI;
        
         Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='ReactivationRateBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        MonthActivationRateBatch batch = new MonthActivationRateBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }

}