/**
* Covered Classes : PostResponse, RetailerDocumentService, RetailerProductAllocation_Update, SchemeApplyDetail, SchemeUtility,
* JourneyPlanActivityTranslatorUpload, JourneyPlanMarketTranslatorUpload, OrderLineItemTriggerHandler, OrderUploadTranslator,
* DivisionService, OrderLineItemService, PromotionalPlanUploadTranslator, PromotionalPlanningService, PromotionalPlanningDetailsService,
* SchemeService, SchemeApplyDetailTriggerHandler, SchemeProductGroupTriggerHandler, AccountTrigger, TriggerLogicService,
* SalesforecastingTrigger, DreamListService, promotionalPlanHeaderUploadTranslator
*/
@isTest
public class testLorealUploadTranslator {
    @isTest
    public static void testconvertStringToDate()
    {
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        tdydate=tdydate.replace('-', '/');
        LOrealUploadTranslator.convertStringToDate(tdydate);
        Date dateToday = Date.today();
        String sMonth = String.valueof(dateToday.month());
        String sDay = String.valueof(dateToday.day());
        if(sMonth.length()==1){
            sMonth = '0' + sMonth;
        }
        if(sDay.length()==1){
            sDay = '0' + sDay;
        }
        String formattedData = sMonth+'/'+sDay+'/'+String.valueof(dateToday.year());
        //String sToday = String.valueof(dateToday.year()) + sMonth + sDay ;
        LOrealUploadTranslator.ConvertTOSFFormatDate(formattedData);
    }
    public static testmethod void visit()
    {
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
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
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
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        List<ivybase__Visit__c> visitlist = new List<ivybase__Visit__c>();
        
        ivybase__Visit__c vi = TestUtility.createTestVisit(Date.valueOf('2018-02-19'), acc.Id ,'');
        visitlist.add(vi);
        LOrealUploadTranslator.getVisit(visitlist,acc.id,Date.valueOf('2018-02-19'));
        LOrealUploadTranslator.getVisit(visitlist,acc.id,Date.valueOf('2018-02-20'));
    }
    public static testmethod void retailereditTransaction()
    {
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        //Id userId = UserInfo.getUserId();
        
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locHrNatnl= TestUtility.createTestLocationHierarchy('Test Location Hierarchy National', NULL); 
        locHrNatnl.RecordTypeId = RT.get('National').getRecordTypeId();
        locHrNatnl.CurrencyIsoCode = usr.CurrencyIsoCode;
        locHrNatnl.Market_ISO__c = usr.Market_ISO__c;
        insert locHrNatnl;
        system.debug('locHrNatnl '+locHrNatnl);
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',usr.Id,restype.id);
        res.SAP_Id__c='12121212';
        res.Market_ISO__c = usr.Market_ISO__c;
        res.CurrencyIsoCode = usr.CurrencyIsoCode;
        res.ivybase__Location_Hierarchy__c = locHrNatnl.Id;
        insert res;
        
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c='MY';
        division.Market_ISO__c = usr.Market_ISO__c;
        division.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert division;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert locHr;
        
                //MAG CLASSIFICATION:
        //createHHTMenuMaster (String name, Integer flag, String rField1, String menuType, String mName, Id locHr, Id resourceTypeId, String flex)
        
        List<ivybase__HHTMenu_Master__c> hhtMenuList = new List<ivybase__HHTMenu_Master__c>();
        
		hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_55', 1, '55', 'RETAILER_PROFILE', 'No of Stylist', locHrNatnl.Id, restype.Id, 'No_of_Stylist__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_56', 1, '56', 'RETAILER_PROFILE', 'No of Chairs', locHrNatnl.Id, restype.Id, 'No_of_Chairs__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_57', 1, '57', 'RETAILER_PROFILE', 'No of Backwash Units', locHrNatnl.Id, restype.Id, 'No_of_Backwash_Units__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_58', 1, '58', 'RETAILER_PROFILE', 'Color Price', locHrNatnl.Id, restype.Id, 'Color_Price__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_59', 1, '59', 'RETAILER_PROFILE', 'Treatment Price', locHrNatnl.Id, restype.Id, 'Treatment_Price__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_60', 1, '60', 'RETAILER_PROFILE', 'Cutting Price', locHrNatnl.Id, restype.Id, 'Cutting_Price__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_61', 1, '61', 'RETAILER_PROFILE', 'Blow Dry Price', locHrNatnl.Id, restype.Id, 'Blow_Dry_Price__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_62', 1, '62', 'RETAILER_PROFILE', 'Texture Price', locHrNatnl.Id, restype.Id, 'Texture_Price__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_63', 1, '63', 'RETAILER_PROFILE', 'Key Competitor', locHrNatnl.Id, restype.Id, 'Key_Competitor__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_64', 1, '64', 'RETAILER_PROFILE', 'Customer Attribute1', locHrNatnl.Id, restype.Id, 'Customer_Attribute1__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_65', 1, '65', 'RETAILER_PROFILE', 'Customer Attribute2', locHrNatnl.Id, restype.Id, 'Customer_Attribute2__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_66', 1, '66', 'RETAILER_PROFILE', 'Customer Attribute3', locHrNatnl.Id, restype.Id, 'Customer_Attribute3__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_67', 1, '67', 'RETAILER_PROFILE', 'Customer Attribute4', locHrNatnl.Id, restype.Id, 'Customer_Attribute4__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_68', 1, '68', 'RETAILER_PROFILE', 'Customer Attribute5', locHrNatnl.Id, restype.Id, 'Customer_Attribute5__c'));
        
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_50', 1, '50', 'RETAILER_PROFILE', 'Kerastase Luxury Mag', locHrNatnl.Id, restype.Id, 'Kerastase_Luxury_Mag__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_09', 1, '9', 'RETAILER_PROFILE', 'Shipping Address', locHrNatnl.Id, restype.Id, 'Shipping_Address__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_10', 1, '10', 'RETAILER_PROFILE', 'Billing Address', locHrNatnl.Id, restype.Id, 'Billing_Address__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_27', 1, '27', 'RETAILER_PROFILE', 'Store Address', locHrNatnl.Id, restype.Id, 'Store_Address__c'));
        hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_36', 1, '36', 'RETAILER_PROFILE', 'Last Visit Date', locHrNatnl.Id, restype.Id, 'ivybase__Last_Visit__c'));
        //hhtMenuList.add(TestUtility.createHHTMenuMaster('PROFILE_LO_68', 1, '68', 'RETAILER_PROFILE', 'Customer Attribute5', locHrNatnl.Id, restype.Id, 'Customer_Attribute5__c'));
        
        insert hhtMenuList;
        
        system.debug('hhtMenuList '+hhtMenuList);
        
         List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'LL', ivybase__List_Name__c = 'LL', ivybase__List_Type__c = 'LUXURY_MAG',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'LH', ivybase__List_Name__c = 'LH', ivybase__List_Type__c = 'LUXURY_MAG',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'HL', ivybase__List_Name__c = 'HL', ivybase__List_Type__c = 'LUXURY_MAG',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'CMT_NL', ivybase__List_Name__c = 'Display', ivybase__List_Type__c = 'COMPETITOR_TRACKING_TYPE',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
        
        system.debug('stdMasterList '+stdMasterList);
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        divLoc.Market_ISO__c = usr.Market_ISO__c;
        divLoc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        Account acc1 = TestUtility.createTestAccount('12' , 'Test Vivek' , '123456789' , '111228933' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Dream test';
        acc1.Progress_Percentage__c = 100;
        acc1.Market_ISO__c = usr.Market_ISO__c;
        acc1.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert acc1;
        acc1.ivybase__Active__c = 'Yes';
        update acc1;
        
        acc1 = [SELECT Id,ivybase__Internal_Id__c FROM Account WHERE Id = :acc1.Id];
        
        String todayDate = Date.today().format();
        LorealUploadclass.HairDresserInfo hairDresser = new LorealUploadclass.HairDresserInfo();
        hairDresser.Date_x = todaydate;
        hairDresser.Hairdressercode = '76Ao';
        hairDresser.HairdresserId = '4';
        hairDresser.HairdresserName = 'TEST';
        hairDresser.IsExisting = '';
        hairDresser.MobileNo = '';
        hairDresser.Privacy='True';
        hairDresser.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        hairDresser.Signature = '';
        hairDresser.SocialMediaId='hhh';
        hairDresser.Tid = '12432455235';
        
        LorealUploadclass.NewRetailerEditHeaderInfo retailerHeader = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailerHeader.Tid='12432455235';
        retailerHeader.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        retailerHeader.Date_x=todayDate;
        retailerHeader.isNew='1';
        
        LorealUploadclass.NewRetailerEditHeaderInfo retailerHeader1 = new LorealUploadclass.NewRetailerEditHeaderInfo();
        retailerHeader1.Tid='12432455236';
        retailerHeader1.RetailerId=String.valueOf(acc1.ivybase__Internal_Id__c);
        retailerHeader1.Date_x=todayDate;
        retailerHeader1.isNew='1';
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetailHead1 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetailHead1.Tid='12432455236';
        retailerDetailHead1.Code='PROFILE_LO_05';
        retailerDetailHead1.Value='TEST Conquest';
        retailerDetailHead1.RefId = '';
        retailerDetailHead1.RetailerId=String.valueOf(acc1.ivybase__Internal_Id__c);
        
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail.Tid='12432455235';
        retailerDetail.Code='PROFILE_LO_05';
        retailerDetail.Value='TEST Vivek';
        retailerDetail.RefId = '';
        retailerDetail.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail1 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail1.Tid='12432455235';
        retailerDetail1.Code='PROFILE_LO_55';
        retailerDetail1.Value='700';
        retailerDetail1.RefId = '';
        retailerDetail1.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail2 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail2.Tid='12432455235';
        retailerDetail2.Code='PROFILE_LO_56';
        retailerDetail2.Value='6';
        retailerDetail2.RefId = '';
        retailerDetail2.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail3 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail3.Tid='12432455235';
        retailerDetail3.Code='PROFILE_LO_57';
        retailerDetail3.Value='2';
        retailerDetail3.RefId = '';
        retailerDetail3.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail4 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail4.Tid='12432455235';
        retailerDetail4.Code='PROFILE_LO_58';
        retailerDetail4.Value='TEST Conquest';
        retailerDetail4.RefId = '';
        retailerDetail4.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail5 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail5.Tid='12432455235';
        retailerDetail5.Code='PROFILE_LO_59';
        retailerDetail5.Value='1000';
        retailerDetail5.RefId = '';
        retailerDetail5.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail6 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail6.Tid='12432455235';
        retailerDetail6.Code='PROFILE_LO_60';
        retailerDetail6.Value='1000';
        retailerDetail6.RefId = '';
        retailerDetail6.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail7 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail7.Tid='12432455235';
        retailerDetail7.Code='PROFILE_LO_61';
        retailerDetail7.Value='1000';
        retailerDetail7.RefId = '';
        retailerDetail7.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail8 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail8.Tid='12432455235';
        retailerDetail8.Code='PROFILE_LO_62';
        retailerDetail8.Value='1000';
        retailerDetail8.RefId = '';
        retailerDetail8.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail9 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail9.Tid='12432455235';
        retailerDetail9.Code='PROFILE_LO_63';
        retailerDetail9.Value='TEST';
        retailerDetail9.RefId = '';
        retailerDetail9.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail10 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail10.Tid='12432455235';
        retailerDetail10.Code='PROFILE_LO_64';
        retailerDetail10.Value='TEST Conquest';
        retailerDetail10.RefId = '';
        retailerDetail10.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail11 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail11.Tid='12432455235';
        retailerDetail11.Code='PROFILE_LO_65';
        retailerDetail11.Value='TEST Conquest';
        retailerDetail11.RefId = '';
        retailerDetail11.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail12 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail12.Tid='12432455235';
        retailerDetail12.Code='PROFILE_LO_66';
        retailerDetail12.Value='TEST Conquest';
        retailerDetail12.RefId = '';
        retailerDetail12.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail13 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail13.Tid='12432455235';
        retailerDetail13.Code='PROFILE_LO_67';
        retailerDetail13.Value='TEST Conquest';
        retailerDetail13.RefId = '';
        retailerDetail13.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail14 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail14.Tid='12432455235';
        retailerDetail14.Code='PROFILE_LO_68';
        retailerDetail14.Value='TEST Conquest';
        retailerDetail14.RefId = '';
        retailerDetail14.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail15 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail15.Tid='12432455235';
        retailerDetail15.Code='PROFILE_LO_50';
        system.debug('Vivek '+stdMasterList[0].Name);
        retailerDetail15.Value= [SELECT Id, Name FROM ivybase__Standard_List_Master__c WHERE ivybase__List_Type__c = 'LUXURY_MAG' LIMIT 1].Name;
        retailerDetail15.RefId = '';
        retailerDetail15.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail16 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail16.Tid='12432455235';
        retailerDetail16.Code='PROFILE_LO_27';
        retailerDetail16.Value= 'Store address';
        retailerDetail16.RefId = '';
        retailerDetail16.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail17 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail17.Tid='12432455235';
        retailerDetail17.Code='PROFILE_LO_10';
        retailerDetail17.Value= 'Billing address';
        retailerDetail17.RefId = '';
        retailerDetail17.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail18 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail18.Tid='12432455235';
        retailerDetail18.Code='PROFILE_LO_09';
        retailerDetail18.Value= 'Shipping address';
        retailerDetail18.RefId = '';
        retailerDetail18.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.NewRetailerEditDetailInfo retailerDetail19 = new LorealUploadclass.NewRetailerEditDetailInfo();
        retailerDetail19.Tid='12432455235';
        retailerDetail19.Code='PROFILE_LO_36';
        retailerDetail19.Value= todayDate;
        retailerDetail19.RefId = '';
        retailerDetail19.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        
        
        
        
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.HairDresserNew = new List<LorealUploadclass.HairDresserInfo>{hairDresser};
            wrapperClass.NewRetailerEditHeader = new List<LorealUploadclass.NewRetailerEditHeaderInfo>{retailerHeader, retailerHeader1};
                wrapperClass.NewRetailerEditDetail = new List<LorealUploadclass.NewRetailerEditDetailInfo>{retailerDetail, retailerDetail1, retailerDetail2, retailerDetail3, 
                    retailerDetail4, retailerDetail5, retailerDetail6, retailerDetail7, retailerDetail8, retailerDetail9, retailerDetail10, retailerDetail11, retailerDetail12,
                    retailerDetail13, retailerDetail14, retailerDetail15, retailerDetail16, retailerDetail17, retailerDetail18, retailerDetail19, retailerDetailHead1};
                    
                    
                    LOrealUploadTranslator.RetailerEditTransaction(wrapperClass.NewRetailerEditHeader,wrapperClass.NewRetailerEditDetail,wrapperClass.HairDresserNew);
        LOrealUploadTranslator.RetailerEditTransaction(null,null,wrapperClass.HairDresserNew);
    }
    public static testmethod void orderTransaction()
    {
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        //Id userId = UserInfo.getUserId();
        //
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        UserwiseCountryValues__c settings = UserwiseCountryValues__c.getOrgDefaults();
        settings.Market_ISO__c = usr.Market_ISO__c;
        settings.SetupOwnerId= userinfo.getUserId();
        insert settings;
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',usr.Id,restype.id);
        res.SAP_Id__c='12121212';
        res.ivybase__Related_User__c = usr.Id;
        res.Market_ISO__c = usr.Market_ISO__c;
        res.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHrNatnl= TestUtility.createTestLocationHierarchy('Test Location Hierarchy National', NULL); 
        locHrNatnl.RecordTypeId = RT.get('National').getRecordTypeId();
        locHrNatnl.CurrencyIsoCode = usr.CurrencyIsoCode;
        locHrNatnl.Market_ISO__c = usr.Market_ISO__c;
        insert locHrNatnl;
        system.debug('locHrNatnl '+locHrNatnl);
        
        ivybase__Standard_List_Master__c inoiceStandard = new ivybase__Standard_List_Master__c(ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__List_Name__c='Loreal Professional',ivybase__List_Code__c = 'LP');
        inoiceStandard.ivybase__Resource_Type__c = restype.Id;
        inoiceStandard.ivybase__Location_Hierarchy__c = locHrNatnl.Id;
        insert inoiceStandard;
        
        Division__c  division = new Division__c ();
        division.name='Loreal Professional';
        division.Market_ISO__c = usr.Market_ISO__c;
        division.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes');
        ph.Market_ISO__c = usr.Market_ISO__c;
        ph.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.Market_ISO__c = usr.Market_ISO__c;
        p1.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert p1;
        p1=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p1.id];
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduplotwo',ph.Id,'Testdesc1', false ,'Yes');
        p2.Market_ISO__c = usr.Market_ISO__c;
        p2.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert p2;
        p2=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p2.id];
        
