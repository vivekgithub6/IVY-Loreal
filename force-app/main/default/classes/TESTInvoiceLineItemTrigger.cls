@isTest
public class TESTInvoiceLineItemTrigger {

    private static testMethod void testInvoiceLineItem(){
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
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
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
        
        ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c();
        pgd.ivybase__Product__c=p1.id;
        pgd.ivybase__Product_Group__c=pg1.id;
        insert pgd;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id; 
        insert order;
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        insert invoice;
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id);    
        invLineItem.ivydsd__Default_UOM__c = 'Piece';
        insert invLineItem;
        
    }
    
    private static testMethod void testInvoiceLineItemupdate(){
    
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
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
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
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadtwo',ph.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c();
        pgd.ivybase__Product__c=p1.id;
        pgd.ivybase__Product_Group__c=pg1.id;
        insert pgd;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id; 
        insert order;
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order1.Division__c=division.id;
        order1.ivydsd__Resource__c = res.Id; 
        insert order1;
        
        ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(acc.id ,'1', 00 , order.id , con.id);
        invoice.ivydsd__Invoice_Date__c = System.today();
        insert invoice;
        
        ivydsd__Invoice__c invoice1 = TestUtility.createTestInvoice(acc.id ,'1', 00 , order1.id , con.id);
        invoice1.ivydsd__Invoice_Date__c = System.today();
        insert invoice1;
        
        List<ivydsd__Invoice_Line_Item__c> iltemList = new List<ivydsd__Invoice_Line_Item__c>();
        
        ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id);    
        invLineItem.ivydsd__Default_UOM__c = 'Piece';
        invLineItem.ivydsd__UOM_1_Rate__c = 100;
        invLineItem.ivydsd__UOM_1_Quantity__c = 1;
        iltemList.add(invLineItem);
        
        ivydsd__Invoice_Line_Item__c invLineItem1 = TestUtility.createTestInvoiceLineItem(invoice1.Id,p2.Id);    
        invLineItem1.ivydsd__Default_UOM__c = 'Piece';
        invLineItem1.ivydsd__UOM_1_Rate__c = 100;
        invLineItem1.ivydsd__UOM_1_Quantity__c = 1;
        iltemList.add(invLineItem1);
        
        insert iltemList;
        
        iltemList[0].ivydsd__UOM_1_Rate__c = 200;
        iltemList[1].ivydsd__UOM_1_Rate__c = 250;
        update iltemList;
        
        list<ivydsd__Invoice_Line_Item__c> iltemQueredList= [SELECT Id,ivydsd__Total_Amount__c 
                                                            FROM ivydsd__Invoice_Line_Item__c 
                                                            WHERE Id =:iltemList[0].Id LIMIT 1];
                                          
        list<SKU_SaloonSale__c> saloonsaleList= [SELECT Id,Invoice_Line_Item__c,SaleAmount__c 
                                                 FROM SKU_SaloonSale__c 
                                                 WHERE Invoice_Line_Item__c =:iltemList[0].Id LIMIT 1];
        System.debug('saloonsaleList===>'+saloonsaleList);
        System.assertEquals(iltemQueredList[0].ivydsd__Total_Amount__c, saloonsaleList[0].SaleAmount__c);
        
    }

}