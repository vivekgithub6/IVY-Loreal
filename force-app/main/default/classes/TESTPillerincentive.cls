@isTest
private class TESTPillerincentive {
    
    public static testmethod void test1()
    {
        Test.startTest();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c = 'SG';
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes');     
        Signature.Market_ISO__c = 'SG';
        insert Signature;
        
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        Brand.Market_ISO__c = 'SG';
        insert Brand;
        
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        subBrand.Market_ISO__c = 'SG';
        insert subBrand;
        
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        reference.Market_ISO__c = 'SG';
        insert reference;
        
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        naunce.Market_ISO__c = 'SG';
        insert naunce;
        
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        axe.Market_ISO__c = 'SG';
        insert axe;
        
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        subAxe.Market_ISO__c = 'SG';
        insert subAxe;
        
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        classP.Market_ISO__c = 'SG';
        insert classP;
        
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        function1.Market_ISO__c = 'SG';
        insert function1;
        
        ivybase__Product_Hierarchy__c Brand1 = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand1.ivybase__Parent__c = Signature.Id;
        Brand1.Market_ISO__c = 'SG';
        insert Brand1;
        
        ivybase__Product_Hierarchy__c subBrand1 = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand1.ivybase__Parent__c = Brand1.Id;
        subBrand1.Market_ISO__c = 'SG';
        insert subBrand1;
        
        ivybase__Product_Hierarchy__c reference1 = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference1.ivybase__Parent__c = subBrand1.Id;
        reference1.Market_ISO__c = 'SG';
        insert reference1;
        
        ivybase__Product_Hierarchy__c naunce1 = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce1.ivybase__Parent__c = reference1.Id;
        naunce1.Market_ISO__c = 'SG';
        insert naunce1;
        
        ivybase__Product_Hierarchy__c axe1 = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe1.ivybase__Parent__c = naunce1.Id;
        axe1.Market_ISO__c = 'SG';
        insert axe1;
        
        ivybase__Product_Hierarchy__c subAxe1 = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe1.ivybase__Parent__c = axe1.Id;
        subAxe1.Market_ISO__c = 'SG';
        insert subAxe1;
        
        ivybase__Product_Hierarchy__c classP1 = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP1.ivybase__Parent__c = subAxe1.Id;
        classP1.Market_ISO__c = 'SG';
        insert classP1;
        
        ivybase__Product_Hierarchy__c function11 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function11.ivybase__Parent__c = classP1.Id;
        function11.Market_ISO__c = 'SG';
        insert function11;
        
        List<ivybase__Product__c> proList = new List<ivybase__Product__c>();
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'SG';
        proList.add(proSKU);
        
        ivybase__Product__c proSKU1 = TestUtility.createTestProduct('Testdsduploadtwo',function1.Id,'Testdesc', false ,'Yes');
        proSKU1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU1.Market_ISO__c = 'SG';
        proList.add(proSKU1);
        
        ivybase__Product__c proSKU2 = TestUtility.createTestProduct('Testdsduploadthree',function11.Id,'Testdesc', false ,'Yes');
        proSKU2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU2.Market_ISO__c = 'SG';
        proList.add(proSKU2);
        
        ivybase__Product__c proSKU3 = TestUtility.createTestProduct('Testdsduploadfour',function11.Id,'Testdesc', false ,'Yes');
        proSKU3.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU3.Market_ISO__c = 'SG';
        proList.add(proSKU3);
        
        insert proList;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'SG';
        insert locHr;
        
        List<Account> accList = new List<Account>();
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = 'SG';
        accList.add(acc);
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456780' , '11122233' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        acc1.Market_ISO__c = 'SG';
        accList.add(acc1);
        
        Account acc2 = TestUtility.createTestAccount('3' , 'Test Acc2' , '123456780' , '11122233' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        acc2.Market_ISO__c = 'SG';
        accList.add(acc2);
        
        Account acc3 = TestUtility.createTestAccount('4' , 'Test Acc3' , '123456780' , '11122233' , res.id , 'Retail_Account' , 'Yes' );
        acc3.ivybase__Location_Hierarchy__c = locHr.Id;
        acc3.Converted_to_Normal_Saloon__c = true;
        acc3.Dream_List_Status__c ='Test';
        acc3.Progress_Percentage__c = 100;
        acc3.Market_ISO__c = 'SG';
        accList.add(acc3);
        insert accList;
        
        accList[0].ivybase__Active__c='yes';
        accList[1].ivybase__Active__c='yes';
        accList[2].ivybase__Active__c='yes';
        accList[3].ivybase__Active__c='yes';
        update accList;
        
        List<Contact> conList = new List<Contact>();
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        conList.add(con);
        
        
        insert conList;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'SG');
        insert division;
        
        List<ivydsd__Order__c> orderList =  new List<ivydsd__Order__c>();
        
        for(integer i=0;i<accList.size()-1;i++) {
            
            for(integer j=0;j<10;j++) {
                
                ivydsd__Order__c order = TestUtility.createTestOrder(accList[i].id,'Draft',conList[0].id,'1');  
                order.ivydsd__Resource__c = res.Id;
                order.Division__c=division.id;
                order.Market_ISO__c = 'SG';
                orderList.add(order);
            }   
        }    
        
        insert orderList;
        
        List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
        for(integer i=0;i<orderList.size();i++) {
            
            for(integer j=0;j<4;j++) {
                
                ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[i].id , proList[j].id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
                oliList.add(oli);
            }   
        }    
        insert oliList;
        
        ivydsd__Order__c lastorder = TestUtility.createTestOrder(accList[3].id,'Ordered',conList[0].id,'1');  
        lastorder.ivydsd__Resource__c = res.Id;
        lastorder.Division__c=division.id;
        lastorder.Market_ISO__c = 'SG';
        insert lastorder;
        
        List<ivydsd__Invoice__c> invList =  new List<ivydsd__Invoice__c>();
        
        for(integer i=0;i<orderList.size();i++) {
            
            ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(orderList[i].ivydsd__Store__c, '1', 15000 , orderList[i].id , orderList[i].ivydsd__Seller__c);
            invoice.ivydsd__Invoice_Date__c = System.today();
            invoice.ivydsd__Resource__c = res.Id;
            invoice.Market_ISO__c = 'SG';
            invList.add(invoice);
        }
        
        
        insert invList;
        
        List<ivydsd__Invoice_Line_Item__c> invLineList =  new List<ivydsd__Invoice_Line_Item__c>();
        
        for(integer i=0;i<invList.size();i++) {
            
            for(integer j=0;j<4;j++) {
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invList[i].Id,proList[j].Id); 
                invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
                invLineItem.Market_ISO__c = 'SG';
                invLineList.add(invLineItem);
            }   
        }    
        insert invLineList;
        Test.stopTest();
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(lastorder.ivydsd__Store__c, '1', 15000 , lastorder.id , lastorder.ivydsd__Seller__c);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        invoice.Market_ISO__c = 'SG';
        insert invoice;
        
