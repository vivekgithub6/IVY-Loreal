@istest
public class TestRestSalonFrequencyMapping {
    static testmethod void testmethod1(){
        Id RTId = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId();
        
        List<ivybase__Location_Hierarchy__c> lh = new List<ivybase__Location_Hierarchy__c>{new ivybase__Location_Hierarchy__c(Name = 'Test lh', Market_ISO__c='MY',recordtypeId =RTId,ivybase__Active__c = 'Yes'),
            new ivybase__Location_Hierarchy__c(Name = 'Test lh1',Market_ISO__c='JPN',ivybase__Active__c = 'Yes') };
                insert lh;
        Division__c div = new Division__c(Name='Test Division',Division_Code__c='TEST',Market_ISO__c = 'JPN');
        insert div;
        ivybase__Resource__c res = new ivybase__Resource__c(Name='Resource', Market_ISO__c='JPN', ivybase__Related_User__c = userInfo.getuserId(),ivybase__Location_Hierarchy__c=lh[0].id);
        insert res;
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Account acc = new Account(Name='aaa', Is_Conquest__c = true,Market_ISO__c = 'JPN',recordTypeId=accrecordTypeId, ivybase__Active__c='Yes');
        insert acc;
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        SalonFrequencyDivMapping__c sfd= new SalonFrequencyDivMapping__c();
        sfd.Resource__c=res.id;
        sfd.Salon__c=acc.id;
        sfd.Salon_Frequency__c='5';
        sfd.Division__c=div.id;
        insert sfd;
        Test.startTest();
        RestSalonFrequencyMapping.getSalonFrequencyMasterInfo();
        Test.stopTest();
    }
    
}