        ivybase__Product__c p3Bom = TestUtility.createTestProduct('Test Product 1', ph.Id, 'Testdesc1', FALSE ,'Yes');
        p3Bom.Market_ISO__c = usr.Market_ISO__c;
        p3Bom.CurrencyIsoCode = usr.CurrencyIsoCode;
        p3Bom.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Bill_Of_Material_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id; 
        INSERT p3Bom;
        
        p3Bom = [SELECT Id, Name, ivybase__InternalId__c FROM ivybase__Product__c  WHERE Id=:p2.Id];
        
        ivybase__Bill_Of_Material_SKU_Detail__c  bom1 = new ivybase__Bill_Of_Material_SKU_Detail__c ();
        bom1.ivybase__Bill_Of_Material_SKU__c = p3Bom.id;
        bom1.ivybase__Product__c = p2.id;
        bom1.ivybase__Quantity__c = 1;
        bom1.Market_ISO__c = usr.Market_ISO__c;
        bom1.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert bom1;
        
        String todayDate = Date.today().format();
        LorealUploadclass.OrderHeader orderHead = new LorealUploadclass.OrderHeader();
        orderHead.OrderID = '3123123123123123';
        orderHead.OrderDate = todayDate;
        orderHead.RetailerId = String.valueOf(acc.ivybase__Internal_Id__c);
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
        orderDetail.OrderId = '3123123123123123';
        orderDetail.ProductId = String.valueOf(p1.ivybase__InternalId__c);
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
        
