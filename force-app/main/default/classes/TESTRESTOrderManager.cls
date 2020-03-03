/**
 * Created By : Ivy Mobility
 * Covered Class : ContactTriggerHandler(100%), promotionFreeDetail(100%), PromotionGroup(100%),
  promotionslabTarget(100%), PromotionSlabTrigger(100%), SchemeProductGroupTrigger(100%), PromotionPackageCappingTrigger(94%),
  OrderLineItemService(90%), CommonUtility(89%), OrderTrigger(88%), ProductUOMService(86%), RESTOrderManager(83%), AccountTrigger(81%),
  AverageTurnoverPerRep(80%), ContactTrigger(80%), OrderLineItem(80%), OrderTranslator(80%), TriggerLogicService(80%)
*/
@isTest
private class TESTRESTOrderManager {
    private static testMethod void testOrderManager(){
        
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
                insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='MY');

        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
       
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.Division__c = division.Id;
        insert p1;
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p2;
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p3;
        ivybase__Product__c p4 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p4;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');  
        order.ivydsd__Order_Date__c = Date.today();
        order.Division__c=division.id;
        order.ivydsd__Resource__c =res.Id;
        orderList.add(order);
        
        

        ivydsd__Order__c order2 = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1'); 
        order2.ivydsd__Order_Date__c = Date.today();
        order2.Division__c=division.id;
        order2.ivydsd__Resource__c = res.Id;
        orderList.add(order2);
        
        insert orderList;
        
        order.ivydsd__Order_Status__c = 'Ordered';
        Order2.ivydsd__Order_Status__c = 'Ordered';
        update orderList;
        //Datetime yesterday = Datetime.now().addDays(-30);
        //Test.setCreatedDate(orderList[0].Id, yesterday);
        //Datetime yesterday1 = Datetime.now().addDays(-40);
        //Test.setCreatedDate(orderList[0].Id, yesterday1);

        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(orderList[0].id , p1.id, 100 , 0 , 0 , 10 , 0 , 0 );
        insert oli;
        
        ivydsd__Order_Line_item__c oli2 = TestUtility.createTestOrderLineItem(orderList[1].id , p2.id, 100 , 0 , 0 , 10 , 0 , 0 );
        insert oli2;
        
        /*User u = TestUtility.getCustomerArgoUser();
        system.runAs(u){
             
            try{
                insert order2;
                
                ivydsd__Order_Line_item__c oli2 = TestUtility.createTestOrderLineItem(order2.id , p2.id, 100 , 0 , 0 , 10 , 0 , 0 );
                insert oli2;
           }catch(Exception e){}
        }*/
        
        Test.startTest();
        RESTOrderManager.getOrderdetails();
        Test.stopTest();
        
        List<ivydsd__Order__c> orderList1 = [SELECT Id, Name, ivydsd__Order_Date__c, ivydsd__Store__r.ivybase__StoreCode__c, 
                                ivydsd__Order_Status__c, ivydsd__Store__c, ivydsd__Store__r.ivybase__Internal_Id__c, ivydsd__Order_Value__c, 
                                ivydsd__Number_of_Line_Items__c, ivydsd__Internal_Id__c, ivydsd__Resource__c, ivydsd__Purchase_Order_Number__c 
                            FROM  ivydsd__Order__c 
                            ORDER BY CreatedDate DESC];
        System.debug('orderList1===>'+orderList1);
    }

}