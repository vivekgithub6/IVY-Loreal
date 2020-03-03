public with sharing class StoreHierarchyService {
    public static Set<String> getAllParentStoreHierarchy(Set<String> storeHierarchy)
    {
        List<ivybase__Store_Hierarchy__c> st = [select id,name,
                                                ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                                
                                        from ivybase__Store_Hierarchy__c where 
                                       id=:storeHierarchy];
        
        Set<String> allStoreHierarchyId = new Set<String>();
        for(ivybase__Store_Hierarchy__c s:st)
        {
            allStoreHierarchyId.add(String.valueOf(s.id));
            if(s.ivybase__Parent__c!=null)
            {
                allStoreHierarchyId.add(String.valueOf(s.ivybase__Parent__c));
            }
            if(s.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                allStoreHierarchyId.add(String.valueOf(s.ivybase__Parent__r.ivybase__Parent__c));
            }
            if(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                allStoreHierarchyId.add(String.valueOf(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c));
            }
            if(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                allStoreHierarchyId.add(String.valueOf(s.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c));
            }
        }
       return  allStoreHierarchyId;
    }
    public static List<ivybase__Store_Hierarchy__c> getStoreHierarchiedUnderDivision(Set<Id> divSet)
    {
        List<ivybase__Store_Hierarchy__c> st = [select id,name
                                        from ivybase__Store_Hierarchy__c where 
                                       Division__c=:divSet or
                                       ivybase__Parent__r.Division__c=:divSet or
                                       ivybase__Parent__r.ivybase__Parent__r.Division__c=:divSet or 
                                       ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Division__c=:divSet];
        
        return st;
    }
    public static Set<Id> getStoreHierarchyAndRelatedChildFromStoreCode(Set<String> StoreHierarchyCode)
    {
        
        Set<Id> storeIdSet = new Set<Id>();
        List<ivybase__Store_Hierarchy__c> storeHierarchy = [select 
                                                            id,
                                                            name,
                                                            Store_Number__c,
                                                            ivybase__Parent__c,
                                                            ivybase__Parent__r.Name,
                                                            ivybase__Parent__r.Store_Number__c,
                                                            ivybase__Parent__r.ivybase__Parent__c,
                                                            ivybase__Parent__r.ivybase__Parent__r.Name,
                                                            ivybase__Parent__r.ivybase__Parent__r.Store_Number__c,
                                                            ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                            ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Name,
                                                            ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c
                                                            from ivybase__Store_Hierarchy__c where Store_Number__c=:StoreHierarchyCode or ivybase__Parent__r.Store_Number__c=:StoreHierarchyCode or ivybase__Parent__r.ivybase__Parent__r.Store_Number__c=:StoreHierarchyCode or ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c=:StoreHierarchyCode];
        for(ivybase__Store_Hierarchy__c sh:storeHierarchy)
        {
            if(StoreHierarchyCode.contains(sh.Store_Number__c)){
                storeIdSet.add(sh.Id);
            }
            if(StoreHierarchyCode.contains(sh.ivybase__Parent__r.Store_Number__c))
            {     
                storeIdSet.add(sh.ivybase__Parent__c);
                storeIdSet.add(sh.Id);
            }
            if(StoreHierarchyCode.contains(sh.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c))
            {
                
                storeIdSet.add(sh.ivybase__Parent__r.ivybase__Parent__c);
                storeIdSet.add(sh.ivybase__Parent__c);
                storeIdSet.add(sh.Id);    
            }
            if(StoreHierarchyCode.contains(sh.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Store_Number__c))
            {
                
                storeIdSet.add(sh.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
                storeIdSet.add(sh.ivybase__Parent__r.ivybase__Parent__c);
                storeIdSet.add(sh.ivybase__Parent__c);
                storeIdSet.add(sh.Id);
            }
        }
        
        return storeIdSet;
    }
    
   public static List<ivybase__Store_Hierarchy__c> getStoreHierarchyFromStoreCode(Set<String> StoreHierarchyCode)
    {
        List<ivybase__Store_Hierarchy__c> storeHierarchy = new List<ivybase__Store_Hierarchy__c>();
        storeHierarchy=[select id,name,Store_Number__c from ivybase__Store_Hierarchy__c where Store_Number__c=:StoreHierarchyCode];
        return storeHierarchy;
    }
    public static Set<String> getchildStorehieIds(Set<String> storehieIdSet) {
        
        Set<String> childStoreHieIdsSet = new Set<String>();
        String[] ckFields = new String[] {'ivybase__Parent__c'}; 
            
            if (SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', ckFields)) {
                
                for(ivybase__Store_Hierarchy__c sh : [SELECT Id,ivybase__Parent__c FROM ivybase__Store_Hierarchy__c WHERE  ivybase__Parent__c IN :storehieIdSet]){
                    
                    childStoreHieIdsSet.add(sh.Id);
                    
                }
                return childStoreHieIdsSet;
            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    }
    
    public static Set<String> getparentStorehieIds(Set<String> storehieIdSet) {
        
        Set<String> parentStoreHieIdsSet = new Set<String>();
        String[] ckFields = new String[] {'ivybase__Parent__c'}; 
            
            if (SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', ckFields)) {
                
                for(ivybase__Store_Hierarchy__c sh : [SELECT Id,ivybase__Parent__c FROM ivybase__Store_Hierarchy__c WHERE Id IN :storehieIdSet]){
                    
                    parentStoreHieIdsSet.add(sh.ivybase__Parent__c);
                    
                }
                return parentStoreHieIdsSet;
            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    }
    public static List<account> getNode4ForThisAccount(Set<id> storeSet)
    {
        List<account> acclist=[select id,ivybase__Store_Hierarchy__c from account where id IN:storeSet and ivybase__Store_Hierarchy__c!=null];
        return acclist;
    }
    public static Set<id> getParentStorehierarchyIdFromNode4(Set<id> storehierarchySet){
        list<ivybase__Store_Hierarchy__c> StoreHierarchyList=[select id,ivybase__Parent__c,
                                                              RecordType.Name,
                                                              ivybase__Parent__r.ivybase__Parent__c,
                                                              ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                                                              ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                                              from ivybase__Store_Hierarchy__c where id IN:storehierarchySet ];
        Set<Id> storehirid = new Set<Id>();
        if(StoreHierarchyList!=null){
            for(ivybase__Store_Hierarchy__c acc:StoreHierarchyList){    
                storehirid.add(acc.Id);
                if(acc.ivybase__Parent__c!=null){
                    storehirid.add(acc.ivybase__Parent__c); 
                }
                if(acc.ivybase__Parent__r.ivybase__Parent__c!=null){
                    storehirid.add(acc.ivybase__Parent__r.ivybase__Parent__c);
                }
                if(acc.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){
                    storehirid.add(acc.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                }
                if(acc.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){
                    storehirid.add(acc.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                }
            } 
        }
        return storehirid;
    }
    
    public static map<id,ivybase__Store_Hierarchy__c> getstoreHierarchyRecords(set<id> storehirid){
        list<ivybase__Store_Hierarchy__c> sthdetails= new list<ivybase__Store_Hierarchy__c>();
        if(storehirid!=null){
            sthdetails=[select id,Division__c,ivybase__Internal_Id__c,ivybase__Level__c,RecordType.name,ivybase__Parent__c,Name,Store_Number__c
                        from ivybase__Store_Hierarchy__c where ID IN:storehirid];  
        }
        map<id,ivybase__Store_Hierarchy__c> sthidSthMap = new map<id,ivybase__Store_Hierarchy__c>();
        if(sthdetails!=null){
            for(ivybase__Store_Hierarchy__c sth:sthdetails){
                sthidSthMap.put(sth.id,sth); 
            } 
        }
        
        return sthidSthMap;
    }
}