/**
 * Created By : Ivy Mobility
 * Classes Covered : UserTriggerTranslator(100%), VisitTrigger(100%), ConversionUtility(98%),
  OrderLineItem(93%), OrderUploadTranslator(93%), OrderLineItemService(90%), SchemeService(85%), UserTrigger(85%),
  RouteDetailsTriggerHandler(82%), AccountTrigger(81%), RecordTypeService(81%), AverageTurnoverPerRep(80%), ContactTrigger(80%),
  TriggerLogicService(80%), OrderTrigger(78%)
*/
@isTest
public class TestOrderUploadTranslator {
public static testmethod void allnull()
{
    OrderUploadTranslator.translateOrderHeader(null,null);
    List<LorealUploadclass.OrderDetail> detail = new List<LorealUploadclass.OrderDetail>();
    OrderUploadTranslator.translateOrderDetails(detail,null,null);
    OrderUploadTranslator.translateSchemeApplyDetails(null,null);
}
    public static testmethod void empty()
{
    
    List<LorealUploadclass.OrderHeader> header = new List<LorealUploadclass.OrderHeader>();
    List<LorealUploadclass.OrderDetail> detail = new List<LorealUploadclass.OrderDetail>();
    List<LorealUploadclass.SchemeDetail> scheme = new List<LorealUploadclass.SchemeDetail>();
    List<LorealUploadclass.SchemeFreeProductDetail> freedetail = new List<LorealUploadclass.SchemeFreeProductDetail>();
    OrderUploadTranslator.translateOrderHeader(header,detail);
    OrderUploadTranslator.translateOrderDetails(detail,scheme,freedetail);
    OrderUploadTranslator.translateSchemeApplyDetails(scheme,freedetail);
}
    
    public static testmethod void header()
    {
        List<Id> productId = new List<Id>();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c='MY';
        insert division;
        
        insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='SG');
       
      /*  UserwiseCountryValues__c uc = new UserwiseCountryValues__c();
        uc.Market_Iso__c = 'SG';
        insert uc; */
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        res.ivybase__Location_Hierarchy__c = locHr.Id;
        update res;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Internal_Id__c=343434;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '1234567892' , '1112223332' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        acc2.ivybase__Internal_Id__c=23373434;
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        update acc2;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        Territory_Routing__c territoryRoute = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert territoryRoute;
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        ivybase__Route_Details__c routeDetail2 = TestUtility.createTestRouteDetail('TestRouteDetail2',route.Id,'Yes',acc2.Id);   
        insert routeDetail2;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
    
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        //p1.ivybase__InternalId__c = 34231;
        insert p1;
            
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone2',ph.Id,'Testdesc', false ,'Yes');
        p2.ivybase__Non_Saleable__c=true;
       // p2.ivybase__InternalId__c=34234;
        insert p2;
        
        productId.add(p2.id);
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadone2',ph.Id,'Testdesc', false ,'Yes');
        p3.ivybase__Non_Saleable__c=true;
      //  p3.ivybase__InternalId__c=34235;
        insert p3;
        
