/**
 * Created By : Ivy Mobility(Absyz Team)
 * This class is used to query the discounts.
 * Test Classes : TestPricingAndDiscountCreation,TESTOrderLineItem,TESTOrderTrigger,TestDiscountClass,TESTRESTDiscountManager
 * Last Modified By : Karthikeyan
 * Date : 2019-Sep-09
 * Change : Added Parent__r.ivydsd__Product__r.ivybase__InternalId__c field in the queries
 * Purpose : To sending the BOM Id in the API's
*/
public with sharing class DiscountService {
    public static List<ivydsd__Discount_Detail__c> getAllDiscountDetail_List_GrandChild(Set<Id> parentdiscountdetailId) {
        
        String[] discproddetailFields = new String[] {'Id','ivydsd__Value__c','RelatedCustomerCode__c','Division__c',
            								'ivydsd__Is_Percentage__c','ivydsd__Min_Slab__c','ivydsd__Max_Slab__c'};
        String[] discproddetail1Fields = new String[] {'ivydsd__Internal_Id__c','Type__c'};
        String[] discproddetail2Fields = new String[] {'ivybase__InternalId__c'};
        String[] discproddetail3Fields = new String[] {'ivybase__InternalId__c'};
        if (SecurityUtility.checkIsAccessible('ivydsd__Discount_Detail__c', discproddetailFields) 
            && SecurityUtility.checkIsAccessible('ivydsd__Discount__c', discproddetail1Fields) 
            && SecurityUtility.checkIsAccessible('ivybase__Product__c', discproddetail2Fields) 
            && SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c',discproddetail3Fields)) { 
            return [SELECT  Id,
                    ivydsd__Discounts__c,
                    ivydsd__Discounts__r.Type__c,
                    ivydsd__Discounts__r.ivydsd__Internal_Id__c,
                    ivydsd__Product_Hierarchy__c,
                    ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c,
                    ivydsd__Product__c,
                    Division__c,
                    Division__r.Internal_Id__c,
                    Division__r.Name,                               
                    RelatedCustomerCode__c,
                    ivydsd__Product__r.ivybase__InternalId__c,
                    ivydsd__Value__c,
                    ivydsd__Is_Percentage__c,
                    ivydsd__Min_Slab__c,
                    ivydsd__Max_Slab__c,
                    Parent__c,
                    Parent__r.ivydsd__Discounts__r.ivydsd__Internal_Id__c,
                    Parent__r.ivydsd__Product__c,
                    Parent__r.ivydsd__Discounts__c,
                    ToValue__c, Parent__r.ivydsd__Product__r.ivybase__InternalId__c
                    FROM ivydsd__Discount_Detail__c where Parent__c=:parentdiscountdetailId];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                 'INSUFFICIENT_PERMISSIONS');
        }
    }

    public static Map<String,ivydsd__Discount_Detail__c> CheckIfDiscountDetailCombinationExist(Id ProdutId,Set<Id> DiscountListId,Id ProductHierarchyId) {
        Map<String,ivydsd__Discount_Detail__c> combinationMap  = new Map<String,ivydsd__Discount_Detail__c>();
        List<ivydsd__Discount_Detail__c> discountDetail = new List<ivydsd__Discount_Detail__c>();
        discountDetail=[select id,name,ivydsd__Product__c,ivydsd__Product_Hierarchy__c,ivydsd__Discounts__c,ivydsd__Value__c,RelatedCustomerCode__c  
                        from ivydsd__Discount_Detail__c where ivydsd__Discounts__c=:DiscountListId and (ivydsd__Product__c=:ProdutId 
                                                                                                        Or ivydsd__Product_Hierarchy__c=:ProductHierarchyId)];
        for(ivydsd__Discount_Detail__c dd:discountDetail)
        {
            if(ProdutId!=null){
            combinationMap.put(dd.ivydsd__Product__c+''+dd.ivydsd__Discounts__c,dd);
            }
            if(ProductHierarchyId!=null)
            {
                combinationMap.put(dd.ivydsd__Product_Hierarchy__c+''+dd.ivydsd__Discounts__c,dd);
            }
        }
        return combinationMap;
    }
    
    public static Map<String,ivydsd__Discount_Mapping__c> CheckIfDiscoutMappingExistWithValidDiscountList(String DiscountTypeCode,Set<Id> store) {
        List<ivydsd__Discount_Mapping__c> discountMapping = new List<ivydsd__Discount_Mapping__c>();
        Map<String,ivydsd__Discount_Mapping__c> StoreVSMappingCombination = new Map<String,ivydsd__Discount_Mapping__c>();
        discountMapping = [SELECT Id, Name, ivydsd__Account__c, ivydsd__Discount__c, ivydsd__Store_Hierarchy__c
                        FROM ivydsd__Discount_Mapping__c WHERE ivydsd__Account__c =:store
                        AND ivydsd__Discount__r.Type__c =:DiscountTypeCode 
                        AND (ivydsd__Discount__r.ivydsd__Effective_To__c >= today or ivydsd__Discount__r.ivydsd__Effective_To__c = null) 
                        AND (ivydsd__Discount__r.ivydsd__Effective_From__c <= today or ivydsd__Discount__r.ivydsd__Effective_From__c=null ) ];        
        
        for(ivydsd__Discount_Mapping__c dm:discountMapping) {
            if(store.contains(dm.ivydsd__Account__c)) {
                StoreVSMappingCombination.put(dm.ivydsd__Account__c,dm);
            }
        }
        return StoreVSMappingCombination;
    }
    
    public static Boolean CheckIfValidDiscounMappingIsPresent(Id storeOrStoreHierarchy,Id DiscountId) {
        List<ivydsd__Discount_Mapping__c> discountMapping = new List<ivydsd__Discount_Mapping__c>();
        discountMapping=[select id,name,ivydsd__Account__c,ivydsd__Discount__c,ivydsd__Store_Hierarchy__c 
                         from ivydsd__Discount_Mapping__c where ivydsd__Discount__c=:DiscountId and 
                         (ivydsd__Store_Hierarchy__c=:storeOrStoreHierarchy or ivydsd__Account__c=:storeOrStoreHierarchy) ];
        if(discountMapping.size()>0) {
            return true;
        }
        else {
            return false;
        }
    }

    public static List<ivydsd__Discount__c> CheckIfValidDiscountListIsPresent(String DiscountTypeCode) {
        List<ivydsd__Discount__c> discountList = new List<ivydsd__Discount__c>();
        discountList = [SELECT  ivydsd__Internal_Id__c,ivydsd__Discount_Type__c,Type__c,ivydsd__Description__c,ivydsd__Apply_Type__c,ivydsd__Module_Type__c 
                        FROM ivydsd__Discount__c 
                    where Type__c=:DiscountTypeCode AND (ivydsd__Effective_To__c >= today or ivydsd__Effective_To__c = null)  
                    AND (ivydsd__Effective_From__c <= today or ivydsd__Effective_From__c=null ) ];
        if(discountList.size()>0) {
            return discountList;
        }
        else {
            return null;
        }
    }
    
    public static List<ivydsd__Discount_Mapping__c> getDiscountFromDiscountMapping(Set<Id> storeHierarchyIdSet,Set<Id> accountIdSet) {
        List<ivydsd__Discount_Mapping__c> discountMapping = new List<ivydsd__Discount_Mapping__c>();
        Set<Id> discountIdSet = new Set<Id>();
        String[] discmapFields = new String[] {'Discount__c','ivydsd__Discount__c','Store_Hierarchy__c'}; 
        String[] discmap1Fields = new String[] {'Internal_Id__c'}; 
        String[] discmap2Fields = new String[] {'ivybase__Internal_Id__c'}; 
        String[] discmap3Fields = new String[] {'ivybase__Internal_Id__c'}; 
        if (SecurityUtility.checkIsAccessible('ivydsd__Discount_Mapping__c', discmapFields) && SecurityUtility.checkIsAccessible('ivydsd__Discount__c', discmap1Fields)
            && SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', discmap2Fields) && SecurityUtility.checkIsAccessible('Account', discmap3Fields)) { 
            for(ivydsd__Discount_Mapping__c discount : [SELECT  Id,name,ivydsd__Discount__c,ivydsd__Discount__r.ivydsd__Internal_Id__c,ivydsd__Store_Hierarchy__c,
                                                        ivydsd__Store_Hierarchy__r.ivybase__Internal_Id__c,ivydsd__Account__c,ivydsd__Account__r.ivybase__Internal_Id__c 
                                                        FROM ivydsd__Discount_Mapping__c WHERE ivydsd__Account__c IN: accountIdSet]){

                discountMapping.add(discount);
            }
            return discountMapping;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                 'INSUFFICIENT_PERMISSIONS');
        }
    }

    public static List<ivydsd__Discount__c> getAllDiscount_List(Set<Id> discountId) {
        
        String[] discountFields = new String[] {'ivydsd__Internal_Id__c', 'ivydsd__Discount_Type__c', 'ivydsd__Description__c', 
            			'ivydsd__Apply_Type__c', 'ivydsd__Module_Type__c','ivydsd__Effective_To__c','ivydsd__Effective_From__c'}; 
        if (SecurityUtility.checkIsAccessible('ivydsd__Discount__c', discountFields)) {
            return [SELECT  ivydsd__Internal_Id__c,ivydsd__Discount_Type__c,Type__c,ivydsd__Description__c,
                    ivydsd__Apply_Type__c,ivydsd__Module_Type__c FROM ivydsd__Discount__c 
                    where Id=:discountId AND
                    (ivydsd__Effective_To__c >= today or ivydsd__Effective_To__c = null) 
                      AND (ivydsd__Effective_From__c <= today or ivydsd__Effective_From__c=null ) ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                 'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static List<ivydsd__Discount_Detail__c> getAllDiscountDetail_List(Set<Id> discountId) {
        
        String[] discproddetailFields = new String[] {'Id','ivydsd__Value__c','RelatedCustomerCode__c','Division__c',
            									'ivydsd__Is_Percentage__c','ivydsd__Min_Slab__c','ivydsd__Max_Slab__c'}; 
        String[] discproddetail1Fields = new String[] {'ivydsd__Internal_Id__c','Type__c'}; 
        String[] discproddetail2Fields = new String[] {'ivybase__InternalId__c'}; 
        String[] discproddetail3Fields = new String[] {'ivybase__InternalId__c'}; 
         if (SecurityUtility.checkIsAccessible('ivydsd__Discount_Detail__c', discproddetailFields) 
             && SecurityUtility.checkIsAccessible('ivydsd__Discount__c', discproddetail1Fields) 
             && SecurityUtility.checkIsAccessible('ivybase__Product__c', discproddetail2Fields) 
             && SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c',discproddetail3Fields)) { 
             Integer total_records = [SELECT  COUNT() FROM ivydsd__Discount_Detail__c WHERE ivydsd__Discounts__c =:discountId];
             System.debug('++++ total_records ++++' + total_records);
             return [SELECT  Id,
                    ivydsd__Discounts__c,
                    ivydsd__Discounts__r.Type__c,
                    ivydsd__Discounts__r.ivydsd__Internal_Id__c,
                    ivydsd__Product_Hierarchy__c,
                    ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c,
                    ivydsd__Product__c,
                    Division__c,
                    Division__r.Internal_Id__c,
                    Division__r.Name,
                    RelatedCustomerCode__c,
                    ivydsd__Product__r.ivybase__InternalId__c,
                    ivydsd__Value__c,
                    Parent__c,
                    ivydsd__Is_Percentage__c,
                    ivydsd__Min_Slab__c,
                    ivydsd__Max_Slab__c,
                    ToValue__c, Parent__r.ivydsd__Product__r.ivybase__InternalId__c
                     FROM ivydsd__Discount_Detail__c WHERE ivydsd__Discounts__c=:discountId LIMIT 40000];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                 'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static List<ivydsd__Discount_Detail__c> getAllDiscountDetail_List_GrandChild(Set<Id> discountId,Set<Id> BOM) {
        
        String[] discproddetailFields = new String[] {'Id','ivydsd__Value__c','Division__c','RelatedCustomerCode__c',
            										'ivydsd__Is_Percentage__c','ivydsd__Min_Slab__c','ivydsd__Max_Slab__c'}; 
        String[] discproddetail1Fields = new String[] {'ivydsd__Internal_Id__c','Type__c'}; 
        String[] discproddetail2Fields = new String[] {'ivybase__InternalId__c'}; 
        String[] discproddetail3Fields = new String[] {'ivybase__InternalId__c'}; 
         if (SecurityUtility.checkIsAccessible('ivydsd__Discount_Detail__c', discproddetailFields) 
             && SecurityUtility.checkIsAccessible('ivydsd__Discount__c', discproddetail1Fields) 
             && SecurityUtility.checkIsAccessible('ivybase__Product__c', discproddetail2Fields) 
             && SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c',discproddetail3Fields)) { 
            return [SELECT  Id,
                    ivydsd__Discounts__c,
                    ivydsd__Discounts__r.Type__c,
                    ivydsd__Discounts__r.ivydsd__Internal_Id__c,
                    ivydsd__Product_Hierarchy__c,
                    ivydsd__Product_Hierarchy__r.ivybase__Internal_Id__c,
                    ivydsd__Product__c,
                    Division__c,
                    Division__r.Internal_Id__c,
                    Division__r.Name,
                    RelatedCustomerCode__c,
                    ivydsd__Product__r.ivybase__InternalId__c,
                    ivydsd__Value__c,
                    ivydsd__Is_Percentage__c,
                    ivydsd__Min_Slab__c,
                    ivydsd__Max_Slab__c,
                    Parent__c,
                    Parent__r.ivydsd__Discounts__c,
                    Parent__r.ivydsd__Discounts__r.Type__c,
                    Parent__r.ivydsd__Product__c,
                    ToValue__c, Parent__r.ivydsd__Product__r.ivybase__InternalId__c
                    FROM ivydsd__Discount_Detail__c WHERE Parent__r.ivydsd__Discounts__c=:discountId 
                    	AND Parent__r.ivydsd__Product__c =:BOM];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                 'INSUFFICIENT_PERMISSIONS');
        }
    }
}