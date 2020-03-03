@isTest
private class TESTCoverageBatchClass {
    private static testMethod void testCoverageBatch(){
    
    
        ivybase__Resource_Type__c restype= TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        //Id userId = u.Id;
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,resType.id);   
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd Nat',Market_ISO__c = 'MY',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        ivybase__Location_Hierarchy__c lR =new ivybase__Location_Hierarchy__c(name = 'ddd Reg',Market_ISO__c = 'MY',ivybase__Parent__c=i1.Id,ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId());
        insert lR;
        ivybase__Location_Hierarchy__c lA =new ivybase__Location_Hierarchy__c(name = 'ddd Area',Market_ISO__c = 'MY',ivybase__Parent__c=i1.Id,ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Area').getRecordTypeId());
        insert lA;
        ivybase__Location_Hierarchy__c lL =new ivybase__Location_Hierarchy__c(name = 'ddd Log',Market_ISO__c = 'MY',ivybase__Parent__c=i1.Id,ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Logical_Territory').getRecordTypeId());
        insert lL;
            
            
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Parent__c = lL.Id;
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test conquest' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c='Yes';
        acc.Converted_Date__c = Date.today().addDays(-4);
        update acc;
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test conquest1' , '123456780' , '111222334' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        acc1.Is_Conquest__c = true;
        insert acc1;
        acc1.ivybase__Active__c='Yes';
        acc1.Converted_Date__c = Date.today().addDays(-10);
        update acc1;
        

        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert terrRouting; 
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        pg1.Buy_Logic__c='ANY';
        pg1.Buy_Logic_Value__c=1;
        insert pg1;
        
        ivybase__Product_Group__c pg2=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg2.ivybase__Grouping_Type__c = 'New Launch';
        pg2.Buy_Logic__c='ALL';
        pg2.Buy_Logic_Value__c=1;
        insert pg2;
        
        ivybase__Product_Hierarchy__c phBrand = TestUtility.createTestProductHierarchy('Test Brand','Brand', true ,'Yes'); 
        insert phBrand;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product_Group_Detail__c proDetail = new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c=pg1.Id,Market_ISO__c = 'MY',Product_Hierarchy__c=phBrand.Id,ivybase__Product__c=p1.Id);
        insert proDetail;
        
        ivybase__Product_Group_Detail__c proDetail2 = new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c=pg2.Id,Market_ISO__c = 'MY',Product_Hierarchy__c=phBrand.Id,ivybase__Product__c=p1.Id);
        insert proDetail2;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(acc.id, null,con.id,'1');   
        order1.Division__c=division.id;
        order1.ivydsd__Final_Order_Value__c = 50;
        order1.ivydsd__Order_Date__c = Date.today().addDays(-1);
        order1.ivydsd__Resource__c = res.Id;
        insert order1;
        
        ivydsd__Order__c order2 = TestUtility.createTestOrder(acc.id, null,con.id,'1');   
        order2.Division__c=division.id;
        order2.ivydsd__Final_Order_Value__c = 50;
        order2.ivydsd__Order_Date__c = Date.today().addDays(-1);
        order2.ivydsd__Resource__c = res.Id;
        insert order2;

        ivydsd__Invoice__c invoice1 = TestUtility.createTestInvoice(acc.id ,'1', 00 , order1.id , con.id);
        invoice1.ivydsd__Invoice_Date__c = Date.today().addDays(-1);
        insert invoice1;
        
        ivydsd__Invoice_Line_Item__c invLineItem1 = TestUtility.createTestInvoiceLineItem(invoice1.Id,p1.Id); 
        invLineItem1.ivydsd__UOM_1_Quantity__c = 1000;
        invLineItem1.Market_ISO__c = 'MY';
        insert invLineItem1;
        
        ivydsd__Invoice__c invoice2 = TestUtility.createTestInvoice(acc.id ,'1', 00 , order2.id , con.id);
        invoice2.ivydsd__Invoice_Date__c = Date.today().addDays(-1);
        insert invoice2;
        
        ivydsd__Invoice_Line_Item__c invLineItem2 = TestUtility.createTestInvoiceLineItem(invoice2.Id,p1.Id); 
        invLineItem2.ivydsd__UOM_1_Quantity__c = 1000;
        invLineItem2.Market_ISO__c = 'MY';
        insert invLineItem2;
        
        /*User u = TestUtility.getCustomerArgoUser();
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1'); 
        order.ivydsd__Final_Order_Value__c = 50;
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        
        system.runAs(u){
             
            try{
                insert order;
                
                ivydsd__Order_Line_Item__c orderLine = new ivydsd__Order_Line_Item__c(ivydsd__Order__c=order.Id,ivydsd__Product1__c=p1.Id,ivydsd__UOM_1_Quantity__c=200,ivydsd__UOM_1_Rate__c=200);
                insert orderLine;
                
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                insert invoice;
        
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
                invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
                insert invLineItem;
           }catch(Exception e){}
        }*/
        
        //map<string,Decimal> OrderAmountMap=new map<string,Decimal>();
        //OrderAmountMap.put(acc.id,order.ivydsd__Final_Order_Value__c);
        
