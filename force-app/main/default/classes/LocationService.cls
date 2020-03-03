public with sharing class LocationService {
    
    
    public static Set<Id> getAllWarehouseId(){
        Set<Id> warehourseId = new Set<Id>();
    List<ivybase__Location__c> locList = new List<ivybase__Location__c>();
        String[] phFields = new String[] {'RecordTypeId','RecordType.developerName','RecordType.Name'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Location__c', phFields)) {
             locList = [select id,name,RecordTypeId,RecordType.developerName,RecordType.Name from ivybase__Location__c where RecordType.Name='Warehouse'];  
            for(ivybase__Location__c l:locList)
            {
              warehourseId.add(l.id);  
            }
           return warehourseId;
        }
        else
        {
           throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS'); 
        }
    }
    
}