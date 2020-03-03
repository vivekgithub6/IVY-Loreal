@RestResource(urlMapping='/v1/ProductTagging/Masters/*')
global with sharing class RESTProductTagging {
    
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getProductTagging() {
        
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        RExAPIResponseDomain.ResponseInfo ProductTaggingMasterInfo;
        RExAPIResponseDomain.ResponseInfo ProductTaggingGroupMappingInfo;
        RExAPIResponseDomain.ResponseInfo ProductTaggingCriteriaMappingInfo;
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        
        try {
            
            Set<Id> producGrpIds = new Set<Id>();
            
            List<ivybase__Product_Group_Mapping__c> prodgrpmaplist = ProductGroupService.getProductgroupMappping_List();
            system.debug('prodgrpmaplist'+prodgrpmaplist);
            ProductTaggingCriteriaMappingInfo = ProductGroupTranslator.objectToProductGroupMappingInfo(prodgrpmaplist,null);
            response.Tables.add(ProductTaggingCriteriaMappingInfo);
            
            if(prodgrpmaplist != NULL) {
                for(ivybase__Product_Group_Mapping__c pgm : prodgrpmaplist) {
                    
                    producGrpIds.add(pgm.ivybase__Product_Group__c);
                }
            }
            
            List<ivybase__Product_Group__c> productgrouplist = ProductgroupService.getAllProductGroup_List(producGrpIds);
            system.debug('productgrouplist'+productgrouplist);
           // Resource__c res = ResourceService.getSellerId(UserInfo.getUserId());
           // Id locHieId = res != null ? res.Location_Hierarchy__c : null;
           // Id resTypeId = res != null ? res.Resource_Type__c : null;
           // 
            List<String> SLmTypeString = new List<String>();
            SLmTypeString.add('PRODUCT_TAGGING');
            List<ivybase__Standard_List_Master__c> SLMList = StandardListMasterService.getStandardListUsingListType(SLmTypeString);

           // List<Standard_List_Master__c> SLMList = StandardListMasterService.getStandardlistbyresandlocid('PRODUCT_TAGGING',resTypeId,locHieId);
            ProductTaggingMasterInfo = ProductGroupTranslator.objectToProductTaggingInfo(productgrouplist,SLMList,null);
            response.Tables.add(ProductTaggingMasterInfo);
                        system.debug('producGrpIds'+producGrpIds);
            List<ivybase__Product_Group_Detail__c> prodgrpdetlist = ProductGroupService.getAllProductGroupDetail_List(producGrpIds);
            system.debug('prodgrpdetlist'+prodgrpdetlist);
            ProductTaggingGroupMappingInfo = ProductGroupTranslator.objectToProductGroupDetailInfo(prodgrpdetlist,null);
            response.Tables.add(ProductTaggingGroupMappingInfo);
            
            
            
         } catch (SecurityUtility.SFDCAccessControlException ex) {
         
            ProductTaggingMasterInfo = ProductGroupTranslator.objectToProductTaggingInfo(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(ProductTaggingMasterInfo);
            
            ProductTaggingGroupMappingInfo = ProductGroupTranslator.objectToProductGroupDetailInfo(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(ProductTaggingGroupMappingInfo);
           
            ProductTaggingCriteriaMappingInfo = ProductGroupTranslator.objectToProductGroupMappingInfo(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(ProductTaggingCriteriaMappingInfo);
        }
      
        return response;
    }
}