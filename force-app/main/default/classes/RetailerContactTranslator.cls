public class RetailerContactTranslator {
 public static RExAPIResponseDomain.ResponseInfo TranslateContactsToJson(list<contact> contactlist,string errorcode){
           RExAPIResponseDomain.ResponseInfo RetailerHairdresserResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerHairdresserResponce.Master = 'HairDresserMaster';
        RetailerHairdresserResponce.Field = new List<String> {'RetailerId','HairdresserId','Hairdressercode','HairdresserName','EmailId','Experience','MobileNo','Signature','Privacy','SocialMediaId'};
        RetailerHairdresserResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerHairdresserResponce.Next = '0'; 
         List<List<String>> retailerContacts = new List<List<String>>();
     try{  
     for (contact con:contactlist) {
                 List<String> retailerContact = new List<String>();
             retailerContact.add(String.valueOf(con.Account.ivybase__Internal_Id__c) != null ? String.valueOf(con.Account.ivybase__Internal_Id__c) : '');//retailerid
                 retailerContact.add(String.valueOf(con.Internal_Id__c) != null ? String.valueOf(con.Internal_Id__c) : '');//hairdresserId
                retailerContact.add(con.Contact_Code__c != null ? con.Contact_Code__c : '');//hairdresserCode
                      retailerContact.add(con.name != null ? con.name : '');//name
           retailerContact.add(con.Email != null ? con.Email : '');//Email
                retailerContact.add(String.valueOf(con.Experience__c) != null ? String.valueOf(con.Experience__c) : '');//experience
                retailerContact.add(con.MobilePhone != null ? con.MobilePhone : '');//MobilePhone
                retailerContact.add(con.Signature__c != null ? con.Signature__c : '');//Signature
          retailerContact.add(String.valueOf(con.Privacy__c) != null ? String.valueOf(con.Privacy__c) : '');//Privacy
           retailerContact.add(con.Social_Media_Id__c != null ? con.Social_Media_Id__c : '');//SocialMediaId
             retailerContacts.add(retailerContact);
             }
         RetailerHairdresserResponce.data=retailerContacts;
     }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
        return RetailerHairdresserResponce;
    
}
     public static RExAPIResponseDomain.ResponseInfo TranslateConquestToJson(list<Partner_Function__c> partnerList,string errorcode){
        RExAPIResponseDomain.ResponseInfo RetailerHairdresserResponce = new RExAPIResponseDomain.ResponseInfo();
        RetailerHairdresserResponce.Master = 'Retailercontact';
        RetailerHairdresserResponce.Field = new List<String> {'RetailerId','contactname','ContactNumber','CPID','IsPrimary','dob','contact_title',
            'contact_title_lovid','contactname_LName'};
                RetailerHairdresserResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerHairdresserResponce.Next = '0'; 
        List<List<String>> retailerContacts = new List<List<String>>();
        try{  
            for (Partner_Function__c partner:partnerList) {
                List<String> retailerContact = new List<String>();
                if(partner.Account__c != NULL && partner.Account__r.ivybase__Internal_Id__c != null) {
                    retailerContact.add(String.valueOf(partner.Account__r.ivybase__Internal_Id__c));//RetailerId
                } else {
                    retailerContact.add('');//RetailerId blank
                }
                
                retailerContact.add(partner.Partner__r.Name);//resourcename
                retailerContact.add('');//resourceNumber
                retailerContact.add('');//CPID
                retailerContact.add('');//IsPrimary
                retailerContact.add('');//dob blank
                
                retailerContact.add('');//resource_title
                retailerContact.add('');//resource_title_lovid
                retailerContact.add('');//resourcename_LName
                
                retailerContacts.add(retailerContact);
            }
            RetailerHairdresserResponce.data=retailerContacts;
            
        }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
        return RetailerHairdresserResponce;
        
        
    }     

}