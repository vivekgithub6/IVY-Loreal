@isTest
public class TestRESTHolidayMaster {
    static testmethod void testmethod1(){
        
        ivybase__Resource_Type__c resType = new ivybase__Resource_Type__c(Name='Test ResType');
        insert resType;
        
        Id RTId = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId();
        
        List<ivybase__Location_Hierarchy__c> lh = new List<ivybase__Location_Hierarchy__c>{new ivybase__Location_Hierarchy__c(Name = 'Test lh', Market_ISO__c = 'MY',recordtypeId =RTId,ivybase__Resource_Type__c=restype.Id,ivybase__Active__c = 'Yes'),
            new ivybase__Location_Hierarchy__c(Name = 'Test lh1',ivybase__Active__c = 'Yes',Market_ISO__c = 'MY') };
        insert lh;
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name='Resource',  Market_ISO__c = 'MY', ivybase__Related_User__c = userInfo.getuserId(),ivybase__Location_Hierarchy__c=lh[0].id,ivybase__Resource_Type__c=restype.Id);
        insert res;
        
        ivybase__Holiday__c holiday=new ivybase__Holiday__c();
        holiday.name='Ramzan';
        holiday.ivybase__End__c=system.today()+2;
        holiday.ivybase__Start__c=system.today()+1;
        holiday.ivybase__Description__c='Ramzan';
        holiday.Location_Hierarchy__c=lh[0].id;
        holiday.Market_ISO__c = 'MY';
        insert holiday;
        try{
            RESTHolidayMaster.getHolidayMasterInfo();
        }catch(Exception e){}
    }
    static testmethod void testmethod2(){
        RESTHolidayMaster.getHolidayMasterInfo();
    }
}