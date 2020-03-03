@RestResource(urlmapping='/v1/Scheme/Masters/*')
global with sharing class RESTSchemeManager {
    
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo  getSchemeInfo() {
    
        RExAPIResponseDomain.MultipleResponseInfo SchemeTablesDetail = new RExAPIResponseDomain.MultipleResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemeMaster = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemeBuyMaster = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemefreeMaster = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemeFreeProducts = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemeMapping = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemePackageCapping = new RExAPIResponseDomain.ResponseInfo();
        
        List<RExAPIResponseDomain.ResponseInfo> responsesList = new List<RExAPIResponseDomain.ResponseInfo>();
        
        try {
            
            Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = new Map<String, Set<String>>();
            Set<String> storeHierarchyIdSet = new Set<String>();
            Set<Id> schemeIdSet = new Set<Id>();
            Set<Id> schemeSlabIdSet = new Set<Id>();
            Map<Id, List<ivydsd__Scheme_Slab_Target__c>> sGroupIdAndSSTargetListMap = new Map<Id, List<ivydsd__Scheme_Slab_Target__c>>();
            List<ivydsd__Scheme_Group_Product__c> schemeGroupProductList = new List<ivydsd__Scheme_Group_Product__c>();
            list<ivydsd__Scheme_Group__c> schemegrouplist= new list<ivydsd__Scheme_Group__c>();
            Map<String,String> UOMAndInternalIdMap = new Map<String,String>();
            Map<Id, List<ivydsd__Scheme_Free_Detail__c>> schemegroupIdwithSchemeFreeDetailMap = new Map<Id, List<ivydsd__Scheme_Free_Detail__c>>();
            Map<Id, ivydsd__Scheme_Free_Detail__c> schemeFreeDetailMap = new Map<Id, ivydsd__Scheme_Free_Detail__c> ();
            List<ivydsd__Scheme_Group_Product__c> schemeFreeProductsList = new List<ivydsd__Scheme_Group_Product__c> ();
            List<Promotion_Package_Capping__c> schemePackageCappingList = new List<Promotion_Package_Capping__c> ();
            
            List<ivybase__Standard_List_Master__c> stdList = new List<ivybase__Standard_List_Master__c>();
            List<String> ListType = new List<String>();
            ListType.add('PRODUCT_UOM');
            ListType.add('DIVISION_TYPE');
            stdList = StandardListMasterService.getStandardListUsingListType(ListType);
            
            hierarchyNamewithSetOfIdsMap  = AccountService.getHierarchyIdsbysellerId_Map(ResourceService.getLoginSellerId());
            system.debug('::::hierarchyNamewithSetOfIdsMap::::'+hierarchyNamewithSetOfIdsMap);
            storeHierarchyIdSet =  hierarchyNamewithSetOfIdsMap.get('Store');
            if(storeHierarchyIdSet==null){
                storeHierarchyIdSet = new Set<String>(); 
            }
            system.debug(storeHierarchyIdSet+'storeHierarchyIdSet');
            
            List<ivybase__Location_Hierarchy__c> userTerritory = LocationMasterService.getUserTerritory();
            Set<Id> userTerritoryId = new Set<Id>(); 
            for(ivybase__Location_Hierarchy__c l:userTerritory)
            {
                 userTerritoryId.add(l.id);
            }
            Set<Id> divId = DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
             
            system.debug('divId'+divId);
            List<ivybase__Store_Hierarchy__c> storeHierarchiesReleatedToUserDivision = StoreHierarchyService.getStoreHierarchiedUnderDivision(divId);
            Set<String> relatedstoreId = new set<String>();
            for(ivybase__Store_Hierarchy__c sh:storeHierarchiesReleatedToUserDivision)
            {
                relatedstoreId.add(String.valueOf(sh.id));
            }
            Set<String> tempSHId =  new Set<String>(storeHierarchyIdSet);
            tempSHId.removeAll(relatedstoreId);
            storeHierarchyIdSet.removeAll(tempSHId);            

            List<ivydsd__Scheme_Mapping__c> schemeMappingList = SchemeService.getSchemeIdSet(storeHierarchyIdSet,divId);
            system.debug('schemeMappingList'+schemeMappingList);
            if (schemeMappingList != null && schemeMappingList.size() > 0) {
                for (ivydsd__Scheme_Mapping__c schemeMap : schemeMappingList ){
                    schemeIdSet.add(schemeMap.ivydsd__Scheme__c);
                }
            }
            system.debug('::::schemeIdSet:::'+schemeIdSet);
            
            Map<Id, ivydsd__Scheme_Slab__c> schemeSlabMap = SchemeService.getSchemeSlabMap(schemeIdSet);
            List<ivydsd__Scheme_Slab__c> schemeSlabList = new List<ivydsd__Scheme_Slab__c> ();
            system.debug('::::schemeSlabMap:::'+schemeSlabMap);
            
            if (schemeSlabMap != null && schemeSlabMap.size() > 0) {            
                schemeSlabIdSet = schemeSlabMap.keySet();
                schemeSlabList = schemeSlabMap.Values();
            }
            schemeMaster = schemeTranslator.getSchemeInfo(schemeSlabList,null);
            responsesList.add(schemeMaster);
            
            for( ivybase__Product_UOM__c productUOM :ProductUOMService.getProductUOMList(divId)){
                UOMAndInternalIdMap.put(String.valueOf(productUOM.ivybase__Product__r.ivybase__InternalId__c),productUOM.ivybase__UOM__c);
            } 
            
            sGroupIdAndSSTargetListMap = SchemeService.getSchemeGroupAndTargetList(schemeSlabIdSet);
            system.debug(':::sGroupIdAndSSTargetListMap:::'+sGroupIdAndSSTargetListMap);
            
            schemeGroupProductList  = SchemeService.getSchemeGroupProductList(schemeIdSet);
            schemegrouplist=SchemeService.getSchemeGroupList(schemeIdSet);
            
            system.debug(':::schemeGroupProductList:::'+schemeGroupProductList);
            
            schemeBuyMaster = schemeTranslator.getSchemeBuyInfo(sGroupIdAndSSTargetListMap,schemeGroupProductList,UOMAndInternalIdMap,stdList,schemegrouplist,null);
            responsesList.add(schemeBuyMaster);
            
            //SchemeFreeMaster 
            schemeFreeDetailMap = SchemeService.getSchemeFreeDetails(schemeSlabIdSet);
            
            schemefreeMaster = schemeTranslator.getSchemeFreeDetailInfo(schemeFreeDetailMap, null);
            responsesList.add(schemefreeMaster);
            
            // SchemeFreeProducts           
            
            if (schemeFreeDetailMap != null && schemeFreeDetailMap.size() > 0) {
                for (ivydsd__Scheme_Free_Detail__c sfd : schemeFreeDetailMap.Values()) {
                    if (sfd.ivydsd__Scheme_Group__c != null) {
                        if (!schemegroupIdwithSchemeFreeDetailMap.containsKey(sfd.ivydsd__Scheme_Group__c)) {
                            schemegroupIdwithSchemeFreeDetailMap.put(sfd.ivydsd__Scheme_Group__c, new List<ivydsd__Scheme_Free_Detail__c>());
                        } 
                        schemegroupIdwithSchemeFreeDetailMap.get(sfd.ivydsd__Scheme_Group__c).add(sfd); 
                    }
                }
            }
            
            schemeFreeProductsList = SchemeService.getSchemeFreeProductsList(schemegroupIdwithSchemeFreeDetailMap.keySet());
            schemeFreeProducts = schemeTranslator.getSchemeFreeProductsInfo(SchemeFreeProductsList,schemegroupIdwithSchemeFreeDetailMap, stdList, null);
            responsesList.add(schemeFreeProducts);
            
            schemeMapping= schemeTranslator.getSchemeMappingInfo(schemeMappingList , null);
            responsesList.add(schemeMapping);
            
            //SchemePackageCapping
            Map<String,String> StdLovidDivisionmap = new Map<String,String>();
            
            //List<ivybase__Standard_List_Master__c> stdListMaster = StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')});
            StdLovidDivisionmap = SchemeTranslator.stdMap(stdList);           
        
            schemePackageCappingList = SchemeService.getSchemePackageCapping(schemeIdSet);
            schemePackageCapping = schemeTranslator.getSchemePackageCappingInfo(schemePackageCappingList, StdLovidDivisionmap, null);
            responsesList.add(schemePackageCapping);
                        
            SchemeTablesDetail.Tables = responsesList;
            

        } catch (SecurityUtility.SFDCAccessControlException ex) {
        
            responsesList = new List<RExAPIResponseDomain.ResponseInfo>();
            schemeMaster = schemeTranslator.getSchemeInfo(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            schemeBuyMaster = schemeTranslator.getSchemeBuyInfo(null,null,null,null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            schemefreeMaster = schemeTranslator.getSchemeFreeDetailInfo(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            schemeFreeProducts = schemeTranslator.getSchemeFreeProductsInfo(null,null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            schemeMapping = schemeTranslator.getSchemeMappingInfo(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            schemePackageCapping = schemeTranslator.getSchemePackageCappingInfo(null, null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
            responsesList.add(schemeMaster );
            responsesList.add(schemeBuyMaster );
            responsesList.add(schemefreeMaster );
            responsesList.add(schemeFreeProducts ); 
            responsesList.add(schemeMapping);
            responsesList.add(schemePackageCapping);
            
            SchemeTablesDetail.Tables = responsesList;  
        }
        return SchemeTablesDetail;
    }
    
}