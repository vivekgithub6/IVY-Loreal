@isTest
private class TESTSalesTargetCalculatingBatch {
    private static testMethod void testSalesTarget(){
       
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
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
       
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'MY');
        insert divLoc;
       
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c='yes';
        update acc;
          
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','Top20sku');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        insert pgFusio;
        
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        
        Incentive_Group__c incentiveGrp1 = TestUtility.createTestIncentiveDroup('Test Incentive Group1');   
        insert incentiveGrp1;
        
        Incentive_Slab__c incentiveSlab = TestUtility.createTestIncentiveSlab('TestTarget',2000,1000,1500,incentiveGrp.Id);   
        insert incentiveSlab;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',0,60,500,incentiveGrp.Id);   
        insert incentiveSlab1;
        
        Incentive_Slab__c incentiveSlab2 = TestUtility.createTestIncentiveSlab('TestTarget',60,100,1500,incentiveGrp.Id);   
        insert incentiveSlab2;
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target achievement',Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                           Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Sales_Recovery_Value__c = 1, Sales_Recovery__c=true, Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget;
        
        Target_Actual__c salesTarget1 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Quarter incentive',Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Incentive_Group__c = incentiveGrp.Id);
        salesTarget1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget1;
        
        //Target_Actual__c salesTarget2 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000, Parameter_type__c = 'Target achievement',Actual__c=2000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
        //                                                    Start_Date1__c=Date.today().addMonths(-1),End_Date1__c=Date.today().addDays(+3), Sales_Recovery_Value__c = 1,Sales_Recovery__c=true, Incentive_Group__c = incentiveGrp.Id);
        //salesTarget2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        //insert salesTarget2;
        
        Target_Actual__c salesTarget3 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000, Parameter_type__c = 'Target achievement',Actual__c=2000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addMonths(-1),End_Date1__c=Date.today().addDays(+3), Sales_Recovery_Value__c = 1,Sales_Recovery__c=true, Incentive_Group__c = incentiveGrp1.Id);
        salesTarget3.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget3;
        
        Target_Actual__c salesTarget5 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000, Parameter_type__c = 'Sales Recovery',Actual__c=2000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addMonths(-1),End_Date1__c=Date.today().addDays(+3), Sales_Recovery_Value__c = 1,Sales_Recovery__c=false, Incentive_Group__c = incentiveGrp.Id);
        salesTarget5.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget5;
        
        Target_Actual__c salesTarget4 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000, Parameter_type__c = 'Target achievement',Actual__c=2000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Achievement__c=1000,Start_Date1__c=Date.today().addMonths(-2),End_Date1__c=Date.today().addMonths(-1), Sales_Recovery_Value__c = 1,Sales_Recovery__c=true, Incentive_Group__c = incentiveGrp.Id);
        salesTarget4.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget4;
        update salesTarget4;
        
        List<Target_Division__c> targetDivList = new List<Target_Division__c>{
            new Target_Division__c(Name='Test Division1',Market_ISO__c = 'MY',Division__c=division.Id,Target_Actual__c=salesTarget3.Id)
        };
        insert targetDivList;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
       
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        insert order;
    
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 1500000 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,proSKU.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 100000;
        insert invLineItem;
            
        Test.startTest();
        SalesTargetCalculatingBatch salesTargetBatch = new SalesTargetCalculatingBatch();
        Database.executeBatch(salesTargetBatch);
        Test.stopTest();
        
        List<Target_Actual__c> targetActualList = [SELECT Id, Actual__c, Achievement__c FROM Target_Actual__c WHERE Incentive_Group__c =: incentiveGrp.Id];
        System.debug('targetActualLis===>'+targetActualList);
        //System.assertEquals(incentiveSlab.Incentive__c+incentiveSlab1.Incentive__c, targetActualList[0].Achievement__c);
    }
    
    private static testMethod void testSalesTargetPH(){
       
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        res.Market_ISO__c = 'PH';
        insert res;
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        ph.Market_ISO__c = 'PH';    
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');
        Signature.Market_ISO__c = 'PH';    
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.Market_ISO__c = 'PH';
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');   
        subBrand.Market_ISO__c = 'PH';  
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');  
        reference.Market_ISO__c = 'PH';   
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.Market_ISO__c = 'PH';
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.Market_ISO__c = 'PH';
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.Market_ISO__c = 'PH';
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.Market_ISO__c = 'PH';
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');    
        function1.Market_ISO__c = 'PH';
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'PH';
        insert proSKU;
        
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'PH';
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'PH';
        insert locHr;
       
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'PH');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'PH');
        insert divLoc;
       
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = 'PH';
        insert acc;
        acc.ivybase__Active__c='yes';
        update acc;
          
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','Top20sku');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Market_ISO__c = 'PH';
        insert pgFusio;
        
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        Incentive_Slab__c incentiveSlab = TestUtility.createTestIncentiveSlab('TestTarget',1000,2000,1500,incentiveGrp.Id);   
        insert incentiveSlab;
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target achievement',Actual__c=1000,Market_ISO__c = 'PH',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3),Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget;
       
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
       
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        order.Market_ISO__c = 'PH';
        insert order;
    
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 150000 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        invoice.Market_ISO__c = 'PH';
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,proSKU.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        invLineItem.Market_ISO__c = 'PH';
        insert invLineItem;
          list< Incentive_Slab__c> inslblist= new list<Incentive_Slab__c>();
        inslblist.add(incentiveSlab);
        Test.startTest();
        SalesTargetCalculatingBatch.getMinimumIncentiveSlabExcept50(inslblist);
        SalesTargetCalculatingBatch salesTargetBatch = new SalesTargetCalculatingBatch();
        Database.executeBatch(salesTargetBatch);
        Test.stopTest();
    }
}