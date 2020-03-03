@isTest
public class TESTSalesforecastingTrigger {

    public static testMethod void approvalTest(){
        
        id userId = userInfo.getUserId();
          
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=userId, Market_ISO__c = 'MY');
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
        
        Date myDate = Date.newInstance(2018,6,6);
        List<Sales_Forecast__c> salesforecast = new List<Sales_Forecast__c>{
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().month()),Target__c=700,Territory__c=location.Id,Status__c='Submitted',  Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id),
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().addmonths(1).month()),Target__c=705,Territory__c=location.Id,Status__c='Draft', Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id),
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().addmonths(2).month()),Target__c=720,Territory__c=location.Id,Status__c='Submitted', Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id)
        };   
        insert salesforecast;
        salesforecast[1].Status__c = 'Submitted';
        update salesforecast[1];
        salesforecast[2].Status__c = 'Approved';
        update salesforecast[2];
        
    }
    
    public static testMethod void approvalTest1 (){
        
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
        
        Date myDate = Date.newInstance(2018,6,6);
        List<Sales_Forecast__c> salesforecast = new List<Sales_Forecast__c>{
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().month()),DummyUpdate__c='Approved',Target__c=700,Territory__c=location.Id,Status__c='Submitted', Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id),
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().addmonths(1).month()),DummyUpdate__c='Rejected',Target__c=705,Status__c='Draft', Year__c = string.valueOF(system.today().year()), Resource__c = resource.Id),
            new Sales_Forecast__c(Date__c=Date.today(),Month__c=String.valueOf(Date.today().addmonths(2).month()),DummyUpdate__c='Rejected',Target__c=720,Territory__c=location.Id,Status__c='Submitted', Year__c = string.valueOF(system.today().year()),Resource__c = resource.Id)
        };   
        insert salesforecast;
        
        salesforecast[1].DummyUpdate__c = 'Rejected';
        update salesforecast[1];
        salesforecast[2].DummyUpdate__c = 'Approved';
        update salesforecast[2];
        salesforecast[2].DummyUpdate__c = 'Approved';
        update salesforecast[2];
    }
}