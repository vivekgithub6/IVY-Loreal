public class DivisionMappingService {
    public static List<StoreDivisionMapping__c> getRetailerCheck(set<id> accid){
       List<StoreDivisionMapping__c> storeDivRecords = new List<StoreDivisionMapping__c>();
        String[] accDivisionFields = new String[] {'Name','Account__c','Division__c','Store_Hierarchy__c'};
            String[] storeFields = new String[]{'ivybase__Internal_Id__c'};
         //getting user divisions 
           map<string,string> userdivmap= ResourceService.GetAllResourceDivisionNameIdmap();
        
            if(SecurityUtility.checkIsAccessible('StoreDivisionMapping__c', accDivisionFields) && SecurityUtility.checkIsAccessible('Account', storeFields)){
                storeDivRecords = [Select Id,Name,Account__c,Account__r.ivybase__Internal_Id__c,Division__c,Store_Hierarchy__c,Store_Hierarchy__r.ivybase__Internal_Id__c,
                                   Store_Hierarchy__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Internal_Id__c,Store_Hierarchy__r.name,Salon_Frequency__c
                                   from StoreDivisionMapping__c 
                                   where Account__c!= null AND Account__c IN:accid  AND  Division__c!= null AND Division__c IN:userdivmap.keyset() ];
            }
        return storeDivRecords;
    }

}