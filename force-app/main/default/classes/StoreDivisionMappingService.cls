public with sharing class StoreDivisionMappingService {

    public static Set<Id> getAllAccountIdForStoreHierarchy(Set<Id> storeHierarchyId)
    {
        Set<Id> AccountId = new Set<Id>();
        List<StoreDivisionMapping__c> storeDiv = [select id,name,Store_Hierarchy__c,Account__c from StoreDivisionMapping__c where Store_Hierarchy__c=:storeHierarchyId];
        for(StoreDivisionMapping__c sdm:storeDiv)
        {
            if(sdm.Account__c!=null){
            AccountId.add(sdm.Account__c);
            }
        }
        return AccountId;
    }
    public static Map<Id,Id> getOneMatchingStoreHierarchyForAccount(List<Account> account)
    {
        Set<Id> accIdSet = new Set<Id>();
        for(Account a:account)
        {
            accIdSet.add(a.Id);
        }
        Map<Id,Id> AccountStoreHierarchyMap = new Map<Id,Id>();
        List<StoreDivisionMapping__c> storeDiv = [select id,name,Store_Hierarchy__c,Account__c from StoreDivisionMapping__c where Account__c=:accIdSet and Store_Hierarchy__c!=null];
        for(StoreDivisionMapping__c sd:storeDiv)
        {
            AccountStoreHierarchyMap.put(sd.Account__c,sd.Store_Hierarchy__c);
        }
        return AccountStoreHierarchyMap;
    }
}