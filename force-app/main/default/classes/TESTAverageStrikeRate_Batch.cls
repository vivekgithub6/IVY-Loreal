/**Last edited Pranav @03-05-2019**/

@isTest
public class TESTAverageStrikeRate_Batch {
    private static testMethod void testAvgStrike(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
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
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.ivybase__Barcode__c = 1234;
        insert p1;
        p1.ivybase__Barcode__c = 4321;
        update p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Order_Date__c = Date.today();
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id;

        insert order;
        
         ivybase__Visit__c visit = TestUtility.createTestVisit(Date.today(), acc.Id ,''); 
        visit.ivybase__Status__c = 'Completed';
        visit.ivybase__Visit_Date__c=date.today();
        visit.ivybase__Resource__c = res.Id;
        insert visit;
        
        Map<String, Schema.RecordTypeInfo> targets = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
        system.debug(targets);

        Target_Actual__c orderTarget = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Avg No Of Orders');
        orderTarget.Market_ISO__c = 'MY';
        orderTarget.RecordTypeId = targets.get('Sales_KPI').getRecordTypeId();
        insert orderTarget;
        
        Target_Actual__c visitTarget = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Avg No Of Visits');
        visitTarget.RecordTypeId = targets.get('Sales_KPI').getRecordTypeId();
        visitTarget.Market_ISO__c = 'MY';
        insert visitTarget;
        
        Target_Actual__c avgTarget = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Average Strike rate');
        avgTarget.RecordTypeId = targets.get('Sales_KPI').getRecordTypeId();
        avgTarget.Market_ISO__c = 'MY';
        insert avgTarget;
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='SalesTargetCalculation_SG';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        AverageStrikeRate_Batch batch = new AverageStrikeRate_Batch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        
    }
    
}