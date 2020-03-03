/**
 * Created By : Ivy Mobility
 * Classes Covered : OrderService(90%), OrderTriggerHandler(80%), OrderHeaderTranslator(89%), SchemeApplyDetail(100%),
  RESTOrderDetails(96%), OrderLineItemTranslator(85%), AverageTurnoverPerRep(80%), OrderLineItem(80%), TriggerLogicService(80%),
  OrderTrigger(78%) class codes
*/
@istest
public class TestRestOrderDetails {

    private static testMethod void testOrderDetails(){
    
        id currentUserId= userinfo.getUserId();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype; 
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',RecordTypeId=RT.get('National').getRecordTypeId(),ivybase__Primary_Resource__c=res.Id);
        insert location; 
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
                insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='MY');

        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Conquest__c = true;
        insert acc;
        acc.ivybase__Active__c='Yes';
        acc.Converted_to_Normal_Saloon__c = true;
        update acc;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        insert ph;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        insert pg1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadtwo',ph.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c();
        pgd.ivybase__Product__c=p1.id;
        pgd.ivybase__Product_Group__c=pg1.id;
        insert pgd;
        
        Set<Id> visitIdSet = new Set<Id>();
        
        list<ivybase__Visit__c> Visitlist=new  list<ivybase__Visit__c>();
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        insert Visitlist;
        Visitlist[0].ivybase__Resource__c = res.Id;
        Visitlist[1].ivybase__Resource__c = res.Id;
        update Visitlist;
        
        visitIdSet.add(Visitlist[0].Id);
        visitIdSet.add(Visitlist[1].Id);
        
        ivydsd__Order__c o = TestUtility.createTestOrder(acc.id,'Draft',null,'12345');
        o.ivydsd__Order_Date__c = Date.today().addDays(-10);
        o.ivydsd__Delivery_Date__c = Date.today();
        o.ivydsd__Purchase_Order_Number__c = 'ORDER12';
        o.ivydsd__Remarks__c = 'Test Remarks';
        o.Total_Tax_Value__c = 100;
        o.Bill_To__c = acc.Id;
        o.Ship_To__c = acc.Id;
        o.Payer_Code__c = 'PAYER';
        o.Tax_Details__c = 200;
        o.Handling_Charges__c = 20;
        o.Order_Notes__c = 'Notes';
        o.Division__c=division.id;
        o.ivydsd__Resource__c = res.Id;
        o.ivydsd__Visit__c = Visitlist[0].Id;

        insert o;
        
