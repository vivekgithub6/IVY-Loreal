public with sharing class SchemeService {
    
    public static List<ivydsd__Scheme_Group_Product__c> getSchemeFreeProductsList(Set<Id> schemeGroupIds) {
        
        String[] SchmGrpProdFields = new String[]{'Id','ivydsd__Scheme_Group__c','ivydsd__Product1__c'};
        String[] ProdFields = new String[]{'ivybase__InternalId__c'};
       
        if(SecurityUtility.checkIsAccessible('ivydsd__Scheme_Group_Product__c', SchmGrpProdFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', ProdFields)){
            
            List<ivydsd__Scheme_Group_Product__c> schemeGrpProdList = New List<ivydsd__Scheme_Group_Product__c>();
            if (schemeGroupIds != null && schemeGroupIds.size() > 0) {
                schemeGrpProdList = [SELECT Id, 
                                     ivydsd__Scheme_Group__c,
                                     ivydsd__Scheme_Group__r.Name,ivydsd__Scheme_Group__r.Internal_Id__c,
                                     ivydsd__Scheme_Group__r.Product_Hierarchy__c,
                                      ivydsd__Scheme_Group__r.Product_Hierarchy__r.ivybase__Internal_Id__c,
                                     ivydsd__Scheme_Group__r.Product_Hierarchy__r.RecordType.developername,
                                     ivydsd__Scheme_Group__r.Product_Hierarchy__r.RecordType.name,
                                     ivydsd__Product1__c,
                                     Product_Hierarchy__c,
                                      Product_Hierarchy__r.RecordType.name,
                                      Product_Hierarchy__r.ivybase__Internal_Id__c,
                                     ivydsd__Product1__r.RecordType.name,
                                     ivydsd__Product1__r.ivybase__InternalId__c,
                                     ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c
                                     FROM ivydsd__Scheme_Group_Product__c 
                                     WHERE 
                                         ivydsd__Scheme_Group__c IN:schemeGroupIds]; 
            }
            return schemeGrpProdList;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        }
    }
    
    Public static Map<Id,ivydsd__Scheme_Free_Detail__c> getSchemeFreeDetails(Set<Id> slabIdSet) {
       
        Map<Id, ivydsd__Scheme_Free_Detail__c> schemefreedetailMap = new Map<Id, ivydsd__Scheme_Free_Detail__c> ();
        String[] SchemFreeDtl = new String[]{'Id', 'ivydsd__Scheme_Slab__c','ivydsd__Rate_Discount__c','ivydsd__Maximum_Rate_Discount__c', 'ivydsd__Price_Discount__c', 'ivydsd__Percentage_Discount__c','ivydsd__Maximum_Percentage_Discount__c','ivydsd__Maximum_Price_Discount__c','ivydsd__Free_Quantity__c', 'ivydsd__Free_Quantity_UOM__c', 'ivydsd__Scheme_Group__c','ivydsd__Maximum_Free_Quantity__c'};
        String[] schemeslabFields = new String[]{'ivydsd__Internal_Id__c'};
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Scheme_Free_Detail__c', SchemFreeDtl) && SecurityUtility.checkIsAccessible('ivydsd__Scheme_Slab__c', schemeslabFields)){
            
            if (slabIdSet != null && slabIdSet.size() > 0) {
                schemefreedetailMap = new Map<Id,ivydsd__Scheme_Free_Detail__c> (
                    [SELECT Id,ivydsd__Scheme_Slab__c,
                     ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c,
                     ivydsd__Rate_Discount__c, 
                     ivydsd__Maximum_Rate_Discount__c,
                     Product_Value_Worth__c,
                     ivydsd__Price_Discount__c,
                     ivydsd__Percentage_Discount__c,
                     ivydsd__Maximum_Free_Quantity__c,
                     ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c,
                     ivydsd__Maximum_Percentage_Discount__c,
                     ivydsd__Maximum_Price_Discount__c,
                     ivydsd__Free_Quantity__c,
                     ivydsd__Free_Quantity_UOM__c,
                     Product_Master__c ,
                     Scheme_Type__c,
                     ivydsd__Scheme_Group__c,
                     ivydsd__Scheme_Group__r.Name,
                     ivydsd__Scheme_Group__r.Product_Hierarchy__c,
                      ivydsd__Scheme_Group__r.Product_Hierarchy__r.ivybase__Internal_Id__c,
                     ivydsd__Scheme_Group__r.Product_Hierarchy__r.RecordType.developername,
                     ivydsd__Scheme_Group__r.Product_Hierarchy__r.RecordType.name,
                     ivydsd__Scheme_Group__r.Internal_Id__c
                                        FROM 
                                            ivydsd__Scheme_Free_Detail__c
                                        WHERE 
                                            ivydsd__Scheme_Slab__c IN:slabIdSet]);
            }                                   
            return schemefreedetailMap;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        } 
          
    }
    
    public static List<ivydsd__Scheme_Group_Product__c> getSchemeGroupProductList(Set<Id> schemeIdSet){
        
        String[] SchmGrpProdFields = new String[]{'Id','ivydsd__Scheme_Group__c','ivydsd__Product1__c'};
        String[] SchemeGroupFields = new String[]{'ivydsd__Group_Type__c','Name','ivydsd__Group_Logic__c'};
        String[] ProdFields = new String[]{'ivydsd__ivybase__InternalId__c'};
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Scheme_Group_Product__c', SchmGrpProdFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', ProdFields) &&SecurityUtility.checkIsAccessible('ivydsd__Scheme_Group__c', schemeGroupFields)){
           
            List<ivydsd__Scheme_Group_Product__c> schemeGroupProductList = new List<ivydsd__Scheme_Group_Product__c>();
            schemeGroupProductList = [SELECT Id,
                                      ivydsd__Scheme_Group__c,
                                      ivydsd__Scheme_Group__r.Name,
                                      ivydsd__Scheme_Group__r.Internal_Id__c,
                                      ivydsd__Scheme_Group__r.Product_Hierarchy__c,
                                      ivydsd__Scheme_Group__r.Product_Hierarchy__r.ivybase__Internal_Id__c,
                                      ivydsd__Scheme_Group__r.Product_Hierarchy__r.RecordType.developername,
                                      ivydsd__Scheme_Group__r.Product_Hierarchy__r.RecordType.name,
                                      ivydsd__Product1__c,
                                      Product_Hierarchy__c,
                                      Product_Hierarchy__r.RecordType.name,
                                      Product_Hierarchy__r.ivybase__Internal_Id__c,
                                      ivydsd__Product1__r.RecordType.name,
                                      ivydsd__Product1__r.RecordType.developername,
                                      ivydsd__Product1__r.ivybase__InternalId__c,
                                      ivydsd__Scheme_Group__r.ivydsd__Group_Type__c,
                                      ivydsd__Scheme_Group__r.ivydsd__Group_Logic__c 
                                      FROM 
                                          ivydsd__Scheme_Group_Product__c 
                                      WHERE 
                                          ivydsd__Scheme_Group__r.ivydsd__Scheme__c IN:schemeIdSet];
            return schemeGroupProductList;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        }
    }
    
    public static List<ivydsd__Scheme_Group__c> getSchemeGroupList(Set<Id> schemeIdSet){
        
        String[] SchmGrpProdFields = new String[]{'Id','ivydsd__Scheme_Group__c','ivydsd__Product1__c'};
        String[] SchemeGroupFields = new String[]{'ivydsd__Group_Type__c','Name','ivydsd__Group_Logic__c'};
        String[] ProdFields = new String[]{'ivydsd__ivybase__InternalId__c'};
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Scheme_Group_Product__c', SchmGrpProdFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', ProdFields) &&SecurityUtility.checkIsAccessible('ivydsd__Scheme_Group__c', schemeGroupFields)){
           
            List<ivydsd__Scheme_Group__c> schemeGroupList = new List<ivydsd__Scheme_Group__c>();
            schemeGroupList = [SELECT Id,
                                     
                                      Name,
                                     Internal_Id__c,
                                      Product_Hierarchy__c,
                                      Product_Hierarchy__r.ivybase__Internal_Id__c,
                                      Product_Hierarchy__r.RecordType.developername,
                                      Product_Hierarchy__r.RecordType.name,
                                      ivydsd__Group_Type__c,
                                      ivydsd__Group_Logic__c,
                                      ivydsd__Scheme__c
                                      FROM 
                                          ivydsd__Scheme_Group__c 
                                      WHERE 
                                         ivydsd__Scheme__c IN:schemeIdSet AND Product_Hierarchy__c!=null ];
            return schemeGroupList;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        }
    }
    
    public static Map<Id, List<ivydsd__Scheme_Slab_Target__c>> getSchemeGroupAndTargetList( Set<Id> schemeSlabIdSet){
        
        Map<Id, List<ivydsd__Scheme_Slab_Target__c>> sGroupIdAndSSTargetListMap = new Map<Id, List<ivydsd__Scheme_Slab_Target__c>>();
        
        String[] schemeslabFields = new String[]{'ivydsd__Internal_Id__c'};
        String[] schemeGroupFields = new String[]{'ivydsd__Group_Type__c','Name'};
        String[] schmslabtrgtFields =  new String[]{'Id','ivydsd__Maximum_Value__c','ivydsd__Minimum_Value__c','ivydsd__Scheme_Group__c','ivydsd__Scheme_Slab__c','ivydsd__UOM__c'};
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Scheme_Slab_Target__c', schmslabtrgtFields) && SecurityUtility.checkIsAccessible('ivydsd__Scheme_Slab__c', schemeslabFields) &&SecurityUtility.checkIsAccessible('ivydsd__Scheme_Group__c', schemeGroupFields)){
            
            for(ivydsd__Scheme_Slab_Target__c slabTarget: [SELECT Id,
                                                           ivydsd__Maximum_Value__c,
                                                           ivydsd__Minimum_Value__c,
                                                           ivydsd__Scheme_Group__c,
                                                           ivydsd__Scheme_Group__r.Name,
                                                           ivydsd__Scheme_Slab__c,
                                                           Type__c,
                                                           ivydsd__UOM__c,
                                                           ivydsd__Scheme_Slab__r.ivydsd__Internal_Id__c,
                                                           ivydsd__Scheme_Group__r.ivydsd__Group_Type__c,
                                                           Product_Master__c
                                                   FROM ivydsd__Scheme_Slab_Target__c
                                                           WHERE 
                                                           ivydsd__Scheme_Slab__c IN:schemeSlabIdSet
                                                   AND ivydsd__Scheme_Group__r.ivydsd__Group_Type__c = 'Buy']){
                                                   
                if(!sGroupIdAndSSTargetListMap.containsKey(slabTarget.ivydsd__Scheme_Group__c)) {
                    sGroupIdAndSSTargetListMap.put(slabTarget.ivydsd__Scheme_Group__c, new List<ivydsd__Scheme_Slab_Target__c>());
                }
                sGroupIdAndSSTargetListMap.get(slabTarget.ivydsd__Scheme_Group__c).add(slabTarget);
            }
            return sGroupIdAndSSTargetListMap;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        }
    }
    
    public static Map<Id,ivydsd__Scheme_Slab__c> getSchemeSlabMap(Set<Id> schemeIdSet){
    
        String[] schemeFields = new String[]{'ivydsd__Description__c','ivydsd__Internal_Id__c','ivydsd__Scheme_Buy_Logic__c','ivydsd__Scheme_Type__c','Name','ivydsd__IsOnInvoice__c'};
        String[] schemeslabFields = new String[]{'Id', 'ivydsd__Internal_Id__c', 'ivydsd__Scheme__c'};
        
        if (SecurityUtility.checkIsAccessible('ivydsd__Scheme_Slab__c', schemeslabFields) && SecurityUtility.checkIsAccessible('ivydsd__Scheme__c', schemeFields)) {
        
            Map<Id,ivydsd__Scheme_Slab__c> schemeSlabMap = new Map<Id,ivydsd__Scheme_Slab__c>([SELECT Id,
                                                                                               ivydsd__Internal_Id__c,
                                                                                               ivydsd__Scheme__c,
                                                                                               ivydsd__Scheme__r.ivydsd__Description__c,
                                                                                               ivydsd__Scheme__r.ivydsd__Internal_Id__c,
                                                                                               ivydsd__Scheme__r.ivydsd__Scheme_Buy_Logic__c,
                                                                                               ivydsd__Scheme__r.ivydsd__Scheme_Get_Logic__c,
                                                                                               ivydsd__Scheme__r.ivydsd__Scheme_Type__c,
                                                                                               ivydsd__Scheme__r.ivydsd__From__c,
                                                                                               ivydsd__Scheme__r.ivydsd__To__c,
                                                                                               ivydsd__Scheme__r.Name,
                                                                                               ivydsd__Scheme__r.ivydsd__IsOnInvoice__c,
                                                                                               ivydsd__Scheme__r.Scheme_Value__c
                              FROM ivydsd__Scheme_Slab__c WHERE ivydsd__Scheme__c IN:schemeIdSet]);
            
            return schemeSlabMap;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');

        }
    }
    
    public static List<ivydsd__Scheme_Mapping__c> getSchemeIdSet(Set<String> storeHierarchyIdSet, Set<Id> DivisionIdSet) {
    
        UserwiseCountryValues__c  mc = UserwiseCountryValues__c.getInstance(userinfo.getUserId());
        if (mc.Market_ISO__c=='MY' || mc.Market_ISO__c=='SG') {
            return [SELECT Id,
                    ivydsd__Scheme__c,
                    ivydsd__Scheme__r.ivydsd__Internal_Id__c,
                    ivydsd__Store_Hierarchy__c,
                    ivydsd__Store_Hierarchy__r.ivybase__Internal_Id__c,
                    ivydsd__Internal_Id__c,
                    ivydsd__Scheme__r.ivydsd__IsOnInvoice__c
                    FROM ivydsd__Scheme_Mapping__c 
                    WHERE ivydsd__Scheme__r.ivydsd__Active__c='Yes' AND ivydsd__Scheme__r.Status__c='Approved' AND (ivydsd__Store_Hierarchy__c IN:storeHierarchyIdSet
                    OR Division__c IN:DivisionIdSet)
                    AND (ivydsd__Scheme__r.ivydsd__To__c = null OR ivydsd__Scheme__r.ivydsd__To__c >=:Date.today())];
        } else if(mc.Market_ISO__c == 'PH'){
            return [SELECT Id,
                    ivydsd__Scheme__c,
                    ivydsd__Scheme__r.ivydsd__Internal_Id__c,
                    ivydsd__Store_Hierarchy__c,
                    ivydsd__Store_Hierarchy__r.ivybase__Internal_Id__c,
                    ivydsd__Internal_Id__c,
                    ivydsd__Scheme__r.ivydsd__IsOnInvoice__c
                    FROM ivydsd__Scheme_Mapping__c 
                    WHERE ivydsd__Scheme__r.ivydsd__Active__c='Yes' AND (ivydsd__Store_Hierarchy__c IN:storeHierarchyIdSet
                        OR Division__c IN:DivisionIdSet)
                        AND ((ivydsd__Scheme__r.ivydsd__From__c = null OR ivydsd__Scheme__r.ivydsd__From__c <=:Date.today()) 
                        AND (ivydsd__Scheme__r.ivydsd__To__c = null OR ivydsd__Scheme__r.ivydsd__To__c >=:Date.today()))];
        }
        return null;
    }
    
    public static Map<String, ivydsd__Scheme_Slab__c> getSchemeSlabMapUsingInternalIds(Set<String> schemeSlabInternalIdSet){
    
       
        String[] schemeslabFields = new String[]{'Id', 'ivydsd__Internal_Id__c', 'ivydsd__Scheme__c'};
        
        if (SecurityUtility.checkIsAccessible('ivydsd__Scheme_Slab__c', schemeslabFields) ) {
        
            Map<String, ivydsd__Scheme_Slab__c> schemeSlabMap = new Map<string, ivydsd__Scheme_Slab__c>();
            for(ivydsd__Scheme_Slab__c schemeSlab : [SELECT Id, ivydsd__Internal_Id__c ,ivydsd__Scheme__c ,Name
                              FROM ivydsd__Scheme_Slab__c WHERE ivydsd__Internal_Id__c IN:schemeSlabInternalIdSet]){
                schemeSlabMap.put(schemeSlab.ivydsd__Internal_Id__c,schemeSlab);
            }
            
            return schemeSlabMap;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    public static Map<String, ivydsd__Scheme__c> getSchemeMapUsingInternalIds(Set<String> schemeInternalIdSet)
    {
        String[] schemeFields = new String[]{'Id', 'Name', 'ivydsd__Internal_Id__c'};
        
        if (SecurityUtility.checkIsAccessible('ivydsd__Scheme_Slab__c', schemeFields) ) {
        
            Map<String, ivydsd__Scheme__c > schemeMap = new Map<string, ivydsd__Scheme__c>();
            for(ivydsd__Scheme__c  scheme : [SELECT Id, Name ,ivydsd__Internal_Id__c
                              FROM ivydsd__Scheme__c  WHERE ivydsd__Internal_Id__c IN:schemeInternalIdSet]){
                schemeMap.put(scheme.ivydsd__Internal_Id__c,scheme);
            }
            
            return schemeMap;
            
        } else {
          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        
    }
    
    public static List<Promotion_Package_Capping__c> getSchemePackageCapping(Set<Id> schemeIdSet){
        
        String[] schemePackageCappingFields = new String[]{'Store__c','Division__c','Is_Package__c', 'Promotion__c', 'Market_ISO__c',
                                                           'Package_Count__c'};        
        
        if (SecurityUtility.checkIsAccessible('Promotion_Package_Capping__c', schemePackageCappingFields)) {
            
            return [SELECT Id,
                           Store__r.ivybase__Internal_Id__c,
                           Division__r.Internal_Id__c,
                           Division__r.Name,
                           Is_Package__c,
                           Promotion__r.ivydsd__Internal_Id__c,
                           Market_ISO__c,
                           Package_Count__c
                    FROM Promotion_Package_Capping__c
                    WHERE Promotion__c IN :schemeIdSet
                    AND Active__c = 'Yes'
                    AND ((Promotion_Package_Capping__c.Start_Date__c <=:date.today() 
                          AND 
                          Promotion_Package_Capping__c.End_Date__c >=:date.today()
                         ) 
                         OR 
                         ((Promotion_Package_Capping__c.Start_Date__c = null 
                           OR 
                           Promotion_Package_Capping__c.Start_Date__c<=:date.today()
                          ) 
                          AND 
                          (Promotion_Package_Capping__c.End_Date__c = null 
                           OR 
                           Promotion_Package_Capping__c.End_Date__c >=:date.today()
                          )
                         )
                        )
                   ];
                    
        } else {          
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }      
    }
}