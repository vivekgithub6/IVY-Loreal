@isTest
public class TESTSecurityUtility {
    private static testMethod void testSecUtility(){
        String[] ck2Fields = new String[] {'ivybase__Internal_Id__c', 'ivybase__StoreCode__c','BillingStreet', 'ivybase__Customer_Category__c', 'BillingCity',
            'BillingState', 'BillingPostalCode', 'ivybase__Credit_Limit__c', 'ivybase__TIN_Number__c', 'ShippingStreet', 
            'ShippingCity', 'ivybase__Store_Hierarchy__c', 'ShippingState', 'ShippingPostalCode', 'ivybase__Contact_Email__c',
            'ivybase__Contact_PhoneNo__c','Price_List__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Credit_Period__c', 'Phone', 'Fax', 'ivybase__Lat_and_Long__c',
            'ivybase__Lat_and_Long__latitude__s', 'ivybase__Lat_and_Long__longitude__s','ivybase__Visit_Plan__c','ivybase__Seller_Name__c','ivybase__Resource__c','ivybase__Image_Path__c',
            'ivybase__Image_Name__c','ivybase__Last_Visit__c','Location_Hierarchy__c',  'AccountNumber','ivybase__Second_LastVisit__c','Is_Dream_List__c','Converted_to_Normal_Saloon__c','Is_Conquest__c','Payer_Code__c','Phone','Kerastase_Luxury_Mag__c',
            'Salon_Person_Contact_Code__c','Due_Amount__c','Store_Address__c','Remarks__c','Last_Visit_Date__c'};
                
                
       Test.startTest();
        SecurityUtility.checkIsAccessible('Account',ck2Fields);
        SecurityUtility.checkIsCreateable('Account',ck2Fields);
        SecurityUtility.checkIsEditable('Account',ck2Fields);
        SecurityUtility.checkIsDeletable('Account');
        new SecurityUtility.ExtSFDCAccessControlException('INSUFFICIENT_PERMISSIONS','PERMISSIONS','Account');
        Test.stopTest();
    }

}