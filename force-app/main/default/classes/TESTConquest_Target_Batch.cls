@isTest
public class TESTConquest_Target_Batch {
    private static testMethod void testConqIncentive(){
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
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'PH');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'PH');
        insert divLoc;
        
        List<Account> accList = new List<Account>();
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        accList.add(acc);
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc1' , '123456781' , '111222332' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        accList.add(acc1);
        
        insert accList;
        
        accList[0].ivybase__Active__c='Yes';
        accList[0].Converted_Date__c = Date.today().addDays(-4);       
        accList[1].ivybase__Active__c='Yes';
        accList[1].Converted_Date__c = Date.today().addDays(-4);
        update accList;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.ivybase__Barcode__c = 1234;
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadon2e',ph.Id,'Testdesc', false ,'Yes');
        p2.ivybase__Barcode__c = 1235;
        insert p2;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c >();
        ivydsd__Order__c order = TestUtility.createTestOrder(accList[0].id,null,con.id,'1'); 
        order.ivydsd__Order_Date__c = Date.today();
        order.ivydsd__Resource__c = res.Id;
        order.Bill_To__c = accList[0].id;
        order.Division__c=division.id;
        order.Market_ISO__c = 'PH';
        insert order;
        
        ivydsd__Order__c order1 = TestUtility.createTestOrder(accList[1].id,null,con.id,'2'); 
        order1.ivydsd__Order_Date__c = Date.today();
        order1.ivydsd__Resource__c = res.Id;
        order1.Bill_To__c = accList[1].id;
        order1.Division__c=division.id;
        order1.Market_ISO__c = 'PH';
        insert order1;
        
        ivydsd__Order__c order11 = TestUtility.createTestOrder(accList[1].id,null,con.id,'2'); 
        order11.ivydsd__Order_Date__c = Date.today();
        order11.ivydsd__Resource__c = res.Id;
        order11.Bill_To__c = accList[1].id;
        order11.Division__c=division.id;
        order11.Market_ISO__c = 'PH';
        insert order11;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 1100 , 0 , 0 , 3 , 0 , 0 );
        insert oli;
        
        ivydsd__Order_Line_item__c oli1 = TestUtility.createTestOrderLineItem(order1.id , p2.id, 1100 , 0 , 0 , 3 , 0 , 0 );
        insert oli1;
        
        /*User u = TestUtility.getCustomerArgoUser();
        
        ivydsd__Order__c order2 = TestUtility.createTestOrder(accList[0].id,'Ordered',con.id,'3');  
        order2.ivydsd__Order_Date__c = Date.today().addDays(-1);
        order2.ivydsd__Resource__c = res.Id;
        order2.Division__c=division.id;
        order2.Market_ISO__c = 'PH';
 
        /*system.runAs(u){
             
            try{
                insert order2;
                
                ivydsd__Invoice__c invoice = TestUtility.createTestInvoice(accList[0].id ,'1', 00 , order.id , con.id);
                invoice.ivydsd__Invoice_Date__c = System.today();
                insert invoice;
                
                ivydsd__Invoice_Line_Item__c invLineItem = TestUtility.createTestInvoiceLineItem(invoice.Id,p1.Id); 
                invLineItem.ivydsd__UOM_1_Quantity__c = 1000;
                insert invLineItem;
            }
            catch(Exception e){}
        }*/
        
        
        
        Map<String, Schema.RecordTypeInfo> targets = Schema.SObjectType.Target_Actual__c.getRecordTypeInfosByDeveloperName();
        system.debug(targets);

        Target_Actual__c orderTarget = new Target_Actual__c(Target__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),
                                                            Start_Date1__c=Date.today().addDays(-5),End_Date1__c=Date.today().addDays(+3));
        orderTarget.RecordTypeId =  [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        orderTarget.Market_ISO__c = 'PH';
        orderTarget.Parameter_type__c =  'Conquest monthly';
        insert orderTarget;
        
        Test.startTest();
        Conquest_Target_Batch batch = new Conquest_Target_Batch();
        Database.executeBatch(batch);
        Test.stopTest();
        
        list<Account> Accountlist=[select id,ivybase__StoreCode__c ,ivybase__Resource__c,(select ivydsd__Order_Value__c,ivydsd__Store__c,ivydsd__Resource__c,ivydsd__Order_Date__c from ivydsd__Orders__r where ivydsd__Order_Status__c!='Draft' order by ivydsd__Order_Date__c desc limit 2) from Account where Converted_Date__c!=Null and Converted_to_Normal_Saloon__c=true];
        System.debug('Accountlist==='+Accountlist);
        
        for(Account A:Accountlist){
            System.debug('a.ivydsd__Orders__r==='+a.ivydsd__Orders__r);
            OrderList.addall(a.ivydsd__Orders__r);
            System.debug('OrderList==='+OrderList);
        }
    }

}