        List<ivybase__Visit__c> visitList = new List<ivybase__Visit__c>();
        ivybase__Visit__c vi = new ivybase__Visit__c(ivybase__Original_Date__c=Date.today(), ivybase__Store__c=acc.Id , ivybase__Resource__c = res.id, ivybase__Status__c='Completed');
        ivybase__Visit__c v2 = new ivybase__Visit__c(ivybase__Original_Date__c=Date.today(), ivybase__Store__c=acc1.Id , ivybase__Resource__c = res.id, ivybase__Status__c='Completed');
        visitList.add(vi);
        visitList.add(v2);
        insert visitList;
               
        ivybase__Location__c loc = new ivybase__Location__c(Name='Location',ivybase__Active__c='Yes',Market_ISO__c = 'MY');      
        loc.ivybase__Code__c ='CODE';   
        loc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : 'In_Store' Limit 1].Id;
        insert loc;
        
        List<ivybase__Location_Stock__c> locStockList = new List<ivybase__Location_Stock__c>();
        ivybase__Location_Stock__c stock= new ivybase__Location_Stock__c(ivybase__VanLoad_Mobile_Uid__c=null,Market_ISO__c='MY',ivybase__Location__c=loc.Id ,ivybase__Product__c= p1.Id ,ivybase__Visit__c=visitList[0].id ,ivybase__Type__c='Stock Check',ivybase__UOM1__c=3);   
        ivybase__Location_Stock__c stock1= new ivybase__Location_Stock__c(ivybase__VanLoad_Mobile_Uid__c=null,Market_ISO__c='MY',ivybase__Location__c=loc.Id ,ivybase__Product__c= p1.Id ,ivybase__Visit__c=visitList[1].id ,ivybase__Type__c='Stock Check',ivybase__UOM1__c=3);   
        locStockList.add(stock);
        locStockList.add(stock1);
        insert locStockList; 
        
        Map<String, Schema.RecordTypeInfo> targetRT = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
       
        Target_Actual__c target = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(-3));
        target.RecordTypeId = targetRT.get('Conquest').getRecordTypeId();
        target.Market_ISO__c = 'MY';
        target.Parameter_type__c = 'Conquest monthly';
        insert target;
        Target_Actual__c Coverage = new Target_Actual__c(Account__c=acc1.Id,Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(5),End_Date1__c=Date.today().addDays(7));
        Coverage.RecordTypeId  = targetRT.get('Coverage').getRecordTypeId();
        Coverage.Market_ISO__c = 'MY';
        insert Coverage;
        
        Target_Actual__c inventory = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(5),End_Date1__c=Date.today().addDays(7));
        inventory.RecordTypeId =targetRT.get('Inventory_Check').getRecordTypeId();
        inventory.Market_ISO__c = 'MY';
        insert inventory;
        
        Target_Actual__c activation = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(5),End_Date1__c=Date.today().addDays(7));
        activation.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Activation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        activation.Market_ISO__c = 'MY';
        insert activation;
        
        List<Account_Target__c> accTargetCoverage = new List<Account_Target__c>{
            new Account_Target__c(Account__c=acc1.Id,Product_Group__c=pg1.Id,Target_Actual__c=Coverage.Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target_Actual__c=inventory.Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target_Actual__c=activation.Id,Month__c=Date.today().Month())};
        insert accTargetCoverage; 
        
        ///addeed new
        //
        Target_Actual__c target2 = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg2.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(-3));
        target2.RecordTypeId = targetRT.get('Conquest').getRecordTypeId();
        target2.Market_ISO__c = 'MY';
        target2.Parameter_type__c = 'Conquest monthly';
        insert target2;
        
        Target_Actual__c Coverage2 = new Target_Actual__c(Account__c=acc1.Id,Product_Group__c=pg2.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(5),End_Date1__c=Date.today().addDays(7));
        Coverage2.RecordTypeId  = targetRT.get('Coverage').getRecordTypeId();
        Coverage2.Market_ISO__c = 'MY';
        insert Coverage2;
        
        Target_Actual__c inventory2 = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg2.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(5),End_Date1__c=Date.today().addDays(7));
        inventory2.RecordTypeId =targetRT.get('Inventory_Check').getRecordTypeId();
        inventory2.Market_ISO__c = 'MY';
        insert inventory2;
        
        Target_Actual__c activation2 = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg2.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(5),End_Date1__c=Date.today().addDays(7));
        activation2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Activation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        activation2.Market_ISO__c = 'MY';
        insert activation2;
        
        List<Account_Target__c> accTargetCoverage2 = new List<Account_Target__c>{
            new Account_Target__c(Account__c=acc1.Id,Product_Group__c=pg2.Id,Target_Actual__c=Coverage.Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=acc.Id,Product_Group__c=pg2.Id,Target_Actual__c=inventory.Id,Month__c=Date.today().Month()),
            new Account_Target__c(Account__c=acc.Id,Product_Group__c=pg2.Id,Target_Actual__c=activation.Id,Month__c=Date.today().Month())};
        insert accTargetCoverage2; 
        
        Test.startTest();
        CoverageBatchClass coverageBatch = new CoverageBatchClass();
        Database.executeBatch(coverageBatch);
        Test.stopTest();
        
        
    }

    

}