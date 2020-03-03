@isTest
public class TESTActivationCoverageBatch2 {
    private static testMethod void testActCoverage(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        res.Market_ISO__c = 'PH';
        insert res;
        
        ivybase__Resource__c res1 = TestUtility.createTestResource('Resource1',null,restype.id);
        res1.SAP_Id__c = '12346';
        res1.Market_ISO__c = 'PH';
        insert res1;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'PH';
        insert locHr;
        
        ivybase__Location_Hierarchy__c locHr1 = TestUtility.createTestLocationHierarchy('Test Location Hierarchy1',res1.Id); 
        locHr1.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr1.ivybase__Resource_Type__c = restype.id;
        locHr1.Market_ISO__c = 'PH';
        insert locHr1;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'PH');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'PH');
        insert divLoc;
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456780' , '111222335' , res1.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr1.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        acc1.Market_ISO__c = 'PH';
        insert acc1;
        update acc1;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = 'PH';
        insert acc;
        update acc;
        
        Account acc2 = TestUtility.createTestAccount('3' , 'Test Acc2' , '123456788' , '111222336' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        acc2.Market_ISO__c = 'PH';
        insert acc2;
        update acc2;
        
        Account acc3 = TestUtility.createTestAccount('4' , 'Test Acc3' , '123456784' , '111222331' , null , 'Retail_Account' , 'Yes' );
        acc3.ivybase__Location_Hierarchy__c = locHr.Id;
        acc3.Converted_to_Normal_Saloon__c = true;
        acc3.Dream_List_Status__c ='Test';
        acc3.Progress_Percentage__c = 100;
        acc3.Market_ISO__c = 'PH';
        insert acc3;
        update acc3;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        route.Market_ISO__c = 'PH';
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);
        routeDetail.Market_ISO__c = 'PH';   
        insert routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute1',route.Id,locHr.Id);
        terrRouting.Market_ISO__c = 'PH';   
        insert terrRouting;
        
        ivybase__Route__c route1 = TestUtility.createTestRoute(res.Id,'Yes');   
        route1.Market_ISO__c = 'PH';
        insert route1;
        
        ivybase__Route_Details__c routeDetail1 = TestUtility.createTestRouteDetail('TestRouteDetail1',route1.Id,'Yes',acc3.Id);
        routeDetail1.Market_ISO__c = 'PH';   
        insert routeDetail1;
        
        Territory_Routing__c terrRouting1 = TestUtility.createTestTerrRouting('TestTerrRoute1',route1.Id,locHr.Id);
        terrRouting1.Market_ISO__c = 'PH';   
        insert terrRouting1;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        pg1.Market_ISO__c = 'PH';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        ph.Market_ISO__c = 'PH';
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.ivybase__Barcode__c = 1234;
        p1.Market_ISO__c = 'PH';
        insert p1;
        p1.ivybase__Barcode__c = 4321;
        update p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.Division__c=division.id;
        order.ivydsd__Order_Date__c = Date.today().addDays(-1);
        order.ivydsd__Resource__c = res.Id;
        order.Market_ISO__c = 'PH';
        orderList.add(order);
        
        ivydsd__Order__c order2 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order2.Division__c=division.id;
        order2.ivydsd__Order_Date__c = Date.today();
        order2.ivydsd__Resource__c = res.Id;
        order2.Market_ISO__c = 'PH';
        orderList.add(order2);
        
        insert orderList;

        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[0].id , con.id);
        invoice.ivydsd__Invoice_Date__c = Date.today().addDays(-1);
        invoice.Market_ISO__c = 'PH';
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        invLineItem.Market_ISO__c = 'PH';
        insert invLineItem;
        
        /*User u = TestUtility.getCustomerArgoUser();
        
        ivydsd__Order__c order2 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order2.Division__c=division.id;
        order2.ivydsd__Order_Date__c = Date.today();
        order2.ivydsd__Resource__c = res.Id;
        
        system.runAs(u){
             
            try{
                insert order2;
                ivydsd__Invoice__c invoice2 = TestUtility.createTestInvoice(acc.id ,'1', 00 , order2.id , con.id);
                invoice2.ivydsd__Invoice_Date__c = Date.today();
                insert invoice2;
        
                ivydsd__Invoice_Line_Item__c invLineItem2 = TestUtility.createTestInvoiceLineItem(invoice2.Id,p1.Id); 
                invLineItem2.ivydsd__UOM_1_Quantity__c = 1000;
                insert invLineItem2;
           }catch(Exception e){}
        }*/
        
        ivydsd__Invoice__c invoice2 = TestUtility.createTestInvoice(acc.id ,'1', 00 , orderList[1].id , con.id);
        invoice2.ivydsd__Invoice_Date__c = Date.today();
        invoice2.Market_ISO__c = 'PH';
        insert invoice2;

        ivydsd__Invoice_Line_Item__c invLineItem2 = TestUtility.createTestInvoiceLineItem(invoice2.Id,p1.Id); 
        invLineItem2.ivydsd__UOM_1_Quantity__c = 1000;
        invLineItem2.Market_ISO__c = 'PH';
        insert invLineItem2;
                
        SaloonInvoice__c solonInv = new SaloonInvoice__c(LastInvoiceDate__c=Date.today(),Account__c=acc.Id,Resource__c=res.Id,Market_ISO__c = 'PH');
        insert solonInv;
        
        //SaloonInvoice__c solonInv1 = new SaloonInvoice__c(LastInvoiceDate__c=Date.today(),Account__c=acc1.Id,Resource__c=res1.Id,Market_ISO__c = 'PH');
        //insert solonInv1;
        
        Map<String, Schema.RecordTypeInfo> targetRT = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
       
        Target_Actual__c target = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(-3));
        target.RecordTypeId = targetRT.get('Activation').getRecordTypeId();
        target.Market_ISO__c = 'PH';
        insert target;
        
        Target_Actual__c target1 = new Target_Actual__c(Account__c=acc.Id,Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res1.Id,Month__c=Date.today().Month(),
                                                      Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(-3));
        target1.RecordTypeId = targetRT.get('Activation').getRecordTypeId();
        target1.Market_ISO__c = 'PH';
        insert target1;
        
        Test.startTest();
        ActivationCoverageBatch batch = new ActivationCoverageBatch();
        Database.executeBatch(batch);
        Test.stopTest();   
        
    }

}