        LorealUploadclass.OrderDetail orderDetail2 = new LorealUploadclass.OrderDetail();
        orderDetail2.OrderId = '3123123123123123';
        orderDetail2.ProductId = String.valueOf(p2.ivybase__InternalId__c);
        orderDetail2.Qty='60';
        orderDetail2.Rate='100';
        orderDetail2.uomcount='60';
        orderDetail2.pieceQty='30';
        orderDetail2.caseqty='20';
        orderDetail2.uomid='';
        orderDetail2.totalamount='1000';
        orderDetail2.casePrice='200';
        orderDetail2.outerPrice='300';
        orderDetail2.outerQty='30';
        orderDetail2.douomQty='40';
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                         ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        scheme.Market_ISO__c = usr.Market_ISO__c;
        scheme.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        //schemeSlab.Market_ISO__c = usr.Market_ISO__c;
        schemeSlab.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert schemeSlab;
        
        List<ivydsd__Scheme_Slab__c>  schemeList = [SELECT Id, ivydsd__Internal_Id__c FROM ivydsd__Scheme_Slab__c];
        LorealUploadclass.SchemeDetail schemeDetail = new LorealUploadclass.SchemeDetail();
        schemeDetail.OrderID='3123123123123123';  
        schemeDetail.InvoiceID=''; 
        schemeDetail.SchemeID=string.valueOf(schemeList[0].ivydsd__Internal_Id__c); 
        schemeDetail.ProductID=String.valueOf(p2.ivybase__InternalId__c);
        schemeDetail.SchemeType=''; 
        schemeDetail.Value=''; 
        schemeDetail.parentid=''; 
        schemeDetail.SchemeDetailNew=''; 
        schemeDetail.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c); 
        schemeDetail.distributorid=''; 
        schemeDetail.Amount=''; 
        
        LorealUploadclass.SchemeFreeProductDetail freedetail = new LorealUploadclass.SchemeFreeProductDetail();
        freedetail.OrderID='3123123123123123';  
        freedetail.InvoiceID=''; 
        freedetail.SchemeID=string.valueOf(schemeList[0].ivydsd__Internal_Id__c); 
        freedetail.FreeProductID=String.valueOf(p1.ivybase__InternalId__c);
        freedetail.FreeQty='1';  
        freedetail.UomID=''; 
        freedetail.UomCount=''; 
        freedetail.BatchId=''; 
        
        LorealUploadclass.OrderPackageDetail packageDetail = new LorealUploadclass.OrderPackageDetail();
        packageDetail.OrderId = '3123123123123123';
        packageDetail.Pid = String.valueOf(p2.ivybase__InternalId__c);
        packageDetail.Bpid = String.valueOf(p3Bom.ivybase__InternalId__c);
        packageDetail.NoOfPackage = '2';
        packageDetail.Mqty = '3';
        packageDetail.RetailerId = String.valueOf(acc.ivybase__Internal_Id__c);
        packageDetail.DivisionId = inoiceStandard.Name;
        packageDetail.PackageType = '1';
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.OrderHeaderNew = new List<LorealUploadclass.OrderHeader>{orderHead};
            wrapperClass.OrderDetailNew = new List<LorealUploadclass.OrderDetail>{orderDetail,orderDetail2};
                wrapperClass.SchemeDetailNew = new List<LorealUploadclass.SchemeDetail>{schemeDetail};
                    wrapperClass.SchemeFreeProductDetailNew = new List<LorealUploadclass.SchemeFreeProductDetail>{freedetail};
                        wrapperClass.OrderPackageDetailNew = new List<LorealUploadclass.OrderPackageDetail>{packageDetail};
                            
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
        /*
         * Remove comment
         * 
		*/
        LOrealUploadTranslator.orderTransaction(wrapperClass.OrderHeaderNew,wrapperClass.OrderDetailNew,wrapperClass.SchemeDetailNew,wrapperClass.SchemeFreeProductDetailNew);
        //  LOrealUploadTranslator.orderTransaction(wrapperClass.OrderHeaderNew,wrapperClass.OrderDetailNew,null,null);
    }
    public static testmethod void dreamlisttransaction()
    {
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
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        insert divLoc;
        
        String todayDate = Date.today().format();
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        acc = [select id,ivybase__Internal_Id__c from account where id=:acc.id];
        LorealUploadclass.DreamListInfo dreamList = new LorealUploadclass.DreamListInfo();
        dreamList.Date_x = todayDate;
        dreamList.IsConquest = '';
        dreamList.ProgressPercentage = '80';
        dreamList.Remarks = 'No Remarks';
        dreamList.Rid = String.valueOf(acc.ivybase__Internal_Id__c);
        dreamList.status = 'Test';
        dreamList.SuperWiserFeedBack = 'Test Feedback';
        dreamList.Upload = '';
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.RetailerDreamList = new List<LorealUploadclass.DreamListInfo>{dreamList};
            LOrealUploadTranslator.DreamListTransaction(wrapperClass.RetailerDreamList);
        
    }
    public static testmethod void promotionalPlanning()
    {
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
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        insert divLoc;
        
        String todayDate = Date.today().format();
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        acc = [select id,ivybase__Internal_Id__c from account where id=:acc.id];
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        p1=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p1.id];
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduplotwo',ph.Id,'Testdesc1', false ,'Yes');
        insert p2;
        p2=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p2.id];
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'New_Launch' LIMIT 1].Id;
        pg1.ivybase__Start_Date__c = Date.today();
        pg1.ivybase__End_Date__c = Date.today()+1;
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        List<ivybase__Product_Group_Detail__c> proDetailList = new List<ivybase__Product_Group_Detail__c>{
            new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c=pg1.Id,Market_ISO__c = 'MY',Product_Hierarchy__c=ph.Id,ivybase__Product__c=p1.Id) 
                };
                    insert proDetailList;
        
        LorealUploadclass.PromotionalPlanninginfo promoInfo = new LorealUploadclass.PromotionalPlanninginfo();
        promoInfo.Date_x = todayDate;
        promoInfo.Status = 'D';
        promoInfo.SupervisorComments='Test Comments';
        promoInfo.TId = '12432455235';
        promoInfo.UserId = '';
        
        ivydsd__Scheme__c scheme1 = TestUtility.createTestScheme('TestScheme1','AND','AND','Code1','TestDescription',date.today(),date.today()+1,'QTY','Yes');
        scheme1.Market_ISO__c = 'MY';
        insert scheme1;
        
        ivydsd__Scheme_Group__c sg = new ivydsd__Scheme_Group__c();
        sg.Name = 'TestSchemegroup';
        sg.ivydsd__Scheme__c = scheme1.Id;
        sg.ivydsd__Group_Type__c = 'Get';
        insert sg;
        
        ivydsd__Scheme_Group__c sg1 = new ivydsd__Scheme_Group__c();
        sg1.Name = 'TestSchgrp';
        sg1.ivydsd__Scheme__c = scheme1.Id;
        sg1.ivydsd__Group_Type__c = 'Buy';
        insert sg1;
        
        ivydsd__Scheme_Group_Product__c sgp = new ivydsd__Scheme_Group_Product__c();
        sgp.ivydsd__Scheme_Group__c = sg1.Id;
        sgp.ivydsd__Product1__c = p1.Id;
        insert sgp;
        
        ivydsd__Scheme_Group_Product__c sgp1 = new ivydsd__Scheme_Group_Product__c();
        sgp1.ivydsd__Scheme_Group__c = sg.Id;
        sgp1.ivydsd__Product1__c = p1.Id;
        insert sgp1;
        
        scheme1=[select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c where id=:scheme1.id];
        LorealUploadclass.PromotionalPlanningDetail promoDetail = new LorealUploadclass.PromotionalPlanningDetail();
        promoDetail.pid = String.valueOf(p1.ivybase__InternalId__c);
        promoDetail.Qty = '20';
        promoDetail.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c);
        promoDetail.SchemeId = String.valueOf(scheme1.ivydsd__Internal_Id__c);
        promoDetail.TId = '12432455235';
        promoDetail.Value = '123';
        
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.PromotionalPlanningHeader = new List<LorealUploadclass.PromotionalPlanninginfo>{promoInfo};
            wrapperClass.PromotionalPlanningDetails = new List<LorealUploadclass.PromotionalPlanningDetail>{promoDetail};
                LOrealUploadTranslator.PromotionalPlanningTransaction(wrapperClass.PromotionalPlanningHeader,wrapperClass.PromotionalPlanningDetails,userTerritory);
        
    }
    public static testmethod void competitorTracking()
    {
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
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        insert divLoc;
        
        String todayDate = Date.today().format();
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        acc = [select id,ivybase__Internal_Id__c from account where id=:acc.id];
        
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        //ph.ivybase__Parent__c = phparent.Id;
        //ph.ivybase__Internal_Id__c = 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        p1=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p1.id];
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduplotwo',ph.Id,'Testdesc1', false ,'Yes');
        insert p2;
        p2=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p2.id];
        ivydsd__Scheme__c scheme1 = TestUtility.createTestScheme('TestScheme1','AND','AND','Code1','TestDescription',date.today(),date.today()+1,'QTY','Yes');
        scheme1.Market_ISO__c = 'MY';
        insert scheme1;
        
        scheme1=[select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c where id=:scheme1.id];
        
        
        LorealUploadclass.CompetitorHeaderInfo compHeader = new LorealUploadclass.CompetitorHeaderInfo();
        compHeader.Date_x = todayDate;
        compHeader.Feedback='Feedback';
        compHeader.Remark = 'Test Remark';
        compHeader.RetailerId = string.valueOf(acc.ivybase__Internal_Id__c);
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
        compPhotoDetails.tcompetitorid = String.valueOf(p1.ivybase__InternalId__c);
        compPhotoDetails.Tid='12432455235';
        
        LorealUploadclass.CompetitorDetailsInfo compDetail = new LorealUploadclass.CompetitorDetailsInfo();
        compDetail.avgPrice = '1000';
        compDetail.Comments = 'Test Comments';
        compDetail.contract = 'Contract';
        compDetail.FrqOfEduVisit = '12';
        compDetail.FrqOfRepVisit='10';
        compDetail.pid = String.valueOf(p1.ivybase__InternalId__c);
        compDetail.qty = '10';
        compDetail.qtysize='10';
        compDetail.Rebate = '10';
        compDetail.RetailPrice = '100';
        compDetail.tcompetitorid = string.valueOf(acc.ivybase__Internal_Id__c);
        compDetail.Tid = '12432455235';
        compDetail.TypeOfTraining = 'Test'; 
        
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.CompetitorHeaderNew = new List<LorealUploadclass.CompetitorHeaderInfo>{compHeader};
            wrapperClass.CompetitorPhotoDetailsNew = new List<LorealUploadclass.CompetitorPhotoDetailsInfo>{compPhotoDetails};
                wrapperClass.CompetitorDetailsNew = new List<LorealUploadclass.CompetitorDetailsInfo>{compDetail};
                    LOrealUploadTranslator.CompetitorTrackingTransaction(wrapperClass.CompetitorHeaderNew,wrapperClass.CompetitorDetailsNew,wrapperClass.CompetitorPhotoDetailsNew);
        
    }
    public static testmethod void journeyplan()
    {
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
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        insert divLoc;
        
        String todayDate = Date.today().format();
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        acc = [select id,ivybase__Internal_Id__c from account where id=:acc.id];
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        p1=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p1.id];
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduplotwo',ph.Id,'Testdesc1', false ,'Yes');
        insert p2;
        p2=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p2.id];
        ivydsd__Scheme__c scheme1 = TestUtility.createTestScheme('TestScheme1','AND','AND','Code1','TestDescription',date.today(),date.today()+1,'QTY','Yes');
        scheme1.Market_ISO__c='MY';
        insert scheme1;
        
        scheme1=[select id,ivydsd__Internal_Id__c from ivydsd__Scheme__c where id=:scheme1.id];
        
        JourneyPlan__c journeyplan = new JourneyPlan__c(Tid__c='12432455235',Market_ISO__c='MY',Territory__c=locHr.Id,Date__c=Date.today(),Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Status__c='D');
        insert journeyplan;
        
        
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
        journeyPlanMarket.RetailerId=string.valueOf(acc.ivybase__Internal_Id__c);
        
        LorealUploadclass.JourneyPlanDetailInfo journeyPlanDetail = new LorealUploadclass.JourneyPlanDetailInfo();
        journeyPlanDetail.Comments = 'Test Comments';
        journeyPlanDetail.date_x = todayDate;
        journeyPlanDetail.TId = '12432455235';
        journeyPlanDetail.TypeId = '';
        journeyPlanDetail.WorkWithUserId='';
        
        List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
        List<ivybase__Location_Hierarchy__c> userTerritory1 = LocationMasterService.getUserTerritory(res.Id);
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.JourneyPlanHeader = new List<LorealUploadclass.Journeyplaninfo>{journeyPlanInfo};
            wrapperClass.JourneyPlan_MarketVisitDetail = new List<LorealUploadclass.JorneyMarketMarketVisitDetailInfo>{journeyPlanMarket};
                wrapperClass.JourneyPlanDetail = new List<LorealUploadclass.JourneyPlanDetailInfo>{journeyPlanDetail};
                    wrapperClass.RintinDokoHeader = new LIST<LorealUploadclass.RintinDokoHeaderInfo>{};
                    
                    LOrealUploadTranslator.journeyPlanTransaction(wrapperClass.JourneyPlanHeader,wrapperClass.JourneyPlan_MarketVisitDetail,wrapperClass.JourneyPlanDetail,userTerritory,wrapperClass.RintinDokoHeader);
        
    }
    
    public static testmethod void orderTransaction1()
    {
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        //Id userId = UserInfo.getUserId();
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        UserwiseCountryValues__c settings = UserwiseCountryValues__c.getOrgDefaults();
        settings.Market_ISO__c = 'PH';
        settings.Market_ISO__c = usr.Market_ISO__c;
        settings.SetupOwnerId= userinfo.getUserId();
        insert settings;
        system.debug('settings'+settings);
        ivybase__Resource__c res = TestUtility.createTestResource('Resource', usr.Id, restype.id);
        res.SAP_Id__c='12121212';
        res.Market_ISO__c = usr.Market_ISO__c;
        res.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHrNatnl= TestUtility.createTestLocationHierarchy('Test Location Hierarchy National', res.Id); 
        locHrNatnl.RecordTypeId = RT.get('National').getRecordTypeId();
        locHrNatnl.CurrencyIsoCode = usr.CurrencyIsoCode;
        locHrNatnl.Market_ISO__c = usr.Market_ISO__c;
        insert locHrNatnl;
        system.debug('locHrNatnl '+locHrNatnl);
        
        ivybase__Standard_List_Master__c inoiceStandard = new ivybase__Standard_List_Master__c(ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__List_Name__c='Loreal Professional',ivybase__List_Code__c = 'LP');
        inoiceStandard.ivybase__Resource_Type__c = restype.Id;
        inoiceStandard.ivybase__Location_Hierarchy__c = locHrNatnl.Id;
        insert inoiceStandard;
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c='MY';
        division.Market_ISO__c = usr.Market_ISO__c;
        division.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert division;
        
        res.ivybase__Location_Hierarchy__c = locHrNatnl.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert locHr;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c();
        divLoc.Location_Hierarchy__c=locHr.id;
        divLoc.Division__c=division.id;
        divLoc.Market_ISO__c='MY';
        divLoc.Market_ISO__c = usr.Market_ISO__c;
        divLoc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        ivybase__Product_Hierarchy__c phmainparent = TestUtility.createTestProductHierarchy('Test1','Function', true ,'Yes');
        phmainparent.Market_ISO__c = usr.Market_ISO__c;
        phmainparent.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert phmainparent;
        
        ivybase__Product_Hierarchy__c phparent = TestUtility.createTestProductHierarchy('Test2','Function', true ,'Yes');
        phparent.ivybase__Parent__c = phmainparent.Id;
        phparent.Market_ISO__c = usr.Market_ISO__c;
        phparent.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert phparent;
        
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        ph.ivybase__Parent__c = phparent.Id;
        ph.Market_ISO__c = usr.Market_ISO__c;
        ph.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.Market_ISO__c = usr.Market_ISO__c;
        p1.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert p1;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Piece', ivybase__List_Name__c = 'Piece', ivybase__List_Type__c = 'PRODUCT_UOM',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'CASE', ivybase__List_Name__c = 'CASE', ivybase__List_Type__c = 'PRODUCT_UOM',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'AS_HOST', ivybase__List_Type__c = 'PRODUCT_UOM',ivybase__Location_Hierarchy__c=locHrNatnl.Id,ivybase__Resource_Type__c=restype.Id)
                
                }; 
                    insert stdMasterList;
        
        p1=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p1.id];
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduplotwo',ph.Id,'Testdesc1', false ,'Yes');
        p2.Market_ISO__c = usr.Market_ISO__c;
        p2.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert p2;
        p2=[select id,name,ivybase__InternalId__c from ivybase__Product__c  where id=:p2.id];
        
        ivybase__Product__c p3Bom = TestUtility.createTestProduct('Test Product 1', ph.Id, 'Testdesc1', FALSE ,'Yes');
        p3Bom.Market_ISO__c = usr.Market_ISO__c;
        p3Bom.CurrencyIsoCode = usr.CurrencyIsoCode;
        p3Bom.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Bill_Of_Material_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id; 
        INSERT p3Bom;
        
        String todayDate = Date.today().format();
        LorealUploadclass.OrderHeader orderHead = new LorealUploadclass.OrderHeader();
        orderHead.OrderID = '3123123123123123';
        orderHead.OrderDate = todayDate;
        orderHead.RetailerId = String.valueOf(acc.ivybase__Internal_Id__c);
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
        
        List<ivybase__Standard_List_Master__c> stdMasterList1 = [SELECT Id, Name FROM ivybase__Standard_List_Master__c];
        System.debug('stdMasterList1===>'+stdMasterList1);
        System.debug('stdMasterList1[0].Name===>'+stdMasterList1[0].Name);
        System.debug('stdMasterList1[1].Name===>'+stdMasterList1[1].Name);
        System.debug('stdMasterList1[2].Name===>'+stdMasterList1[2].Name);
        
        LorealUploadclass.OrderDetail orderDetail = new LorealUploadclass.OrderDetail();
        orderDetail.OrderId = '3123123123123123';
        orderDetail.ProductId = String.valueOf(p1.ivybase__InternalId__c);
        orderDetail.Qty='60';
        orderDetail.Rate='100';
        orderDetail.uomcount='60';
        orderDetail.pieceQty='30';
        orderDetail.caseqty='20';
        orderDetail.uomid=stdMasterList1[1].Name;
        orderDetail.totalamount='1000';
        orderDetail.casePrice='200';
        orderDetail.outerPrice='300';
        orderDetail.outerQty='30';
        orderDetail.douomQty='40';
        orderDetail.PcsUomId=stdMasterList1[0].Name;
        orderDetail.douomid=stdMasterList1[2].Name;
        
        LorealUploadclass.OrderDetail orderDetail2 = new LorealUploadclass.OrderDetail();
        orderDetail2.OrderId = '3123123123123123';
        orderDetail2.ProductId = String.valueOf(p2.ivybase__InternalId__c);
        orderDetail2.Qty='60';
        orderDetail2.Rate='100';
        orderDetail2.uomcount='60';
        orderDetail2.pieceQty='30';
        orderDetail2.caseqty='20';
        orderDetail2.uomid=stdMasterList1[1].Name;
        orderDetail2.totalamount='1000';
        orderDetail2.casePrice='200';
        orderDetail2.outerPrice='300';
        orderDetail2.outerQty='30';
        orderDetail2.douomQty='40';
        orderDetail2.PcsUomId=stdMasterList1[0].Name;
        orderDetail2.douomid=stdMasterList1[2].Name;
        
        ivydsd__Scheme__c scheme1 = TestUtility.createTestScheme('TestScheme1','AND','AND','Code1','TestDescription',date.today(),date.today()+1,'QTY','Yes');
        scheme1.Market_ISO__c = 'MY';
        insert scheme1;
        
        List<ivydsd__Scheme__c>  schemeList = [SELECT Id, ivydsd__Internal_Id__c FROM ivydsd__Scheme__c ];
        
        LorealUploadclass.SchemeDetail schemeDetail = new LorealUploadclass.SchemeDetail();
        schemeDetail.OrderID='3123123123123123';  
        schemeDetail.InvoiceID=''; 
        schemeDetail.SchemeID=string.valueOf(schemeList[0].ivydsd__Internal_Id__c); 
        schemeDetail.ProductID=String.valueOf(p2.ivybase__InternalId__c);
        schemeDetail.SchemeType=''; 
        schemeDetail.Value=''; 
        schemeDetail.parentid=''; 
        schemeDetail.SchemeDetailNew=''; 
        schemeDetail.RetailerId=String.valueOf(acc.ivybase__Internal_Id__c); 
        schemeDetail.distributorid=''; 
        schemeDetail.Amount=''; 
        
        LorealUploadclass.SchemeFreeProductDetail freedetail = new LorealUploadclass.SchemeFreeProductDetail();
        freedetail.OrderID='3123123123123123';  
        freedetail.InvoiceID=''; 
        freedetail.SchemeID=string.valueOf(scheme1.ivydsd__Internal_Id__c); 
        freedetail.FreeProductID=String.valueOf(p1.ivybase__InternalId__c);
        freedetail.FreeQty='1';  
        freedetail.UomID=''; 
        freedetail.UomCount=''; 
        freedetail.BatchId='';
        
        LorealUploadclass.OrderPackageDetail packageDetail = new LorealUploadclass.OrderPackageDetail();
        packageDetail.OrderId = '3123123123123123';
        packageDetail.Pid = String.valueOf(p2.ivybase__InternalId__c);
        packageDetail.Bpid = String.valueOf(p3Bom.ivybase__InternalId__c);
        packageDetail.NoOfPackage = '2';
        packageDetail.Mqty = '3';
        packageDetail.RetailerId = String.valueOf(acc.ivybase__Internal_Id__c);
        packageDetail.DivisionId = inoiceStandard.Name;
        packageDetail.PackageType = '1';
        
        LorealUploadclass.MultipleResponseInfo wrapperClass = new LorealUploadclass.MultipleResponseInfo();
        wrapperClass.OrderHeaderNew = new List<LorealUploadclass.OrderHeader>{orderHead};
            wrapperClass.OrderDetailNew = new List<LorealUploadclass.OrderDetail>{orderDetail,orderDetail2};
                wrapperClass.SchemeDetailNew = new List<LorealUploadclass.SchemeDetail>{schemeDetail};
                    wrapperClass.SchemeFreeProductDetailNew = new List<LorealUploadclass.SchemeFreeProductDetail>{freedetail};
                        wrapperClass.OrderPackageDetailNew = new List<LorealUploadclass.OrderPackageDetail>{packageDetail};
                            
                            /*
                             * Remove comment
                              // LOrealUploadTranslator.orderTransaction(wrapperClass.OrderHeaderNew,wrapperClass.OrderDetailNew,wrapperClass.SchemeDetailNew,wrapperClass.SchemeFreeProductDetailNew, wrapperClass.OrderPackageDetailNew);
        					*/
			//  LOrealUploadTranslator.orderTransaction(wrapperClass.OrderHeaderNew,wrapperClass.OrderDetailNew,null,null);
    }
}