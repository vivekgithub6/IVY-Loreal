@isTest
private class TestRESTPromotionalPlan {

    private static testMethod void testPromotinalPlan(){
    
        DateTime TDate = System.now();
        Date todayDate = Date.newinstance(TDate.year(), TDate.month(), TDate.day());
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
            
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Date__c=todayDate.addMonths(1),Target__c=1000.0,Territory__c=locHr.Id,Status__c='Draft',SuperVisorComments__c='Test Comments');
        insert salesForecast;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');     
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.Is_Conquest__c = true;
        insert acc;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(Name='Test Scheme',ivydsd__Scheme_Type__c  ='QTY',ivydsd__Active__c='Yes',ivydsd__Code__c='SCHEME',
                                                         Product_Hierarchy__c=ph.Id,ivydsd__Description__c='Test Description',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c = Date.today().addYears(5),ivydsd__Scheme_Buy_Logic__c='ANY',Market_ISO__c='MY'); 
        insert scheme;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DT', ivybase__List_Name__c = 'Bill', ivybase__List_Type__c = 'DISCOUNT_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DAT', ivybase__List_Name__c = 'Item', ivybase__List_Type__c = 'DISCOUNT_APPLY_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'INVOICE', ivybase__List_Name__c = 'Invoice', ivybase__List_Type__c = 'DISCOUNT_MODULE_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
               
                }; 
        insert stdMasterList;
        
        
        
        Sales_Forecast_Detail__c salesForeCastDetail  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList[0].Id,Store__c=acc.Id,Target__c=1000);
        insert salesForeCastDetail;
                
        Test.startTest();
        RESTPromotionalPlan.getpromotionplanMasterInfo();
        PromotionalPlanningService.getPromotions_Resource();
        PromotionalPlanningService.getpromotionalPlan();
        PromotionalPlanningService.getApprovedPromotionalPlan();
        Test.stopTest();
    }

}