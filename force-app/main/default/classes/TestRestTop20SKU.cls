@isTest
public class TestRestTop20SKU {
    private static testMethod void testTop20SKU(){
       id currentUserId= userinfo.getUserId();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Conquest__c = true;
        insert acc;
        acc.ivybase__Active__c='yes';
        acc.Converted_to_Normal_Saloon__c=true;
        update acc;
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        insert ph;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        insert pg1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
              ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c();
        pgd.ivybase__Product__c=p1.id;
        pgd.ivybase__Product_Group__c=pg1.id;
        insert pgd;
        ivydsd__Order__c o = TestUtility.createTestOrder(acc.id,'Ordered',null,'12345');  
        o.Division__c=division.id;
        o.ivydsd__Resource__c = res.Id;
        insert o;
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , p1.id, 300 , 0 , 0 , 3 , 0 , 0 );
        insert oli;
        Date todayDate1 = date.Today();
        Date ThisYearStart = Date.newInstance(todayDate1.year(),1,1);
        Date LastYearStart = Date.newInstance(todayDate1.year()-1,1,1);
        Date todayDate = date.Today();
        List<ivydsd__Invoice__c> inv = new List<ivydsd__Invoice__c>();
        inv.add(TestUtility.createTestInvoice(acc.id ,'12345', 200 , o.id ,null));
        inv.add(TestUtility.createTestInvoice(acc.id ,'12345', 200 , o.id ,null));
        
        insert inv;
        inv[0].ivydsd__Invoice_Date__c=LastYearStart;
        
        inv[1].ivydsd__Invoice_Date__c=todayDate;
        test.startTest();
        update inv;
        List<ivydsd__Invoice_Line_Item__c> invLineItem = new List<ivydsd__Invoice_Line_Item__c>();
            invLineItem.add(TestUtility.createTestInvoiceLineItem(inv[0].Id,p1.Id));
        invLineItem.add(TestUtility.createTestInvoiceLineItem(inv[1].Id,p1.Id));
        insert invLineItem;
        RESTTop20SKU.getTop20skuMasterInfo();
        test.stopTest();
        
    }
   
}