/********************************/
/* Created By      : Gayathri.D
/* Date            : 17-02-2020
 * Covered Classes : SalonDataTranslator,RestSaloonDataBasedOnRequest,SalonDataservice
/* ******************************/

@isTest
public class TestRestSaloonDataBasedOnRequest {
    
    public static testMethod Void methodOne(){
        
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        restype.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=usr.Id,Market_ISO__c = usr.Market_ISO__c);
        resource.ivybase__Resource_Type__c = restype.Id;
        resource.Market_ISO__c = usr.Market_ISO__c;
        resource.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert resource;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',resource.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = usr.Market_ISO__c;
        locHr.CurrencyIsoCode = usr.CurrencyIsoCode;
        locHr.ivybase__Primary_Resource__c = resource.id;
        insert locHr;
        
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = usr.Market_ISO__c);
        div.Market_ISO__c = usr.Market_ISO__c;
        div.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert div;
        
        DivisionLocation__c divLoc = TestUtility.createdivisionLocation(div.id,locHr.id);
        insert divLoc;
        
      
    
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.Location_Hierarchy__c = locHr.Id;
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Internal_Id__c = 1;
        acc.ivybase__Active__c ='Yes';
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        //acc.ivybase__Parent_Branch__c =parentBranch.id;
        insert acc;
        
        Account acc1 = [SELECT Id,ivybase__Internal_Id__c,ivybase__Active__c FROM Account where ivybase__Internal_Id__c = 1];
        acc.Location_Hierarchy__c = locHr.Id;
        acc1.ivybase__Active__c ='Yes';
        acc1.IsFocus__c = true;
        acc1.IsAgent__c = true;
        //acc1.Is_Conquest__c = true;
        update acc1;
        
        ivybase__Visit__c  visit = TestUtility.createTestVisit(system.today(),acc1.id,'Planned');
        insert visit;
       
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Billto', ivybase__List_Name__c = 'Billing Address', ivybase__List_Type__c = 'ADDRESS_TYPE',ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Shipo', ivybase__List_Name__c = 'Shipping Adress', ivybase__List_Type__c = 'LUXURY_MAG',ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Shipo', ivybase__List_Name__c = 'SoldTo Address', ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Channel', ivybase__List_Name__c = 'Channel', ivybase__List_Type__c = 'CHANNEL_HIERARCHY',ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'CASH', ivybase__List_Name__c = 'CASH', ivybase__List_Type__c = 'RETAILER_TYPE',ivybase__Resource_Type__c=restype.Id)
                }; 
        insert stdMasterList;
        
        RetailerMasterSearchClass.PostIds postRetailerId = new RetailerMasterSearchClass.PostIds();
        List<String> retailerIds = new List<String>{String.ValueOf(acc.ivybase__Internal_Id__c)};
        postRetailerId.RETAILERID = retailerIds;
        
        String JSONString = Json.Serialize(postRetailerId);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        
        Test.startTest();
        RestSaloonDataBasedOnRequest.getRetailerInfo();
        //PostResponse postRes = new PostResponse();
        Test.stopTest();
    }
}