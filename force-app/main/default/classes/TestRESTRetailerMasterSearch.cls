@isTest
public class TestRESTRetailerMasterSearch {
    
    public static TestMethod void MethodOne() {
        
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
        insert locHr;
        
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = usr.Market_ISO__c);
        div.Market_ISO__c = usr.Market_ISO__c;
        div.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert div;
        
        ivybase__Store_Hierarchy__c channel = new ivybase__Store_Hierarchy__c(Name = 'store Channel',Division__c = div.Id,Market_ISO__c =  usr.Market_ISO__c);
        channel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Channel').getRecordTypeId();
        channel.Market_ISO__c = usr.Market_ISO__c;
        channel.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert channel;
        ivybase__Store_Hierarchy__c subChannel = new ivybase__Store_Hierarchy__c(Name = 'store Sub Channel',ivybase__Parent__c=channel.Id,Market_ISO__c =  usr.Market_ISO__c);
        subChannel.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Channel').getRecordTypeId();
        subChannel.Market_ISO__c = usr.Market_ISO__c;
        subChannel.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert subChannel;
        ivybase__Store_Hierarchy__c node3 = new ivybase__Store_Hierarchy__c(Name = 'store Node3',ivybase__Parent__c=subChannel.Id,Market_ISO__c =  usr.Market_ISO__c);
        node3.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node3').getRecordTypeId();
        node3.Market_ISO__c = usr.Market_ISO__c;
        node3.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert node3;
        ivybase__Store_Hierarchy__c node4 = new ivybase__Store_Hierarchy__c(Name = 'store Node4',ivybase__Parent__c=node3.Id,Market_ISO__c =  usr.Market_ISO__c);
        node4.RecordTypeId = Schema.SObjectType.ivybase__Store_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Node4').getRecordTypeId();
        node4.Market_ISO__c = usr.Market_ISO__c;
        node4.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert node4;
        
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        acc.ivybase__Store_Hierarchy__c =node4.Id;
        acc.Market_ISO__c = usr.Market_ISO__c;
        acc.CurrencyIsoCode = usr.CurrencyIsoCode;
        
        insert acc;
        
        
        
        RetailerMasterSearchClass.PostInformation postInfo = new RetailerMasterSearchClass.PostInformation();
        postInfo.SearchText = 'Test';
        LIST<String> stList = new LIST<String>{'Name','Node2'};
		postInfo.SearchType = stList;
        
        String JSONString = Json.Serialize(postInfo);
        System.Debug('******JSONString'+JSONString);
        
        RestRequest req = new RestRequest(); 
        req.requestBody = Blob.valueOf(JSONString);
        RestContext.request =req ;
        
        Test.startTest();
        RESTRetailerMasterSearch.returnHandler();
        PostResponse postRes = new PostResponse();
        Test.stopTest();
        
    }
    
    
}