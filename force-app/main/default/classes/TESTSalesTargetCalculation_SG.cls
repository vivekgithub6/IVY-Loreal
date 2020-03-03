/**Last edited Pranav @06-05-2019**/
@isTest
private class TESTSalesTargetCalculation_SG {
    
    @testSetup
    private static void setupmethod(){
       
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        restype.CurrencyIsoCode = 'SGD';
        insert restype;
        
        User usr = TestUtility.getSGBAUser();
        Id userId = usr.Id;//UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c = 'SG';
        res.SAP_Id__c = '12345';
        res.CurrencyIsoCode = 'SGD';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test1','Sub_Brand', false ,'Yes');   
        ph.Market_ISO__c = 'SG';  
        ph.CurrencyIsoCode = 'SGD';
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes');     
        Signature.Market_ISO__c = 'SG';
        Signature.CurrencyIsoCode = 'SGD';
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        Brand.Market_ISO__c = 'SG';
        Brand.CurrencyIsoCode = 'SGD';
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        subBrand.Market_ISO__c = 'SG';
        subBrand.CurrencyIsoCode = 'SGD';
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        reference.Market_ISO__c = 'SG';
        reference.CurrencyIsoCode = 'SGD';
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        naunce.Market_ISO__c = 'SG';
        naunce.CurrencyIsoCode = 'SGD';
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        axe.Market_ISO__c = 'SG';
        axe.CurrencyIsoCode = 'SGD';
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        subAxe.Market_ISO__c = 'SG';
        subAxe.CurrencyIsoCode = 'SGD';
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        classP.Market_ISO__c = 'SG';
        classP.CurrencyIsoCode = 'SGD';
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        function1.Market_ISO__c = 'SG';
        function1.CurrencyIsoCode = 'SGD';
        insert function1;
        
        List<ivybase__Product__c> proList = new List<ivybase__Product__c>();
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'SG';
        proSKU.CurrencyIsoCode = 'SGD';
        proList.add(proSKU);
        
        ivybase__Product__c proSKU1 = TestUtility.createTestProduct('Testdsduploadtwo',function1.Id,'Testdesc', false ,'Yes');
        proSKU1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU1.Market_ISO__c = 'SG';
        proSKU1.CurrencyIsoCode = 'SGD';
        proList.add(proSKU1);
        
        insert proList;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'SG';
        locNational.CurrencyIsoCode = 'SGD';
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'SG';
        locHr.CurrencyIsoCode = 'SGD';
        insert locHr;
       
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'SG', CurrencyIsoCode = 'SGD');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, CurrencyIsoCode = 'SGD',Market_ISO__c = 'SG');
        insert divLoc;
        
        List<Account> accList = new List<Account>();
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = 'SG';
        acc.CurrencyIsoCode = 'SGD';
        accList.add(acc);
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456780' , '11122233' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        acc1.Market_ISO__c = 'SG';
        acc1.CurrencyIsoCode = 'SGD';
        accList.add(acc1);
        
        insert accList;
        
        accList[0].ivybase__Active__c='yes';
        accList[1].ivybase__Active__c='yes';
        update accList;
    }
    
    @isTest
    private static void  testSalesTargetCalculation() {
        
        User u = TestUtility.getSGBAUser();
        System.debug('u====>'+u);
        Id userId = u.Id; //UserInfo.getUserId
        
        ivybase__Resource__c res = [SELECT Id FROM ivybase__Resource__c LIMIT 1];
        
        List<ivybase__Product_Hierarchy__c> phList = [SELECT Id, Name FROM ivybase__Product_Hierarchy__c];
        
        List<ivybase__Product__c> proList = [SELECT Id, Name FROM ivybase__Product__c];
        
        Division__c  division  = [SELECT Id, Name FROM Division__c];
        
        List<Account> accList = [SELECT Id, Name FROM Account];
        
        ivybase__Product_Group__c pgColorIncentive = TestUtility.createTestProductGroup('TestProductGroupColorIncentive','Yes','KPI_Group');
        pgColorIncentive.ivybase__Grouping_Type__c = 'Color Incentive';
        pgColorIncentive.Buy_Logic_Value__c = 1;
        pgColorIncentive.Buy_Logic__c = 'ANY';
        pgColorIncentive.Market_ISO__c = 'SG';
        pgColorIncentive.CurrencyIsoCode = 'SGD';
        insert pgColorIncentive;
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>{
            new ivybase__Product_Group_Detail__c(Market_ISO__c='SG',CurrencyIsoCode = 'SGD',ivybase__Product_Group__c = pgColorIncentive.Id, ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='SG',CurrencyIsoCode = 'SGD',ivybase__Product_Group__c = pgColorIncentive.Id, ivybase__Product__c = proList[1].Id)
            
        };
        insert pgdList;
                
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group'); 
        incentiveGrp.CurrencyIsoCode = 'SGD';  
        insert incentiveGrp;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',200,50,500,incentiveGrp.Id); 
        incentiveSlab1.IsPercentage__c  = true;
        incentiveSlab1.CurrencyIsoCode = 'SGD';
        insert incentiveSlab1;
        
        List<Target_Actual__c> targetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgColorIncentive.Id,CurrencyIsoCode = 'SGD',Target__c=100,Parameter_type__c = 'TurnOver Incentive',Actual__c=1000,Market_ISO__c = 'SG',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        targetActualList.add(salesTarget);
        insert targetActualList;
        
        List<Account_Target__c> accTargetCoverage1 = new List<Account_Target__c>{
            new Account_Target__c(Account__c=accList[0].Id,CurrencyIsoCode = 'SGD',Product_Group__c=pgColorIncentive.Id,Target_Actual__c=targetActualList[0].Id,Month__c=Date.today().Month())
        };
        insert accTargetCoverage1;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
        
        List<ivydsd__Order__c> orderList =  new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        order.Market_ISO__c = 'SG';
        order.CurrencyIsoCode = 'SGD';
        orderList.add(order);
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(accList[1].id,'Ordered',con.id,'1');  
        order1.ivydsd__Resource__c = res.Id;
        order1.Division__c=division.id;
        order1.Market_ISO__c = 'SG';
        order1.CurrencyIsoCode = 'SGD';
        orderList.add(order1);
        insert orderList;
        
        List<ivydsd__Invoice__c> invList =  new List<ivydsd__Invoice__c>();
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(accList[0].id ,'1', 100, orderList[0].id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        invoice.Market_ISO__c = 'SG';
        invoice.CurrencyIsoCode = 'SGD';
        invList.add(invoice);
        
        ivydsd__Invoice__c invoice1 = TestUtility.createTestInvoice(accList[1].id ,'1', 100, orderList[1].id , con.id);
        invoice1.ivydsd__Invoice_Date__c = System.today();
        invoice1.ivydsd__Resource__c = res.Id;
        invoice1.Market_ISO__c = 'SG';
        invoice1.CurrencyIsoCode = 'SGD';
        invList.add(invoice1);
        
        insert invList;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='SGCoverageBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        //Test.startTest();
        
        System.runAs(u) {
        
            SalesTargetCalculation_SG SGSalesTargetCalculation = new SalesTargetCalculation_SG();
            Database.executeBatch(SGSalesTargetCalculation);
            //Test.stopTest();
        }
        
        list<AggregateResult> groupedResults11 = new list<AggregateResult>();
        map<id,decimal> invoiceMap= new map<id,decimal>();
        //ivydsd__Invoice_Date__c
            groupedResults11 = [Select SUM(ivydsd__Invoice_Amount__c) sum,ivydsd__Resource__c from ivydsd__Invoice__c 
                              Group By ivydsd__Resource__c];
        
        System.debug('groupedResults11====>'+groupedResults11);
        List<Target_Actual__c> targetActualList1 = [SELECT Id, Actual__c, Achievement__c FROM Target_Actual__c WHERE Incentive_Group__c =: incentiveGrp.Id];
        System.debug('targetActualLis===>'+targetActualList1);
        //System.assertEquals(incentiveSlab1.Incentive__c, targetActualList1[0].Achievement__c);
    }
    
    @isTest
    private static void  testSalesTargetCalculation1() {
        
        Id userId = UserInfo.getUserId();
        
        ivybase__Resource__c res = [SELECT Id FROM ivybase__Resource__c LIMIT 1];
        
        List<ivybase__Product_Hierarchy__c> phList = [SELECT Id, Name FROM ivybase__Product_Hierarchy__c];
        
        List<ivybase__Product__c> proList = [SELECT Id, Name FROM ivybase__Product__c];
        
        Division__c  division  = [SELECT Id, Name FROM Division__c];
        
        List<Account> accList = [SELECT Id, Name FROM Account];
        
        ivybase__Product_Group__c pgColorIncentive = TestUtility.createTestProductGroup('TestProductGroupColorIncentive','Yes','KPI_Group');
        pgColorIncentive.ivybase__Grouping_Type__c = 'Color Incentive';
        pgColorIncentive.Buy_Logic_Value__c = 1;
        pgColorIncentive.Buy_Logic__c = 'ANY';
        pgColorIncentive.Market_ISO__c = 'SG';
        insert pgColorIncentive;
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>{
            new ivybase__Product_Group_Detail__c(Market_ISO__c='SG',ivybase__Product_Group__c = pgColorIncentive.Id, ivybase__Product__c = proList[0].Id),
            new ivybase__Product_Group_Detail__c(Market_ISO__c='SG',ivybase__Product_Group__c = pgColorIncentive.Id, ivybase__Product__c = proList[1].Id)
            
        };
        insert pgdList;
                
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',200,50,500,incentiveGrp.Id); 
        incentiveSlab1.IsPercentage__c  = false;
        insert incentiveSlab1;
        
        List<Target_Actual__c> targetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgColorIncentive.Id,Target__c=1000,Parameter_type__c = 'TurnOver Incentive',Actual__c=1000,Market_ISO__c = 'SG',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        targetActualList.add(salesTarget);
        insert targetActualList;
        
        List<Account_Target__c> accTargetCoverage1 = new List<Account_Target__c>{
            new Account_Target__c(Account__c=accList[0].Id,Product_Group__c=pgColorIncentive.Id,Target_Actual__c=targetActualList[0].Id,Month__c=Date.today().Month())
        };
        insert accTargetCoverage1;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
        
        List<ivydsd__Order__c> orderList =  new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        order.Market_ISO__c = 'SG';
        orderList.add(order);
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(accList[1].id,'Ordered',con.id,'1');  
        order1.ivydsd__Resource__c = res.Id;
        order1.Division__c=division.id;
        order1.Market_ISO__c = 'SG';
        orderList.add(order1);
        insert orderList;
        
        List<ivydsd__Invoice__c> invList =  new List<ivydsd__Invoice__c>();
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(accList[0].id ,'1', 15000 , orderList[0].id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        invoice.Market_ISO__c = 'SG';
        invList.add(invoice);
        
        ivydsd__Invoice__c invoice1 = TestUtility.createTestInvoice(accList[1].id ,'1', 15000 , orderList[1].id , con.id);
        invoice1.ivydsd__Invoice_Date__c = System.today();
        invoice1.ivydsd__Resource__c = res.Id;
        invoice1.Market_ISO__c = 'SG';
        invList.add(invoice1);
        
        insert invList;
            
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='SGCoverageBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        SalesTargetCalculation_SG SGSalesTargetCalculation = new SalesTargetCalculation_SG();
        Database.executeBatch(SGSalesTargetCalculation);
        Test.stopTest();
        
        List<Target_Actual__c> targetActualList1 = [SELECT Id, Actual__c, Achievement__c FROM Target_Actual__c WHERE Incentive_Group__c =: incentiveGrp.Id];
        System.debug('targetActualLis===>'+targetActualList1);
        //System.assertEquals(incentiveSlab1.Incentive__c, targetActualList1[0].Achievement__c);
    }
}