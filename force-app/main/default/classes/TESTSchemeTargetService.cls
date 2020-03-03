@isTest
public class TESTSchemeTargetService {
    private static testMethod void testSchemeTarget(){
         id userId = userInfo.getUserId();
          
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=userId,Market_ISO__c = 'MY');
        insert resource;
        
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        ivybase__Location_Hierarchy__c nationalLoc = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource.Id,RecordTypeId=RT.get('National').getRecordTypeId(),ivybase__Active__c='Yes',ivybase__Primary_Resource__c=resource.Id);
        insert nationalLoc;
        ivybase__Location_Hierarchy__c regionalLoc = new ivybase__Location_Hierarchy__c(Name='Test Regional',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource.Id,ivybase__Parent__c=nationalLoc.Id,RecordTypeId=RT.get('Regional').getRecordTypeId(),ivybase__Active__c='Yes',ivybase__Primary_Resource__c=resource.Id);
        insert regionalLoc;
        ivybase__Location_Hierarchy__c areaLoc = new ivybase__Location_Hierarchy__c(Name='Test Area',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource.Id,ivybase__Parent__c=regionalLoc.Id,RecordTypeId=RT.get('Area').getRecordTypeId(),ivybase__Active__c='Yes',ivybase__Primary_Resource__c=resource.Id);
        insert areaLoc;
        
        
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource.Id,ivybase__Parent__c=areaLoc.Id,ivybase__Active__c='Yes',RecordTypeId=RT.get('Territory').getRecordTypeId(),ivybase__Primary_Resource__c=resource.Id);
        insert location; 
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = location.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Description__c='Test Description',
                                                         ivydsd__Code__c='TEST',ivydsd__Scheme_Buy_Logic__c='AND',ivydsd__From__c=Date.today(),
                                                         Product_Hierarchy__c=ph.Id,ivydsd__Scheme_Get_Logic__c='AND',ivydsd__To__c=Date.today().addDays(15),
                                                         Name='Test Promotion',ivydsd__Scheme_Type__c='QTY',Market_ISO__C='MY');
        insert scheme;
        
        
        Date myDate = Date.newInstance(2018,6,6);
        List<Sales_Forecast__c> salesforecast = new List<Sales_Forecast__c>{
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().month()),Target__c=700,Territory__c=location.Id,Status__c='Submitted',Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id),
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().addmonths(1).month()),Target__c=705,Territory__c=location.Id,Status__c='Draft',Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id),
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().addmonths(2).month()),Target__c=720,Territory__c=location.Id,Status__c='Submitted',Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id)
                };   
        insert salesforecast;
        
        Sales_Forecast_Detail__c SFDetail = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Sales_Forecast__c=salesforecast[0].Id,Store__c=acc.Id,Scheme__c=scheme.Id);
        insert SFDetail;
        
        Scheme_Target__c proTarget = new Scheme_Target__c(Scheme__c=scheme.Id,Sales_Forecast_Detail__c=SFDetail.Id,Quantity__c=20,Target__c=50,Name='Test Target');
        insert proTarget;
        Set<Id> targetIds = new Set<Id>();
        targetIds.add(SFDetail.Id);
        
        SchemeTargetService.getSchemeTargetDetails(targetIds);
        
        
    }

}