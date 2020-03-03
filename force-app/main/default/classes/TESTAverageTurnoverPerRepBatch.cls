@isTest
private class TESTAverageTurnoverPerRepBatch {

    private static testMethod void testTOPerRep(){
        
        Batch_SwitchOff__c batchSwitchoff = new Batch_SwitchOff__c();
        batchSwitchoff.Name =  'AverageTurnOverPerClientBatch';
        batchSwitchoff.Sequence__c = 12;
        batchSwitchoff.SwitchOff__c = false;
        insert batchSwitchoff;
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        
        Id currentUserId = UserInfo.getUserId();
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
        acc.Converted_to_Normal_Saloon__c = true;
        acc.ivybase__Active__c='yes';
        update acc;
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        insert ph;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        insert pg1;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        insert div;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.Division__c = division.Id;
        insert p1;
        
        ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c(ivybase__Product__c=p1.id,Market_ISO__c = 'MY',ivybase__Product_Group__c=pg1.id);
        insert pgd;
        
        ivydsd__Order__c o = TestUtility.createTestOrder(acc.id,'Ordered',null,'12345'); 
        o.Division__c=division.id;
        o.ivydsd__Resource__c = res.Id;
        insert o;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , p1.id, 300 , 0 , 0 , 3 , 0 , 0 );
        insert oli;
        
        Date todayDate = date.Today();
        ivydsd__Invoice__c inv = TestUtility.createTestInvoice(acc.id ,'12345', 200 , o.id ,null);
        //inv.ivydsd__Invoice_Date__c=Date.newInstance(todayDate.year(),1,5);
        inv.ivydsd__Invoice_Date__c=todayDate;
        insert inv;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(inv.Id,p1.Id);
        
        Test.startTest();
        insert invLineItem;
        
        AverageTurnoverPerRepBatch batch = new AverageTurnoverPerRepBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }

}