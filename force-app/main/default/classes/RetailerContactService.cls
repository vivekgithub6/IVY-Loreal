public class RetailerContactService {
   
    public static map<string,contact> getContactRoleMap(set<id> AccountIds){
       map<string,contact> ContactRoleMap=new   map<string,contact>();
        for(Contact c:[select Contact_Role__c,id,AccountId,lastname,Email,phone from contact where AccountId in:AccountIds]) {
            system.debug('Hiyft'+c);
           ContactRoleMap.put(c.AccountId+'.'+c.Contact_Role__c, c);
        }
        System.debug('ContactRoleMap:: '+ContactRoleMap);
        return ContactRoleMap;
    }
    public static list<contact> getAllContacts(set<id> AccIds){
    return[select Account.ivybase__Internal_Id__c,id,Internal_Id__c,Contact_Code__c,name,Experience__c,MobilePhone,Signature__c,Privacy__c,Social_Media_Id__c,Email from contact where Contact_Role__c='' AND Accountid in:AccIds and Internal_Id__c!=Null];
}
     public static list<Partner_Function__c> getAllConquests(Set<Id> accIds){
         String[] accFields = new String[] {'Name','ivybase__Internal_Id__c','ivybase__Contact_Email__c','ivybase__Contact_PhoneNo__c','Is_Conquest__c'}; 
         String[] partnerFields = new String[] {'Partner__c','Account__c','Type__c'};
          System.debug('accIds'+accIds);   
         List<Partner_Function__c> partners = [Select Id,Partner__c,Account__c,Account__r.ivybase__Internal_Id__c,Partner__r.ivybase__Internal_Id__c,Partner__r.ivybase__Contact_PhoneNo__c,
                                                      Partner__r.Name from Partner_Function__c where Account__c IN : accIds];
          System.debug('partners in Service:::'+partners);    
       return partners; 
    }
}