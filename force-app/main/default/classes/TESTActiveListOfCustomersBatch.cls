/**Last edited Pranav @03-05-2019**/
@isTest
public class TESTActiveListOfCustomersBatch {
    private static testMethod void testActiveListOfCustomers(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'PH');
        insert division;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'PH');
        
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c = Date.today();
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;
        insert order;
        System.debug('order:::'+order+ '    Status::'+order.ivydsd__Order_Status__c);
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 100 , 100 , 100 , 10 , 10 , 10 );
        insert oli;
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        insert invoice;
        
        Target_Actual__c target = new Target_Actual__c(Resource__c=res.Id,Actual__c=100,
                                                       Achievement__c=10,Month__c=Date.today().month(),
                                                       Parameter_type__c='Active No Of Customers',
                                                       Market_ISO__c = 'PH');
        target.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        
        insert target;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='GainOfClientsBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        ActiveListOfCustomersBatch batch = new ActiveListOfCustomersBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
}