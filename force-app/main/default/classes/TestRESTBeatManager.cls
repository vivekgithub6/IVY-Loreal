@isTest
public class TestRESTBeatManager {
   
    public static testMethod Void testBeatMng() {
        ivybase__Resource_Type__c restyp = TestUtility.createTestResourceType('Merchandiser');
        insert restyp;
        
        
        
        ivybase__Resource__c res =  new ivybase__Resource__c();
        res.ivybase__Related_User__c = UserInfo.getUserId();
        res.name = 'Test';
        res.ivybase__Resource_Type__c = restyp.Id;
        res.Market_ISO__c = 'MY';
        insert res;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Dream_List__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        
        
        ivybase__Location_Hierarchy__c locHier = new ivybase__Location_Hierarchy__c();
        locHier.name = 'Test';
        locHier.RecordTypeId = [select Id from RecordType where DeveloperName = 'Territory' LIMIT 1].Id;
        locHier.ivybase__Primary_Resource__c = res.Id;
        locHier.ivybase__Resource_Type__c = restyp.Id;
        locHier.Market_ISO__c = 'MY';
        insert locHier;
        
        
        
        ivybase__Route__c rt = new ivybase__Route__c();
        rt.ivybase__Description__c = 'description Test';
        rt.ivybase__Active__c = 'Yes';
        rt.Location_Hierarchy_Territory__c = locHier.Id;
        rt.ivybase__Resource__c = res.Id;
        insert rt;
        
        Territory_Routing__c tr = new Territory_Routing__c();
        tr.Location_Hierarchy__c = locHier.id;
        tr.Route__c  = rt.id;
        tr.Market_ISO__c = 'SG';
        insert tr; 
        
        LocationMasterService.getCurrentUserTerritory(res.Id);
        
        RExAPIResponseDomain.ResponseInfo resp = RESTBeatManager.getBeatInfo();
        system.assert(resp != null);
        
        Test.startTest();
        
                RExAPIResponseDomain.ResponseInfo resp1 = RESTBeatManager.getBeatInfo();
               RouteTranslator rto = new RouteTranslator();
                RouteTranslator.getTodayField('12/15/15');
        Test.stopTest();
       }
}