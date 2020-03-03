public with sharing class ProductService {
	   public static List<ivybase__Product__c> getProductFromProductCode(Set<String> ProductCode) {
	   List<ivybase__Product__c> relatedProduct = new List<ivybase__Product__c>();
	   relatedProduct=[select id,name,External_Code__c,ivybase__Code__c,ivybase__Parent__c from ivybase__Product__c where External_Code__c=:ProductCode];
	   return relatedProduct;
	   }
	   public static Map<Id,Id> getProductAndDivisionMap(Set<Id> ProductId) {
	   List<ivybase__Product__c> relatedProduct = new List<ivybase__Product__c>();
	   Map<Id,Id> productDivisionMap = new Map<Id,Id>();
	   relatedProduct=[select id,name,Division__c from ivybase__Product__c where id=:ProductId];
	   for(ivybase__Product__c p:relatedProduct)
	   {
	   	productDivisionMap.put(p.id,p.Division__c);
	   }
	   return productDivisionMap;
	   }
    public static List<ivybase__Product__c> getAllProduct_List(Set<Id> divId) {
        
        String[] prodFields = new String[] {'ivybase__InternalId__c', 'Name', 'ivybase__Code__c', 'ivybase__Short_Description__c', 'ivybase__Barcode__c', 'ivybase__Parent__c', 'ivybase__Returnable__c', 'ivybase__Non_Saleable__c', 'ivybase__Full_Description__c','ivybase__Active__c','ivybase__Is_Competitor__c'}; 
        String[] prohieFields = new String[]{'ivybase__Level__c','ivybase__Internal_Id__c'};
        if (SecurityUtility.checkIsAccessible('ivybase__Product__c', prodFields ) && SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c', prohieFields )) { 
            return [SELECT  ivybase__InternalId__c,
                            Name,
                            ivybase__Code__c,
                            ivybase__Short_Description__c,
                            ivybase__Barcode__c,
                            ivybase__Parent__r.ivybase__Level__c,
                            ivybase__Parent__r.ivybase__Internal_Id__c,
                            ivybase__Parent__c,
                            ivybase__Default_UOM__c,
                            ivybase__Returnable__c,
                            RecordType.Name,
                    IsPackage__c,
                            ivybase__Non_Saleable__c,
                            ivybase__Full_Description__c,
                            ivybase__Active__c,
                    		Division__c ,Promotion_Item_Type__c
                    FROM ivybase__Product__c
                    WHERE ivybase__Is_Competitor__c = false
                    AND ivybase__Active__c = 'Yes'
                    AND Division__c=:divId
                    ORDER BY Name ASC 
                   ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }   
    public static Map<String, ProductDomain.cls_ProductService> getPhIdOrProdId(Set<String> internalId) {
      
        Map<String, ProductDomain.cls_ProductService> prodOrPhieMap = new Map<String, ProductDomain.cls_ProductService>();
        ProductDomain.cls_ProductService temp;
        
        String[] pFields = new String[] {'ivybase__InternalId__c'}; 
        Set<Decimal> internalIdSet = new Set<Decimal>();
        for(String st : internalId) {
            internalIdSet.add(Decimal.valueOf(st));
        }
        if (SecurityUtility.checkIsAccessible('ivybase__Product__c', pFields)) {
            for(ivybase__Product__c pd : [SELECT Id, ivybase__InternalId__c FROM ivybase__Product__c WHERE ivybase__InternalId__c IN :internalIdSet]) {
                temp = new ProductDomain.cls_ProductService();
                temp.objtype = 'ivybase__Product__c';
                temp.internalid = String.valueOf(pd.ivybase__InternalId__c);
                temp.sfid = pd.Id;
                prodOrPhieMap.put(String.valueOf(pd.ivybase__InternalId__c), temp);
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
        
        String[] phFields = new String[] {'ivybase__Internal_Id__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c', phFields)) {
            for(ivybase__Product_Hierarchy__c ph : [SELECT Id, ivybase__Internal_Id__c FROM ivybase__Product_Hierarchy__c WHERE ivybase__Internal_Id__c IN :internalId]) {
                temp = new ProductDomain.cls_ProductService();
                temp.objtype = 'ivybase__Product_Hierarchy__c';
                temp.internalid = ph.ivybase__Internal_Id__c;
                temp.sfid = ph.Id;
                prodOrPhieMap.put(ph.ivybase__Internal_Id__c, temp);
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
        
        return prodOrPhieMap;
    }
    
    
     public static Map<String, Id> getSFIdByInternalId(Set<String> internalId) {

        String[] pFields = new String[] {'ivybase__InternalId__c', 'ivybase__Active__c'}; 
        Set<Decimal> internalIdSet = new Set<Decimal>();
        for(String st : internalId) {
            internalIdSet.add(Decimal.valueOf(st));
        }
        if (SecurityUtility.checkIsAccessible('ivybase__Product__c', pFields)) {
            if (internalId != null && internalId.size() > 0) {
                Map<String, Id> prodInternalIdwithIdMap = new Map<String, Id>();
                for (ivybase__Product__c pro: [SELECT Id, ivybase__InternalId__c FROM ivybase__Product__c WHERE ivybase__InternalId__c != NULL AND ivybase__InternalId__c IN:internalIdSet AND ivybase__Active__c = 'Yes']) {
                    prodInternalIdwithIdMap.put(String.valueOf(pro.ivybase__InternalId__c), pro.Id);
                }    
                return prodInternalIdwithIdMap;
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        return null;
    }
     public static Map<String,ivybase__Product__c> getSFRecordByInternalId(Set<String> internalId) {

        String[] pFields = new String[] {'ivybase__InternalId__c','ivybase__Non_Saleable__c ', 'ivybase__Active__c'}; 
        Set<Decimal> internalIdSet = new Set<Decimal>();
        for(String st : internalId) {
            internalIdSet.add(Decimal.valueOf(st));
        }
         System.debug('internalIdSet====>'+internalIdSet);
        if (SecurityUtility.checkIsAccessible('ivybase__Product__c', pFields)) {
            if (internalId != null && internalId.size() > 0) {
                Map<String, ivybase__Product__c> prodInternalIdwithIdMap = new Map<String, ivybase__Product__c>();
                for (ivybase__Product__c pro: [SELECT Id, ivybase__InternalId__c,ivybase__Non_Saleable__c  FROM ivybase__Product__c WHERE ivybase__InternalId__c != NULL AND ivybase__InternalId__c IN:internalIdSet]) {
                    prodInternalIdwithIdMap.put(String.valueOf(pro.ivybase__InternalId__c), pro);
                }    
                return prodInternalIdwithIdMap;
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        return null;
    }
    
        public static Map<ID,Set<ID>> getprodvsprodhrchyMap(set<Id> ProductId) {
        
        
        //set<Id> ProductId  = new Set<ID>();
        Map<ID,Set<ID>> ProductVSPRoductHierarchy = new Map<Id,Set<ID>>();
        List<ivybase__Product__c> prod = [select id,name,
                                          ivybase__Parent__c,
                                          ivybase__Parent__r.ivybase__Parent__c,  
                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,  
                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,  
                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,  
                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                          from ivybase__Product__c where id=:ProductId ];
        system.debug('prod'+prod);
        Set<Id> FinalPHId = new Set<Id>();
        for(ivybase__Product__c p:prod)
        {
            Set<Id> PHId = new Set<Id>();
            if(p.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__c);
            }
            if(p.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                FinalPHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
            }
            
            
            ProductVSPRoductHierarchy.put(p.id,PHId);
        }
        
        List<ivybase__Product_Hierarchy__c> phierarchy = [select id,name,
                                                          ivybase__Parent__c,
                                                          ivybase__Parent__r.ivybase__Parent__c,
                                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, 
                                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, 
                                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, 
                                                          ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                                          from ivybase__Product_Hierarchy__c where id=:FinalPHId
                                                         ];
        Map<Id,Set<Id>> COntPHandPHId = new Map<Id,Set<Id>>(); 
        for(ivybase__Product_Hierarchy__c p:phierarchy)
        {
            Set<Id> PHId = new Set<Id>();
            if(p.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__c);
            }
            if(p.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c); 
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            {
                PHId.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
            }
            COntPHandPHId.put(p.id,PHId);
        }
        
        for(Id pId:ProductVSPRoductHierarchy.keySet())
        {
            for(Id level6Id:COntPHandPHId.keySet())
            {
                if(ProductVSPRoductHierarchy.get(pId).contains(level6Id))
                {
                    ProductVSPRoductHierarchy.get(pId).addAll(COntPHandPHId.get(level6Id)); 
                }
            }
        }
        
        return ProductVSPRoductHierarchy;
    }
    

}