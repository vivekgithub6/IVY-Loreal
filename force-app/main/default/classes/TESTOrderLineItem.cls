@isTest
private class TESTOrderLineItem {
    private static testMethod void testOrderLine(){
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
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'MY');
        insert divLoc;
        
        ivybase__Price_List__c priceList = TestUtility.createTestPriceList('Yes','Test PriceList',Date.today(),Date.today().addDays(1));   
        insert priceList;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c =true;
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        acc.Price_List__c = priceList.Id;
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Price_List_Entrie__c priceListEntry = TestUtility.createTestPriceListEntry('Yes',p1.Id,priceList.Id,'YPR0',200.30);   
        insert priceListEntry;

        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        insert order;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 100 , 100 , 100 , 10 , 10 , 10 );
        insert oli;

        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
        invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
        insert invLineItem;
    }

}