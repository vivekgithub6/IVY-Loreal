@isTest
private class TESTBatchClass_Top20Sales {
    private static testMethod void testTop20(){
        
         ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        insert ph;
        
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
        
        
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', ivybase__Active__c = 'yes',
                                                                             ivybase__Primary_Resource__c=res.Id,
                                                                             RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId(),
                                                                             Market_ISO__c = 'MY');
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', ivybase__Active__c = 'yes',
                                                                             ivybase__Primary_Resource__c=res.Id,
                                                                             RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id,
                                                                             Market_ISO__c = 'MY');
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'MY'),
                new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'MY'),
                new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'MY') 
                };
        insert shyList;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
      
        Account acc = new Account(Name='aaa', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', 
                                  ivybase__Location_Hierarchy__c=i2.Id, 
                                  ivybase__Store_Hierarchy__c=shyList[0].Id,
                                  Market_ISO__c = 'MY');
        acc.Is_Conquest__c = true;
        insert acc;
        acc.ivybase__Active__c = 'yes';
        acc.Converted_to_Normal_Saloon__c = true;
        
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-11));
        insert skuasaloonsale;
        
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-11));
        insert skuasaloonsale1;
        
        SKU_SaloonSale__c skuasaloonsale2= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale2;
        
        SKU_SaloonSale__c skuasaloonsale3= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale3;
        
        SKU_SaloonSale__c skuasaloonsale4= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-12));
        insert skuasaloonsale4;
        
        SKU_SaloonSale__c skuasaloonsale5= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-12));
        insert skuasaloonsale5;
            
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
            
        ivybase__Product_Group_Detail__c proGrpDetail = new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c=pg1.Id,Market_ISO__c = 'MY',ivybase__Product__c=proSKU.Id);
        insert proGrpDetail;
            
        Test.startTest();
        BatchClass_Top20Sales t=new BatchClass_Top20Sales();
        Database.executeBatch(t);
        test.stopTest();
        
    }
    
    private static testMethod void testTop201(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        insert ph;
        
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
        
        
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', ivybase__Active__c = 'yes',
                                                                             ivybase__Primary_Resource__c=res.Id,
                                                                             RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId(),
                                                                             Market_ISO__c = 'MY');
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', ivybase__Active__c = 'yes',
                                                                             ivybase__Primary_Resource__c=res.Id,
                                                                             RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id,
                                                                             Market_ISO__c = 'MY');
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'MY'),
                new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'MY'),
                new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'MY') 
                };
        insert shyList;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
      
        Account acc = new Account(Name='aaa', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', 
                                  ivybase__Location_Hierarchy__c=i2.Id, 
                                  ivybase__Store_Hierarchy__c=shyList[0].Id,
                                  Market_ISO__c = 'MY');
        acc.Is_Conquest__c = true;
        insert acc;
        acc.ivybase__Active__c = 'yes';
        acc.Converted_to_Normal_Saloon__c = true;
        
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-11));
        insert skuasaloonsale;
        
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-11));
        insert skuasaloonsale1;
        
        SKU_SaloonSale__c skuasaloonsale2= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale2;
        
        SKU_SaloonSale__c skuasaloonsale3= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale3;
        
        SKU_SaloonSale__c skuasaloonsale4= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-12));
        insert skuasaloonsale4;
        
        SKU_SaloonSale__c skuasaloonsale5= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'MY',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today().addMonths(-12));
        insert skuasaloonsale5;
        
        Top20Account__c top20 = new Top20Account__c(Account__c=acc.Id,Market_ISO__c = 'MY');
        insert top20;
        
        Top20ProductDetail__c Top20pd = new Top20ProductDetail__c(Top20Account__c=top20.Id,Product_Master__c=proSKU.id,LastYearNetSales__c=1000,YTD__c=100,LYTD__c=900);
        insert Top20pd;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
            
        ivybase__Product_Group_Detail__c proGrpDetail = new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c=pg1.Id,Market_ISO__c = 'MY',ivybase__Product__c=proSKU.Id);
        insert proGrpDetail;
            
        Test.startTest();
        BatchClass_Top20Sales t=new BatchClass_Top20Sales();
        Database.executeBatch(t);
        test.stopTest();
        
    }

}