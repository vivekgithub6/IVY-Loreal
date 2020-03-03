@isTest
public class UserController_Test {
    
    public static testMethod void testRunAs() {
        // Setup test data
        // Create a unique UserName
       // String uniqueUserName = 'standarduserGFASFa@testorg.com';
        // This code runs as the system user
        /*Profile p = [SELECT Id FROM Profile where Name = 'Sales_Rep_ARGO'];
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = TestUtility.insertMaxInternalId();
        
        User u = new User(Alias = 'Testuser', Email='TestuserChatter@testorg.com',
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing001', 
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          ProfileId = p.id,
                          TimeZoneSidKey='America/Los_Angeles',
                          Market_ISO__c = 'MY',
                          UserName='TestuserChatter@testorg.com',
                          ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c);*/
        
        User u = TestUtility.getBAUser();
        
        insert u ;
       
       
        
    }
    public static testmethod void testRunAs1() {
        // Setup test data
        // Create a unique UserName
       // String uniqueUserName = 'standarduserGFASFa@testorg.com';
        // This code runs as the system user
        /*Profile p = [SELECT Id FROM Profile where Name = 'Sales_Rep_ARGO'];
        
        List<ivybase__Max_Internal_Id_Value__c> maxInternalIdValList = TestUtility.insertMaxInternalId();
        
        User u = new User(Alias = 'Testuser', Email='TestuserChatter@testorg.com',
                          EmailEncodingKey='UTF-8', 
                          LastName='Testing001', 
                          LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', 
                          ProfileId = p.id,
                          TimeZoneSidKey='America/Los_Angeles',
                          Market_ISO__c = 'MY',
                          UserName='TestuserChatter@testorg.com',
                          ivybase__Internal_Id__c = maxInternalIdValList[0].ivybase__Max_Internal_Id__c);*/
        
        User u = TestUtility.getSRUser();
        
        insert u ;
        u.Market_ISO__c='MY';
        UserwiseCountryValues__c  mc = UserwiseCountryValues__c.getInstance(u.id);
         system.debug('mc******'+mc);

        update u;
       
        
    }
}