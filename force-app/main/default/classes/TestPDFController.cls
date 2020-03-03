@isTest
public class TestPDFController {

    public static TestMethod void PdfControllerMethodOne(){
        
        //id currentUserId= userinfo.getUserId();
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
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
        
        ivybase__Resource__c res = TestUtility.createTestResource('Resource', usr.Id, restype.id);
        res.SAP_Id__c = '12345';
        res.ivybase__Related_User__c = usr.Id;
        res.ivybase__Location_Hierarchy__c = locHrNatnl.Id;
        insert res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert locHr;
        
        Division__c  division = new Division__c (name='Loreal Professional', Market_ISO__c= usr.Market_ISO__c);
        division.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = usr.Market_ISO__c);
        divLoc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Conquest__c = true;
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert acc;
        acc.ivybase__Active__c='Yes';
        acc.Converted_to_Normal_Saloon__c = true;
        update acc;
        
        Contact con1 = TestUtility.createTestContact('Test','Buddy', usr.Id , usr.currencyIsoCode, 'testBuddy@salesforce.com',
                                                     NULL, 'Retailer_Contact' );
        insert con1;  
        
        JourneyPlan__c journeyPlan = new JourneyPlan__c();
        journeyPlan.Year__c = system.today().year();
        journeyPlan.Tid__c='555';
        journeyPlan.Territory__c=locHr.id;
        journeyPlan.Status__c='Draft';
        journeyPlan.Month__c=system.today().month();
        journeyPlan.SupervisorComments__c='Test Comments';
        journeyPlan.Date__c = system.today();
        journeyPlan.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlan.Market_ISO__c = usr.Market_ISO__c;
        insert journeyPlan;
        
        Rintin_Plan__c rintinPlan1 = TestUtility.createRintinPlan(journeyPlan.Id);
        rintinPlan1.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert rintinPlan1;
        
        RintinDokoVisitActual__c rdvActual = new RintinDokoVisitActual__c ( Training_Name__c='Test Training', Date__c=system.today(), Rintin_Plan__c=rintinPlan1.Id);
        insert rdvActual;
        
        RintinDokoVisitDetail__c rdvDetail = new RintinDokoVisitDetail__c (RintinDokoVisitActual__c=rdvActual.Id, Hair_Dresser__c=con1.Id);
        insert rdvDetail;
        
        PDFController controllerInstance = new PDFController();
        controllerInstance.detailId = rdvDetail.Id;
        controllerInstance.getPDFValues();
    }
}