        /*ivydsd__Order__c o2 = TestUtility.createTestOrder(acc.id,'',null,'12345');
        o2.ivydsd__Order_Date__c = Date.today().addDays(-10);
        o2.Division__c=division.id;
        o2.ivydsd__Resource__c = res.Id;
        insert o2;*/
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , p1.id, 300 , 0 , 0 , 3 , 0 , 0 );
        oli.ivydsd__Line_Item_Type__c ='Normal';
        insert oli;
        
        /*ivydsd__Order_Line_item__c oli1 = TestUtility.createTestOrderLineItem(o.id , p2.id, 300 , 0 , 0 , 3 , 0 , 0 );
        insert oli1;*/
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        insert schemeSlab;
        
        ivydsd__Scheme_Apply_Detail__c schemeApply = new ivydsd__Scheme_Apply_Detail__c(ivydsd__Order__c=o.Id,
                                                                                        ivydsd__Order_Line_Item__c=oli.Id,
                                                                                       ivydsd__Scheme__c=schemeSlab.Id,
                                                                                       Amount__c = 1000,
                                                                                       Scheme_Description__c = 'Test');
        schemeApply.RecordTypeId = [SELECT Id 
                                    FROM RecordType 
                                    WHERE DeveloperName ='Buy_Product' 
                                    AND sobjecttype='ivydsd__Scheme_Apply_Detail__c' 
                                    LIMIT 1].Id;                                                                               
        insert schemeApply;
        
        ivybase__Standard_List_Master__c orderStandard = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'ORDER_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = resType.Id);
        insert orderStandard;
                             
        test.startTest();
        RESTOrderDetails.getOrderDetailInfo();
        OrderService.getOrderByvisits(visitIdSet);
        test.stopTest();
        
        List<ivydsd__Order__c> orderlist = [Select Id,Name,ivydsd__Internal_Id__c,ivydsd__Order_Date__c,ivydsd__Store__c,ivydsd__Store__r.ivybase__Internal_Id__c,ivydsd__Order_Value__c,ivydsd__Number_of_Line_Items__c,ivydsd__Delivery_Date__c,ivydsd__Purchase_Order_Number__c,
                             ivydsd__Mobile_Order_Number__c,ivydsd__Remarks__c,Bill_To__c,Bill_To__r.ivybase__Internal_Id__c,Ship_To__c,Ship_To__r.ivybase__Internal_Id__c,ivydsd__Geolocation__c,ivydsd__Geolocation__latitude__s,ivydsd__Geolocation__longitude__s,Total_Tax_Value__c,Payer_Code__c,Tax_Details__c,Handling_Charges__c,Order_Notes__c,Signature_Image_Path__c,ivydsd__Order_Status__c From ivydsd__Order__c
                             where ivydsd__Visit__c!=null]; 
        system.debug(orderlist);  
    }
    
    private static testMethod void testOrderDetails1(){
    
        id currentUserId= userinfo.getUserId();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype; 
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',RecordTypeId=RT.get('National').getRecordTypeId(),ivybase__Primary_Resource__c=res.Id);
        insert location; 
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
                insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='MY');

        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Conquest__c = true;
        insert acc;
        acc.ivybase__Active__c='Yes';
        acc.Converted_to_Normal_Saloon__c = true;
        update acc;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        insert ph;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        insert pg1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadtwo',ph.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c();
        pgd.ivybase__Product__c=p1.id;
        pgd.ivybase__Product_Group__c=pg1.id;
        insert pgd;
        
        Set<Id> visitIdSet = new Set<Id>();
        
        list<ivybase__Visit__c> Visitlist=new  list<ivybase__Visit__c>();
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        insert Visitlist;
        Visitlist[0].ivybase__Resource__c = res.Id;
        Visitlist[1].ivybase__Resource__c = res.Id;
        update Visitlist;
        
        visitIdSet.add(Visitlist[0].Id);
        visitIdSet.add(Visitlist[1].Id);
        
        ivydsd__Order__c o = TestUtility.createTestOrder(acc.Id,'Draft',null,'12345');
        o.ivydsd__Order_Date__c = Date.today().addDays(-10);        
        o.Division__c=division.id;
        o.ivydsd__Resource__c = res.Id;
        o.ivydsd__Visit__c = Visitlist[0].Id;

        insert o;
        
        /*ivydsd__Order__c o2 = TestUtility.createTestOrder(acc.id,'',null,'12345');
        o2.ivydsd__Order_Date__c = Date.today().addDays(-10);
        o2.Division__c=division.id;
        o2.ivydsd__Resource__c = res.Id;
        insert o2;*/
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , p1.id, 300 , 0 , 0 , 3 , 0 , 0 );
        oli.ivydsd__Line_Item_Type__c ='Normal';
        insert oli;
        
        /*ivydsd__Order_Line_item__c oli1 = TestUtility.createTestOrderLineItem(o.id , p2.id, 300 , 0 , 0 , 3 , 0 , 0 );
        insert oli1;*/
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        insert schemeSlab;
        
        ivydsd__Scheme_Apply_Detail__c schemeApply = new ivydsd__Scheme_Apply_Detail__c(ivydsd__Order__c=o.Id,
                                                                                        ivydsd__Order_Line_Item__c=oli.Id,
                                                                                       ivydsd__Scheme__c=schemeSlab.Id,
                                                                                       Amount__c = 1000,
                                                                                       Scheme_Description__c = 'Test');
        schemeApply.RecordTypeId = [SELECT Id 
                                    FROM RecordType 
                                    WHERE DeveloperName ='Buy_Product' 
                                    AND sobjecttype='ivydsd__Scheme_Apply_Detail__c' 
                                    LIMIT 1].Id;                                                                               
        insert schemeApply;
        
        ivybase__Standard_List_Master__c orderStandard = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'ORDER_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = resType.Id);
        insert orderStandard;
                             
        test.startTest();
        RESTOrderDetails.getOrderDetailInfo();
        OrderService.getOrderByvisits(visitIdSet);
        test.stopTest();
        
        List<ivydsd__Order__c> orderlist = [Select Id,Name,ivydsd__Internal_Id__c,ivydsd__Order_Date__c,ivydsd__Store__c,ivydsd__Store__r.ivybase__Internal_Id__c,ivydsd__Order_Value__c,ivydsd__Number_of_Line_Items__c,ivydsd__Delivery_Date__c,ivydsd__Purchase_Order_Number__c,
                             ivydsd__Mobile_Order_Number__c,ivydsd__Remarks__c,Bill_To__c,Bill_To__r.ivybase__Internal_Id__c,Ship_To__c,Ship_To__r.ivybase__Internal_Id__c,ivydsd__Geolocation__c,ivydsd__Geolocation__latitude__s,ivydsd__Geolocation__longitude__s,Total_Tax_Value__c,Payer_Code__c,Tax_Details__c,Handling_Charges__c,Order_Notes__c,Signature_Image_Path__c,ivydsd__Order_Status__c From ivydsd__Order__c
                             where ivydsd__Visit__c!=null]; 
        system.debug(orderlist);  
    }
    
    private static testMethod void testFreeProductScheme(){
    
        id currentUserId= userinfo.getUserId();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype; 
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',currentUserId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',RecordTypeId=RT.get('National').getRecordTypeId(),ivybase__Primary_Resource__c=res.Id);
        insert location; 
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
                insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='MY');

        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Conquest__c = true;
        insert acc;
        acc.ivybase__Active__c='Yes';
        acc.Converted_to_Normal_Saloon__c = true;
        update acc;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        insert ph;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        insert pg1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadtwo',ph.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivybase__Product_Group_Detail__c pgd = new ivybase__Product_Group_Detail__c();
        pgd.ivybase__Product__c=p1.id;
        pgd.ivybase__Product_Group__c=pg1.id;
        insert pgd;
        
        list<ivybase__Visit__c> Visitlist=new  list<ivybase__Visit__c>();
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        Visitlist.add(TestUtility.createTestVisit(Date.today(),acc.id,'Completed'));
        insert Visitlist;
        Visitlist[0].ivybase__Resource__c = res.Id;
        Visitlist[1].ivybase__Resource__c = res.Id;
        update Visitlist;
        
        ivydsd__Order__c o = TestUtility.createTestOrder(acc.id,'Draft',null,'12345');
        o.ivydsd__Order_Date__c = Date.today().addDays(-10);
        o.ivydsd__Delivery_Date__c = Date.today();
        o.ivydsd__Purchase_Order_Number__c = 'ORDER12';
        o.ivydsd__Remarks__c = 'Test Remarks';
        o.Total_Tax_Value__c = 100;
        o.Bill_To__c = acc.Id;
        o.Ship_To__c = acc.Id;
        o.Payer_Code__c = 'PAYER';
        o.Tax_Details__c = 200;
        o.Handling_Charges__c = 20;
        o.Order_Notes__c = 'Notes';
        o.Division__c=division.id;
        o.ivydsd__Resource__c = res.Id;
        o.ivydsd__Visit__c = Visitlist[0].Id;

        insert o;
        
        /*ivydsd__Order__c o2 = TestUtility.createTestOrder(acc.id,'',null,'12345');
        o2.ivydsd__Order_Date__c = Date.today().addDays(-10);
        o2.Division__c=division.id;
        o2.ivydsd__Resource__c = res.Id;
        insert o2;*/
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(o.id , p1.id, 300 , 0 , 0 , 3 , 0 , 0 );
        oli.ivydsd__Line_Item_Type__c ='Free of Cost';
        insert oli;
        
        /*ivydsd__Order_Line_item__c oli1 = TestUtility.createTestOrderLineItem(o.id , p2.id, 300 , 0 , 0 , 3 , 0 , 0 );
        insert oli1;*/
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        insert schemeSlab;
        
        ivydsd__Scheme_Apply_Detail__c schemeApply = new ivydsd__Scheme_Apply_Detail__c(ivydsd__Order__c=o.Id,
                                                                                        ivydsd__Order_Line_Item__c=oli.Id,
                                                                                       ivydsd__Scheme__c=schemeSlab.Id,
                                                                                       Scheme_Description__c = 'Testfree');
        schemeApply.RecordTypeId = [SELECT Id 
                                    FROM RecordType 
                                    WHERE DeveloperName ='Free_Product' 
                                    AND sobjecttype='ivydsd__Scheme_Apply_Detail__c' 
                                    LIMIT 1].Id;                                                                               
        insert schemeApply;
        
        ivybase__Standard_List_Master__c orderStandard = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'ORDER_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = resType.Id);
        insert orderStandard;
                             
        test.startTest();
        RESTOrderDetails.getOrderDetailInfo();        
        test.stopTest();
        
        List<ivydsd__Order__c> orderlist = [Select Id,Name,ivydsd__Internal_Id__c,ivydsd__Order_Date__c,ivydsd__Store__c,ivydsd__Store__r.ivybase__Internal_Id__c,ivydsd__Order_Value__c,ivydsd__Number_of_Line_Items__c,ivydsd__Delivery_Date__c,ivydsd__Purchase_Order_Number__c,
                             ivydsd__Mobile_Order_Number__c,ivydsd__Remarks__c,Bill_To__c,Bill_To__r.ivybase__Internal_Id__c,Ship_To__c,Ship_To__r.ivybase__Internal_Id__c,ivydsd__Geolocation__c,ivydsd__Geolocation__latitude__s,ivydsd__Geolocation__longitude__s,Total_Tax_Value__c,Payer_Code__c,Tax_Details__c,Handling_Charges__c,Order_Notes__c,Signature_Image_Path__c,ivydsd__Order_Status__c From ivydsd__Order__c
                             where ivydsd__Visit__c!=null]; 
        system.debug(orderlist);  
    }    
}