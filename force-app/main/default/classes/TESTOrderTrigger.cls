/**
 * Created By : Ivy Mobility
 * Created Date : 2018
 * Purpose : To cover the codes of the OrderTrigger and OrderTriggerHandler
 * Classes covered : OrderTrigger(96%), OrderTriggerHandler(83%)
*/
@isTest
private class TESTOrderTrigger {
    
    @isTest
    private static void  testOrderUpdate() {
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c = 'SG';
        res.SAP_Id__c = '12345';
        insert res;
        
        insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='SG');
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test1','Sub_Brand', false ,'Yes');   
        ph.Market_ISO__c = 'SG';  
        insert ph;
        
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
        
        List<ivybase__Product__c> proList = new List<ivybase__Product__c>();
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'SG';
        proList.add(proSKU);
        
        ivybase__Product__c proSKU1 = TestUtility.createTestProduct('Testdsduploadtwo',function1.Id,'Testdesc', false ,'Yes');
        proSKU1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU1.Market_ISO__c = 'SG';
        proList.add(proSKU1);
        
        insert proList;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'SG';
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'SG';
        insert locHr;
       
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'SG');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'SG');
        insert divLoc;
        
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
        
        insert accList;
        
        accList[0].ivybase__Active__c='Yes';
        accList[0].Converted_Date__c = Date.today().addDays(-4);       
        accList[1].ivybase__Active__c='Yes';
        accList[1].Converted_Date__c = Date.today().addDays(-4);
        update accList;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
        
        List<ivydsd__Order__c> order =  new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order11 = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order11.ivydsd__Resource__c = res.Id;
        order11.Division__c=division.id;
        order11.Market_ISO__c = 'SG';
        order.add(order11);
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(accList[1].id,'Ordered',con.id,'1');  
        order1.ivydsd__Resource__c = res.Id;
        order1.Division__c=division.id;
        order1.Market_ISO__c = 'SG';
        order.add(order1);
        
        insert order;
        
        List<ivydsd__Order_Line_item__c> oliList = new List<ivydsd__Order_Line_item__c>();
        ivydsd__Order_Line_item__c oli= TestUtility.createTestOrderLineItem(order[0].id , proList[0].id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
        oliList.add(oli);
        ivydsd__Order_Line_item__c oli1= TestUtility.createTestOrderLineItem(order[1].id , proList[0].id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
        oliList.add(oli1);
        
        insert oliList;
        
        order[0].ivydsd__Order_Status__c = 'Ordered';
        order[1].ivydsd__Order_Status__c = 'Ordered';
        update order;
        
        OrderTriggerHandler.MatchingRepDivison(order);
    }
    @isTest
    private static void  testOrderUpdate1() {
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c = 'SG';
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test1','Sub_Brand', false ,'Yes');   
        ph.Market_ISO__c = 'SG';  
        insert ph;
        
                insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='SG');
        
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
        
        List<ivybase__Product__c> proList = new List<ivybase__Product__c>();
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'SG';
        proList.add(proSKU);
        
        ivybase__Product__c proSKU1 = TestUtility.createTestProduct('Testdsduploadtwo',function1.Id,'Testdesc', false ,'Yes');
        proSKU1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU1.Market_ISO__c = 'SG';
        proList.add(proSKU1);
        
        insert proList;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'SG';
        insert locNational;
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'SG';
        insert locHr;
       
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'SG');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'SG');
        insert divLoc;
        
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
        
        insert accList;
        
        accList[0].ivybase__Active__c='Yes';
        accList[0].Converted_Date__c = Date.today().addDays(-4);       
        accList[1].ivybase__Active__c='Yes';
        accList[1].Converted_Date__c = Date.today().addDays(-4);
        update accList;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser');
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        order.Market_ISO__c = 'SG';
        
        insert order;
        
        Minimum_Order_Amount__c minOrder = new Minimum_Order_Amount__c(Division__c = division.Id,Value__c=100,
                                                                      From__c=Date.today(), To__c=Date.today(),
                                                                      Market_ISO__c = 'SG');
        insert minOrder;
        
        order.ivydsd__Order_Status__c = 'Ordered';
        //update order;
        
        ivydsd__Order_Line_item__c oli= TestUtility.createTestOrderLineItem(order.id , proList[0].id, ((1+1)*100) ,0, 0 , ((1+1)*10) , 0, 0 );
        insert oli;
        
        /*****/
        // The following code block was added by Karthik to cover the OrderTrigger and OrderTriggerHandler Class codes
        List<ivybase__Standard_List_Master__c> slmList = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__Resource_Type__c = restype.Id, ivybase__Location_Hierarchy__c = locNational.Id,
                                                ivybase__List_Type__c = 'TAX_TYPE')
        };
        insert slmList;
        User u = new User(Id = UserInfo.getUserId(), ProfileId = UserInfo.getProfileId(), Market_ISO__c = 'PH');
        System.runAs(u) {
            UserwiseCountryValues__c ucv = UserwiseCountryValues__c.getValues(UserInfo.getUserId());
            ucv.Market_ISO__c = 'PH';
            update ucv;
            ivydsd__Order__c phorder = TestUtility.createTestOrder(accList[0].id, 'Ordered', con.id,'1');  
            phorder.ivydsd__Resource__c = res.Id;
            phorder.Division__c = division.id;
            phorder.Customer_PO__c = 'PO#123';
            phorder.Market_ISO__c = 'PH';
            phorder.Signature_Image_Path__c = 'http://test.salesforce.com';
            insert phorder;
            System.debug('+++'+phorder.Id);
        }
        /*****/
    }
}