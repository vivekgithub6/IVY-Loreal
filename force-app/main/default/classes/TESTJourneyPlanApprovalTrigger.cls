@isTest
public class TESTJourneyPlanApprovalTrigger {
    public static testMethod void approvalTest(){
        
        id userId = userInfo.getUserId();
          
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=userId, Market_ISO__c = 'MY');
        insert resource;
        
        ivybase__Resource__c resource1 = new ivybase__Resource__c(Name='Test Res1', Market_ISO__c = 'MY');
        insert resource1;
        
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
        List<JourneyPlan__c> journeyplan = new List<JourneyPlan__c>{
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted'),
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted'),
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted')
                };   
        insert journeyplan;
       JourneyPlanApprovalTriggerHandler.ApproveOrReject(journeyplan[0].id,'Approve','Test');
       }
       
       public static testMethod void approvalTest1(){
        
        id userId = userInfo.getUserId();
          
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name='Test ResType');
        insert restype;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name='Test Res',ivybase__Related_User__c=userId, Market_ISO__c = 'MY');
        insert resource;
        
        ivybase__Resource__c resource1 = new ivybase__Resource__c(Name='Test Res1', Market_ISO__c = 'MY');
        insert resource1;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        ivybase__Location_Hierarchy__c nationalLoc = new ivybase__Location_Hierarchy__c(Name='Test National',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource1.Id, ivybase__Secondary_Resource_From_Date__c=Date.today(),ivybase__Secondary_Resource_To_Date__c=Date.today().addDays(+30),RecordTypeId=RT.get('National').getRecordTypeId(),ivybase__Active__c='Yes');
        insert nationalLoc;
        ivybase__Location_Hierarchy__c regionalLoc = new ivybase__Location_Hierarchy__c(Name='Test Regional',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource1.Id, ivybase__Secondary_Resource_From_Date__c=Date.today(),ivybase__Secondary_Resource_To_Date__c=Date.today().addDays(+30),ivybase__Parent__c=nationalLoc.Id,RecordTypeId=RT.get('Regional').getRecordTypeId(),ivybase__Active__c='Yes');
        insert regionalLoc;
        ivybase__Location_Hierarchy__c areaLoc = new ivybase__Location_Hierarchy__c(Name='Test Area',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource1.Id,ivybase__Secondary_Resource_From_Date__c=Date.today(),ivybase__Secondary_Resource_To_Date__c=Date.today().addDays(+30),ivybase__Parent__c=regionalLoc.Id,RecordTypeId=RT.get('Area').getRecordTypeId(),ivybase__Active__c='Yes');
        insert areaLoc;
        ivybase__Location_Hierarchy__c location = new ivybase__Location_Hierarchy__c(Name='Test Territory',Market_ISO__c = 'MY',ivybase__Secondary_Resource__c=resource.Id,ivybase__Secondary_Resource_From_Date__c=Date.today(),ivybase__Secondary_Resource_To_Date__c=Date.today().addDays(+30),ivybase__Parent__c=areaLoc.Id,ivybase__Active__c='Yes',RecordTypeId=RT.get('Territory').getRecordTypeId(),ivybase__Primary_Resource__c=resource.Id);
        insert location; 
        
        Date myDate = Date.newInstance(2018,6,6);
        List<JourneyPlan__c> journeyplan = new List<JourneyPlan__c>{
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted'),
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted'),
            new JourneyPlan__c(Tid__c='8',Market_ISO__c = 'MY',Date__c=myDate,Month__c=7,Year__c=7,SupervisorComments__c='Test Comments',Territory__c=location.Id,Status__c='Submitted')
                };   
        insert journeyplan;
       }
}