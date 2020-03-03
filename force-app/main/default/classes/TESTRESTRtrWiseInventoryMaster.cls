@isTest
public class TESTRESTRtrWiseInventoryMaster {
    private static testMethod void testRtwWiseP4Order(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Is_Conquest__c = true;
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
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Suggested_Quantity__c sq = new ivydsd__Suggested_Quantity__c();
        sq.Name = 'testsq';
        sq.ivydsd__Product__c = p1.Id;
        sq.ivydsd__Quantity__c = 12;
        sq.ivydsd__Retailer__c = acc.Id;
        insert sq;
        
        ivydsd__Suggested_Quantity__c sqt = new ivydsd__Suggested_Quantity__c();
        sqt.Name = 'testsqt';
        sqt.ivydsd__Product__c = p1.Id;
        sqt.ivydsd__Retailer__c = acc.Id;
        insert sqt;
        
        RExAPIResponseDomain.ResponseInfo resp = RESTRtrWiseInventoryMaster.getRtrWiseInventoryMaster();
        system.assert(resp != null);
        
        try{
                 RExAPIResponseDomain.ResponseInfo res1 = RESTRtrWiseInventoryMaster.getRtrWiseInventoryMaster();
            }catch(Exception e){}
            
            try{
                 SuggestedQuantityService.getAllSuggesqty();
            }catch(Exception e){}
    }

}