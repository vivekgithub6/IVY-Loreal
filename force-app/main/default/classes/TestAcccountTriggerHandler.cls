@isTest
public class TestAcccountTriggerHandler {
    
    
    
    public static testMethod void MethodOne() {
        
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        Id userid = userinfo.getUserId();
        Id RecordTypeId =  Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        Contact con = new Contact(lastName = 'Test', ivybase__Related_User__c = userid,Email = 'test@gmail.com',RecordTypeId =RecordTypeId);
        insert con;
        
        
        ivybase__Resource_Type__c restype1 = new ivybase__Resource_Type__c(name = 'Sales rep');
        insert restype1;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name = 'Test', ivybase__Related_User__c = userid,ivybase__Resource_Type__c=restype1.Id);
        insert resource;
        List<Mag_Classification__c> magClassList = new List<Mag_Classification__c>{
            new Mag_Classification__c(Name='Test MagClass One',Range__c='50-100',Criteria__c='# Of Hair Stylist',Market_ISO__c=usr.Market_ISO__c),
                new Mag_Classification__c(Name='Test MagClass Two',Range__c='100-200',Criteria__c='SERVICE FEE',Market_ISO__c=usr.Market_ISO__c)
                };
                    insert   magClassList;        
        
        List<Salon_Catagory__c> salCategory = new List<Salon_Catagory__c>{
            new Salon_Catagory__c(Name='Test Category',Criteria1__c=magClassList[0].Id,Criteria2__c=magClassList[1].Id,Salon_Catagoty__c='A1',Market_ISO__c=usr.Market_ISO__c)
                };
                    insert salCategory;
                String accRecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();

        List<Account> accList = new List<Account> {
            new Account(Name = 'testone', ivybase__Active__c = 'Yes', ivybase__Resource__c = resource.Id,
                        RecordTypeId=accRecType,Is_Conquest__c=true,Market_ISO__c = usr.Market_ISO__c, No_of_Stylist__c = 1, Color_Price__c = 12)
                                                   
                };
                    insert accList;
        
        for(Account acc : accList) {
            acc.ivybase__Active__c = 'Yes';
        }
        update accList;
        
        
    }
}