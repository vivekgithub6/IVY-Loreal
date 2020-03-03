@isTest
public class TestRestClassFrequencyMaster {
    static testmethod void testmethod1(){
        Id RTId = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId();
        
        List<ivybase__Location_Hierarchy__c> lh = new List<ivybase__Location_Hierarchy__c>{new ivybase__Location_Hierarchy__c(Name = 'Test lh', Market_ISO__c='MY',recordtypeId =RTId,ivybase__Active__c = 'Yes'),
            new ivybase__Location_Hierarchy__c(Name = 'Test lh1',Market_ISO__c='MY',ivybase__Active__c = 'Yes') };
        insert lh;
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name='Resource', Market_ISO__c='MY', ivybase__Related_User__c = userInfo.getuserId(),ivybase__Location_Hierarchy__c=lh[0].id);
        insert res;
        Class_Frequency__c c=new Class_Frequency__c(Name='A',Frequency__c=4, Market_ISO__c='MY', FrequencyForLocation__c=lh[0].id,Color_Code__c='2#3AN');
        insert c;
        try{
            RestClassFrequencyMaster.getClassFrequencyMasterInfo();
            c.Name='';
            c.Frequency__c=Null;
            c.Color_Code__c='';
            update c;
            RestClassFrequencyMaster.getClassFrequencyMasterInfo();
        }catch(Exception e){}
    }
    static testmethod void testmethod2(){
        RestClassFrequencyMaster.getClassFrequencyMasterInfo();
    }
}