@isTest
public class TestAccountService {
    static testmethod void method1(){ 
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
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
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
       
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = division.Id,Market_ISO__c = 'MY');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
       node4.Store_Number__c = 'NODE4';
        insert node4;
                            
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Is_Conquest__c = true, recordTypeId=accrecordTypeId, Market_ISO__c = 'MY', ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id);
        insert acc;
        
        Contact con = new Contact();
        con.Lastname = 'Testcon';
        con.Email = 'Test@gmail.com' ;
        con.ivybase__Related_User__c = UserInfo.getuserId();
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        insert con;    
        Decimal accInternalId = [SELECT ivybase__Internal_Id__c FROM Account WHERE Id = :acc.Id].ivybase__Internal_Id__c;
        
        acc.ivybase__Active__c = 'Yes';
        acc.ivybase__Resource__c = res.Id;
        acc.Sold_To_Party_Number__c = 'SOLD12';
        acc.ivybase__Store_Hierarchy__c=node4.id;
        acc.Converted_to_Normal_Saloon__c =true;
        update acc; 
        
        set<id> accid = new set<id>{acc.id};
            set<string> soldtopart = new set<string>{acc.Sold_To_Party_Number__c};
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert terrRouting;
        
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');     
            //function.ivybase__Parent__c = classP.Id;
        insert function;
            
            
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        insert proSKU;
              
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        insert order;
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order1.ivydsd__Resource__c = res.Id;
        order1.ivydsd__Order_Date__c = Date.today();
        order1.Division__c=division.id;
        order1.ivydsd__Store__c = acc.Id;
        insert order1;
         
        list<ivydsd__Invoice__c> invoice = new list<ivydsd__Invoice__c>();
        invoice.add(TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id));
        insert invoice;
        invoice[0].ivydsd__Invoice_Date__c = System.today();
        invoice[0].ivydsd__Resource__c = res.Id;
        
        update  invoice[0];
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice[0].Id,proSKU.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
            
        list<ivybase__Visit__c> Visitlist=new  list<ivybase__Visit__c>();
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        insert Visitlist;
        Visitlist[0].ivybase__Resource__c = res.Id;
        Visitlist[1].ivybase__Resource__c = res.Id;
        update Visitlist;
        
        List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
        Date sampleDate = date.today();
        sampleDate=sampleDate.addDays(-48);
        Date secondOldDate = sampleDate.addDays(-90);
        saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
        saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
        insert saloonInvoiceList;
                
        Test.startTest();
        AccountService.getAllRetailerMaster_List_for_Resource();
        AccountService.getAllRetailerMaster_List_from_Route();
        AccountService.GetRelatedAccountFormCustomerCode(new Set<String>{'SOLD12'});
        AccountService.GetRelatedAccountFormStoreHierarchyCode(new Set<String>{'NODE4'});
        AccountService.getSetOfHierarchyForThisResource();
        AccountService.getHierarchyIdsbysellerId_Map(con.Id);
        AccountService.getAccountBasedOnId(accid);
        AccountService.getAccbyId(accid);
        AccountService.getAccountByInternalId(new Set<String>{String.valueOf(acc.ivybase__Internal_Id__c)});
        AccountService.getAccountBySoldToPartyID(soldtopart);
        // AccountService.UpdateAccountResourceLastInvoiceDate(invoice);
        // AccountService.UpdateAccountResourceLastVisitDate(Visitlist);
        AccountService.get_All_Retailer_For_All_Resource();
        BatchUpdatingStoreINVDateOrdrValue batchUpdatelastinvoicedate = new BatchUpdatingStoreINVDateOrdrValue();
        database.executeBatch(batchUpdatelastinvoicedate);
        
        BatchUpdatStoreINVDateOrdrValSched UpdatstoreInvoicevistdate = new BatchUpdatStoreINVDateOrdrValSched();
        String sch1 = '0 10 22 * 11-12 ?';
        system.schedule('Updatestoreinoicedateviistadte', sch1, UpdatstoreInvoicevistdate);
        
        //AccountService.get_All_Retailer_For_All_Resource_Excludeconquest();
        Test.stopTest();
        
    }
    static testmethod void method2(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c = 'MY';
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '1234567892' , '1112223332' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        update acc2;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        Territory_Routing__c territoryRoute = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert territoryRoute;
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        ivybase__Route_Details__c routeDetail2 = TestUtility.createTestRouteDetail('TestRouteDetail2',route.Id,'Yes',acc2.Id);   
        insert routeDetail2;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivybase__Visit__c v1 = TestUtility.createTestVisit(Date.today(), acc.Id ,'');  
        insert v1;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        for(integer i=0;i<20;i++)
        {
            ivydsd__Order__c order;
            if(i>10){
             order = TestUtility.createTestOrder(acc.id,'Draft',con.id,'1');
            }
            else
            {
               order = TestUtility.createTestOrder(acc2.id,'Draft',con.id,'1'); 
            }
            order.ivydsd__Purchase_Order_Number__c=''+i*342;
            order.Division__c=division.id;
            order.ivydsd__Resource__c=res.id;
            orderList.add(order);
        }
        insert orderList;
        
        List<ivydsd__Order_Line_item__c> orderlineItemList = new List<ivydsd__Order_Line_item__c>();
        for(integer i=0;i<20;i++)
        {
            ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[i].id, p1.id, 100 , 100 , 100 , 20 , 30 , 20 );
            orderlineItemList.add(oli);
        }
        insert orderlineItemList;
        
        Test.startTest();
        List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
        for(Integer i=0;i<20;i++)
        {
            
            Date todayDate = System.today();
            Date prevone = todayDate.addDays((-1)*(i));
            ivydsd__Invoice__c invoice;
            if(i>10){
             invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 ,orderList[i].id, con.id);
            }
            else
            {
                invoice = TestUtility.createTestInvoice(acc2.id ,'1', 00 ,orderList[i].id, con.id);
            }
                invoice.ivydsd__Invoice_Date__c = prevone;
            invoiceList.add(invoice);
        }
        insert invoiceList;
        List<ivydsd__Invoice_Line_Item__c> invoiceLineItemList = new List<ivydsd__Invoice_Line_Item__c>();
        for(Integer i=0;i<20;i++)
        {
            Date todayDate = System.today();
            Date prevone = todayDate.addDays((-1)*(i));
            ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[i].Id,p1.Id); 
            if(i>10){
            invLineItem.ivydsd__UOM_1_Quantity__c = 1000*(i+1);
            }
            invoiceLineItemList.add(invLineItem);
        }
        insert invoiceLineItemList;
        
         
        BatchUpdatingStoreINVDateOrdrValue batchUpdatelastinvoicedate = new BatchUpdatingStoreINVDateOrdrValue();
        database.executeBatch(batchUpdatelastinvoicedate);
       
        RExAPIResponseDomain.ResponseInfo response = RESTRtwWiseP4OrderAndStockMaster.getRtrWiseP4OrderAndStockMasterInfo();
        system.debug('response'+response);
        
        Test.stopTest();
        
    }
    private static testMethod void testRtwWiseP4Ordermultiple(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divloc.Market_ISO__c = 'MY';
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '1234567892' , '1112223332' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        update acc2;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        Territory_Routing__c territoryRoute = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert territoryRoute;
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        ivybase__Route_Details__c routeDetail2 = TestUtility.createTestRouteDetail('TestRouteDetail2',route.Id,'Yes',acc2.Id);   
        insert routeDetail2;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivybase__Visit__c v1 = TestUtility.createTestVisit(Date.today(), acc.Id ,'');  
        insert v1;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        for(integer i=0;i<20;i++)
        {
            ivydsd__Order__c order;
            if(i>10){
             order = TestUtility.createTestOrder(acc.id,'Draft',con.id,'1');
            }
            else
            {
               order = TestUtility.createTestOrder(acc2.id,'Draft',con.id,'1'); 
            }
            order.ivydsd__Purchase_Order_Number__c=''+i*342;
            order.Division__c=division.id;
            order.ivydsd__Resource__c=res.id;
            orderList.add(order);
        }
        insert orderList;
        
        List<ivydsd__Order_Line_item__c> orderlineItemList = new List<ivydsd__Order_Line_item__c>();
        for(integer i=0;i<20;i++)
        {
            ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[i].id, p1.id, 100 , 100 , 100 , 20 , 30 , 20 );
            orderlineItemList.add(oli);
        }
        insert orderlineItemList;
        
        Test.startTest();
        List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
        for(Integer i=0;i<20;i++)
        {
            
            Date todayDate = System.today();
            Date prevone = todayDate.addDays((-1)*(i));
            ivydsd__Invoice__c invoice;
            if(i>10){
             invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 ,orderList[i].id, con.id);
            }
            else
            {
                invoice = TestUtility.createTestInvoice(acc2.id ,'1', 00 ,orderList[i].id, con.id);
            }
                invoice.ivydsd__Invoice_Date__c = prevone;
            invoiceList.add(invoice);
        }
        insert invoiceList;
        List<ivydsd__Invoice_Line_Item__c> invoiceLineItemList = new List<ivydsd__Invoice_Line_Item__c>();
        for(Integer i=0;i<20;i++)
        {
            ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoiceList[i].Id,p1.Id); 
            if(i>10){
            invLineItem.ivydsd__UOM_1_Quantity__c = 1000*(i+1);
            }
            invoiceLineItemList.add(invLineItem);
        }
        ivydsd__Invoice_Line_Item__c invLineItem1 = TestUtility.createTestInvoiceLineItem(invoiceList[12].Id,p2.Id);
        invLineItem1.ivydsd__UOM_1_Quantity__c = 1000*(12+1);
        invoiceLineItemList.add(invLineItem1);
        ivydsd__Invoice_Line_Item__c invLineItem2 = TestUtility.createTestInvoiceLineItem(invoiceList[12].Id,p1.Id);
        invLineItem2.ivydsd__UOM_1_Quantity__c = 1000*(12+1);
        invoiceLineItemList.add(invLineItem2);
        
        insert invoiceLineItemList;
           // AccountService.UpdateAccountLastInvoiceDate(invoiceList);
       // AccountService.UpdateAccountLastVisitDate(invoiceList);
        //AccountService.UpdateAccountAVGOrderValue(orderList);
        //AccountService.UpdateAccountResourceLastInvoiceDate(invoiceList);
    }
    static testmethod void TestupdateOutstandingAmountinSoldtoParty(){ 
         Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='test Account',Due_Amount__c=0, Market_ISO__c = 'MY', Converted_to_Normal_Saloon__c = true,recordTypeId=accrecordTypeId, ivybase__Active__c='Yes',ivybase__Status__c='Active');
        insert acc;
        Account partner = new Account(Name='test partner',Due_Amount__c =0, Market_ISO__c = 'MY',Converted_to_Normal_Saloon__c = true, recordTypeId=accrecordTypeId, ivybase__Active__c='Yes',ivybase__Status__c='Active');
        insert partner;
        Partner_Function__c pf = new Partner_Function__c(partner__c = partner.id, account__c = acc.id, type__c= 'Payer',Market_ISO__c = 'MY');
        insert pf;
        acc.ivybase__Active__c = 'Yes';// update acc;
        partner.ivybase__Active__c = 'Yes';
        partner.Due_Amount__c = 50000;
        update partner;
     
     
    }
    
    static testmethod void TestHHTMethod1(){ 
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
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
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
                       
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = division.Id,Market_ISO__c = 'MY');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Store_Number__c = 'NODE4';
        insert node4;
        
        List<ivybase__HHTMenu_Master__c> hhtMenuList = new List<ivybase__HHTMenu_Master__c>();
        
        ivybase__HHTMenu_Master__c hhtmenu11 = new ivybase__HHTMenu_Master__c();
        hhtmenu11.Name = 'PROFILE_LO_05';
        hhtmenu11.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu11.ivybase__Flex__c = 'Document__c';
        hhtmenu11.ivybase__Flag__c = 1;
        hhtmenu11.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu11);
        
        ivybase__HHTMenu_Master__c hhtmenu12 = new ivybase__HHTMenu_Master__c();
        hhtmenu12.Name = 'PROFILE_LO_06';
        hhtmenu12.ivybase__MenuType__c = 'RETAILER_PROFILE';
        hhtmenu12.ivybase__Flex__c = 'Document__c';
        hhtmenu12.ivybase__Flag__c = 1;
        hhtmenu12.ivybase__Location_Hierarchy__c = locNational.Id;
        hhtMenuList.add(hhtmenu12);
        
        insert hhtMenuList;
                            
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa',Is_Conquest__c = true, recordTypeId=accrecordTypeId, Market_ISO__c = 'MY', ivybase__Active__c='Yes', Location_Hierarchy__c=locNational.Id);
        insert acc;
               
    }
}