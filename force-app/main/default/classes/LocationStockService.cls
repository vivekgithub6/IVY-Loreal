public with sharing class LocationStockService {
    
    
    public static Map<String,String> getProductAndQuantityMapFromWarehouse(Set<Id> warehouseId){
     Map<String,String> ProductQuantity = new Map<String,String>();
    List<ivybase__Location_Stock__c> locList = new List<ivybase__Location_Stock__c>();
        String[] LFields = new String[] {'ivybase__UOM1__c','ivybase__Product__c','ivybase__Product__r.ivybase__InternalId__c','ivybase__Location__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Location_Stock__c', LFields)) {
             locList = [select id,name,ivybase__UOM1__c,ivybase__Product__c,ivybase__Product__r.ivybase__InternalId__c,ivybase__Location__c from ivybase__Location_Stock__c where ivybase__Location__c=:warehouseId limit 5000];  
            for(ivybase__Location_Stock__c l:locList)
            {
				ProductQuantity.put(String.valueOf(l.ivybase__Product__r.ivybase__InternalId__c),String.valueOf(l.ivybase__UOM1__c)); 
            }
           return ProductQuantity;
        }
        else
        {
           throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS'); 
        }
    }
    
}