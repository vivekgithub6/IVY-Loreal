/**Last edited Pranav @03-05-2019**/

@isTest
public class TESTGainOfClientsBatch {
    
    @testSetup
    private static void setup(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        insert ph;
        
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
        
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        //acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        acc.Last_Visit_Date__c = Date.today();
        acc.SecondLastInvoiceDate__c = Date.today().addMonths(-12);
        acc.LastInvoiceDate__c = Date.today();
        acc.Converted_to_Normal_Saloon__c = true;
        update acc;
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert terrRouting;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','KPI_Group');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
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
         
        list<ivydsd__Invoice__c> invoice = new list<ivydsd__Invoice__c>();
        invoice.add(TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id));
        insert invoice;
        invoice[0].ivydsd__Invoice_Date__c = System.today();
        invoice[0].ivydsd__Resource__c = res.Id;
        
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
        
        Target_Actual__c quantity = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'MY',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        quantity.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        quantity.Parameter_type__c = 'Gain of new clients';
        insert quantity;
    }
    @isTest
    private static void testGainOfClient() {
        
        ivybase__Resource__c res = [SELECT Id FROM ivybase__Resource__c LIMIT 1];
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<SaloonInvoice__c> saloonInvoiceList = new List<SaloonInvoice__c>();
                
        Date sampleDate = date.today();
        Date secondOldDate = sampleDate.addMonths(-13);
        saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
        saloonInvoiceList.add(TestUtility.createSaloonInvoice(secondOldDate,null,sampleDate,res.id,acc.id,null,null));
        insert saloonInvoiceList;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='LossOfClientsBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        GainOfClientsBatch batch = new GainOfClientsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    @isTest
    private static void testGainOfClienttarget0() {
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='LossOfClientsBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        GainOfClientsBatch batch = new GainOfClientsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
}