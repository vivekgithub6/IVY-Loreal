@isTest
private class TESTKeyBetsCalculation_batch {
    
    @testSetup
    private static void setupmethod(){
       
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test1','Sub_Brand', false ,'Yes');     
        insert ph;
        
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
        
        List<ivybase__Product__c> proList = new List<ivybase__Product__c>();
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proList.add(proSKU);
        
        ivybase__Product__c proSKU1 = TestUtility.createTestProduct('Testdsduploadtwo',function1.Id,'Testdesc', false ,'Yes');
        proSKU1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proList.add(proSKU1);
        
        insert proList;
        
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
        
        List<Account> accList = new List<Account>();
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        accList.add(acc);
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456780' , '11122233' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        accList.add(acc1);
        
        insert accList;
        
        accList[0].ivybase__Active__c='yes';
        accList[1].ivybase__Active__c='yes';
        update accList;
    }
    
    @isTest
    private static void  testKeyBetsCalculation() {
        
        Id userId = UserInfo.getUserId();
        
        ivybase__Resource__c res = [SELECT Id FROM ivybase__Resource__c LIMIT 1];
        
        List<ivybase__Product_Hierarchy__c> phList = [SELECT Id, Name FROM ivybase__Product_Hierarchy__c];
        
        List<ivybase__Product__c> proList = [SELECT Id, Name FROM ivybase__Product__c];
        
        Division__c  division  = [SELECT Id, Name FROM Division__c];
        
        List<Account> accList = [SELECT Id, Name FROM Account];
        
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','Top20sku');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Buy_Logic_Value__c = 1;
        pgFusio.Buy_Logic__c = 'ANY';
        insert pgFusio;
        
        ivybase__Product_Group__c pgFusio1=TestUtility.createTestProductGroup('TestProductGroupFusio1','Yes','Top20sku');
        pgFusio1.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio1.Buy_Logic_Value__c = 1;
        pgFusio1.Buy_Logic__c = 'ANY';
        insert pgFusio1;
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>{
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgFusio.Id, ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgFusio.Id, ivybase__Product__c = proList[1].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgFusio.Id, Product_Hierarchy__c = phList[9].Id)
            
        };
        insert pgdList;
                
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',null,40,500,incentiveGrp.Id);   
        insert incentiveSlab1;
        