        productId.add(p3.id);
        productId.add(p1.id);
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivybase__Visit__c v1 = TestUtility.createTestVisit(Date.today(), acc.Id ,'');  
        insert v1;
    
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'ORDER_STATUS',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
        }; 
        insert stdMasterList;
    
    
        List<String> updateRecord = new List<String>();
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        for(integer i=0;i<2;i++)
        {
            ivydsd__Order__c order;
            if(i>0){
             order = TestUtility.createTestOrder(acc.id,'Draft',con.id,'1');
            }
            else
            {
               order = TestUtility.createTestOrder(acc2.id,'Draft',con.id,'1'); 
            }
            order.ivydsd__Purchase_Order_Number__c=''+i*342;
            order.Division__c=division.id;
            order.ivydsd__Resource__c=res.id;
            order.ivydsd__Remarks__c='asdfg';
            
            order.ivydsd__Mobile_Order_Number__c=String.valueOf(crypto.getRandomLong());
            updateRecord.add(order.ivydsd__Mobile_Order_Number__c);
            orderList.add(order);
        }
        insert orderList;
        
       
        List<ivydsd__Order_Line_item__c> orderlineItemList = new List<ivydsd__Order_Line_item__c>();
        for(integer i=0;i<2;i++)
        {
            ivydsd__Order_Line_item__c oli;
            if(i>0){
             oli = TestUtility.createTestOrderLineItem(orderList[i].id, p1.id, 100 , 100 , 100 , 20 , 30 , 20 );
            }else{
                oli=TestUtility.createTestOrderLineItem(orderList[i].id, p2.id, 100 , 100 , 100 , 20 , 30 , 20 );
            }
            orderlineItemList.add(oli);
        }
        insert orderlineItemList;
        
    test.startTest();
    
    List<LorealUploadclass.OrderHeader> header = new List<LorealUploadclass.OrderHeader>();
    List<LorealUploadclass.OrderDetail> detail = new List<LorealUploadclass.OrderDetail>();
    List<String> orderID = new List<String>();
    for(integer i=0;i<20;i++)
    {
        LorealUploadclass.OrderHeader head = new LorealUploadclass.OrderHeader();
        head.OrderID=String.valueOf(crypto.getRandomLong());
        orderID.add(head.OrderID);
        head.Status='Ordered';
        head.OrderDate=String.valueOf(system.today());
        head.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        head.deliveryDate=String.valueOf(system.today().addDays(2));
        head.OrderValue=string.valueOf(234324234);
        head.totalTaxValue=string.valueOf(234234234);
        head.BIllTo=String.valueOf(acc.ivybase__Internal_Id__c);
        head.ShipTo=String.valueOf(acc.ivybase__Internal_Id__c);    
        head.PayerCode=String.valueOf(acc.ivybase__Internal_Id__c);    
        header.add(head);
    }
    //update records
    LorealUploadclass.OrderHeader updatehead = new LorealUploadclass.OrderHeader();
        updatehead.OrderID=updateRecord[0];
        updatehead.OrderDate=String.valueOf(system.today());
        updatehead.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        updatehead.deliveryDate=String.valueOf(system.today().addDays(2));
        updatehead.OrderValue=string.valueOf(234324234);
        updatehead.totalTaxValue=string.valueOf(234234234);
        header.add(updatehead);
      updatehead = new LorealUploadclass.OrderHeader();
        updatehead.OrderID=updateRecord[1];
        updatehead.OrderDate=String.valueOf(system.today());
        updatehead.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        updatehead.deliveryDate=String.valueOf(system.today().addDays(2));
        updatehead.OrderValue=string.valueOf(234324234);
        updatehead.totalTaxValue=string.valueOf(234234234);
        updatehead.Status='Ordered'; 
        header.add(updatehead);
    
    //posmOrder
        List<ivybase__Product__c> prod = [select id,name,ivybase__InternalId__c from ivybase__Product__c where id=:productId];
        system.debug('&&&Prod'+prod);
        LorealUploadclass.OrderDetail recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[5];
        recdetail.ProductId=String.valueOf(prod[0].ivybase__InternalId__c);
        detail.add(recdetail);  
         recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[5];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);  
        
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[6];
        recdetail.ProductId=String.valueOf(prod[2].ivybase__InternalId__c);
        detail.add(recdetail);  
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[6];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);
    
    //update records posm and normal order
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[0];
        recdetail.ProductId=String.valueOf(prod[0].ivybase__InternalId__c);
        detail.add(recdetail);
    
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[0];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);
    
       recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[1];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);
    
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[1];
        recdetail.ProductId=String.valueOf(prod[2].ivybase__InternalId__c);
        detail.add(recdetail);
        system.debug('&&&detail'+detail);
        
        User u = TestUtility.getCustomerArgoUser();
        //insert u;
        system.runAs(u){    
            try{
                OrderUploadTranslator.translateOrderHeader(header,detail);
                OrderUploadTranslator.translateOrderDetails(detail,null,null);
            }catch(Exception e){}
        }
        test.stopTest();
    }
    public static testmethod void headerwithdetail()
    {
        List<Id> productId = new List<Id>();
        List<Id> productInternalId = new List<Id>();
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('supervisor');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        insert new UserwiseCountryValues__c(SetupOwnerId=UserInfo.getUserId(), Market_Iso__c ='SG');
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c='MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        res.ivybase__Location_Hierarchy__c = locHr.Id;
        update res;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Internal_Id__c=343434;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        Account acc2 = TestUtility.createTestAccount('2' , 'Test Acc2' , '1234567892' , '1112223332' , res.id , 'Retail_Account' , 'Yes' );
        acc2.ivybase__Location_Hierarchy__c = locHr.Id;
        acc2.Converted_to_Normal_Saloon__c = true;
        acc2.Dream_List_Status__c ='Test';
        acc2.Progress_Percentage__c = 100;
        acc2.ivybase__Internal_Id__c=23373434;
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        update acc2;
        
        ivybase__Route__c route = TestUtility.createTestRoute(res.Id,'Yes');   
        insert route;
        Territory_Routing__c territoryRoute = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        insert territoryRoute;
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        insert routeDetail;
        ivybase__Route_Details__c routeDetail2 = TestUtility.createTestRouteDetail('TestRouteDetail2',route.Id,'Yes',acc2.Id);   
        insert routeDetail2;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
    
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
            
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone2',ph.Id,'Testdesc', false ,'Yes');
        p2.ivybase__Non_Saleable__c=true;
        //p2.ivybase__InternalId__c=34234;
        insert p2;
        productId.add(p2.id);
        
        ivybase__Product__c p3 = TestUtility.createTestProduct('Testdsduploadone2',ph.Id,'Testdesc', false ,'Yes');
        p3.ivybase__Non_Saleable__c=true;
        //p3.ivybase__InternalId__c=34235;
        insert p3;
        productId.add(p3.id);
        productId.add(p1.id);
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivybase__Visit__c v1 = TestUtility.createTestVisit(Date.today(), acc.Id ,'');  
        insert v1;
    
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TAX_TYPE', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'TAX_TYPE',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Flex1__c='1'),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
        }; 
        insert stdMasterList;
    
    
        List<String> updateRecord = new List<String>();
        List<ivydsd__Order__c> orderList = new List<ivydsd__Order__c>();
        for(integer i=0;i<20;i++)
        {
            ivydsd__Order__c order;
            if(i>10){
             order = TestUtility.createTestOrder(acc.id,'Draft',con.id,'1');
            }
            else
            {
               order = TestUtility.createTestOrder(acc2.id,'Draft',con.id,'1'); 
            }
            order.ivydsd__Purchase_Order_Number__c=''+i*342;
            order.Division__c=division.id;
            order.ivydsd__Resource__c=res.id;
            order.ivydsd__Mobile_Order_Number__c=String.valueOf(crypto.getRandomLong());
            updateRecord.add(order.ivydsd__Mobile_Order_Number__c);
            orderList.add(order);
        }
        insert orderList;
        
        List<ivydsd__Order_Line_item__c> orderlineItemList = new List<ivydsd__Order_Line_item__c>();
        for(integer i=0;i<1;i++)
        {
            ivydsd__Order_Line_item__c oli;
            
             oli = TestUtility.createTestOrderLineItem(orderList[i].id, p1.id, 100 , 100 , 100 , 20 , 30 , 20 );
             oli.Item_Number__c=10;
            /*else{
                oli=TestUtility.createTestOrderLineItem(orderList[i].id, p2.id, 100 , 100 , 100 , 20 , 30 , 20 );
            }*/
            orderlineItemList.add(oli);
            system.debug('**** Line Item'+oli);
        }
        insert orderlineItemList;
        
    test.startTest();
    
    List<LorealUploadclass.OrderHeader> header = new List<LorealUploadclass.OrderHeader>();
    List<LorealUploadclass.OrderDetail> detail = new List<LorealUploadclass.OrderDetail>();
    List<String> orderID = new List<String>();
    for(integer i=0;i<20;i++)
    {
        LorealUploadclass.OrderHeader head = new LorealUploadclass.OrderHeader();
        head.OrderID=String.valueOf(crypto.getRandomLong());
        orderID.add(head.OrderID);
        head.Status='Ordered';
        head.OrderDate=String.valueOf(system.today());
        head.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        head.deliveryDate=String.valueOf(system.today().addDays(2));
        head.OrderValue=string.valueOf(234324234);
        head.totalTaxValue=string.valueOf(234234234);
        head.BIllTo=String.valueOf(acc.ivybase__Internal_Id__c);
        head.ShipTo=String.valueOf(acc.ivybase__Internal_Id__c);    
        head.PayerCode=String.valueOf(acc.ivybase__Internal_Id__c);    
        header.add(head);
    }
    //update records
    LorealUploadclass.OrderHeader updatehead = new LorealUploadclass.OrderHeader();
        updatehead.OrderID=updateRecord[0];
        updatehead.OrderDate=String.valueOf(system.today());
        updatehead.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        updatehead.deliveryDate=String.valueOf(system.today().addDays(2));
        updatehead.OrderValue=string.valueOf(234324234);
        updatehead.totalTaxValue=string.valueOf(234234234);
        header.add(updatehead);
      updatehead = new LorealUploadclass.OrderHeader();
        updatehead.OrderID=updateRecord[1];
        updatehead.OrderDate=String.valueOf(system.today());
        updatehead.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        updatehead.deliveryDate=String.valueOf(system.today().addDays(2));
        updatehead.OrderValue=string.valueOf(234324234);
        updatehead.totalTaxValue=string.valueOf(234234234);
        updatehead.Status='Ordered'; 
        header.add(updatehead);
    
    //posmOrder
       List<ivybase__Product__c> prod = [select id,name,ivybase__InternalId__c from ivybase__Product__c where id=:productId];
        system.debug('&&&Prod'+prod);
        LorealUploadclass.OrderDetail recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[5];
        recdetail.ProductId=String.valueOf(prod[0].ivybase__InternalId__c);
        detail.add(recdetail);  
         recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[5];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);  
        
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[6];
        recdetail.ProductId=String.valueOf(prod[2].ivybase__InternalId__c);
        detail.add(recdetail);  
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=orderID[6];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);
        
        //productInternalId.add(String.valueOf(prod[0].ivybase__InternalId__c));
        //productInternalId.add(String.valueOf(prod[1].ivybase__InternalId__c));
        //productInternalId.add(String.valueOf(prod[2].ivybase__InternalId__c));
    
    //update records posm and normal order
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[0];
        recdetail.ProductId=String.valueOf(prod[0].ivybase__InternalId__c);
        detail.add(recdetail);
    
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[0];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);
    
       recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[1];
        recdetail.ProductId=String.valueOf(prod[1].ivybase__InternalId__c);
        detail.add(recdetail);
    
        recdetail = new LorealUploadclass.OrderDetail();
        recdetail.OrderId=updateRecord[1];
        recdetail.ProductId=String.valueOf(prod[2].ivybase__InternalId__c);
        detail.add(recdetail);
        system.debug('&&&detail'+detail);
        
        User u = TestUtility.getCustomerArgoUser();
        //insert u;
        system.runAs(u){    
            try{
                OrderUploadTranslator.translateOrderHeader(header,detail);
                OrderUploadTranslator.translateOrderDetails(detail,null,null);
            }catch(Exception e){}
        }
        test.stopTest();
        
        //Set<Decimal> internalIdSet = new Set<Decimal>();
        //for(String st : productInternalId) {
        //    internalIdSet.add(Decimal.valueOf(st));
        //}
        
        //List<ivybase__Product__c> li = [SELECT Id, ivybase__InternalId__c,ivybase__Non_Saleable__c  FROM ivybase__Product__c WHERE ivybase__InternalId__c != NULL AND ivybase__InternalId__c IN:internalIdSet];
        //system.debug('li::::>>>>'+li);
}
}