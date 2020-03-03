public with sharing class ProductUOMService {
	public static list<ivybase__Product_UOM__c> getProductUOMs(Set<Id> productIds) {
    
      String[] pFields = new String[] {'Id','ivybase__Product__c','ivybase__UOM__c','ivybase__UOM_Number__c'}; 
      if (SecurityUtility.checkIsAccessible('ivybase__Product_UOM__c', pFields)) {
          list<ivybase__Product_UOM__c> productUOMList = [
                                SELECT
                                 Id,
                                 ivybase__Product__c,
                                 ivybase__UOM__c,
                                 ivybase__UOM_Number__c
                                FROM
                                  ivybase__Product_UOM__c
                                WHERE 
                                  ivybase__Product__c IN:productIds                                  
                               ];
           return productUOMList;
       }else {
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','ivybase__Product_UOM__c');
       }
    }   
    public static list<ivybase__Product_UOM__c> getProductUOMList(Set<Id> divId) {
    
      String[] pFields = new String[] {'Id','ivybase__Bar_Code__c', 'Name','ivybase__Base_Price__c','ivybase__Conversion_Factor__c','ivybase__Product__c','ivybase__UOM__c'}; 
      String[] proFields = new String[]{'ivybase__InternalId__c','ivybase__Is_Competitor__c','ivybase__Active__c'}; 
      if (SecurityUtility.checkIsAccessible('ivybase__Product_UOM__c', pFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', proFields)) {
          list<ivybase__Product_UOM__c> productUOMList = [
                                SELECT
                                 Id,
                                 Name,
                                 ivybase__Bar_Code__c,
                                 ivybase__Base_Price__c, 
                                 ivybase__Conversion_Factor__c,
                                 ivybase__Product__c,
              ivybase__Product__r.ivybase__Barcode__c,
                                 ivybase__UOM__c,
                                 ivybase__Product__r.ivybase__InternalId__c
                                FROM
                                  ivybase__Product_UOM__c
                                  WHERE ivybase__Product__r.ivybase__Is_Competitor__c = false
                                  AND ivybase__Product__r.ivybase__Active__c = 'Yes'
                                  AND ivybase__Product__r.Division__c=:divId
                               ];
                   return productUOMList;
       }else {
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','ivybase__Product_UOM__c');
       }
    }
    public static list<ivybase__Product_UOM__c> getProductUOMListByProdIds(Set<Id> ProdIds) {
    
      String[] pFields = new String[] {'ivybase__Product__c','ivybase__UOM__c','ivybase__UOM_Number__c','ivybase__Conversion_Factor__c'}; 
      String[] proFields = new String[]{'ivybase__InternalId__c'};
      if (SecurityUtility.checkIsAccessible('ivybase__Product_UOM__c', pFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', proFields)) {
          list<ivybase__Product_UOM__c> productUOMList = [
                                SELECT
                                 Id,
                                 Name,
                                 ivybase__Product__c,
                                 ivybase__UOM__c,
                                 ivybase__UOM_Number__c,
                                 ivybase__Conversion_Factor__c,
                                 ivybase__Product__r.ivybase__InternalId__c
                                FROM
                                  ivybase__Product_UOM__c
                                  WHERE 
                                  ivybase__Product__c IN :ProdIds
                               ];
                   return productUOMList;
       }else {
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','ivybase__Product_UOM__c');
            
       }
   }
}