        List<Target_Actual__c> lyTargetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c lySalesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target achievement',
                                                            Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-365),End_Date1__c=Date.today().addDays(-350), 
                                                            Incentive_Group__c = incentiveGrp.Id, Year__c =  Date.today().year() - 1);
        lySalesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        lyTargetActualList.add(lySalesTarget);
        
        insert lyTargetActualList ;
        List<Target_Actual__c> targetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target achievement',Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        targetActualList.add(salesTarget);
        
        insert targetActualList;
        
        List<Account_Target__c> accTargetCoverage = new List<Account_Target__c>{
            new Account_Target__c(Account__c=accList[0].Id,Product_Group__c=pgFusio.Id,Target_Actual__c=lyTargetActualList[0].Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=accList[1].Id,Product_Group__c=pgFusio.Id,Target_Actual__c=lyTargetActualList[0].Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=accList[0].Id,Product_Group__c=pgFusio.Id,Target_Actual__c=targetActualList[0].Id,Month__c=Date.today().Month())
        };
        insert accTargetCoverage;
       
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
        
        List<ivydsd__Order__c> orderList =  new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        orderList.add(order);
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order1.ivydsd__Resource__c = res.Id;
        order1.Division__c=division.id;
        orderList.add(order1);
        
        insert orderList;
        
        List<ivydsd__Invoice__c> invList =  new List<ivydsd__Invoice__c>();
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(accList[0].id ,'1', 15000 , orderList[0].id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        invList.add(invoice);
        
        ivydsd__Invoice__c invoice1 = TestUtility.createTestInvoice(accList[1].id ,'1', 15000 , orderList[1].id , con.id);
        invoice1.ivydsd__Invoice_Date__c = System.today();
        invoice1.ivydsd__Resource__c = res.Id;
        invList.add(invoice1);
        
        insert invList;
        
        List<ivydsd__Invoice_Line_Item__c> invLineList =  new List<ivydsd__Invoice_Line_Item__c>();
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invList[0].Id,proList[0].Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem);
        
        ivydsd__Invoice_Line_Item__c invLineItem1 = TestUtility.createTestInvoiceLineItem(invList[0].Id,proList[1].Id); 
        invLineItem1.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem1);
        
        ivydsd__Invoice_Line_Item__c invLineItem2 = TestUtility.createTestInvoiceLineItem(invList[1].Id,proList[0].Id); 
        invLineItem2.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem2);
        
        ivydsd__Invoice_Line_Item__c invLineItem3 = TestUtility.createTestInvoiceLineItem(invList[1].Id,proList[1].Id); 
        invLineItem3.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem3);
        
        insert invLineList;
            
        Test.startTest();
        KeyBetsCalculation_batch salesTargetBatch = new KeyBetsCalculation_batch();
        Database.executeBatch(salesTargetBatch);
        Test.stopTest();
        
        List<Target_Actual__c> targetActualList1 = [SELECT Id, Actual__c, Achievement__c FROM Target_Actual__c WHERE Incentive_Group__c =: incentiveGrp.Id];
        System.debug('targetActualLis===>'+targetActualList1);
        //System.assertEquals(incentiveSlab1.Incentive__c, targetActualList1[1].Achievement__c);
    }
    
    @isTest
    private static void  testKeyBetsCalculation2() {
        
        Id userId = UserInfo.getUserId();
        
        ivybase__Resource__c res = [SELECT Id FROM ivybase__Resource__c LIMIT 1];
        
        List<ivybase__Product_Hierarchy__c> phList = [SELECT Id, Name FROM ivybase__Product_Hierarchy__c];
        System.debug('phList===>'+phList[8]);
        List<ivybase__Product__c> proList = [SELECT Id, Name FROM ivybase__Product__c];
        
        Division__c  division  = [SELECT Id, Name FROM Division__c];
        
        List<Account> accList = [SELECT Id, Name FROM Account];
        
        
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','Top20sku');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Buy_Logic_Value__c = 1;
        pgFusio.Buy_Logic__c = 'ANY';
        insert pgFusio;
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>{
            new ivybase__Product_Group_Detail__c(Market_ISO__c='MY',ivybase__Product_Group__c = pgFusio.Id, Product_Hierarchy__c = phList[8].Id)
            
        };
        insert pgdList;
                
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',null,40,500,incentiveGrp.Id);   
        insert incentiveSlab1;
        
        List<Target_Actual__c> lyTargetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c lySalesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target achievement',
                                                            Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-365),End_Date1__c=Date.today().addDays(-350), 
                                                            Incentive_Group__c = incentiveGrp.Id, Year__c =  Date.today().year() - 1);
        lySalesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        lyTargetActualList.add(lySalesTarget);
        
        insert lyTargetActualList ;
        
        List<Account_Target__c> accTargetCoverage = new List<Account_Target__c>{
            new Account_Target__c(Account__c=accList[0].Id,Product_Group__c=pgFusio.Id,Target_Actual__c=lyTargetActualList[0].Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=accList[1].Id,Product_Group__c=pgFusio.Id,Target_Actual__c=lyTargetActualList[0].Id,Month__c=Date.today().Month())
        };
        insert accTargetCoverage;
        
        List<Target_Actual__c> targetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target achievement',Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        targetActualList.add(salesTarget);
        
        insert targetActualList;
       
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
        
        List<ivydsd__Order__c> orderList =  new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        orderList.add(order);
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order1.ivydsd__Resource__c = res.Id;
        order1.Division__c=division.id;
        orderList.add(order1);
        
        insert orderList;
        
        List<ivydsd__Invoice__c> invList =  new List<ivydsd__Invoice__c>();
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(accList[0].id ,'1', 15000 , orderList[0].id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        invList.add(invoice);
        
        ivydsd__Invoice__c invoice1 = TestUtility.createTestInvoice(accList[1].id ,'1', 15000 , orderList[1].id , con.id);
        invoice1.ivydsd__Invoice_Date__c = System.today();
        invoice1.ivydsd__Resource__c = res.Id;
        invList.add(invoice1);
        
        insert invList;
        
        List<ivydsd__Invoice_Line_Item__c> invLineList =  new List<ivydsd__Invoice_Line_Item__c>();
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invList[0].Id,proList[0].Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem);
        
        ivydsd__Invoice_Line_Item__c invLineItem1 = TestUtility.createTestInvoiceLineItem(invList[0].Id,proList[1].Id); 
        invLineItem1.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem1);
        
        ivydsd__Invoice_Line_Item__c invLineItem2 = TestUtility.createTestInvoiceLineItem(invList[1].Id,proList[0].Id); 
        invLineItem2.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem2);
        
        ivydsd__Invoice_Line_Item__c invLineItem3 = TestUtility.createTestInvoiceLineItem(invList[1].Id,proList[1].Id); 
        invLineItem3.ivydsd__UOM_1_Quantity__c = 1000;
        invLineList.add(invLineItem3);
        
        insert invLineList;
            
        Test.startTest();
        KeyBetsCalculation_batch salesTargetBatch = new KeyBetsCalculation_batch();
        Database.executeBatch(salesTargetBatch);
        Test.stopTest();
        
        List<Target_Actual__c> targetActualList1 = [SELECT Id, Actual__c, Achievement__c FROM Target_Actual__c WHERE Incentive_Group__c =: incentiveGrp.Id];
        System.debug('targetActualLis===>'+targetActualList1);
        //System.assertEquals(incentiveSlab1.Incentive__c, targetActualList1[1].Achievement__c);
    }
}