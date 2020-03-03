public with sharing class ProductHierarchyService {
    
     public static List<ivybase__Product_Hierarchy__c> getAllProductHierarchy_List1(string market) {
        
        String[] prodFields = new String[] {'ivybase__Internal_Id__c', 'Name', 'ivybase__Level__c', 'ivybase__Active__c'}; 
      //  if (SecurityUtility.checkIsAccessible('Product_Hierarchy__c', prodFields )) { 
            return [SELECT  ivybase__Internal_Id__c,
                            Name,
                            ivybase__Level__c,
                            ivybase__Parent__r.ivybase__Internal_Id__c,
                            ivybase__Active__c,
                            RecordTypeId,
                            RecordType.Name,
                            ivybase__Description__c
                    FROM ivybase__Product_Hierarchy__c
                    WHERE ivybase__Is_Competitor__c = false
                    AND ivybase__Active__c = 'Yes' AND Market_ISO__c=:market
                    ORDER BY Name ASC
                   ];
        //} else {
            //throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
           // return null;
        //}
    }

    
    
    public static Map<Id,Set<Id>> getAlltheProductUnderProductHierarchywithSetOfPHId(set<Id> PHID)
    {
        List<ivybase__Product_Hierarchy__c> phList = [select 
                                                      id,
                                                      ivybase__Parent__c, 
                                                      ivybase__Parent__r.ivybase__Parent__c, 
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, 
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, 
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c, 
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c 
                                                      from ivybase__Product_Hierarchy__c where id=:PHID
                                                      OR
                                                      ivybase__Parent__c=:PHID
                                                      OR
                                                      ivybase__Parent__r.ivybase__Parent__c=:PHID
                                                      OR
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHID
                                                      OR
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHID
                                                      OR
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHID
                                                      OR
                                                      ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:PHID
                                                     ];
        
        Map<Id,Set<Id>> level3WithUpMap = new map<Id,Set<Id>>();
        
        for(ivybase__Product_Hierarchy__c p:phList)
        {
            Set<Id> tempSet= new Set<Id>();
            if(PHID.contains(p.id))
            {
                tempSet.add(p.id);
            }
            else if(p.ivybase__Parent__c!=null && PHID.contains(p.ivybase__Parent__c))
            {
                tempSet.add(p.id);
                if(p.ivybase__Parent__c!=null){
                    tempSet.add(p.ivybase__Parent__c);
                }
            }
            else if(p.ivybase__Parent__r.ivybase__Parent__c!=null && PHID.contains(p.ivybase__Parent__r.ivybase__Parent__c))
            {
                tempSet.add(p.id);
                if(p.ivybase__Parent__c!=null){
                    tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                                                                 }
                
            }
            else if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null && PHID.contains(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c))
            {
                tempSet.add(p.id);
                if(p.ivybase__Parent__c!=null){
                    tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                                                                 }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                    }
                
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null && PHID.contains(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c))
            {
                
                tempSet.add(p.id);
                if(p.ivybase__Parent__c!=null){
                    tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                                                                 }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                    }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                       }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                                          }
            }
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null && PHID.contains(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c) )
            {
                
                tempSet.add(p.id);
                if(p.ivybase__Parent__c!=null){
                    tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                                                                 }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                    }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                       }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                                          }}
            if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null && PHID.contains(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c))
            {
                tempSet.add(p.id);
                if(p.ivybase__Parent__c!=null){
                    tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                                                                 }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                    }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                       }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                                          }
                if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null){tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                                                                                                                                             }
            }
            level3WithUpMap.put(p.id,tempSet);
        }
        for(id level3:level3WithUpMap.keyset())
        {
            system.debug('level3'+level3+' - '+level3WithUpMap.get(level3));
        }
        Set<Id> all = new Set<Id>();
        all.addAll(PHID);
        all.addAll(level3WithUpMap.keyset());
        List<ivybase__Product__c> prod = [select id,ivybase__Parent__c, ivybase__Parent__r.ivybase__Parent__c,ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                                          from ivybase__Product__c where ivybase__Parent__c=:all OR ivybase__Parent__r.ivybase__Parent__c=:all OR ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c=:all ];
        Map<Id,Set<Id>> ProductwithPHMap = new Map<Id,Set<Id>>();
        for(ivybase__Product__c p:prod)
        {
            set<Id> tempSet = new Set<Id>();
            if(p.ivybase__Parent__c!=null && all.contains(p.ivybase__Parent__c))
            {
                if(level3WithUpMap.containsKey(p.ivybase__Parent__c))
                {
                    tempSet.addAll(level3WithUpMap.get(p.ivybase__Parent__c)); 
                }
                tempSet.add(p.ivybase__Parent__c);
                ProductwithPHMap.put(p.id,tempSet);
            }
            else if(p.ivybase__Parent__r.ivybase__Parent__c!=null && all.contains(p.ivybase__Parent__r.ivybase__Parent__c))
            {
                if(level3WithUpMap.containsKey(p.ivybase__Parent__r.ivybase__Parent__c))
                {
                    tempSet.addAll(level3WithUpMap.get(p.ivybase__Parent__r.ivybase__Parent__c)); 
                }
                if(p.ivybase__Parent__c!=null){
                tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){
                tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                }
                ProductwithPHMap.put(p.id,tempSet);
                
            }
            else if(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null && all.contains(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c))
            {
                if(level3WithUpMap.containsKey(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c))
                {
                    tempSet.addAll(level3WithUpMap.get(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c)); 
                }
                if(p.ivybase__Parent__c!=null){
                tempSet.add(p.ivybase__Parent__c);
                }
                if(p.ivybase__Parent__r.ivybase__Parent__c!=null){
                tempSet.add(p.ivybase__Parent__r.ivybase__Parent__c);
                }
                tempSet.add(p.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                ProductwithPHMap.put(p.id,tempSet);
                
            }
        }
        for(Id product : ProductwithPHMap.keyset())
        {
            system.debug('product '+product+' = '+ProductwithPHMap.get(product));
        }
        return ProductwithPHMap;
    }
	public static List<ivybase__Product_Hierarchy__c> getProductHierarchyFrom(set<String> ProductHierarchyCode){
	List<ivybase__Product_Hierarchy__c> productHierarchy = new list<ivybase__Product_Hierarchy__c>();
	productHierarchy=[select id,name,Code__c,ivybase__Parent__c from ivybase__Product_Hierarchy__c where Code__c=:ProductHierarchyCode ];
	return productHierarchy;
	}
	
    public static List<ivybase__Product__c> getfuntionbyproduct(set<id> prdid){
        list<ivybase__Product__c> prdfunct= [select id,ivybase__Parent__c from ivybase__Product__c where ID IN:prdid and ivybase__Parent__c!=null];
        return prdfunct;
    }
    public static List<ivybase__Product_Hierarchy__c> getAllProductHierarchy_List_For_The_Function(set<Id> productHierarchyFunctionId) {
        Set<Id> setOfProductHierarchyId = new Set<Id>();
        Set<Id> level2Id = new Set<Id>();
        Set<Id> level3Id = new Set<Id>();
        Set<Id> level4Id = new Set<Id>();
        Set<Id> level5Id = new Set<Id>();
        Set<Id> level6Id = new Set<Id>();
        Set<Id> level7Id = new Set<Id>();
        Set<Id> level8Id = new Set<Id>();
        Set<Id> level9Id = new Set<Id>();
        
        String[] prodFields = new String[] {'ivybase__Internal_Id__c', 'Name', 'ivybase__Parent__r', 'ivybase__Active__c','ivybase__Is_Competitor__c'}; 
            if (SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c', prodFields )) { 
                List<ivybase__Product_Hierarchy__c> ph = 
                    [select id,
                     name,
                     ivybase__Parent__r.Name,
                     ivybase__Parent__r.ivybase__Parent__r.Name,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Name,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Name,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Name
                     from ivybase__Product_Hierarchy__c where id=:productHierarchyFunctionId];
                for(ivybase__Product_Hierarchy__c prodHierarchy:ph)
                {
                    if(prodHierarchy.ivybase__Parent__c!=null)
                    {
                        level2Id.add(prodHierarchy.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        level3Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        level4Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        level5Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        level6Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                }
                
                
                
                
                
                List<ivybase__Product_Hierarchy__c> ph1 = 
                    [select id,
                     name,
                     ivybase__Parent__r.Name,
                     ivybase__Parent__r.ivybase__Parent__r.Name,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.Name
                     from ivybase__Product_Hierarchy__c where id=:level6Id];
                
                for(ivybase__Product_Hierarchy__c prodHierarchy:ph1)
                {
                    if(prodHierarchy.ivybase__Parent__c!=null)
                    {
                        level7Id.add(prodHierarchy.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        level8Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        level9Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                }
                
                system.debug('productHierarchyFunctionId'+productHierarchyFunctionId);
                system.debug('level9Id'+level9Id);
                system.debug('level8Id'+level8Id);
                system.debug('level7Id'+level7Id);
                system.debug('level6Id'+level6Id);
                system.debug('level5Id'+level5Id);
                system.debug('level4Id'+level4Id);
                system.debug('level3Id'+level3Id);
                system.debug('level2Id'+level2Id);
                
                setOfProductHierarchyId.addAll(level9Id);
                setOfProductHierarchyId.addAll(level8Id);
                setOfProductHierarchyId.addAll(level7Id);
                setOfProductHierarchyId.addAll(level6Id);
                setOfProductHierarchyId.addAll(level5Id);
                setOfProductHierarchyId.addAll(level4Id);
                setOfProductHierarchyId.addAll(level3Id);
                setOfProductHierarchyId.addAll(level2Id);
                setOfProductHierarchyId.addAll(productHierarchyFunctionId);
                return [SELECT  ivybase__Internal_Id__c,
                        Name,
                        ivybase__Level__c,
                        ivybase__Parent__r.ivybase__Internal_Id__c,
                        ivybase__Active__c,
                        ivybase__Parent__c,
                        RecordTypeId,
                        RecordType.Name,
                        ivybase__Description__c,
                        Code__c
                        FROM ivybase__Product_Hierarchy__c
                        WHERE id=:setOfProductHierarchyId
                        AND ivybase__Is_Competitor__c = false
                        AND ivybase__Active__c = 'Yes'
                        ORDER BY Name ASC
                       ];
                
                
            }
        else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        
        
        
        
        
        
    }
    public static List<ivybase__Product_Hierarchy__c> getAllProductHierarchy_List() {
        
        String[] prodFields = new String[] {'ivybase__Internal_Id__c', 'Name', 'ivybase__Level__c', 'ivybase__Active__c'}; 
            if (SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c', prodFields )) { 
                return [SELECT  ivybase__Internal_Id__c,id,
                        Name,
                        ivybase__Level__c,
                        ivybase__Parent__r.ivybase__Internal_Id__c,
                        ivybase__Active__c,
                        RecordTypeId,
                        RecordType.Name,
                        ivybase__Description__c
                        FROM ivybase__Product_Hierarchy__c
                        WHERE ivybase__Is_Competitor__c = false
                        AND ivybase__Active__c = 'Yes'
                        ORDER BY Name ASC
                       ];
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    }
       public static List<ivybase__Product_Hierarchy__c> getAllProductHierarchy_List(set<id> producthierachyids) {
        
        String[] prodFields = new String[] {'ivybase__Internal_Id__c', 'Name', 'ivybase__Level__c', 'ivybase__Active__c'}; 
            if (SecurityUtility.checkIsAccessible('ivybase__Product_Hierarchy__c', prodFields )) { 
                return [SELECT  ivybase__Internal_Id__c,id,
                        Name,
                        ivybase__Level__c,
                        ivybase__Parent__r.ivybase__Internal_Id__c,
                        ivybase__Active__c,
                       RecordTypeId,
                        RecordType.Name,
                        ivybase__Description__c
                        FROM ivybase__Product_Hierarchy__c
                        WHERE ivybase__Is_Competitor__c = false and id in:producthierachyids
                        AND ivybase__Active__c = 'Yes'
                        ORDER BY Name ASC 
                       ];
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    }
   public static  map<string,string> getAllProductHierarchy_MAP_For_The_SKU(set<Id> SKUIds,string prodlevel) {
        Set<Id> setOfProductHierarchyId = new Set<Id>();
        Set<Id> level2Id = new Set<Id>();
        Set<Id> level3Id = new Set<Id>();
        Set<Id> level4Id = new Set<Id>();
        Set<Id> level5Id = new Set<Id>();
        Set<Id> level6Id = new Set<Id>();
        Set<Id> level7Id = new Set<Id>();
        Set<Id> level8Id = new Set<Id>();
        Set<Id> level9Id = new Set<Id>();
        map<string,string> SKUlevel1Map=new map<string,string>();
        map<string,string> SKUlevel2Map=new map<string,string>();
        map<string,string> SKUlevel3Map=new map<string,string>();
        map<string,string> SKUlevel4Map=new map<string,string>();
        map<string,string> SKUlevel5Map=new map<string,string>();
        map<string,string> SKUlevel6Map=new map<string,string>();
        map<string,string> SKUlevel7Map=new map<string,string>();
        map<string,string> SKUlevel8Map=new map<string,string>();
        map<string,string> SKUlevel9Map=new map<string,string>();
        map<string,string> prodlevel5Map=new map<string,string>();
        map<string,string> prodlevel6Map=new map<string,string>();
        map<string,string> prodlevel7Map=new map<string,string>();
        map<string,string> prodlevel8Map=new map<string,string>();
       try{
         List<ivybase__Product__c> ph = 
                    [select id,
                     name,
                     ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__c,
                        ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                             from ivybase__Product__c where id in:SKUIds];
                for(ivybase__Product__c prod:ph)
                {
                    if(prod.ivybase__Parent__c!=null)
                    {
                        SKUlevel1Map.put(prod.id, prod.ivybase__Parent__c);
                       // level2Id.add(prod.ivybase__Parent__c);
                    }
                    if(prod.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                        SKUlevel2Map.put(prod.id, prod.ivybase__Parent__r.ivybase__Parent__c);
                       // level3Id.add(prod.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         SKUlevel3Map.put(prod.id, prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                     
                       // level4Id.add(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         SKUlevel4Map.put(prod.id, prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                     
                        //level5Id.add(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         SKUlevel5Map.put(prod.id, prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
          
                        level5Id.add(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                }
           system.debug('level5Id'+level5Id);
           system.debug('SKUlevel5Map'+SKUlevel5Map.keyset());
                 List<ivybase__Product_Hierarchy__c> ph1 = 
                    [select id,
                     ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                     from ivybase__Product_Hierarchy__c where id in :level5Id];
                system.debug('ph1'+ph1);
                for(ivybase__Product_Hierarchy__c prodHierarchy:ph1 )
                {
                    if(prodHierarchy.ivybase__Parent__c!=null)
                    {
                        prodlevel5Map.put(prodHierarchy.id, prodHierarchy.ivybase__Parent__c);
                       // level7Id.add(prodHierarchy.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         prodlevel6Map.put(prodHierarchy.id, prodHierarchy.ivybase__Parent__r.ivybase__Parent__c);
                      
                       // level8Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         prodlevel7Map.put(prodHierarchy.id, prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                      
                       // level9Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                     if(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         prodlevel8Map.put(prodHierarchy.id, prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                      
                       // level9Id.add(prodHierarchy.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                }
           system.debug('prodlevel7Map'+prodlevel7Map);
                for(string skuid:SKUlevel5Map.keyset()){
                    if(prodlevel5Map.get(SKUlevel5Map.get(skuid))!=Null)
                  SKUlevel6Map.put(skuid,prodlevel5Map.get(SKUlevel5Map.get(skuid)))  ;
                    if(prodlevel6Map.get(SKUlevel5Map.get(skuid))!=Null)
                  SKUlevel7Map.put(skuid,prodlevel6Map.get(SKUlevel5Map.get(skuid)))  ;
                    if(prodlevel7Map.get(SKUlevel5Map.get(skuid))!=Null)
                  SKUlevel8Map.put(skuid,prodlevel7Map.get(SKUlevel5Map.get(skuid)))  ;
                    if(prodlevel8Map.get(SKUlevel5Map.get(skuid))!=Null)
                  SKUlevel9Map.put(skuid,prodlevel8Map.get(SKUlevel5Map.get(skuid)))  ;
                }
                   system.debug('SKUlevel8Map'+SKUlevel8Map);             
            if(prodlevel=='function')
       return SKUlevel1Map;
       else  if(prodlevel=='class')
       return SKUlevel2Map;
        else if(prodlevel=='subaxe')
       return SKUlevel3Map;
         else if(prodlevel=='axe')
       return SKUlevel4Map;
        else if(prodlevel=='nuance')
       return SKUlevel5Map;
         else if(prodlevel=='reference')
       return SKUlevel6Map;
       else if(prodlevel=='subbrand')
       return SKUlevel7Map;
       else if(prodlevel=='brand')
       return SKUlevel8Map;
       else if(prodlevel=='signature')
       return SKUlevel9Map;
        
        else
            return null;
        
        
       }
       Catch(Exception e){
           
           system.debug('errormesaeg'+e.getMessage());
            return null;
       }
       
        
    }
    public static map<string,string> getSubAxeLevelLOVids(set<id> SKUIds){

         map<string,string> SKUlevel3Map=new map<string,string>();
         map<string,string> SKUlevelSubaxeMap=new map<string,string>();
           map<string,string> SubaxenameLovIdMap=new  map<string,string>();
       
       try{
           
              List<ivybase__Product__c> ph = 
                    [select id,
                     name,
                     ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__c,
                        ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.name,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,
                     ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c
                             from ivybase__Product__c where id in:SKUIds];
                for(ivybase__Product__c prod:ph)
                {
                      if(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
                    {
                         SKUlevel3Map.put(prod.id, prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.name);
                     
                       // level4Id.add(prod.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c);
                    }
                    
                   
                   
                }
               
        List<ivybase__Standard_List_Master__c> stdList = StandardListMasterService.getStandardListUsingListType(new List<String>{'SUB_AXE_LEVEL'});
        for(ivybase__Standard_List_Master__c stdmaster:stdList)
             SubaxenameLovIdMap.put(stdmaster.ivybase__List_Name__c.toLowerCase(), stdmaster.Name); 
           system.debug('SubaxenameLovIdMap'+SubaxenameLovIdMap);
   for(string s:SKUlevel3Map.keyset())
          SKUlevelSubaxeMap.put(s,SubaxenameLovIdMap.get(SKUlevel3Map.get(s).tolowercase()));
system.debug('SKUlevelSubaxeMap'+SKUlevelSubaxeMap);
       return SKUlevelSubaxeMap;
     }
           Catch(Exception e){
           
           system.debug('errormesaeg'+e.getMessage());
            return null;
       }
}
}