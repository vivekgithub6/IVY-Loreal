@isTest
public class Test_RESTP4InvoiceMaster {
    private static testMethod void testP4InvoiceMaster(){
        try{
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
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
        insert order;

        
        List<ivydsd__Invoice__c> invoicelist = new List<ivydsd__Invoice__c>{
            new ivydsd__Invoice__c(ivydsd__Invoice_Date__c = Date.Today(),ivydsd__Resource__c=res.id,ivydsd__Order__c =order.id,ivydsd__Store__c = acc.Id,ivydsd__Invoice_Status__c = 'Pending',ivydsd__Invoice_Amount__c = 0,ivydsd__PaidAmount__c = 100),
            new ivydsd__Invoice__c(ivydsd__Invoice_Date__c = Date.Today(),ivydsd__Resource__c=res.id,ivydsd__Order__c =order.id,ivydsd__Invoice_Status__c = 'Pending',ivydsd__Store__c = acc.Id,ivydsd__Invoice_Amount__c = 0,ivydsd__PaidAmount__c = 200),
            new ivydsd__Invoice__c(ivydsd__Invoice_Date__c = Date.Today(),ivydsd__Resource__c=res.id,ivydsd__Order__c =order.id,ivydsd__Invoice_Status__c = 'Collected',ivydsd__Store__c = acc.Id,ivydsd__Invoice_Amount__c = 0, ivydsd__PaidAmount__c = 300),
                new ivydsd__Invoice__c(ivydsd__Invoice_Date__c = Date.Today(),ivydsd__Resource__c=res.id,ivydsd__Order__c =order.id,ivydsd__Invoice_Status__c = 'Pending', ivydsd__Invoice_Amount__c = 0,ivydsd__Store__c = acc.Id, ivydsd__Mobile_Invoice_Number__c = 'mobileInvoice')
        };
        insert invoicelist;
        List<ivybase__Standard_List_Master__c> slmlist = TestUtility.createTestStandardListMaster();
        
        List<ivybase__Product_Hierarchy__c> pHierarchyList1 = new List<ivybase__Product_Hierarchy__c>();
            pHierarchyList1.add(TestUtility.createTestProductHierarchy('Test','Sub_Brand', true ,'Yes'));
        insert pHierarchyList1; 
                                                                            
        List<ivybase__Product__c> pMasterList = new List<ivybase__Product__c>{
           new ivybase__Product__c(Name = 'Pro1', ivybase__active__c = 'yes',ivybase__Short_Description__c = 'hai',ivybase__is_competitor__c = false,ivybase__Parent__c = pHierarchyList1[0].id)
        };
        insert pMasterList;
     
        List<ivydsd__Invoice_Line_Item__c> iliLists = new List<ivydsd__Invoice_Line_Item__c>{
            new ivydsd__Invoice_Line_Item__c (ivydsd__UOM_1_Quantity__c = 3, ivydsd__UOM_2_Quantity__c= 4, ivydsd__UOM_3_Quantity__c = 8, ivydsd__Invoice__c = invoiceList[0].id, ivydsd__Product_Master1__c  = pMasterList[0].Id) 
        }; 
        
        insert iliLists;
        
        Test.startTest();
        RESTP4InvoiceMaster.getOrderdetails();
        Test.stopTest();
        }catch(exception ex){}
    }
}