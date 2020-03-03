/**Last edited Pranav @03-05-2019**/

@isTest
public class TESTLossOfClientsBatch {
    private static testMethod void TestLossOfClients(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
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
        
        
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
        //acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        acc.Last_Visit_Date__c = Date.today();
        acc.SecondLastInvoiceDate__c = Date.today().addMonths(-12);
        update acc;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert terrRouting;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','KPI_Group');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        Target_Actual__c quantity = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        quantity.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        quantity.Parameter_type__c = 'Loss of Clients';
        insert quantity;
        
        SaloonInvoice__c SInvoice = new SaloonInvoice__c(Account__c=acc.id,Market_ISO__c = 'PH',Resource__c=res.Id,LastInvoiceDate__c=Date.today().addMonths(-12)-1);
        insert SInvoice; 
        
        LocationMasterService.getAllUserTerritory();
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='AverageStrikeRate_Batch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        LossOfClientsBatch batch = new LossOfClientsBatch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        
    }

}