@isTest
private class TESTSalesTargetMidMonthCal {
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
        Incentive_Slab__c incentiveSlab = TestUtility.createTestIncentiveSlab('TestTarget',2000,1000,1500,incentiveGrp.Id);   
        insert incentiveSlab;
        
        Incentive_Slab__c incentiveSlab1 = TestUtility.createTestIncentiveSlab('TestTarget',null,50,500,incentiveGrp.Id);   
        insert incentiveSlab1;
        
        Id salesTargetId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        
        Target_Actual__c salesTarget1 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Target Achievement',
                                                             Actual__c=1000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Achievement__c=1000,Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), 
                                                             Incentive_Group__c = incentiveGrp.Id);
        salesTarget1.RecordTypeId = salesTargetId;
        insert salesTarget1;
        
       
        
        Target_Actual__c salesTarget2 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000, Parameter_type__c = 'Target achievement',Achievement__c=2000,
                                                             Actual__c=2000,Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                             Start_Date1__c=Date.today().addMonths(-1),End_Date1__c=Date.today().addDays(+3),
                                                             Sales_Recovery_Value__c = 1,Sales_Recovery__c=true, Incentive_Group__c = incentiveGrp.Id);
        salesTarget2.RecordTypeId = salesTargetId;
        insert salesTarget2;
        
         Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000,Parameter_type__c = 'Mid Month',Actual__c=1000,
                                                           Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                           Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3), 
                                                           Sales_Recovery_Value__c = 1,  Incentive_Group__c = incentiveGrp.Id,
                                                          Target_Actual__c = salesTarget2.Id);
        salesTarget.RecordTypeId = salesTargetId;
        insert salesTarget;
        
        Target_Actual__c salesTarget4 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Target__c=1000, 
                                                             Parameter_type__c = 'Target achievement',Actual__c=2000,
                                                             Market_ISO__c = 'MY',Resource__c=res.Id,Month__c=Date.today().Month(),
                                                             Achievement__c=1000,Start_Date1__c=Date.today().addMonths(-2),
                                                             End_Date1__c=Date.today().addMonths(-1), Sales_Recovery_Value__c = 1,
                                                             Sales_Recovery__c=true, Incentive_Group__c = incentiveGrp.Id);
        salesTarget4.RecordTypeId = salesTargetId;
        insert salesTarget4;
        update salesTarget4;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller',
                                                    'Merchandiser');
        insert con;
       
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        insert order;
    
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 15000 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        invoice.ivydsd__Resource__c = res.Id;
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,proSKU.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
            
        Test.startTest();
        SalesTargetMidMonthCal salesTargetMidMonthCalBat = new SalesTargetMidMonthCal();
        Database.executeBatch(salesTargetMidMonthCalBat);
        Test.stopTest();
        
        List<Target_Actual__c> targetActualList = [SELECT Id, Actual__c, Target__c, Achievement__c 
                                                   FROM Target_Actual__c WHERE Incentive_Group__c =: incentiveGrp.Id];
        System.debug('targetActualLis===>'+targetActualList);
        
        //targetActualList[0].Parameter_Type__c = 'Target achievement';
        //update targetActualList;
        Target_Actual__c ta = new Target_Actual__c(Target_Actual__c = targetActualList[0].Id, Parameter_Type__c = 'Mid Month',
                                                  Target__c = targetActuallist[0].Target__c);
        //insert ta;
        //System.assertEquals(incentiveSlab.Incentive__c+incentiveSlab1.Incentive__c, targetActualList[0].Achievement__c);
    }
}