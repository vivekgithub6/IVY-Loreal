public with sharing class LocationMasterService {
    public static Set<String> getAllParentLocationHierarchy(Set<String> locationHierarchy)
    {
        List<ivybase__Location_Hierarchy__c > st = [select id,name,
                                                ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                                
                                        from ivybase__Location_Hierarchy__c  where 
                                       id=:locationHierarchy];
        
        Set<String> locationHierarchyId = new Set<String>();
        for(ivybase__Location_Hierarchy__c  s:st)
        {
            locationHierarchyId.add(String.valueOf(s.id));
            if(s.ivybase__Parent__c!=null)
            {
                locationHierarchyId.add(String.valueOf(s.ivybase__Parent__c));
            }
            if(s.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                locationHierarchyId.add(String.valueOf(s.ivybase__Parent__r.ivybase__Parent__c));
            }
            if(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                locationHierarchyId.add(String.valueOf(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c));
            }
            if(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                locationHierarchyId.add(String.valueOf(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c));
            }
        }
       return  locationHierarchyId;
    }
    public static Map<Id,ivybase__Location_Hierarchy__c > getAllLocationMasterMapByLocId(Set<Id> locationIdSet) {
    
        String[] locFields = new String[] {'ivybase__Internal_Id__c','ivybase__Level__c', 'ivybase__Active__c','ivybase__Parent__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Location_Hierarchy__c', locFields)) { 
            List< ivybase__Location_Hierarchy__c > locationListInfo = new List< ivybase__Location_Hierarchy__c >();
            Map<Id,ivybase__Location_Hierarchy__c > locationIdMap = new Map<Id,ivybase__Location_Hierarchy__c>();
            
            locationListInfo = [ SELECT ivybase__Internal_Id__c,
                                        Name,
                                        ivybase__Level__c,
                                        ivybase__Parent__r.ivybase__Internal_Id__c,
                                        ivybase__Active__c,
                                        RecordType.Name
                                 FROM ivybase__Location_Hierarchy__c
                                 WHERE Id IN:locationIdSet AND ivybase__Active__c = 'Yes'];
                                 
            for(ivybase__Location_Hierarchy__c  loc : locationListInfo ){
            
                locationIdMap.put(loc.Id,loc );
            }
                                 
            return locationIdMap;
        } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static List<ivybase__Location_Hierarchy__c> getUserTerritory( ) {
        Id currentUserId = UserInfo.getUserId();
        Return [SELECT id, name,ivybase__Primary_Resource__c FROM ivybase__Location_Hierarchy__c WHERE ivybase__Primary_Resource__r.ivybase__Related_User__c = :currentUserId  AND RecordType.DeveloperName = 'Territory'];
    }
    public static List<ivybase__Location_Hierarchy__c> getUserTerritory(id resourceId) {
        Id currentUserId = UserInfo.getUserId();
        Return [SELECT id, name,ivybase__Primary_Resource__c FROM ivybase__Location_Hierarchy__c WHERE ivybase__Primary_Resource__c=:resourceId  AND RecordType.DeveloperName = 'Territory'];
    }
    public static List<ivybase__Location_Hierarchy__c> getAllUserTerritory( ) {

        Return [SELECT id, name,ivybase__Primary_Resource__c FROM ivybase__Location_Hierarchy__c WHERE ivybase__Primary_Resource__c!=null AND RecordType.DeveloperName = 'Territory'];
    }
    
    public static List<ivybase__Location_Hierarchy__c> getCurrentUserTerritory(String currentResource ) {
        Return [SELECT id, name FROM ivybase__Location_Hierarchy__c WHERE ivybase__Current_Resource__c =:currentResource
                                                                      AND RecordType.DeveloperName = 'Territory'];
    }
}