@isTest
public class JourneyPlanActivityTriggerTest
{
    static testMethod void JourneyPlanActivityTriggerTest()
    {
        id userId = userInfo.getUserId();
        
        User UserRecord = [SELECT ID, Market_Iso__c, CurrencyIsoCode FROM USER WHERE Id =: userId LIMIT 1];
        
        
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        restype.CurrencyIsoCode = UserRecord.CurrencyIsoCode;
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=UserRecord.Id,Market_ISO__c = UserRecord.Market_ISO__c);
        resource.ivybase__Resource_Type__c = restype.Id;
        resource.Market_ISO__c = UserRecord.Market_ISO__c;
        resource.CurrencyIsoCode = UserRecord.CurrencyIsoCode;
        insert resource;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = UserRecord.Market_ISO__c,RecordTypeId=RT.get('Territory').getRecordTypeId(),ivybase__Primary_Resource__c=resource.Id);
        location.Market_ISO__c = UserRecord.Market_ISO__c;
        location.CurrencyIsoCode = UserRecord.CurrencyIsoCode;
        insert location;
        
        
        List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Rinten',ivybase__List_Code__c='Rinten',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Doko',ivybase__List_Code__c='Doko',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Business Visit',ivybase__List_Code__c='Business Visit',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Other',ivybase__List_Code__c='Other',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id)
            //new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Rinten',ivybase__List_Code__c='Rinten',ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = location.Id, ivybase__Resource_Type__c = ResType.Id)
             
                
                };
        insert standardmaster;
          
        Map<String, Schema.RecordTypeInfo> RT2 = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        ivybase__Location_Hierarchy__c nationalLoc = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = UserRecord.Market_ISO__c,ivybase__Secondary_Resource__c=resource.Id,RecordTypeId=RT2.get('National').getRecordTypeId(),ivybase__Active__c='Yes',ivybase__Primary_Resource__c=resource.Id);
        insert nationalLoc;
        ivybase__Location_Hierarchy__c regionalLoc = new ivybase__Location_Hierarchy__c(Name='Test Regional',Market_ISO__c = UserRecord.Market_ISO__c,ivybase__Secondary_Resource__c=resource.Id,ivybase__Parent__c=nationalLoc.Id,RecordTypeId=RT2.get('Regional').getRecordTypeId(),ivybase__Active__c='Yes',ivybase__Primary_Resource__c=resource.Id);
        insert regionalLoc;
        ivybase__Location_Hierarchy__c areaLoc = new ivybase__Location_Hierarchy__c(Name='Test Area',Market_ISO__c = UserRecord.Market_ISO__c,ivybase__Secondary_Resource__c=resource.Id,ivybase__Parent__c=regionalLoc.Id,RecordTypeId=RT2.get('Area').getRecordTypeId(),ivybase__Active__c='Yes',ivybase__Primary_Resource__c=resource.Id);
        insert areaLoc;
        ivybase__Location_Hierarchy__c location2 = new ivybase__Location_Hierarchy__c(Name='Test Territory2',Market_ISO__c = UserRecord.Market_ISO__c,ivybase__Secondary_Resource__c=resource.Id,ivybase__Parent__c=areaLoc.Id,ivybase__Active__c='Yes',RecordTypeId=RT.get('Territory').getRecordTypeId(),ivybase__Primary_Resource__c=resource.Id);
        insert location2; 
        
        Date myDate = Date.newInstance(2018,6,6);
        List<JourneyPlan__c> journeyplan = new List<JourneyPlan__c>{
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = UserRecord.Market_ISO__c,Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted')
            };   
        Database.insert(journeyplan);
        
        JourneyPlan__c insertedJourneyPlan = [SELECT Id FROM JourneyPlan__c LIMIT 1];
        LIST<ivybase__Standard_List_Master__c> stdList = [SELECT Id, ivybase__List_Name__c FROM ivybase__Standard_List_Master__c];
        
       
        ivybase__Resource_Type__c rType  = [SELECT Id FROM ivybase__Resource_Type__c limit 1];
        
        LIST<JourneyPlanActivity__c> jpList = new LIST<JourneyPlanActivity__c>();
        
        for(ivybase__Standard_List_Master__c std: stdList) {
            JourneyPlanActivity__c jpa = new JourneyPlanActivity__c();
            jpa.JourneyPlan__c = insertedJourneyPlan.Id;
            jpa.TypeId__c = std.Id;
            jpList.add(jpa);
        }
        
        database.insert(jpList);
        
    }
}