@isTest

public without sharing class TestTurnOverBathcclass  {

   
    private static testMethod void testTurnOver1(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');  
        ph.Market_ISO__c='SG';
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');     
        Signature.Market_ISO__c='SG';
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        Brand.Market_ISO__c='SG';
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        subBrand.Market_ISO__c='SG';
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        reference.Market_ISO__c='SG';
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        naunce.Market_ISO__c='SG';
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        axe.Market_ISO__c='SG';
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        subAxe.Market_ISO__c='SG';
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        classp.Market_ISO__c='SG';
        insert classP;
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes'); 
        function.Market_ISO__c='SG';
        function.ivybase__Parent__c = classP.Id;
        insert function;
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c='SG';
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
        
        
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'SG', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'SG', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'SG'),
            new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'SG'),
            new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'SG') 
        };
        insert shyList;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Account acc = new Account(Name='aaa', Is_Conquest__c = true,recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id);
        insert acc;
        acc.Market_ISO__c='SG';
        update acc;
        
        List<Account> accList =new List<Account>();
        accList.add(acc);
        
        
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'SG',Account__c=acc.id,SaleAmount__c=1000,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'SG',Account__c=acc.id,SaleAmount__c=1000,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale1;
        
        Turnover__c turnOver = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=classP.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver;
          Turnover__c turnOver1 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=Signature.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver1;
           Turnover__c turnOver2 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=Brand.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver2;
          Turnover__c turnOver3 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=subBrand.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver3;
           Turnover__c turnOver4 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=reference.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver4;
        
         Turnover__c turnOver5 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=naunce.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver5;
           Turnover__c turnOver6 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=axe.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver6;
        Turnover__c turnOver7 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=subAxe.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver7;
         Turnover__c turnOver8 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=function.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver8;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='BatchSalonInvoice_Resource';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        TurnOver_Batch t=new TurnOver_Batch();
        Database.executeBatch(t);
        TurnOver_BatchForPreviousData tPrevious=new TurnOver_BatchForPreviousData(Date.today().year(),Date.today().month());
        Database.executeBatch(tPrevious);
        Test.stopTest();
    }
    
     private static testMethod void testTurnOver2(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');  
        ph.Market_ISO__c='SG';
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');     
        Signature.Market_ISO__c='SG';
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        Brand.Market_ISO__c='SG';
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        subBrand.Market_ISO__c='SG';
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        reference.Market_ISO__c='SG';
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        naunce.Market_ISO__c='SG';
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        axe.Market_ISO__c='SG';
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        subAxe.Market_ISO__c='SG';
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        classp.Market_ISO__c='SG';
        insert classP;
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes'); 
        function.Market_ISO__c='SG';
        function.ivybase__Parent__c = classP.Id;
        insert function;
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c='SG';
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
        
        
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'SG', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'SG', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'SG'),
            new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'SG'),
            new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'SG') 
        };
        insert shyList;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Account acc = new Account(Name='aaa', Is_Conquest__c = true,recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id);
        insert acc;
        acc.Market_ISO__c='SG';
        update acc;
        
        List<Account> accList =new List<Account>();
        accList.add(acc);
        
        
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'SG',Account__c=acc.id,SaleAmount__c=1000,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'SG',Account__c=acc.id,SaleAmount__c=1000,InvoiceDate__c=Date.today(),Resource__c=res.Id);
        insert skuasaloonsale1;
        
     /**   Turnover__c turnOver = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=classP.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver;
          Turnover__c turnOver1 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=Signature.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver1;
           Turnover__c turnOver2 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=Brand.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver2;
          Turnover__c turnOver3 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=subBrand.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver3;
           Turnover__c turnOver4 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=reference.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver4;
        
         Turnover__c turnOver5 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=naunce.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver5;
           Turnover__c turnOver6 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=axe.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver6;
        Turnover__c turnOver7 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=subAxe.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver7;
         Turnover__c turnOver8 = new Turnover__c(Sales_Value__c=1000,Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Product_Hierarchy__c=function.Id,year__c=Date.today().year(),Resource__c=res.Id);
        insert turnOver8;**/
        
        Test.startTest();
        TurnOver_Batch t=new TurnOver_Batch();
        Database.executeBatch(t);
        TurnOver_BatchForPreviousData tPrevious=new TurnOver_BatchForPreviousData(Date.today().year(),Date.today().month());
        Database.executeBatch(tPrevious);
        Test.stopTest();
    }
}