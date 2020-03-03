global class ProductGroupService {
    public static List<ivybase__Product_Group_Detail__c> getAllProductGroupDetail_List(Set<Id> producGrpIds) {
        
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        
        List<ivybase__Product_Group_Detail__c> pgdList = new List<ivybase__Product_Group_Detail__c>();
        System.debug('producGrpIds===>'+producGrpIds);
        if(producGrpIds != NULL && producGrpIds.size() > 0) {
            
            pgdList = [SELECT ivybase__Product_Group__r.ivybase__Internal_Id__c,
                       ivybase__Product__r.ivybase__InternalId__c,
                       ivybase__Target_Price__c,
                       ivybase__Product_Group__r.RecordtypeId,
                       ivybase__Product_Group__r.RecordType.developerName,
                       ivybase__Product__r.Division__c ,
                       ivybase__Sequence__c,
                       ivybase__Product__r.ivybase__Is_Competitor__c,
                       ivybase__Product_Group__r.RecordType.Name,
                       ivybase__isAvail__c,
                       ivybase__isFacing__c,
                       ivybase__isStock__c,
                       ivybase__Target__c,
                       ivybase__Category__c,
                       ivybase__Standard_List_Master__r.Name
                       FROM ivybase__Product_Group_Detail__c WHERE ivybase__Product_Group__c IN :producGrpIds AND (ivybase__Product_Group__r.ivybase__Start_Date__c = null OR ivybase__Product_Group__r.ivybase__Start_Date__c <= :surveyProcessDate)
                       AND (ivybase__Product_Group__r.ivybase__End_Date__c >= :surveyProcessDate OR ivybase__Product_Group__r.ivybase__End_Date__c = null)
                       AND ivybase__Product_Group__r.ivybase__Active__c = 'Yes' LIMIT 11000];
        }
        System.debug('++++pgdList' + pgdList);
        return pgdList;
    }
    public static List<ivybase__Product_Group__c> getAllProductGroup_List(Set<Id> producGrpIds) {
        
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        date todaydate= date.today();
        Id res = ResourceService.getLoginSellerId();
        List<ivybase__Product_Group__c> prodGrps = new List<ivybase__Product_Group__c>();
                
        if(producGrpIds != NULL && producGrpIds.size() > 0) {
            
            prodGrps =  [SELECT ivybase__Internal_Id__c,ivybase__Grouping_Type__c,RecordTypeId,RecordType.developerName,RecordType.Name
                         FROM ivybase__Product_Group__c 
                         WHERE Id IN :producGrpIds AND (ivybase__Start_Date__c = null OR ivybase__Start_Date__c <= :todaydate)
                         AND (ivybase__End_Date__c >= :todaydate OR ivybase__End_Date__c = null) AND ivybase__Active__c = 'Yes'];
        }
        System.debug('++++prodGrps' + prodGrps);
        return prodGrps;
    }
    public static List<ivybase__Product_Group_Mapping__c> getProductgroupMappping_List() {
        
        Id sellerId = ResourceService.getLoginSellerId();
        List<ivybase__Product_Group_Mapping__c> pgmList = new List<ivybase__Product_Group_Mapping__c>();
        
        if(sellerId != null) {
            
            Map<String,Set<String>> hierarchymap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
            String[] progrpmapFields = new String[] {'ivybase__Product_Group__c', 'ivybase__Distributor__c', 'ivybase__Location_Hierarchy__c','ivybase__Store_Hierarchy__c'}; 
            String[] progrpmap1Fields = new String[] {'ivybase__Internal_Id__c'};
            String[] territoryFields = new String[] {'ivybase__InternalId__c'};
        
            if (SecurityUtility.checkIsAccessible('ivybase__Product_Group_Mapping__c', progrpmapFields) && 
                SecurityUtility.checkIsAccessible('ivybase__Product_Group__c', progrpmap1Fields) && 
                SecurityUtility.checkIsAccessible('Account', progrpmap1Fields)
                && SecurityUtility.checkIsAccessible('ivybase__Location_Hierarchy__c', progrpmap1Fields) && 
                SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', progrpmap1Fields)) {
                
                String pgmQryString = 'SELECT ivybase__Product_Group__c,ivybase__Product_Group__r.ivybase__Internal_Id__c,'+
                    'ivybase__Distributor__r.RecordType.DeveloperName,ivybase__Distributor__r.ivybase__Internal_Id__c,'+
                    'ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c,ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c,' + 
                    'ivybase__Territory__r.ivybase__InternalId__c FROM ivybase__Product_Group_Mapping__c ';
                String pgmQryClone = pgmQryString;
                
                Set<String> territoryId = new Set<String>();
                List<ivybase__Location_Hierarchy__c> userTerritory=LocationMasterService.getUserTerritory();
                for(ivybase__Location_Hierarchy__c l:userTerritory)
                {
                    territoryId.add(String.valueOf(l.Id));
                }
                Set<String> locSet = LocationMasterService.getAllParentLocationHierarchy(territoryId);
                if(hierarchymap != NULL) {
                    
                    
                    Set<String> storeSet = StoreHierarchyService.getAllParentStoreHierarchy(hierarchymap.get('Store'));
                    System.debug('storeSet'+storeSet);
                    Set<String> accSet = hierarchymap.get('Account');
                    String subQry = '';
                    
                    subQry += locSet != NULL ? 'ivybase__Location_Hierarchy__c IN :locSet OR ivybase__Territory__c IN :locSet' : '';
                    if(String.isNotBlank(subQry)){
                        
                        subQry += storeSet != NULL ? ' OR ivybase__Store_Hierarchy__c IN :storeSet' : '';
                    }
                    else{
                        
                        subQry += storeSet != NULL ? ' ivybase__Store_Hierarchy__c IN :storeSet' : '';
                    }
                    if(String.isNotBlank(subQry)){
                        
                        subQry += (accSet != NULL) ? ' OR ivybase__Distributor__c IN :accSet' : '';
                    }
                    else{
                        
                        subQry += accSet != NULL ? ' ivybase__Distributor__c IN :accSet' : '';
                    }
                    pgmQryString += subQry != '' ? (' WHERE ' + subQry) : ' LIMIT 10000';
                    pgmList = Database.query(pgmQryString);
                }         
                
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
        }
        System.debug('++++pgmList++'+pgmList);
        return pgmList;
    }
    
    public static Set<Id> getAllProductBasedOnGroupRecordType(String recordType)
    {
        
        List<ivybase__Product_Group__c > prodGrps = new List<ivybase__Product_Group__c >();
        prodGrps=[SELECT Id,ivybase__Internal_Id__c,ivybase__Grouping_Type__c,RecordTypeId,RecordType.developerName,RecordType.Name
                  FROM ivybase__Product_Group__c  
                  WHERE (ivybase__Start_Date__c  = null OR ivybase__Start_Date__c  <= TODAY)
                  AND (ivybase__End_Date__c  >= TODAY OR ivybase__End_Date__c  = null) AND ivybase__Active__c = 'Yes' AND RecordType.developerName=:recordType ];
        Set<Id> groupId = new Set<Id>();
        for(ivybase__Product_Group__c gp:prodGrps)
        {
            groupId.add(gp.Id); 
        }
        System.debug('groupId'+groupId);
        List<ivybase__Product_Group_Detail__c> productGrpDetail = new List<ivybase__Product_Group_Detail__c>();
        productGrpDetail=[select Id,ivybase__Product__c from ivybase__Product_Group_Detail__c where ivybase__Product_Group__c=:groupId];
        System.debug('productGrpDetail::: '+productGrpDetail);
        Set<Id> top20SkuProductIdSet = new Set<Id>();
        for(ivybase__Product_Group_Detail__c pd:productGrpDetail)
        {
            top20SkuProductIdSet.add(pd.ivybase__Product__c);
        }
        System.debug('top20SkuProductIdSet'+top20SkuProductIdSet);
        return top20SkuProductIdSet;
    }
    public static Boolean CheckbrandInProductGroup(Map<Id,Set<Id>> AccountProductMap,Map<Id,Set<Id>> AccountSkuMap,Map<ivybase__Product_Group__c,List<ivybase__Product_Group_Detail__c>> ProductGroupdetailMap){
        Set<Id> BrandIDS=new Set<Id>();
        Set<Id> SKUIDS=new Set<Id>();
        Set<Id> mandatorybrandIds=new Set<Id>();
        Set<Id> mandatorySKUIds=new Set<Id>();
        Set<Id> AccountBrandIds=new Set<Id>();
        Set<Id> AccountSKUIds=new Set<Id>();
        Decimal BuyLogicValue;
        string BuyLogic;
        Boolean IsExisted=false;
        for(ivybase__Product_Group__c pg:ProductGroupdetailMap.keyset()){
            
            if(string.valueof(pg.Buy_Logic_Value__c)!=Null)
                BuyLogicValue=pg.Buy_Logic_Value__c;
            else
                BuyLogicValue=0;  
            BuyLogic=pg.Buy_Logic__c;
            System.debug('BuyLogic'+BuyLogic);
            if(pg.Buy_Logic__c=='ALL')
                for(ivybase__Product_Group_Detail__c pd:ProductGroupdetailMap.get(pg)){
                    if(pd.Product_Hierarchy__c!=Null)
                        BrandIDS.add(pd.Product_Hierarchy__c);
                    if(pd.ivybase__Product__c!=Null)
                        SKUIDS.add(pd.ivybase__Product__c);
                }
            if(pg.Buy_Logic__c=='ANY')
                for(ivybase__Product_Group_Detail__c pd:ProductGroupdetailMap.get(pg)){
                    if(pd.Is_Mandatory__c==True && pd.recordtype.developername=='Brand')
                        mandatoryBrandIds.add(pd.Product_Hierarchy__c);
                    if(pd.Is_Mandatory__c==True && pd.recordtype.developername=='SKU')
                        mandatorySKUIds.add(pd.ivybase__Product__c);
                    if(pd.recordtype.developername=='Brand')
                        BrandIDS.add(pd.Product_Hierarchy__c);
                    if(pd.recordtype.developername=='SKU')
                        SKUIDS.add(pd.ivybase__Product__c);
                    
                }   
        }
        System.debug('BrandIDS'+BrandIDS);
        System.debug('AccountId'+AccountProductMap.keyset());
        System.debug('SKUDIS'+SKUIDS);
        System.debug('AccountId'+AccountSkuMap.keyset());
        //Iterating an dchecking whtehwr they are present or not Brand
        if(BrandIDS.size()>0)
            for(Id AccountId:AccountProductMap.keyset()){
                AccountBrandIds.addall(AccountProductMap.get(AccountId));
                Integer BrandIDSize=BrandIDS.size();
                Integer AccountBrandIdSize=AccountProductMap.get(AccountId).size();
                if(mandatoryBrandIds.size()>0 || BuyLogic=='ANY'){
                    BrandIDS.addall(AccountProductMap.get(AccountId));
                    Integer AllBrandIdssize=BrandIDS.size();
                    
                    if(AccountProductMap.get(AccountId).containsall(mandatoryBrandIds)){
                        Integer diff=(BrandIDSize+AccountBrandIdSize)-AllBrandIdssize;
                        if(diff>=BuyLogicValue)
                            IsExisted=True;
                        else
                            IsExisted=False;
                    }
                    else
                        IsExisted=False;  
                } else{
                    if(AccountBrandIds.containsall(BrandIDS))
                        IsExisted=True;
                    else
                        IsExisted=False;
                }
            }
        //Iterating an dchecking whtehwr they are present or not SKU
        System.debug('AccountSkuMap'+AccountSkuMap);
        if(SKUIDS.size()>0) {
            for(Id AccountId:AccountSkuMap.keyset()) {
                AccountSKUIds.addall(AccountSkuMap.get(AccountId));
                System.debug('AccountSKUIds'+AccountSKUIds);
                System.debug('skuIds'+SKUIDS);
                Integer SKUIDSize=SKUIDS.size();
                Integer AccountSKUIdSize=AccountSkuMap.get(AccountId).size();
                
                if(mandatorySKUIds.size()>0 || BuyLogic=='ANY') {
                    System.debug('InsIde IF 1st');
                    SKUIDS.addall(AccountSkuMap.get(AccountId));
                    Integer AllSKUIdssize=SKUIDS.size();
                    System.debug('AllSKUIdssize'+AllSKUIdssize);
                    System.debug('mandatorySKUIds'+mandatorySKUIds);
                    if(AccountSkuMap.get(AccountId).containsall(mandatorySKUIds)) {
                        System.debug('mandatory if');
                        System.debug('SKUIDSize'+SKUIDSize);
                        System.debug('AccountSKUIdSize'+AccountSKUIdSize);
                        Integer diff=(SKUIDSize+AccountSKUIdSize)-AllSKUIdssize;
                        System.debug('diff'+diff);
                        if(diff>=BuyLogicValue)
                            IsExisted=True;
                        else
                            IsExisted=False;
                    } else {
                        System.debug('AccountSKUIds'+AccountSKUIds);
                        System.debug('SKUIDS'+SKUIDS);
                        System.debug('else 1');
                        IsExisted=False;  
                    }
                } else {
                    if(AccountSKUIds.containsall(SKUIDS)){
                        System.debug('Enetered second if');
                        IsExisted=True;
                    } else
                        IsExisted=False;
                }
            }
        }
        return IsExisted;
    }
}