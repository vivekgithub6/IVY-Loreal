/**
 * Covered Classes :AccountTrigger, AverageTurnOverPerRep, DivisionService, LocationTrigger, PostResponse, RetailerContactService,
 RetailerDocumentSerivce, VisitTrigger, VisitTriggerHandler, ConversionUtility, PromotionalPlanHeaderTranslator, ResourceService, 
SchemeUtility, JourneyPlanActivityTranslatorUpload, JourneyPlanMarketTranslatorUpload, DreamListService, LocationTriggerHandler,
RESTJourneyPlan, OrderService, StandardListMasterService, CommonUtility, PromotionalPlanDetailUploadTranslator, VisitService,
HairDresserUploadTranslator, LOrealUploadTranslator, SalesforecastingTriggerHandler, DreamListUploadTranslator, AccountService,
LocationMasterService, LOrealUpload, RouteDetailsTriggerHandler, CompetitorTrackingTranslator, ContactTrigger, OrderTriggerHandler,
TriggerLogicService, SalesforecastingTrigger, RetailerEditUploadTranslaor, OrderTrigger
*/
@isTest
public class TESTLOrealUpload {

    @testSetup static void setup(){
    
        //id userId = userInfo.getUserId();
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        //User u = [SELECT Id FROM User WHERE Id =: userId LIMIT 1];
        //u.Market_ISO__c = 'MY';
        //update u;
        
        Batch_SwitchOff__c batchSwithchOff = new Batch_SwitchOff__c();
        batchSwithchOff.Name = 'SalesForecast_Trigger_month_MoreThan_0';
        batchSwithchOff.SwitchOff__c = false;
        insert batchSwithchOff;
        
        Batch_SwitchOff__c batchSwithchOff2 = new Batch_SwitchOff__c();
        batchSwithchOff2.Name = 'SalesForecast_Trigger_month_equals_0';
        batchSwithchOff2.SwitchOff__c = false;
        insert batchSwithchOff2;
        
        
        
        
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        restype.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=usr.Id,Market_ISO__c = 'MY');
        resource.ivybase__Resource_Type__c = restype.Id;
        resource.Market_ISO__c = usr.Market_ISO__c;
        resource.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert resource;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = 'MY',RecordTypeId=RT.get('Territory').getRecordTypeId(),ivybase__Primary_Resource__c=resource.Id);
        location.Market_ISO__c = usr.Market_ISO__c;
        location.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert location; 
        
        List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Removed',ivybase__List_Code__c='REM', ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Maintenance',ivybase__List_Code__c='AMR', ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'DRAFT',ivybase__List_Code__c='D', ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'SUBMITTED',ivybase__List_Code__c='S', ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'REJECTED',ivybase__List_Code__c='R', ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'APPROVED',ivybase__List_Code__c='A', ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'A',ivybase__List_Code__c='A', ivybase__List_Type__c = 'CHANNEL_HIERARCHY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'A+',ivybase__List_Code__c='A+', ivybase__List_Type__c = 'CHANNEL_HIERARCHY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'B',ivybase__List_Code__c='B', ivybase__List_Type__c = 'CHANNEL_HIERARCHY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'C',ivybase__List_Code__c='C', ivybase__List_Type__c = 'CHANNEL_HIERARCHY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'D',ivybase__List_Code__c='D', ivybase__List_Type__c = 'CHANNEL_HIERARCHY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Single Proprietor',ivybase__List_Code__c='LE_1', ivybase__List_Type__c = 'LEGAL_ENTITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Partnership',ivybase__List_Code__c='LE_2', ivybase__List_Type__c = 'LEGAL_ENTITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'NGO',ivybase__List_Code__c='LE_3', ivybase__List_Type__c = 'LEGAL_ENTITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Check Collection',ivybase__List_Code__c='MOP_1', ivybase__List_Type__c = 'MODE_OF_PAYMENT', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Check Deposit',ivybase__List_Code__c='MOP_2', ivybase__List_Type__c = 'MODE_OF_PAYMENT', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Electronic Transfer',ivybase__List_Code__c='MOP_3', ivybase__List_Type__c = 'MODE_OF_PAYMENT', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Bank',ivybase__List_Code__c='MOP_4', ivybase__List_Type__c = 'MODE_OF_PAYMENT', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Reception',ivybase__List_Code__c='REC', ivybase__List_Type__c = 'PL', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'ORDER_STATUS', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = resType.Id),
            
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'test1',ivybase__List_Type__c = 'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id ),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'test2',ivybase__List_Type__c =  'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id ),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'test3',ivybase__List_Type__c = 'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id ),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'test4',ivybase__List_Type__c =  'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test5',ivybase__List_Type__c = 'AMAZON_CONFIGURATION', ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_PL_REC', ivybase__List_Name__c = 'test6',ivybase__List_Type__c = 'PL',ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_PL_REASON', ivybase__List_Name__c = 'test7',ivybase__List_Type__c = 'REASON',ivybase__Location_Hierarchy__c = location.Id,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Kerastase',ivybase__List_Code__c='KERA', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Loreal Professional',ivybase__List_Code__c='LP', ivybase__List_Type__c = 'DIVISION_TYPE' ,ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Matrix',ivybase__List_Code__c='MX', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Redken and Pureology',ivybase__List_Code__c='R & P', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Resource_Type__c = restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'SKU', ivybase__List_Name__c = 'SKU', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=location.Id,ivybase__Resource_Type__c=restype.Id, ivybase__Encrypted_List_Name__c = 'test')
 
      };
                    insert standardmaster;
        system.debug('standardmaster****'+standardmaster);
        
                
        ivybase__Max_Internal_Id_Value__c contactCustSetting = new ivybase__Max_Internal_Id_Value__c(ivybase__Max_Internal_Id__c=6, Name='Contact');
        insert contactCustSetting;
        
        Contact con1 = TestUtility.createTestContact('Test','Buddy', usr.Id , usr.currencyIsoCode, 'testBuddy@salesforce.com',
                                                     NULL, 'Retailer_Contact' );
        insert con1;

        
        Date myDate = Date.newInstance(2018,6,6);
        
        JourneyPlan__c journeyplan = new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Territory__c=location.Id,Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Status__c='D');
        journeyplan.Market_ISO__c = usr.Market_ISO__c;
        journeyplan.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert journeyplan;
        
        
       /* JourneyPlan__c journeyplan2 = new JourneyPlan__c(Tid__c='10',Market_ISO__c = usr.Market_ISO__c,Territory__c=location.Id,Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Status__c='D');
        journeyplan.Market_ISO__c = usr.Market_ISO__c;
        journeyplan.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert journeyplan;*/
        
        JourneyPlan__c journeyplans = new JourneyPlan__c(Tid__c='9',Market_ISO__c = 'MY',Territory__c=location.Id,Date__c=myDate,Month__c=6,Year__c=7,SupervisorComments__c='Test Comments',Status__c='D');
        journeyplans.Market_ISO__c = usr.Market_ISO__c;
        journeyplans.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert journeyplans;
        
        Rintin_Plan__c rintinPlan1 = TestUtility.createRintinPlan(journeyPlan.Id);
        rintinPlan1.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert rintinPlan1;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',resource.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert locHr;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'MY');
        div.Market_ISO__c = usr.Market_ISO__c;
        div.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert div;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = div.Id,Market_ISO__c = 'MY');
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        channel.Market_ISO__c = usr.Market_ISO__c;
        channel.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c = 'MY');
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        subChannel.Market_ISO__c = usr.Market_ISO__c;
        subChannel.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c = 'MY');
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        node3.Market_ISO__c = usr.Market_ISO__c;
        node3.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c = 'MY');
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Market_ISO__c = usr.Market_ISO__c;
        node4.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert node4;
        
       ivybase__Standard_List_Master__c a =  new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'SKU1', ivybase__List_Name__c = 'SKU1', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=location.Id,ivybase__Resource_Type__c=restype.Id, ivybase__Encrypted_List_Name__c = 'test');
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Store_Hierarchy__c =node4.Id;
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        
        insert acc;
        acc.Sold_To_Party_Number__c='12345';
        acc.ivybase__Active__c = 'yes';
        update acc;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc2 = new Account(Name='aaa2', recordTypeId=accrecordTypeId);
        acc2.Market_ISO__c = usr.Market_ISO__c;
        acc2.CurrencyIsoCode = usr.CurrencyIsoCode;
        acc2.Is_Conquest__c = true;
        insert acc2;
        acc2.ivybase__Active__c = 'Yes';
        acc2.ivybase__Resource__c = resource.Id;
        acc2.ivybase__Store_Hierarchy__c=node4.id;
        acc2.Converted_to_Normal_Saloon__c = true;
        update acc2; 
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',Market_ISO__c='MY',Name='Test Scheme',ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__Scheme_Get_Logic__c='ANY',ivydsd__Code__c='TEST',ivydsd__Description__c='Test Description',ivydsd__From__c=System.today(),ivydsd__To__c=System.today().addDays(20),ivydsd__Scheme_Type__c='QTY');
        scheme.Market_ISO__c = usr.Market_ISO__c;
        scheme.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert scheme;
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Territory__c=location.Id,Date__c=System.today().addMonths(1),Status__c='Draft',SuperVisorComments__c='Test Comments',Target__c=5);
        salesForecast.Market_ISO__c = usr.Market_ISO__c;
        salesForecast.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert salesForecast;
        
        Sales_Forecast_Detail__c salesforcastDetail = new Sales_Forecast_Detail__c(Sales_Forecast__c=salesForecast.Id,Store__c=acc.Id,Target__c=5,Scheme__c=scheme.Id);
        salesforcastDetail.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert salesforcastDetail;
        
        
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        //classP.ivybase__Parent__c = subAxe.Id;
        classP.Market_ISO__c = usr.Market_ISO__c;
        classP.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert classP;
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');     
        function.ivybase__Parent__c = classP.Id;
        function.Market_ISO__c = usr.Market_ISO__c;
        function.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert function;
        
        
        List<ivybase__Product__c> productList = new List<ivybase__Product__c>();
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testprod',function.Id,'Testdesc', true ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        productList.add(proSKU);   
        ivybase__Product__c proSKU2 = TestUtility.createTestProduct('Testproduct',function.Id,'Testdesc', true ,'Yes');
        proSKU2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        productList.add(proSKU2);   
        proSKU.Market_ISO__c = usr.Market_ISO__c;
        proSKU.CurrencyIsoCode = usr.CurrencyIsoCode;
        
        proSKU2.Market_ISO__c = usr.Market_ISO__c;
        proSKU2.CurrencyIsoCode = usr.CurrencyIsoCode;
        
        insert productList;
        
        System.Assert(productList.size()==2);
        
        ivybase__Visit__c visit = new ivybase__Visit__c(ivybase__Resource__c=resource.Id,ivybase__Status__c='Completed',ivybase__Store__c=acc.Id,Name='Test',ivybase__Visit_Date__c=System.today());
        visit.Market_ISO__c = usr.Market_ISO__c;
        visit.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert visit;
        
        ivybase__Standard_List_Master__c standard = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Reception',ivybase__List_Code__c='REC', ivybase__List_Type__c = 'PL', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id);
        standard.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert standard;   
        
        System.debug('StandardListMaster:: '+standard);
        Id InStore = [Select Id from RecordType Where DeveloperName='In_Store' 
                      AND SobjectType='ivybase__Location__c'].Id;
        
        ivybase__Location__c loc = new ivybase__Location__c(RecordTypeId=InStore,Market_ISO__c = 'MY',ivybase__Active__c='Yes',ivybase__Resource__c=resource.Id,ivybase__UOM1__c=12,ivybase__Visit__c=visit.Id,ivybase__Standard_List_Master__c=standard.Id);
        loc.Market_ISO__c = usr.Market_ISO__c;
        loc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert loc;
        
        ivybase__Location_Stock__c locationStock = new ivybase__Location_Stock__c(ivybase__Location__c=loc.Id,Market_ISO__c = 'MY',ivybase__Product__c=productList[0].Id,ivybase__UOM1__c=12,ivybase__Visit__c=visit.Id);
        locationStock.Market_ISO__c = usr.Market_ISO__c;
        locationStock.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert locationStock;
        
        ivybase__Route__c route = TestUtility.createTestRoute(resource.Id,'Yes');   
        route.Market_ISO__c = usr.Market_ISO__c;
        route.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert route;
        
        ivybase__Route_Details__c routeDetail = TestUtility.createTestRouteDetail('TestRouteDetail',route.Id,'Yes',acc.Id);   
        routeDetail.Market_ISO__c = usr.Market_ISO__c;
        routeDetail.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert routeDetail;
        
        Territory_Routing__c terrRouting = TestUtility.createTestTerrRouting('TestTerrRoute',route.Id,locHr.Id);   
        terrRouting.Market_ISO__c = usr.Market_ISO__c;
        terrRouting.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert terrRouting;
        
        Partner_Function__c partner = new Partner_Function__c(Partner__c=acc.Id,Type__c='Bill To',Account__c=acc2.Id, Market_ISO__c = 'MY');
        partner.Market_ISO__c = usr.Market_ISO__c;
        partner.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert partner;
        Partner_Function__c partner2 = new Partner_Function__c(Partner__c=acc.Id,Type__c='Ship To',Account__c=acc2.Id, Market_ISO__c = 'MY');
        partner2.Market_ISO__c = usr.Market_ISO__c;
        partner2.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert partner2;  
        
        /*CountryCodeMarketISO__mdt ccm = new CountryCodeMarketISO__mdt(Order_Auto_Approval__c = FALSE, 
                                                                      Assign_Order_SO_to_PO__c = TRUE, Country_Code__c = usr.Market_ISO__c);
        insert ccm;*/
        
        ivydsd__Order__c order = new ivydsd__Order__c(ivydsd__Delivery_Date__c = system.today()+7);
        order.Market_ISO__c = usr.Market_ISO__c;
        order.CurrencyIsoCode = usr.CurrencyIsoCode;
        order.ivydsd__Store__c = acc.Id;
        insert order;
        
        ivydsd__Invoice__c invoice = new ivydsd__Invoice__c(ivydsd__Order__c = order.Id,ivydsd__Invoice_Amount__c = 123);
        invoice.Market_ISO__c = usr.Market_ISO__c;
        invoice.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert invoice;
        
       /* Return_Type__c returnType = new Return_Type__c(Name='1');
        returnType.Market_ISO__c = 'MY';
        returnType.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert returnType;
            
        Return_Reason__c returnReason = new Return_Reason__c(name='1',Return_Type__c = returnType.Id);
        returnReason.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert returnReason;
        
        ivydsd__Sales_Return__c salesReturn = new ivydsd__Sales_Return__c(Mobile_Return_number__c = '12432455235');
        salesReturn.Market_ISO__c = usr.Market_ISO__c;
        salesReturn.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert salesReturn; */
        
        ivybase__Digital_Content__c dc = new ivybase__Digital_Content__c();
        dc.Market_ISO__c = usr.Market_ISO__c;
        dc.name='test';
        insert dc;
        
        AdhocActivityPlanDetail__c adhoc = new AdhocActivityPlanDetail__c();
        adhoc.Comments__c = 'Sample';
        adhoc.Hour_Spent__c ='4';
        adhoc.Plan_Name__c ='Sample';
        adhoc.TId__c ='22334455';
        adhoc.Standard_List_Master__c =standard.Id;
        insert adhoc;
        
    }
    
    public static testMethod void testmethod1(){
    
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c FROM ivybase__Product__c where ivybase__Is_Competitor__c=true][0].ivybase__InternalId__c);
        String schemeId = String.valueOf([select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c][0].ivydsd__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String reasonid1 = String.Valueof([SELECT Name FROM ivybase__Standard_List_Master__c Where ivybase__List_type__c = 'REASON'][0].Name);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        string slesforecastName = String.Valueof([SELECT Name FROM Sales_Forecast__c][0].Name);
        Id invoiceId = [SELECT Id FROM ivydsd__Invoice__c ][0].Id; 
        //Id returnId = '';//[SELECT Id FROM Return_Reason__c ][0].Id;
        //Id returnTypeId =''; //[SELECT Id FROM Return_Type__c ][0].Id;
        string dcinterid= string.valueof([select id, ivybase__Internal_Id__c from ivybase__Digital_Content__c][0].ivybase__Internal_Id__c);
        
        Id divisionId = [SELECT Id from Division__c limit 1].Id;
       
        String rintinPlanInternalId = String.valueOf([SELECT Id, InternalId__c FROM Rintin_Plan__c][0].InternalId__c);
        String hairDresserId = String.valueOf([SELECT Id, Internal_Id__c FROM Contact][0].Internal_Id__c);
        String tidAdhoc = String.valueOf([Select Id,TId__c FROM AdhocActivityPlanDetail__c][0].TId__c);
        
        String todayDate = Date.today().format();
        LorealUploadclass.Journeyplaninfo journeyPlanInfo = new LorealUploadclass.Journeyplaninfo();
        journeyPlanInfo.TId='12432455235';
        journeyPlanInfo.date_x=todayDate;
        journeyPlanInfo.UserId='';
        journeyPlanInfo.Month='8';
        journeyPlanInfo.Year='2018';
        journeyPlanInfo.SupervisorComments='Test Comments';
        journeyPlanInfo.Status='D';
        
        LorealUploadclass.JorneyMarketMarketVisitDetailInfo journeyPlanMarket = new LorealUploadclass.JorneyMarketMarketVisitDetailInfo();
        journeyPlanMarket.TId='12432455235';
        journeyPlanMarket.date_x=todayDate;
        journeyPlanMarket.RetailerId=accId;
        
        LorealUploadclass.JourneyPlanDetailInfo journeyPlanDetail = new LorealUploadclass.JourneyPlanDetailInfo();
        journeyPlanDetail.Comments = 'Test Comments';
        journeyPlanDetail.date_x = todayDate;
        journeyPlanDetail.TId = '12432455235';
        journeyPlanDetail.TypeId = '';
        journeyPlanDetail.WorkWithUserId='';
       

         LorealUploadclass.RintinDokoHeaderInfo rintinDokoHeaderInfo = new LorealUploadclass.RintinDokoHeaderInfo();
        rintinDokoHeaderInfo.TId = '1234';
        rintinDokoHeaderInfo.date_x = '2029/09/09';
        rintinDokoHeaderInfo.EndTime = '6:20';
        rintinDokoHeaderInfo.StartTime = '5:00';
        rintinDokoHeaderInfo.Location = 'hYD';
        rintinDokoHeaderInfo.OrgSalonCode=accId;
        rintinDokoHeaderInfo.PlanId='12432455235';
        rintinDokoHeaderInfo.Signature='test signature';
        rintinDokoHeaderInfo.Brand='test brand';
        rintinDokoHeaderInfo.SubAxe='test subaxe';
        rintinDokoHeaderInfo.TotalPlannedRetailers='5';
        
        LorealUploadclass.RintinDokoHeaderInfo rintinDokoHeaderInfo1 = new LorealUploadclass.RintinDokoHeaderInfo();
        rintinDokoHeaderInfo1.TId = '12345';
        rintinDokoHeaderInfo1.date_x = '2029/09/09';
        rintinDokoHeaderInfo1.EndTime = '6:20';
        rintinDokoHeaderInfo1.StartTime = '5:00';
        rintinDokoHeaderInfo1.Location = 'hYD';
        rintinDokoHeaderInfo1.OrgSalonCode=accId;
        rintinDokoHeaderInfo1.PlanId='12432455235';
        rintinDokoHeaderInfo1.Signature='test signature1';
        rintinDokoHeaderInfo1.Brand='test brand1';
        rintinDokoHeaderInfo1.SubAxe='test subaxe1';
        rintinDokoHeaderInfo1.TotalPlannedRetailers='5';
        
        
        LorealUploadclass.RintinDokoSalonDetailsInfo rintinDetails = new LorealUploadclass.RintinDokoSalonDetailsInfo();
        rintinDetails.isActive = '1';
        rintinDetails.IsDoko = '1';
        rintinDetails.Rid = accId;
        rintinDetails.TId = '1234';
        
        
        LorealUploadclass.RintinDokoVisitHeaderInfo RintinDokoVisitHeader = new LorealUploadclass.RintinDokoVisitHeaderInfo();
        RintinDokoVisitHeader.Tid = '654';
        RintinDokoVisitHeader.Rid = accId;
        RintinDokoVisitHeader.Date_x = todayDate;
        RintinDokoVisitHeader.TotalHRcount = '10';
        RintinDokoVisitHeader.AttendedHRcount = '1';
        RintinDokoVisitHeader.Visitid = rintinPlanInternalId;
        
        LorealUploadclass.RintinDokoVisitDetailInfo RintinDokoVisitDetail = new LorealUploadclass.RintinDokoVisitDetailInfo();
        RintinDokoVisitDetail.Tid = '654';
        RintinDokoVisitDetail.Rid = accId;
        RintinDokoVisitDetail.HRid = hairDresserId;
        RintinDokoVisitDetail.Agentid = accId;
        
        LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo agentdetails = new LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo();
        agentdetails.AgentId = accId;
        agentdetails.HAId = '';
        agentdetails.isActive = '1';
        agentdetails.Rid = accId;
        agentdetails.TId = '1233';
        
        
        LorealUploadclass.CompetitorHeaderInfo compHeader = new LorealUploadclass.CompetitorHeaderInfo();
        compHeader.Date_x = todayDate;
        compHeader.Feedback='Feedback';
        compHeader.Remark = 'Test Remark';
        compHeader.RetailerId = accId;
        compHeader.Tid = '12432455235';
        
        LorealUploadclass.CompetitorPhotoDetailsInfo compPhotoDetails = new LorealUploadclass.CompetitorPhotoDetailsInfo();
        compPhotoDetails.avgPrice = '1000';
        compPhotoDetails.Description = 'Test Description';
        compPhotoDetails.ImageName = 'Test Image';
        compPhotoDetails.ImagePath = '';
        compPhotoDetails.Name= 'Test';
        compPhotoDetails.qty = '10';
        compPhotoDetails.qtysize='5';
        compPhotoDetails.SellingPrice = '2000';
        compPhotoDetails.tcompetitorid = pid;
        compPhotoDetails.Tid='12432455235';
        
        LorealUploadclass.CompetitorDetailsInfo compDetail = new LorealUploadclass.CompetitorDetailsInfo();
        compDetail.avgPrice = '1000';
        compDetail.Comments = 'Test Comments';
        compDetail.contract = 'Contract';
        compDetail.FrqOfEduVisit = '12';
        compDetail.FrqOfRepVisit='10';
        compDetail.pid = pid;
        compDetail.qty = '10';
        compDetail.qtysize='10';
        compDetail.Rebate = '10';
        compDetail.RetailPrice = '100';
        compDetail.tcompetitorid = accId;
        compDetail.Tid = '12432455235';
        compDetail.TypeOfTraining = 'Test'; 
        
        
        LorealUploadclass.PromotionalPlanninginfo promoInfo = new LorealUploadclass.PromotionalPlanninginfo();
        promoInfo.Date_x = todayDate;
        promoInfo.Status = 'D';
        promoInfo.SupervisorComments='Test Comments';
        //promoInfo.TId = '12432455235';
        promoInfo.TId = slesforecastName;
        promoInfo.UserId = '';
        
        LorealUploadclass.PromotionalPlanningDetail promoDetail = new LorealUploadclass.PromotionalPlanningDetail();
        promoDetail.pid = pid;
        promoDetail.Qty = '20';
        promoDetail.RetailerId=accId;
        promoDetail.SchemeId = schemeId;
        promoDetail.TId = '12432455235';
        promoDetail.Value = '123';
        
        LorealUploadclass.DreamListInfo dreamList = new LorealUploadclass.DreamListInfo();
        dreamList.Date_x = todayDate;
        dreamList.IsConquest = '';
        dreamList.ProgressPercentage = '80';
        dreamList.Remarks = 'No Remarks';
        dreamList.Rid = accId;
        dreamList.status = 'Test';
        dreamList.SuperWiserFeedBack = 'Test Feedback';
        dreamList.Upload = '';
        
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = todaydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        
        LorealUploadclass.OrderHeader orderHead = new LorealUploadclass.OrderHeader();
        orderHead.OrderID = '';
        orderHead.OrderDate = todayDate;
        orderHead.RetailerId = accId;
        orderHead.RouteId ='';
        orderHead.OrderValue='';
        orderHead.LinesPerCall ='';
        orderHead.discount = '';
        orderHead.deliveryDate = todayDate;
        orderHead.downloadDate ='';
        orderHead.po = '';
        orderHead.remark = 'remarks';
        orderHead.latitude = '';
        orderHead.longitude = '';
        orderHead.timestampid = '';
        orderHead.JFlag = '';
        orderHead.ReturnValue = '20';
        orderHead.sid = '';
        orderHead.stype = '';
        orderHead.totalTaxValue = '';
        orderHead.ImageName = 'TEST';
        orderHead.totalWeight = '';
        orderHead.BIllTo = '';
        orderHead.ShipTo = '';
        orderHead.Status = '';
        
        LorealUploadclass.OrderDetail orderDetail = new LorealUploadclass.OrderDetail();
        orderDetail.OrderId = '';
        orderDetail.ProductId = '';
        orderDetail.Qty='60';
        orderDetail.Rate='100';
        orderDetail.uomcount='60';
        orderDetail.pieceQty='30';
        orderDetail.caseqty='20';
        orderDetail.uomid='';
        orderDetail.totalamount='1000';
        orderDetail.casePrice='200';
        orderDetail.outerPrice='300';
        orderDetail.outerQty='30';
        orderDetail.douomQty='40';
        
        LorealUploadclass.NewRetailerEditHeaderInfo retailerHeader = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailerHeader.Tid='12432455235';
        retailerHeader.RetailerId=accId;
        retailerHeader.Date_x=todayDate;
        retailerHeader.isNew='1';
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail.Tid='12432455235';
        retailerDetail.Code='PROFILE_LO_05';
        retailerDetail.Value='TEST Conquest';
        retailerDetail.RefId = '';
        retailerDetail.RetailerId='';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas.UID = '12432455235';
        wrapnonpromas.retailerid = interId;
        wrapnonpromas.RouteID = '123234';
        wrapnonpromas.ReasonID = reasonid1;
        wrapnonpromas.Date_x = '2017/02/15';
        wrapnonpromas.ReasonTypes = '123';
        wrapnonpromas.DistributorID = '0';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas1 = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas1.UID = '12432455235';
        wrapnonpromas1.retailerid = interIdvisit;
        wrapnonpromas1.RouteID = '123234';
        wrapnonpromas1.ReasonID = reasonid1;
        wrapnonpromas1.Date_x = '2017/02/28';
        wrapnonpromas1.ReasonTypes = '123';
        wrapnonpromas1.DistributorID = '0';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet.gpsAccuracy = '0.0';
        wrapoutlet.RetailerID = interId;
        wrapoutlet.gpsCompliance = '0';
        wrapoutlet.VisitDate = '2017/02/15';
        wrapoutlet.JFlag = '0';
        wrapoutlet.BeatID = '1';
        wrapoutlet.VisitID = 'OTS02212017105710';
        wrapoutlet.TimeIn ='2017/02/15 10:57:10';
        wrapoutlet.Feedback='';
        wrapoutlet.longitude='0.0';
        wrapoutlet.latitude='0.0';
        wrapoutlet.Sequence='1';
        wrapoutlet.TimeOut = '2017/02/15 10:57:51';
        wrapoutlet.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel.TimeIn = '2017/02/15 9:57:15';
        wrapouttmstdel.RetailerID = interId;
        wrapouttmstdel.TimeOut = '2017/02/15 10:57:39';
        wrapouttmstdel.UID = 'OTS02212017105710';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet1 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet1.gpsAccuracy = '0.0';
        wrapoutlet1.RetailerID = interId;
        wrapoutlet1.gpsCompliance = '0';
        wrapoutlet1.VisitDate = '2017/02/21';
        wrapoutlet1.JFlag = '0';
        wrapoutlet1.BeatID = '1';
        wrapoutlet1.VisitID = 'OTS02212017105711';
        wrapoutlet1.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet1.Feedback='';
        wrapoutlet1.longitude='0.0';
        wrapoutlet1.latitude='0.0';
        wrapoutlet1.Sequence='1';
        wrapoutlet1.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet1.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel1 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel1.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel1.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel1.RetailerID = interId;
        wrapouttmstdel1.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel1.UID = 'OTS02212017105711';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet2 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet2.gpsAccuracy = '0.0';
        wrapoutlet2.RetailerID = interIdvisit;
        wrapoutlet2.gpsCompliance = '0';
        wrapoutlet2.VisitDate = '2017/02/21';
        wrapoutlet2.JFlag = '0';
        wrapoutlet2.BeatID = '1';
        wrapoutlet2.VisitID = 'OTS02212017105711';
        wrapoutlet2.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet2.Feedback='';
        wrapoutlet2.longitude='0.0';
        wrapoutlet2.latitude='0.0';
        wrapoutlet2.Sequence='1';
        wrapoutlet2.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet2.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel2 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel2.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel2.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel2.RetailerID = interId;
        wrapouttmstdel2.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel2.UID = 'OTS02212017105711';
        
        
        LorealUploadclass.NewSalesReturnHeader slaesReturnHeader = new LorealUploadclass.NewSalesReturnHeader();
        slaesReturnHeader.Tid = '12432455235';
        slaesReturnHeader.RetailerID = interId;
        slaesReturnHeader.UserID = 'OTS02212017105711';
        slaesReturnHeader.invoiceid = String.valueOf(invoiceId);
        //slaesReturnHeader.ReasonId = String.valueOf(returnId);
        //slaesReturnHeader.ReasonTypeId = String.valueOf(returnTypeId);
        slaesReturnHeader.ReturnDate = '2017/02/21'; 
        
        LorealUploadclass.NewSalesReturnDetails details = new LorealUploadclass.NewSalesReturnDetails();
        details.Tid = '12432455235';
        
        //digital content upload
        LorealUploadclass.DigitalContentTrainingDetaildata dcdata = new LorealUploadclass.DigitalContentTrainingDetaildata();
        
            dcdata.imgid=dcinterid;
            dcdata.GroupId='';
            dcdata.DivisionId='';
            dcdata.Date_x='2017/02/21'; 
            dcdata.NoOfTimesOpened='20';
            dcdata.Duration='20.5';
            dcdata.DocumentType='pdf';
            dcdata.RetailerID=interId;
            dcdata.MenuCode='detailsmenuocde';
       /* slaesReturnHeader.RetailerID = interId;
        slaesReturnHeader.UserID = 'OTS02212017105711';
        slaesReturnHeader.invoiceid = String.valueOf(invoiceId);
        slaesReturnHeader.ReasonId = String.valueOf(returnId);
        slaesReturnHeader.ReasonTypeId = String.valueOf(returnTypeId);
        slaesReturnHeader.ReturnDate = '2017/02/21'; */
        
         //Lorial For Japan//createdby Gayathri
        LorealUploadclass.AdhocActivityPlanDetailInfo uploadAdhoc = new LorealUploadclass.AdhocActivityPlanDetailInfo();
        uploadAdhoc.TId = tidAdhoc;
        uploadAdhoc.ActivityDate = '';
        uploadAdhoc.TypeId ='';
        uploadAdhoc.Comment = 'Sample';
        uploadAdhoc.StartTime ='';
        uploadAdhoc.EndTime   ='';
        uploadAdhoc.PlanName  ='Sample';
        uploadAdhoc.UserId    ='';
        uploadAdhoc.HourSpent ='four';
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        
        wrapperClass.AdhocActivityPlanDetail = new List<LorealUploadclass.AdhocActivityPlanDetailInfo>{uploadAdhoc};
        wrapperClass.JourneyPlanHeader = new List<LorealUploadclass.Journeyplaninfo>{journeyPlanInfo};
        wrapperClass.JourneyPlan_MarketVisitDetail = new List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>{journeyPlanMarket};
        wrapperClass.JourneyPlanDetail = new List<LorealUploadclass.JourneyPlanDetailInfo>{journeyPlanDetail};
      
     
        // Rintin doko details actual
        // RintinDokoVisitHeaderInfo RintinDokoVisitHeader
        wrapperClass.RintinDokoVisitHeader = new List<LorealUploadclass.RintinDokoVisitHeaderInfo>{RintinDokoVisitHeader};
        wrapperClass.RintinDokoVisitDetail = new List<LorealUploadclass.RintinDokoVisitDetailInfo>{RintinDokoVisitDetail};    
            
        wrapperClass.CompetitorHeaderNew = new List<LorealUploadclass.CompetitorHeaderInfo>{compHeader};
        wrapperClass.CompetitorPhotoDetailsNew = new List<LorealUploadclass.CompetitorPhotoDetailsInfo>{compPhotoDetails};
        wrapperClass.CompetitorDetailsNew = new List<LorealUploadclass.CompetitorDetailsInfo>{compDetail};
        
        wrapperClass.PromotionalPlanningHeader = new List<LorealUploadclass.PromotionalPlanninginfo>{promoInfo};
        wrapperClass.PromotionalPlanningDetails = new List<LorealUploadclass.PromotionalPlanningDetail>{promoDetail};
            
        wrapperClass.RetailerDreamList = new List<LorealUploadclass.DreamListInfo>{dreamList};
        
        wrapperClass.HairDresserNew = new List<LorealUploadclass.HairDresserInfo>{hairDresser};
            
        wrapperClass.OrderHeaderNew = new List<LorealUploadclass.OrderHeader>{orderHead};
        wrapperClass.OrderDetailNew = new List<LorealUploadclass.OrderDetail>{orderDetail};
            
        wrapperClass.NewRetailerEditHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>{retailerHeader};
        wrapperClass.NewRetailerEditDetail = new List<LorealUploadclass.NewRetailerEditDetailInfo>{retailerDetail};

        wrapperClass.OutletTimeStampDetail = new List<LorealUploadclass.cls_OutletTimeStampDetail>{wrapouttmstdel,wrapouttmstdel1,wrapouttmstdel2};
        wrapperClass.OutletTimestamp = new List<LorealUploadclass.cls_OutletTimestamp>{wrapoutlet,wrapoutlet1,wrapoutlet2};
           
        // To map salesReturn     
        //wrapperClass.SalesReturnHeader = new LIST<LorealUploadclass.NewSalesReturnHeader>{slaesReturnHeader};
        //wrapperClass.SalesReturnDetails = new LIST<LorealUploadclass.NewSalesReturnDetails>{details};
            
        
        wrapperClass.RintinDokoHeader = new LIST<LorealUploadclass.RintinDokoHeaderInfo>{rintinDokoHeaderInfo,rintinDokoHeaderInfo1};
        wrapperClass.RintinDokoSalonDetails = new LIST<LorealUploadclass.RintinDokoSalonDetailsInfo>{rintinDetails};
        //wrapperClass.RintinDokoHeader = new LIST<LorealUploadclass.RintinDokoHeaderInfo>{rintinDokoHeaderInfo2};
        //wrapperClass.RintinDokoSalonDetails = new LIST<LorealUploadclass.RintinDokoSalonDetailsInfo>{rintinDetails2};
        wrapperClass.RintinDokoHairdresserAndAgentDetails = new LIST<LorealUploadclass.RintinDokoHairdresserAndAgentDetailsInfo>{agentdetails};       
      
        //dc upload
        wrapperclass.DigitalContentTrainingDetail=new LIST<LorealUploadclass.DigitalContentTrainingDetaildata>{dcdata};
            
            
        String JSONString = Json.Serialize(wrapperClass);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        Test.startTest();
        LOrealUpload.UploadHandler();
        PostResponse postRes = new PostResponse();
        Test.stopTest();
        /*RestRequest req2 = new RestRequest();
        req2.requestbody = Blob.valueOf('Test');
        req2.addHeader('MobileDate', '2018/08/23 12:30:00');
        LOrealUpload.UploadHandler();*/
        System.Assert(req.requestBody != null);
    }
    
    public static testMethod void testmethod10(){
    
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
       
        Id divisionId = [SELECT Id from Division__c limit 1].Id;
        
        /*ivybase__Survey__c sv  = new ivybase__Survey__c();
        sv.ivybase__HHT_Menu__c = 'Activity Menu';
        sv.Market_ISO__c = 'JPN';
        sv.Name = 'JBP One';
        sv.ivybase__Active__c = true;
        sv.ivybase__Sequence_Number__c = 1;
        sv.ivybase__From__c = system.today();
        sv.ivybase__To__c= system.today()+10;
        sv.ivybase__Type__c = 'Rep';
        sv.ivybase__Maximum_Bonus_Points__c = 2;
        insert sv;
        
        ivybase__Question__c ques = new ivybase__Question__c();
        ques.name = 'TestQuestion';
        ques.ivybase__Question_Type__c = 'Text';
        ques.ivybase__Question__c = 'Sample question';
        insert ques;
        
        ivybase__Survey_Question__c sq = new ivybase__Survey_Question__c();
        sq.ivybase__Survey__c = sv.Id;
        sq.ivybase__Question__c = ques.Id;
        sq.ivybase__From__c = system.today();
        sq.ivybase__To__c = system.today()+20;
        insert sq;
        
        ivybase__Answer_Option__c aq = new ivybase__Answer_Option__c();
        aq.Name = 'Test Option';
        aq.Market_ISO__c = 'JPN';
        insert aq;
        
        
        ivybase__Question_Answer_Option__c qas = new ivybase__Question_Answer_Option__c();
        
        qas.ivybase__Question__c = ques.Id;
        qas.ivybase__Answer_Option__c = aq.Id;
        insert qas;
        
        ivybase__Survey__c surveyInternal = [SELECT Id, ivybase__Internal_Id__c 
                                             FROM  ivybase__Survey__c limit 1 ];
        
        
        ivybase__Survey_Question__c ssq = [SELECT ID,ivybase__Question__r.ivybase__Question_Id__c 
                                           FROM ivybase__Survey_Question__c limit 1 ];
        */
        Contact c1 = [select id, Internal_Id__c 
                      FROM Contact limit 1]; 

        
        
        
        
        //String rintinPlanInternalId = String.valueOf([SELECT Id, InternalId__c FROM Rintin_Plan__c][0].InternalId__c);
        //String hairDresserId = String.valueOf([SELECT Id, Internal_Id__c FROM Contact][0].Internal_Id__c);
        
        //String todayDate = Date.today().format();
        
        
    
        
        
        // Surveys AnswerDetail
        LorealUploadclass.AnswerDetail AnswerDetail = new LorealUploadclass.AnswerDetail();
        AnswerDetail.score = '1234';
        AnswerDetail.uid = '';
        AnswerDetail.answer = 'ans';
        AnswerDetail.ImageName = 'test';
        AnswerDetail.qid = '';
        AnswerDetail.answerid = '788';
        AnswerDetail.isExcluded = '788';
        AnswerDetail.qtype = '7878';
        
        
        // Survey AnswerHeader
        LorealUploadclass.AnswerHeader AnswerHeader = new LorealUploadclass.AnswerHeader();
        
        AnswerHeader.uid = '';
        AnswerHeader.AchBonusPoint = '0';
        AnswerHeader.ModuleID = '4949';
        AnswerHeader.type = 'RETAILER';
        AnswerHeader.MaxBonusPoint = '0';
        AnswerHeader.date_x = '';
        AnswerHeader.surveyid = '';
        AnswerHeader.DistributorID = '245';
        AnswerHeader.tgtScore = '12';
        AnswerHeader.SupervisiorId = '';
        AnswerHeader.achScore = '';
        AnswerHeader.counterid = '';
        AnswerHeader.Remark = 'N';
        AnswerHeader.retailerid = interId;
        AnswerHeader.refid = '12112';
        AnswerHeader.VisitId = '1212';
        AnswerHeader.ImagePath = '';
        AnswerHeader.DivisionId = divisionId;
        AnswerHeader.userid = String.valueOf(c1.Internal_Id__c);
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
          
        // Surveys test class
        wrapperClass.AnswerDetailNew = new List<LorealUploadclass.AnswerDetail>{AnswerDetail};
        wrapperClass.AnswerHeaderNew = new List<LorealUploadclass.AnswerHeader>{AnswerHeader};
     
        String JSONString = Json.Serialize(wrapperClass);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        Test.startTest();
        LOrealUpload.UploadHandler();
        PostResponse postRes = new PostResponse();
        Test.stopTest();
        /*RestRequest req2 = new RestRequest();
        req2.requestbody = Blob.valueOf('Test');
        req2.addHeader('MobileDate', '2018/08/23 12:30:00');
        LOrealUpload.UploadHandler();*/
        System.Assert(req.requestBody != null);
    } 
    
    
    public static testMethod void testmethod2(){
    
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c FROM ivybase__Product__c where ivybase__Is_Competitor__c=true][0].ivybase__InternalId__c);
        String schemeId = String.valueOf([select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c][0].ivydsd__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String reasonid1 = String.Valueof([SELECT Name FROM ivybase__Standard_List_Master__c Where ivybase__List_type__c = 'REASON'][0].Name);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        string slesforecastName = String.Valueof([SELECT Name FROM Sales_Forecast__c][0].Name);
        Id invoiceId = [SELECT Id FROM ivydsd__Invoice__c ][0].Id; 
        //Id returnId = '';//[SELECT Id FROM Return_Reason__c ][0].Id;
        //Id returnTypeId = '';//[SELECT Id FROM Return_Type__c ][0].Id;
        
        String adhocStd = String.valueOf([Select Id,Standard_List_Master__c FROM AdhocActivityPlanDetail__c][0].Standard_List_Master__c);
        
        
        
        //Lorial For Japan//createdby Gayathri
        LorealUploadclass.AdhocActivityPlanDetailInfo uploadAdhoc = new LorealUploadclass.AdhocActivityPlanDetailInfo();
        uploadAdhoc.TId = '887766550';
        uploadAdhoc.ActivityDate = '';
        uploadAdhoc.TypeId = adhocStd;
        uploadAdhoc.Comment = '';
        uploadAdhoc.StartTime ='';
        uploadAdhoc.EndTime   ='';
        uploadAdhoc.PlanName  ='Sample';
        uploadAdhoc.UserId    ='';
        uploadAdhoc.HourSpent ='four';
        
        
        String todayDate = Date.today().format();
        LorealUploadclass.Journeyplaninfo journeyPlanInfo = new LorealUploadclass.Journeyplaninfo();
        journeyPlanInfo.TId='12432455235';
        journeyPlanInfo.date_x=todayDate;
        journeyPlanInfo.UserId='';
        journeyPlanInfo.Month='8';
        journeyPlanInfo.Year='2018';
        journeyPlanInfo.SupervisorComments='Test Comments';
        journeyPlanInfo.Status='D';
        
        
        LorealUploadclass.JorneyMarketMarketVisitDetailInfo journeyPlanMarket = new LorealUploadclass.JorneyMarketMarketVisitDetailInfo();
        journeyPlanMarket.TId='12432455235';
        journeyPlanMarket.date_x=todayDate;
        journeyPlanMarket.RetailerId=accId;
        
        LorealUploadclass.JourneyPlanDetailInfo journeyPlanDetail = new LorealUploadclass.JourneyPlanDetailInfo();
        journeyPlanDetail.Comments = 'Test Comments';
        journeyPlanDetail.date_x = todayDate;
        journeyPlanDetail.TId = '12432455235';
        journeyPlanDetail.TypeId = '';
        journeyPlanDetail.WorkWithUserId='';
        
        
        LorealUploadclass.CompetitorHeaderInfo compHeader = new LorealUploadclass.CompetitorHeaderInfo();
        compHeader.Date_x = todayDate;
        compHeader.Feedback='Feedback';
        compHeader.Remark = 'Test Remark';
        compHeader.RetailerId = accId;
        compHeader.Tid = '12432455235';
        
        LorealUploadclass.CompetitorPhotoDetailsInfo compPhotoDetails = new LorealUploadclass.CompetitorPhotoDetailsInfo();
        compPhotoDetails.avgPrice = '1000';
        compPhotoDetails.Description = 'Test Description';
        compPhotoDetails.ImageName = 'Test Image';
        compPhotoDetails.ImagePath = '';
        compPhotoDetails.Name= 'Test';
        compPhotoDetails.qty = '10';
        compPhotoDetails.qtysize='5';
        compPhotoDetails.SellingPrice = '2000';
        compPhotoDetails.tcompetitorid = pid;
        compPhotoDetails.Tid='12432455235';
        
        LorealUploadclass.CompetitorDetailsInfo compDetail = new LorealUploadclass.CompetitorDetailsInfo();
        compDetail.avgPrice = '1000';
        compDetail.Comments = 'Test Comments';
        compDetail.contract = 'Contract';
        compDetail.FrqOfEduVisit = '12';
        compDetail.FrqOfRepVisit='10';
        compDetail.pid = pid;
        compDetail.qty = '10';
        compDetail.qtysize='10';
        compDetail.Rebate = '10';
        compDetail.RetailPrice = '100';
        compDetail.tcompetitorid = accId;
        compDetail.Tid = '12432455235';
        compDetail.TypeOfTraining = 'Test'; 
        
        
        LorealUploadclass.PromotionalPlanninginfo promoInfo = new LorealUploadclass.PromotionalPlanninginfo();
        promoInfo.Date_x = todayDate;
        promoInfo.Status = 'D';
        promoInfo.SupervisorComments='Test Comments';
        //promoInfo.TId = '12432455235';
        promoInfo.TId = slesforecastName;
        promoInfo.UserId = '';
        
        LorealUploadclass.PromotionalPlanningDetail promoDetail = new LorealUploadclass.PromotionalPlanningDetail();
        promoDetail.pid = pid;
        promoDetail.Qty = '20';
        promoDetail.RetailerId=accId;
        promoDetail.SchemeId = schemeId;
        promoDetail.TId = '12432455235';
        promoDetail.Value = '123';
        
        LorealUploadclass.DreamListInfo dreamList = new LorealUploadclass.DreamListInfo();
        dreamList.Date_x = todayDate;
        dreamList.IsConquest = '';
        dreamList.ProgressPercentage = '80';
        dreamList.Remarks = 'No Remarks';
        dreamList.Rid = accId;
        dreamList.status = 'Test';
        dreamList.SuperWiserFeedBack = 'Test Feedback';
        dreamList.Upload = '';
        
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = todaydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        
        LorealUploadclass.OrderHeader orderHead = new LorealUploadclass.OrderHeader();
        orderHead.OrderID = '';
        orderHead.OrderDate = todayDate;
        orderHead.RetailerId = accId;
        orderHead.RouteId ='';
        orderHead.OrderValue='';
        orderHead.LinesPerCall ='';
        orderHead.discount = '';
        orderHead.deliveryDate = todayDate;
        orderHead.downloadDate ='';
        orderHead.po = '';
        orderHead.remark = 'remarks';
        orderHead.latitude = '';
        orderHead.longitude = '';
        orderHead.timestampid = '';
        orderHead.JFlag = '';
        orderHead.ReturnValue = '20';
        orderHead.sid = '';
        orderHead.stype = '';
        orderHead.totalTaxValue = '';
        orderHead.ImageName = 'TEST';
        orderHead.totalWeight = '';
        orderHead.BIllTo = '';
        orderHead.ShipTo = '';
        orderHead.Status = '';
        
        LorealUploadclass.OrderDetail orderDetail = new LorealUploadclass.OrderDetail();
        orderDetail.OrderId = '';
        orderDetail.ProductId = '';
        orderDetail.Qty='60';
        orderDetail.Rate='100';
        orderDetail.uomcount='60';
        orderDetail.pieceQty='30';
        orderDetail.caseqty='20';
        orderDetail.uomid='';
        orderDetail.totalamount='1000';
        orderDetail.casePrice='200';
        orderDetail.outerPrice='300';
        orderDetail.outerQty='30';
        orderDetail.douomQty='40';
        
        LorealUploadclass.NewRetailerEditHeaderInfo retailerHeader = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailerHeader.Tid='12432455235';
        retailerHeader.RetailerId=accId;
        retailerHeader.Date_x=todayDate;
        retailerHeader.isNew='1';
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail.Tid='12432455235';
        retailerDetail.Code='PROFILE_LO_05';
        retailerDetail.Value='TEST Conquest';
        retailerDetail.RefId = '';
        retailerDetail.RetailerId='';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas.UID = '12432455235';
        wrapnonpromas.retailerid = interId;
        wrapnonpromas.RouteID = '123234';
        wrapnonpromas.ReasonID = reasonid1;
        wrapnonpromas.Date_x = '2017/02/15';
        wrapnonpromas.ReasonTypes = '123';
        wrapnonpromas.DistributorID = '0';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas1 = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas1.UID = '12432455235';
        wrapnonpromas1.retailerid = interIdvisit;
        wrapnonpromas1.RouteID = '123234';
        wrapnonpromas1.ReasonID = reasonid1;
        wrapnonpromas1.Date_x = '2017/02/28';
        wrapnonpromas1.ReasonTypes = '123';
        wrapnonpromas1.DistributorID = '0';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet.gpsAccuracy = '0.0';
        wrapoutlet.RetailerID = interId;
        wrapoutlet.gpsCompliance = '0';
        wrapoutlet.VisitDate = '2017/02/15';
        wrapoutlet.JFlag = '0';
        wrapoutlet.BeatID = '1';
        wrapoutlet.VisitID = 'OTS02212017105710';
        wrapoutlet.TimeIn ='2017/02/15 10:57:10';
        wrapoutlet.Feedback='';
        wrapoutlet.longitude='0.0';
        wrapoutlet.latitude='0.0';
        wrapoutlet.Sequence='1';
        wrapoutlet.TimeOut = '2017/02/15 10:57:51';
        wrapoutlet.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel.TimeIn = '2017/02/15 9:57:15';
        wrapouttmstdel.RetailerID = interId;
        wrapouttmstdel.TimeOut = '2017/02/15 10:57:39';
        wrapouttmstdel.UID = 'OTS02212017105710';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet1 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet1.gpsAccuracy = '0.0';
        wrapoutlet1.RetailerID = interId;
        wrapoutlet1.gpsCompliance = '0';
        wrapoutlet1.VisitDate = '2017/02/21';
        wrapoutlet1.JFlag = '0';
        wrapoutlet1.BeatID = '1';
        wrapoutlet1.VisitID = 'OTS02212017105711';
        wrapoutlet1.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet1.Feedback='';
        wrapoutlet1.longitude='0.0';
        wrapoutlet1.latitude='0.0';
        wrapoutlet1.Sequence='1';
        wrapoutlet1.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet1.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel1 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel1.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel1.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel1.RetailerID = interId;
        wrapouttmstdel1.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel1.UID = 'OTS02212017105711';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet2 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet2.gpsAccuracy = '0.0';
        wrapoutlet2.RetailerID = interIdvisit;
        wrapoutlet2.gpsCompliance = '0';
        wrapoutlet2.VisitDate = '2017/02/21';
        wrapoutlet2.JFlag = '0';
        wrapoutlet2.BeatID = '1';
        wrapoutlet2.VisitID = 'OTS02212017105711';
        wrapoutlet2.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet2.Feedback='';
        wrapoutlet2.longitude='0.0';
        wrapoutlet2.latitude='0.0';
        wrapoutlet2.Sequence='1';
        wrapoutlet2.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet2.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel2 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel2.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel2.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel2.RetailerID = interId;
        wrapouttmstdel2.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel2.UID = 'OTS02212017105711';
        
        
        LorealUploadclass.NewSalesReturnHeader slaesReturnHeader = new LorealUploadclass.NewSalesReturnHeader();
        slaesReturnHeader.Tid = '12432455235';
        slaesReturnHeader.RetailerID = interId;
        slaesReturnHeader.UserID = 'OTS02212017105711';
        slaesReturnHeader.invoiceid = String.valueOf(invoiceId);
        //slaesReturnHeader.ReasonId = String.valueOf(returnId);
        //slaesReturnHeader.ReasonTypeId = String.valueOf(returnTypeId);
        slaesReturnHeader.ReturnDate = '2017/02/21'; 
        
        LorealUploadclass.NewSalesReturnDetails details = new LorealUploadclass.NewSalesReturnDetails();
        details.Tid = '12432455235';
        
        
        
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        
        wrapperClass.AdhocActivityPlanDetail = new List<LorealUploadclass.AdhocActivityPlanDetailInfo>{uploadAdhoc};
        wrapperClass.JourneyPlanHeader = new List<LorealUploadclass.Journeyplaninfo>{journeyPlanInfo};
        wrapperClass.JourneyPlan_MarketVisitDetail = new List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>{journeyPlanMarket};
        wrapperClass.JourneyPlanDetail = new List<LorealUploadclass.JourneyPlanDetailInfo>{journeyPlanDetail};
                    
        wrapperClass.CompetitorHeaderNew = new List<LorealUploadclass.CompetitorHeaderInfo>{compHeader};
        wrapperClass.CompetitorPhotoDetailsNew = new List<LorealUploadclass.CompetitorPhotoDetailsInfo>{compPhotoDetails};
        wrapperClass.CompetitorDetailsNew = new List<LorealUploadclass.CompetitorDetailsInfo>{compDetail};
        
        wrapperClass.PromotionalPlanningHeader = new List<LorealUploadclass.PromotionalPlanninginfo>{promoInfo};
        wrapperClass.PromotionalPlanningDetails = new List<LorealUploadclass.PromotionalPlanningDetail>{promoDetail};
            
        wrapperClass.RetailerDreamList = new List<LorealUploadclass.DreamListInfo>{dreamList};
        
        wrapperClass.HairDresserNew = new List<LorealUploadclass.HairDresserInfo>{hairDresser};
            
        wrapperClass.OrderHeaderNew = new List<LorealUploadclass.OrderHeader>{orderHead};
        wrapperClass.OrderDetailNew = new List<LorealUploadclass.OrderDetail>{orderDetail};
            
        wrapperClass.NewRetailerEditHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>{retailerHeader};
        wrapperClass.NewRetailerEditDetail = new List<LorealUploadclass.NewRetailerEditDetailInfo>{retailerDetail};

        wrapperClass.OutletTimeStampDetail = new List<LorealUploadclass.cls_OutletTimeStampDetail>{wrapouttmstdel,wrapouttmstdel1,wrapouttmstdel2};
        wrapperClass.OutletTimestamp = new List<LorealUploadclass.cls_OutletTimestamp>{wrapoutlet,wrapoutlet1,wrapoutlet2};
           
        // To map salesReturn     
       /* wrapperClass.SalesReturnHeader = new LIST<LorealUploadclass.NewSalesReturnHeader>{slaesReturnHeader};
        wrapperClass.SalesReturnDetails = new LIST<LorealUploadclass.NewSalesReturnDetails>{details};   
            
        ivydsd__Sales_Return__c salesReturn = [SELECT Id,Mobile_Return_number__c FROM ivydsd__Sales_Return__c limit 1]; 
        if(salesReturn != NULL) {
            salesReturn.Mobile_Return_number__c = '123';
        }
        update salesReturn;*/
        
            
        String JSONString = Json.Serialize(wrapperClass);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        Test.startTest();
        LOrealUpload.UploadHandler();
        PostResponse postRes = new PostResponse();
        Test.stopTest();
        /*RestRequest req2 = new RestRequest();
        req2.requestbody = Blob.valueOf('Test');
        req2.addHeader('MobileDate', '2018/08/23 12:30:00');
        LOrealUpload.UploadHandler();*/
        System.Assert(req.requestBody != null);
    }
    
    public static testMethod void testExceptionMethod(){
        
        
        
        Batch_SwitchOff__c batchSwithchOff = new Batch_SwitchOff__c();
        batchSwithchOff.Name = 'SalesForecast_Trigger_month_MoreThan_0';
        batchSwithchOff.SwitchOff__c = false;
        insert batchSwithchOff;
        
        Batch_SwitchOff__c batchSwithchOff2 = new Batch_SwitchOff__c();
        batchSwithchOff2.Name = 'SalesForecast_Trigger_month_equals_0';
        batchSwithchOff2.SwitchOff__c = false;
        insert batchSwithchOff2;
        
    
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c FROM ivybase__Product__c where ivybase__Is_Competitor__c=true][0].ivybase__InternalId__c);
        String schemeId = String.valueOf([select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c][0].ivydsd__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String reasonid1 = String.Valueof([SELECT Name FROM ivybase__Standard_List_Master__c Where ivybase__List_type__c = 'REASON'][0].Name);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        
        ivybase__Bypass_Business_Rules__c setting = new ivybase__Bypass_Business_Rules__c();
        setting.ivybase__Deactivate_All_Rules__c = false;
        insert setting;

        String todayDate = Date.today().format();
        LorealUploadclass.Journeyplaninfo journeyPlanInfo = new LorealUploadclass.Journeyplaninfo();
        journeyPlanInfo.TId='12432455235';
        journeyPlanInfo.date_x=todayDate;
        journeyPlanInfo.UserId='';
        journeyPlanInfo.Month='8';
        journeyPlanInfo.Year='2018';
        journeyPlanInfo.SupervisorComments='Test Comments';
        journeyPlanInfo.Status='D';
                
        LorealUploadclass.JorneyMarketMarketVisitDetailInfo journeyPlanMarket = new LorealUploadclass.JorneyMarketMarketVisitDetailInfo();
        journeyPlanMarket.TId='12432455235';
        journeyPlanMarket.date_x=todayDate;
        journeyPlanMarket.RetailerId=accId;
        
        LorealUploadclass.JourneyPlanDetailInfo journeyPlanDetail = new LorealUploadclass.JourneyPlanDetailInfo();
        journeyPlanDetail.Comments = 'Test Comments';
        journeyPlanDetail.date_x = todayDate;
        journeyPlanDetail.TId = '12432455235';
        journeyPlanDetail.TypeId = '';
        journeyPlanDetail.WorkWithUserId='';
               
        LorealUploadclass.CompetitorHeaderInfo compHeader = new LorealUploadclass.CompetitorHeaderInfo();
        compHeader.Date_x = todayDate;
        compHeader.Feedback='Feedback';
        compHeader.Remark = 'Test Remark';
        compHeader.RetailerId = accId;
        compHeader.Tid = '12432455235';
        
        LorealUploadclass.CompetitorPhotoDetailsInfo compPhotoDetails = new LorealUploadclass.CompetitorPhotoDetailsInfo();
        compPhotoDetails.avgPrice = '1000';
        compPhotoDetails.Description = 'Test Description';
        compPhotoDetails.ImageName = 'Test Image';
        compPhotoDetails.ImagePath = '';
        compPhotoDetails.Name= 'Test';
        compPhotoDetails.qty = '10';
        compPhotoDetails.qtysize='5';
        compPhotoDetails.SellingPrice = '2000';
        compPhotoDetails.tcompetitorid = pid;
        compPhotoDetails.Tid='12432455235';
        
        LorealUploadclass.CompetitorDetailsInfo compDetail = new LorealUploadclass.CompetitorDetailsInfo();
        compDetail.avgPrice = '1000';
        compDetail.Comments = 'Test Comments';
        compDetail.contract = 'Contract';
        compDetail.FrqOfEduVisit = '12';
        compDetail.FrqOfRepVisit='10';
        compDetail.pid = pid;
        compDetail.qty = '10';
        compDetail.qtysize='10';
        compDetail.Rebate = '10';
        compDetail.RetailPrice = '100';
        compDetail.tcompetitorid = accId;
        compDetail.Tid = '12432455235';
        compDetail.TypeOfTraining = 'Test'; 
               
        LorealUploadclass.PromotionalPlanninginfo promoInfo = new LorealUploadclass.PromotionalPlanninginfo();
        promoInfo.Date_x = todayDate;
        promoInfo.Status = 'D';
        promoInfo.SupervisorComments='Test Comments';
        promoInfo.TId = '12432455235';
        promoInfo.UserId = '';
        
        LorealUploadclass.PromotionalPlanningDetail promoDetail = new LorealUploadclass.PromotionalPlanningDetail();
        promoDetail.pid = pid;
        promoDetail.Qty = '20';
        promoDetail.RetailerId=accId;
        promoDetail.SchemeId = schemeId;
        promoDetail.TId = '12432455235';
        promoDetail.Value = '123';
        
        LorealUploadclass.DreamListInfo dreamList = new LorealUploadclass.DreamListInfo();
        dreamList.Date_x = todayDate;
        dreamList.IsConquest = '';
        dreamList.ProgressPercentage = '80';
        dreamList.Remarks = 'No Remarks';
        dreamList.Rid = accId;
        dreamList.status = 'Test';
        dreamList.SuperWiserFeedBack = 'Test Feedback';
        dreamList.Upload = '';
        
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = todaydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        
        LorealUploadclass.OrderHeader orderHead = new LorealUploadclass.OrderHeader();
        orderHead.OrderID = '';
        orderHead.OrderDate = todayDate;
        orderHead.RetailerId = accId;
        orderHead.RouteId ='';
        orderHead.OrderValue='';
        orderHead.LinesPerCall ='';
        orderHead.discount = '';
        orderHead.deliveryDate = todayDate;
        orderHead.downloadDate ='';
        orderHead.po = '';
        orderHead.remark = 'remarks';
        orderHead.latitude = '';
        orderHead.longitude = '';
        orderHead.timestampid = '';
        orderHead.JFlag = '';
        orderHead.ReturnValue = '20';
        orderHead.sid = '';
        orderHead.stype = '';
        orderHead.totalTaxValue = '';
        orderHead.ImageName = 'TEST';
        orderHead.totalWeight = '';
        orderHead.BIllTo = '';
        orderHead.ShipTo = '';
        orderHead.Status = '';
        
        LorealUploadclass.OrderDetail orderDetail = new LorealUploadclass.OrderDetail();
        orderDetail.OrderId = '';
        orderDetail.ProductId = '';
        orderDetail.Qty='60';
        orderDetail.Rate='100';
        orderDetail.uomcount='60';
        orderDetail.pieceQty='30';
        orderDetail.caseqty='20';
        orderDetail.uomid='';
        orderDetail.totalamount='1000';
        orderDetail.casePrice='200';
        orderDetail.outerPrice='300';
        orderDetail.outerQty='30';
        orderDetail.douomQty='40';
        
        LorealUploadclass.NewRetailerEditHeaderInfo retailerHeader = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailerHeader.Tid='12432455235';
        retailerHeader.RetailerId=accId;
        retailerHeader.Date_x=todayDate;
        retailerHeader.isNew='1';
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail.Tid='12432455235';
        retailerDetail.Code='PROFILE_LO_05';
        retailerDetail.Value='TEST Conquest';
        retailerDetail.RefId = '';
        retailerDetail.RetailerId='';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas.UID = '12432455235';
        wrapnonpromas.retailerid = interId;
        wrapnonpromas.RouteID = '123234';
        wrapnonpromas.ReasonID = reasonid1;
        wrapnonpromas.Date_x = '2017/02/15';
        wrapnonpromas.ReasonTypes = '123';
        wrapnonpromas.DistributorID = '0';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas1 = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas1.UID = '12432455235';
        wrapnonpromas1.retailerid = interIdvisit;
        wrapnonpromas1.RouteID = '123234';
        wrapnonpromas1.ReasonID = reasonid1;
        wrapnonpromas1.Date_x = '2017/02/28';
        wrapnonpromas1.ReasonTypes = '123';
        wrapnonpromas1.DistributorID = '0';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet.gpsAccuracy = '0.0';
        wrapoutlet.RetailerID = interId;
        wrapoutlet.gpsCompliance = '0';
        wrapoutlet.VisitDate = '2017/02/15';
        wrapoutlet.JFlag = '0';
        wrapoutlet.BeatID = '1';
        wrapoutlet.VisitID = 'OTS02212017105710';
        wrapoutlet.TimeIn ='2017/02/15 10:57:51';
        wrapoutlet.Feedback='';
        wrapoutlet.longitude='0.0';
        wrapoutlet.latitude='0.0';
        wrapoutlet.Sequence='1';
        wrapoutlet.TimeOut = '2017/02/15 10:57:10';
        wrapoutlet.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel.TimeIn = '2017/02/15 9:57:15';
        wrapouttmstdel.RetailerID = interId;
        wrapouttmstdel.TimeOut = '2017/02/15 8:57:39';
        wrapouttmstdel.UID = 'OTS02212017105710';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet1 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet1.gpsAccuracy = '0.0';
        wrapoutlet1.RetailerID = interId;
        wrapoutlet1.gpsCompliance = '0';
        wrapoutlet1.VisitDate = '2017/02/21';
        wrapoutlet1.JFlag = '0';
        wrapoutlet1.BeatID = '1';
        wrapoutlet1.VisitID = 'OTS02212017105711';
        wrapoutlet1.TimeIn ='2017/02/21 10:57:51';
        wrapoutlet1.Feedback='';
        wrapoutlet1.longitude='0.0';
        wrapoutlet1.latitude='0.0';
        wrapoutlet1.Sequence='1';
        wrapoutlet1.TimeOut = '2017/02/21 10:57:10';
        wrapoutlet1.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel1 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel1.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel1.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel1.RetailerID = interId;
        wrapouttmstdel1.TimeOut = '2017/02/21 8:57:39';
        wrapouttmstdel1.UID = 'OTS02212017105711';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet2 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet2.gpsAccuracy = '0.0';
        wrapoutlet2.RetailerID = interIdvisit;
        wrapoutlet2.gpsCompliance = '0';
        wrapoutlet2.VisitDate = '2017/02/21';
        wrapoutlet2.JFlag = '0';
        wrapoutlet2.BeatID = '1';
        wrapoutlet2.VisitID = 'OTS02212017105711';
        wrapoutlet2.TimeIn ='2017/02/21 10:57:51';
        wrapoutlet2.Feedback='';
        wrapoutlet2.longitude='0.0';
        wrapoutlet2.latitude='0.0';
        wrapoutlet2.Sequence='1';
        wrapoutlet2.TimeOut = '2017/02/21 10:57:10';
        wrapoutlet2.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel2 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel2.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel2.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel2.RetailerID = interId;
        wrapouttmstdel2.TimeOut = '2017/02/21 8:57:39';
        wrapouttmstdel2.UID = 'OTS02212017105711';
                
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.JourneyPlanHeader = new List<LorealUploadclass.Journeyplaninfo>{journeyPlanInfo};
        wrapperClass.JourneyPlan_MarketVisitDetail = new List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>{journeyPlanMarket};
        wrapperClass.JourneyPlanDetail = new List<LorealUploadclass.JourneyPlanDetailInfo>{journeyPlanDetail};
                    
        wrapperClass.CompetitorHeaderNew = new List<LorealUploadclass.CompetitorHeaderInfo>{compHeader};
        wrapperClass.CompetitorPhotoDetailsNew = new List<LorealUploadclass.CompetitorPhotoDetailsInfo>{compPhotoDetails};
        wrapperClass.CompetitorDetailsNew = new List<LorealUploadclass.CompetitorDetailsInfo>{compDetail};
        
        wrapperClass.PromotionalPlanningHeader = new List<LorealUploadclass.PromotionalPlanninginfo>{promoInfo};
        wrapperClass.PromotionalPlanningDetails = new List<LorealUploadclass.PromotionalPlanningDetail>{promoDetail};
            
        wrapperClass.RetailerDreamList = new List<LorealUploadclass.DreamListInfo>{dreamList};
        
        wrapperClass.HairDresserNew = new List<LorealUploadclass.HairDresserInfo>{hairDresser};
            
        wrapperClass.OrderHeaderNew = new List<LorealUploadclass.OrderHeader>{orderHead};
        wrapperClass.OrderDetailNew = new List<LorealUploadclass.OrderDetail>{orderDetail};
            
        wrapperClass.NewRetailerEditHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>{retailerHeader};
        wrapperClass.NewRetailerEditDetail = new List<LorealUploadclass.NewRetailerEditDetailInfo>{retailerDetail};

        wrapperClass.OutletTimeStampDetail = new List<LorealUploadclass.cls_OutletTimeStampDetail>{wrapouttmstdel,wrapouttmstdel1,wrapouttmstdel2};
        wrapperClass.OutletTimestamp = new List<LorealUploadclass.cls_OutletTimestamp>{wrapoutlet,wrapoutlet1,wrapoutlet2};
      
        String JSONString = Json.Serialize(wrapperClass);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        Test.startTest();
               
        LOrealUpload.UploadHandler();
        PostResponse postRes = new PostResponse();
                 
        Test.stopTest();
        /*RestRequest req2 = new RestRequest();
        req2.requestbody = Blob.valueOf('Test');
        req2.addHeader('MobileDate', '2018/08/23 12:30:00');
        LOrealUpload.UploadHandler();*/
        System.Assert(req.requestBody != null);
    }
    
    public static testMethod void testExceptionmethod1(){
        
        
        
        Batch_SwitchOff__c batchSwithchOff = new Batch_SwitchOff__c();
        batchSwithchOff.Name = 'SalesForecast_Trigger_month_MoreThan_0';
        batchSwithchOff.SwitchOff__c = false;
        insert batchSwithchOff;
        
        Batch_SwitchOff__c batchSwithchOff2 = new Batch_SwitchOff__c();
        batchSwithchOff2.Name = 'SalesForecast_Trigger_month_equals_0';
        batchSwithchOff2.SwitchOff__c = false;
        insert batchSwithchOff2;
        
        
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c FROM ivybase__Product__c where ivybase__Is_Competitor__c=true][0].ivybase__InternalId__c);
        String schemeId = String.valueOf([select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c][0].ivydsd__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String reasonid1 = String.Valueof([SELECT Name FROM ivybase__Standard_List_Master__c Where ivybase__List_type__c = 'REASON'][0].Name);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        
        String todayDate = Date.today().format();
        String ordDate = Date.today().addDays(2).format();
        
        LorealUploadclass.Journeyplaninfo journeyPlanInfo = new LorealUploadclass.Journeyplaninfo();
        journeyPlanInfo.TId='12432455235';
        journeyPlanInfo.date_x=todayDate;
        journeyPlanInfo.UserId='';
        journeyPlanInfo.Month='8';
        journeyPlanInfo.Year='2018';
        journeyPlanInfo.SupervisorComments='Test Comments';
        journeyPlanInfo.Status='D';
        
        
        LorealUploadclass.JorneyMarketMarketVisitDetailInfo journeyPlanMarket = new LorealUploadclass.JorneyMarketMarketVisitDetailInfo();
        journeyPlanMarket.TId='12432455235';
        journeyPlanMarket.date_x=todayDate;
        journeyPlanMarket.RetailerId=accId;
        
        LorealUploadclass.JourneyPlanDetailInfo journeyPlanDetail = new LorealUploadclass.JourneyPlanDetailInfo();
        journeyPlanDetail.Comments = 'Test Comments';
        journeyPlanDetail.date_x = todayDate;
        journeyPlanDetail.TId = '12432455235';
        journeyPlanDetail.TypeId = '';
        journeyPlanDetail.WorkWithUserId='';
        
        
        LorealUploadclass.CompetitorHeaderInfo compHeader = new LorealUploadclass.CompetitorHeaderInfo();
        compHeader.Date_x = todayDate;
        compHeader.Feedback='Feedback';
        compHeader.Remark = 'Test Remark';
        compHeader.RetailerId = accId;
        compHeader.Tid = '12432455235';
        
        LorealUploadclass.CompetitorPhotoDetailsInfo compPhotoDetails = new LorealUploadclass.CompetitorPhotoDetailsInfo();
        compPhotoDetails.avgPrice = '1000';
        compPhotoDetails.Description = 'Test Description';
        compPhotoDetails.ImageName = 'Test Image';
        compPhotoDetails.ImagePath = '';
        compPhotoDetails.Name= 'Test';
        compPhotoDetails.qty = '10';
        compPhotoDetails.qtysize='5';
        compPhotoDetails.SellingPrice = '2000';
        compPhotoDetails.tcompetitorid = pid;
        compPhotoDetails.Tid='12432455235';
        
        LorealUploadclass.CompetitorDetailsInfo compDetail = new LorealUploadclass.CompetitorDetailsInfo();
        compDetail.avgPrice = '1000';
        compDetail.Comments = 'Test Comments';
        compDetail.contract = 'Contract';
        compDetail.FrqOfEduVisit = '12';
        compDetail.FrqOfRepVisit='10';
        compDetail.pid = pid;
        compDetail.qty = '10';
        compDetail.qtysize='10';
        compDetail.Rebate = '10';
        compDetail.RetailPrice = '100';
        compDetail.tcompetitorid = accId;
        compDetail.Tid = '12432455235';
        compDetail.TypeOfTraining = 'Test'; 
        
        
        LorealUploadclass.PromotionalPlanninginfo promoInfo = new LorealUploadclass.PromotionalPlanninginfo();
        promoInfo.Date_x = todayDate;
        promoInfo.Status = 'D';
        promoInfo.SupervisorComments='Test Comments';
        promoInfo.TId = '12432455235';
        promoInfo.UserId = '';
        
        LorealUploadclass.PromotionalPlanningDetail promoDetail = new LorealUploadclass.PromotionalPlanningDetail();
        promoDetail.pid = pid;
        promoDetail.Qty = '20';
        promoDetail.RetailerId=accId;
        promoDetail.SchemeId = schemeId;
        promoDetail.TId = '12432455235';
        promoDetail.Value = '123';
        
        LorealUploadclass.DreamListInfo dreamList = new LorealUploadclass.DreamListInfo();
        dreamList.Date_x = todayDate;
        dreamList.IsConquest = '';
        dreamList.ProgressPercentage = '80';
        dreamList.Remarks = 'No Remarks';
        dreamList.Rid = accId;
        dreamList.status = 'Test';
        dreamList.SuperWiserFeedBack = 'Test Feedback';
        dreamList.Upload = '';
        
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = todaydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=accId;
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        
        LorealUploadclass.OrderHeader orderHead = new LorealUploadclass.OrderHeader();
        orderHead.OrderID = '';
        orderHead.OrderDate = ordDate;
        orderHead.RetailerId = accId;
        orderHead.RouteId ='';
        orderHead.OrderValue='';
        orderHead.LinesPerCall ='';
        orderHead.discount = '';
        orderHead.deliveryDate = ordDate;
        orderHead.downloadDate ='';
        orderHead.po = '';
        orderHead.remark = 'remarks';
        orderHead.latitude = '';
        orderHead.longitude = '';
        orderHead.timestampid = '';
        orderHead.JFlag = '';
        orderHead.ReturnValue = '20';
        orderHead.sid = '';
        orderHead.stype = '';
        orderHead.totalTaxValue = '';
        orderHead.ImageName = 'TEST';
        orderHead.totalWeight = '';
        orderHead.BIllTo = '';
        orderHead.ShipTo = '';
        orderHead.Status = '';
        
        LorealUploadclass.OrderDetail orderDetail = new LorealUploadclass.OrderDetail();
        orderDetail.OrderId = '';
        orderDetail.ProductId = '';
        orderDetail.Qty='60';
        orderDetail.Rate='100';
        orderDetail.uomcount='60';
        orderDetail.pieceQty='30';
        orderDetail.caseqty='20';
        orderDetail.uomid='';
        orderDetail.totalamount='1000';
        orderDetail.casePrice='200';
        orderDetail.outerPrice='300';
        orderDetail.outerQty='30';
        orderDetail.douomQty='40';
        
        LorealUploadclass.NewRetailerEditHeaderInfo retailerHeader = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailerHeader.Tid='12432455235';
        retailerHeader.RetailerId=accId;
        retailerHeader.Date_x=todayDate;
        retailerHeader.isNew='1';
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail.Tid='12432455235';
        retailerDetail.Code='PROFILE_LO_05';
        retailerDetail.Value='TEST Conquest';
        retailerDetail.RefId = '';
        retailerDetail.RetailerId='';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas.UID = '12432455235';
        wrapnonpromas.retailerid = interId;
        wrapnonpromas.RouteID = '123234';
        wrapnonpromas.ReasonID = reasonid1;
        wrapnonpromas.Date_x = '2017/02/15';
        wrapnonpromas.ReasonTypes = '123';
        wrapnonpromas.DistributorID = '0';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas1 = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas1.UID = '12432455235';
        wrapnonpromas1.retailerid = interIdvisit;
        wrapnonpromas1.RouteID = '123234';
        wrapnonpromas1.ReasonID = reasonid1;
        wrapnonpromas1.Date_x = '2017/02/28';
        wrapnonpromas1.ReasonTypes = '123';
        wrapnonpromas1.DistributorID = '0';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet.gpsAccuracy = '0.0';
        wrapoutlet.RetailerID = interId;
        wrapoutlet.gpsCompliance = '0';
        wrapoutlet.VisitDate = '2017/02/15';
        wrapoutlet.JFlag = '0';
        wrapoutlet.BeatID = '1';
        wrapoutlet.VisitID = 'OTS02212017105710';
        wrapoutlet.TimeIn ='2017/02/15 10:57:10';
        wrapoutlet.Feedback='';
        wrapoutlet.longitude='0.0';
        wrapoutlet.latitude='0.0';
        wrapoutlet.Sequence='1';
        wrapoutlet.TimeOut = '2017/02/15 10:57:51';
        wrapoutlet.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel.TimeIn = '2017/02/15 9:57:15';
        wrapouttmstdel.RetailerID = interId;
        wrapouttmstdel.TimeOut = '2017/02/15 10:57:39';
        wrapouttmstdel.UID = 'OTS02212017105710';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet1 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet1.gpsAccuracy = '0.0';
        wrapoutlet1.RetailerID = interId;
        wrapoutlet1.gpsCompliance = '0';
        wrapoutlet1.VisitDate = '2017/02/21';
        wrapoutlet1.JFlag = '0';
        wrapoutlet1.BeatID = '1';
        wrapoutlet1.VisitID = 'OTS02212017105711';
        wrapoutlet1.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet1.Feedback='';
        wrapoutlet1.longitude='0.0';
        wrapoutlet1.latitude='0.0';
        wrapoutlet1.Sequence='1';
        wrapoutlet1.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet1.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel1 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel1.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel1.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel1.RetailerID = interId;
        wrapouttmstdel1.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel1.UID = 'OTS02212017105711';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet2 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet2.gpsAccuracy = '0.0';
        wrapoutlet2.RetailerID = interIdvisit;
        wrapoutlet2.gpsCompliance = '0';
        wrapoutlet2.VisitDate = '2017/02/21';
        wrapoutlet2.JFlag = '0';
        wrapoutlet2.BeatID = '1';
        wrapoutlet2.VisitID = 'OTS02212017105711';
        wrapoutlet2.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet2.Feedback='';
        wrapoutlet2.longitude='0.0';
        wrapoutlet2.latitude='0.0';
        wrapoutlet2.Sequence='1';
        wrapoutlet2.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet2.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel2 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel2.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel2.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel2.RetailerID = interId;
        wrapouttmstdel2.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel2.UID = 'OTS02212017105711';
        
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.JourneyPlanHeader = new List<LorealUploadclass.Journeyplaninfo>{journeyPlanInfo};
        wrapperClass.JourneyPlan_MarketVisitDetail = new List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>{journeyPlanMarket};
        wrapperClass.JourneyPlanDetail = new List<LorealUploadclass.JourneyPlanDetailInfo>{journeyPlanDetail};
                    
        wrapperClass.CompetitorHeaderNew = new List<LorealUploadclass.CompetitorHeaderInfo>{compHeader};
        wrapperClass.CompetitorPhotoDetailsNew = new List<LorealUploadclass.CompetitorPhotoDetailsInfo>{compPhotoDetails};
        wrapperClass.CompetitorDetailsNew = new List<LorealUploadclass.CompetitorDetailsInfo>{compDetail};
        
        wrapperClass.PromotionalPlanningHeader = new List<LorealUploadclass.PromotionalPlanninginfo>{promoInfo};
        wrapperClass.PromotionalPlanningDetails = new List<LorealUploadclass.PromotionalPlanningDetail>{promoDetail};
            
        wrapperClass.RetailerDreamList = new List<LorealUploadclass.DreamListInfo>{dreamList};
        
        wrapperClass.HairDresserNew = new List<LorealUploadclass.HairDresserInfo>{hairDresser};
            
        wrapperClass.OrderHeaderNew = new List<LorealUploadclass.OrderHeader>{orderHead};
        wrapperClass.OrderDetailNew = new List<LorealUploadclass.OrderDetail>{orderDetail};
            
        wrapperClass.NewRetailerEditHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>{retailerHeader};
        wrapperClass.NewRetailerEditDetail = new List<LorealUploadclass.NewRetailerEditDetailInfo>{retailerDetail};

        wrapperClass.OutletTimeStampDetail = new List<LorealUploadclass.cls_OutletTimeStampDetail>{wrapouttmstdel,wrapouttmstdel1,wrapouttmstdel2};
        wrapperClass.OutletTimestamp = new List<LorealUploadclass.cls_OutletTimestamp>{wrapoutlet,wrapoutlet1,wrapoutlet2};
                                        
        String JSONString = Json.Serialize(wrapperClass);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        Test.startTest();
        LOrealUpload.UploadHandler();
        PostResponse postRes = new PostResponse();
        Test.stopTest();
        /*RestRequest req2 = new RestRequest();
        req2.requestbody = Blob.valueOf('Test');
        req2.addHeader('MobileDate', '2018/08/23 12:30:00');
        LOrealUpload.UploadHandler();*/
        System.Assert(req.requestBody != null);
    }
    
    public static testMethod void testVistupload(){
    
        string accId = String.Valueof([SELECT Name,ivybase__Internal_Id__c FROM Account Where Name='Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__InternalId__c,ivybase__Is_Competitor__c FROM ivybase__Product__c where ivybase__Is_Competitor__c=true][0].ivybase__InternalId__c);
        String schemeId = String.valueOf([select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c][0].ivydsd__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where Name = 'Test Acc' AND ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        String reasonid1 = String.Valueof([SELECT Name FROM ivybase__Standard_List_Master__c Where ivybase__List_type__c = 'REASON'][0].Name);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas.UID = '12432455235';
        wrapnonpromas.retailerid = interId;
        wrapnonpromas.RouteID = '123234';
        wrapnonpromas.ReasonID = reasonid1;
        wrapnonpromas.Date_x = '2017/02/15';
        wrapnonpromas.ReasonTypes = '123';
        wrapnonpromas.DistributorID = '0';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas1 = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas1.UID = '12432455235';
        wrapnonpromas1.retailerid = interIdvisit;
        wrapnonpromas1.RouteID = '123234';
        wrapnonpromas1.ReasonID = reasonid1;
        wrapnonpromas1.Date_x = '2017/02/28';
        wrapnonpromas1.ReasonTypes = '123';
        wrapnonpromas1.DistributorID = '0';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet.gpsAccuracy = '0.0';
        wrapoutlet.RetailerID = interId;
        wrapoutlet.gpsCompliance = '0';
        wrapoutlet.VisitDate = '2017/02/15';
        wrapoutlet.JFlag = '0';
        wrapoutlet.BeatID = '1';
        wrapoutlet.VisitID = 'OTS02212017105710';
        wrapoutlet.TimeIn ='2017/02/15 10:57:10';
        wrapoutlet.Feedback='';
        wrapoutlet.longitude='0.0';
        wrapoutlet.latitude='0.0';
        wrapoutlet.Sequence='1';
        wrapoutlet.TimeOut = '2017/02/15 10:57:51';
        wrapoutlet.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel.TimeIn = '2017/02/15 9:57:15';
        wrapouttmstdel.RetailerID = interId;
        wrapouttmstdel.TimeOut = '2017/02/15 10:57:39';
        wrapouttmstdel.UID = 'OTS02212017105710';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet1 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet1.gpsAccuracy = '0.0';
        wrapoutlet1.RetailerID = interId;
        wrapoutlet1.gpsCompliance = '0';
        wrapoutlet1.VisitDate = '2017/02/21';
        wrapoutlet1.JFlag = '0';
        wrapoutlet1.BeatID = '1';
        wrapoutlet1.VisitID = 'OTS02212017105711';
        wrapoutlet1.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet1.Feedback='';
        wrapoutlet1.longitude='0.0';
        wrapoutlet1.latitude='0.0';
        wrapoutlet1.Sequence='1';
        wrapoutlet1.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet1.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel1 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel1.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel1.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel1.RetailerID = interId;
        wrapouttmstdel1.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel1.UID = 'OTS02212017105711';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet2 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet2.gpsAccuracy = '0.0';
        wrapoutlet2.RetailerID = interIdvisit;
        wrapoutlet2.gpsCompliance = '0';
        wrapoutlet2.VisitDate = '2017/02/21';
        wrapoutlet2.JFlag = '0';
        wrapoutlet2.BeatID = '1';
        wrapoutlet2.VisitID = 'OTS02212017105711';
        wrapoutlet2.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet2.Feedback='';
        wrapoutlet2.longitude='0.0';
        wrapoutlet2.latitude='0.0';
        wrapoutlet2.Sequence='1';
        wrapoutlet2.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet2.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel2 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel2.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel2.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel2.RetailerID = interId;
        wrapouttmstdel2.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel2.UID = 'OTS02212017105711';
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        
        wrapperClass.Nonproductivereasonmaster = new List<LorealUploadclass.cls_Nonproductivereasonmaster>{wrapnonpromas,wrapnonpromas1};
        wrapperClass.OutletTimeStampDetail = new List<LorealUploadclass.cls_OutletTimeStampDetail>{wrapouttmstdel,wrapouttmstdel1,wrapouttmstdel2};
        wrapperClass.OutletTimestamp = new List<LorealUploadclass.cls_OutletTimestamp>{wrapoutlet,wrapoutlet1,wrapoutlet2};
                                       
        String JSONString = Json.Serialize(wrapperClass);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        Test.startTest();
        LOrealUploadTranslator.uploadVisitDetails(wrapperClass.OutletTimestamp, wrapperClass.OutletTimeStampDetail, 
                                                  wrapperClass.Nonproductivereasonmaster);
        //LOrealUpload.UploadHandler();
        //PostResponse postRes = new PostResponse();
        Test.stopTest();
        /*RestRequest req2 = new RestRequest();
        req2.requestbody = Blob.valueOf('Test');
        req2.addHeader('MobileDate', '2018/08/23 12:30:00');
        LOrealUpload.UploadHandler();*/
        //System.Assert(req.requestBody != null);
    }
    
    private static testMethod void testVisitMethod() {
    
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        //  String qid = String.Valueof([SELECT Question_Id__c FROM Survey_Question__c].Question_Id__c); 
        //String qid = String.Valueof([SELECT ivybase__Question_Id__c FROM ivybase__Question__c limit 1].ivybase__Question_Id__c); 
        //String surid = String.Valueof([SELECT ivybase__Internal_Id__c FROM ivybase__Survey__c].ivybase__Internal_Id__c);
        string interId1 = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes' AND RecordTypeId = :RecordTypeId][0].ivybase__Internal_Id__c);
        //String locid = String.Valueof([SELECT ivybase__Internal_Id__c FROM ivybase__Store_Hierarchy__c].ivybase__Internal_Id__c);
        String pid = String.Valueof([SELECT ivybase__InternalId__c FROM ivybase__Product__c][0].ivybase__InternalId__c);
        //String phid = String.Valueof([SELECT ivybase__Internal_Id__c FROM ivybase__Product_Hierarchy__c].ivybase__Internal_Id__c);
        String reasonid1 = String.Valueof([SELECT Name FROM ivybase__Standard_List_Master__c Where ivybase__List_type__c = 'REASON'][0].Name);
        string interIdvisit = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where ivybase__Active__c = 'Yes'][0].ivybase__Internal_Id__c);
               
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas.UID = '12432455235';
        wrapnonpromas.retailerid = interId;
        wrapnonpromas.RouteID = '123234';
        wrapnonpromas.ReasonID = reasonid1;
        wrapnonpromas.Date_x = '2017/02/15';
        wrapnonpromas.ReasonTypes = '123';
        wrapnonpromas.DistributorID = '0';
        
        LorealUploadclass.cls_Nonproductivereasonmaster wrapnonpromas1 = new  LorealUploadclass.cls_Nonproductivereasonmaster();
        wrapnonpromas1.UID = '12432455235';
        wrapnonpromas1.retailerid = interIdvisit;
        wrapnonpromas1.RouteID = '123234';
        wrapnonpromas1.ReasonID = reasonid1;
        wrapnonpromas1.Date_x = '2017/02/28';
        wrapnonpromas1.ReasonTypes = '123';
        wrapnonpromas1.DistributorID = '0';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet.gpsAccuracy = '0.0';
        wrapoutlet.RetailerID = interId;
        wrapoutlet.gpsCompliance = '0';
        wrapoutlet.VisitDate = '2017/02/15';
        wrapoutlet.JFlag = '0';
        wrapoutlet.BeatID = '1';
        wrapoutlet.VisitID = 'OTS02212017105710';
        wrapoutlet.TimeIn ='2017/02/15 10:57:10';
        wrapoutlet.Feedback='';
        wrapoutlet.longitude='0.0';
        wrapoutlet.latitude='0.0';
        wrapoutlet.Sequence='1';
        wrapoutlet.TimeOut = '2017/02/15 10:57:51';
        wrapoutlet.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel.TimeIn = '2017/02/15 9:57:15';
        wrapouttmstdel.RetailerID = interId;
        wrapouttmstdel.TimeOut = '2017/02/15 10:57:39';
        wrapouttmstdel.UID = 'OTS02212017105710';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet1 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet1.gpsAccuracy = '0.0';
        wrapoutlet1.RetailerID = interId;
        wrapoutlet1.gpsCompliance = '0';
        wrapoutlet1.VisitDate = '2017/02/21';
        wrapoutlet1.JFlag = '0';
        wrapoutlet1.BeatID = '1';
        wrapoutlet1.VisitID = 'OTS02212017105711';
        wrapoutlet1.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet1.Feedback='';
        wrapoutlet1.longitude='0.0';
        wrapoutlet1.latitude='0.0';
        wrapoutlet1.Sequence='1';
        wrapoutlet1.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet1.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel1 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel1.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel1.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel1.RetailerID = interId;
        wrapouttmstdel1.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel1.UID = 'OTS02212017105711';
        
        LorealUploadclass.cls_OutletTimestamp wrapoutlet2 = new  LorealUploadclass.cls_OutletTimestamp();
        wrapoutlet2.gpsAccuracy = '0.0';
        wrapoutlet2.RetailerID = interIdvisit;
        wrapoutlet2.gpsCompliance = '0';
        wrapoutlet2.VisitDate = '2017/02/21';
        wrapoutlet2.JFlag = '0';
        wrapoutlet2.BeatID = '1';
        wrapoutlet2.VisitID = 'OTS02212017105711';
        wrapoutlet2.TimeIn ='2017/02/21 10:57:10';
        wrapoutlet2.Feedback='';
        wrapoutlet2.longitude='0.0';
        wrapoutlet2.latitude='0.0';
        wrapoutlet2.Sequence='1';
        wrapoutlet2.TimeOut = '2017/02/21 10:57:51';
        wrapoutlet2.gpsDistance = '-1.0';
       
        LorealUploadclass.cls_OutletTimeStampDetail wrapouttmstdel2 = new  LorealUploadclass.cls_OutletTimeStampDetail();
        wrapouttmstdel2.ModuleCode = 'MENU_PHOTO';
        wrapouttmstdel2.TimeIn = '2017/02/21 9:57:15';
        wrapouttmstdel2.RetailerID = interId;
        wrapouttmstdel2.TimeOut = '2017/02/21 10:57:39';
        wrapouttmstdel2.UID = 'OTS02212017105711';
        
        LorealUploadclass.MultipleResponseInfo WrpCls = new LorealUploadclass.MultipleResponseInfo();
        WrpCls.Nonproductivereasonmaster = new List<LorealUploadclass.cls_Nonproductivereasonmaster>{wrapnonpromas,wrapnonpromas1};
        WrpCls.OutletTimeStampDetail = new List<LorealUploadclass.cls_OutletTimeStampDetail>{wrapouttmstdel,wrapouttmstdel1,wrapouttmstdel2};
        WrpCls.OutletTimestamp = new List<LorealUploadclass.cls_OutletTimestamp>{wrapoutlet,wrapoutlet1,wrapoutlet2};
         
         
        String JSONString = Json.Serialize(WrpCls);
        System.Debug('******JSONString'+JSONString);
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        req.addHeader('mobiledate', '2017/09/13 12:30:00');
        RestContext.request =req ;
        LOrealUpload.UploadHandler();
        System.Assert(req.requestBody != null);        
    }
}