        ivybase__Product_Group__c pgColorIncentive = TestUtility.createTestProductGroup('TestProductGroupColorIncentive','Yes','KPI_Group');
        pgColorIncentive.ivybase__Grouping_Type__c = 'Color Incentive';
        pgColorIncentive.Buy_Logic_Value__c = 1;
        pgColorIncentive.Buy_Logic__c = 'ANY';
        pgColorIncentive.Market_ISO__c = 'SG';
        insert pgColorIncentive;
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>{
            new ivybase__Product_Group_Detail__c(Market_ISO__c='SG',ivybase__Product_Group__c = pgColorIncentive.Id,ivybase__Product__c = proList[0].Id, Product_Hierarchy__c  = Brand.Id),
                
                new ivybase__Product_Group_Detail__c(Market_ISO__c='SG',ivybase__Product_Group__c = pgColorIncentive.Id,ivybase__Product__c = proList[1].Id, Product_Hierarchy__c  = Brand1.Id)
                
                };
                    insert pgdList;
        
        Incentive_Group__c incentiveGrp = TestUtility.createTestIncentiveDroup('Test Incentive Group');   
        insert incentiveGrp;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',null,50,500,incentiveGrp.Id);   
        insert incentiveSlab1;
        
        List<Target_Actual__c> targetActualList = new List<Target_Actual__c>();
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgColorIncentive.Id,Target__c=1000,Parameter_type__c = 'Target achievement',Actual__c=1000,Market_ISO__c = 'SG',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), Incentive_Group__c = incentiveGrp.Id);
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SG_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        targetActualList.add(salesTarget);
        insert targetActualList;
        
        Account_Target__c att = new Account_Target__c();
        att.Target_Actual__c=targetActualList[0].id;
        att.Account__c=accList[0].id;
        insert att;
        
        set<Id> store = new set<Id>();
        List<ivydsd__Invoice__c> inv = [select id,name,ivydsd__Store__c from ivydsd__Invoice__c];
        for(ivydsd__Invoice__c ins:inv)
        {
            store.add(ins.ivydsd__Store__c);
        }
        System.debug('size store'+store.size());
        System.debug('size invoice'+inv.size());
        
        List<Target_Actual__c> rec = [Select id,Resource__c,Mid_Month_Achievement__c,Product_Group__c,Actual__c,Parameter_type__c,Market_ISO__c,Incentive_Group__c,Achievement__c,Start_Date1__c,End_Date1__c,Target__c from Target_Actual__c];
        
        
        
        pillerIncentive.ProcessTargetActualAndCreateUniqueAccountCovered(rec);
        
        
        List<Account_Target__c> accres = [select id,name,Account__c from Account_Target__c];
        system.debug('acc size'+accres.size());
        for(Account_Target__c a:accres)
        {
            system.debug('a'+accres);
        }
        
    }
    
    
}