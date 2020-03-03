@RestResource(UrlMapping='/v1/DigitalSchemeMappingMaster/')
global with sharing class RestDigitalContentScheme {
    
    @httpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getDigitalContentSchemeinfo(){
        RExAPIResponseDomain.MultipleResponseInfo DigitalContentSchemeResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        DigitalContentSchemeResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo DigitalScheme = new RExAPIResponseDomain.ResponseInfo(); 
        Id sellerId = ResourceService.getLoginSellerId();
        Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
        Set<Id> digitalcontentIds = new Set<Id>();
        
        //RExAPIResponseDomain.ResponseInfo digitalContentMapInfo = new RExAPIResponseDomain.ResponseInfo ();
        List<ivybase__Digital_Content_Mapping__c> digitalContentMapList = DigitalContentMasterService.getAllContentMappingList(hierarchyNamewithSetOfIdsMap );
        for(ivybase__Digital_Content_Mapping__c dcm : digitalContentMapList){
            digitalcontentIds.add(dcm.ivybase__Digital_Content__c);
        }
        
        List<ivybase__Digital_Content_Mapping__c> schmList = DigitalContentSchemeService.getAllContentMappingSchemeList(digitalcontentIds);
        DigitalScheme=DigitalContentSchemeTranslator.objectToSchemeinfo(schmList,null);
        system.debug('DigitalScheme'+DigitalScheme);
        DigitalContentSchemeResponse.Tables.add(DigitalScheme);
        return DigitalContentSchemeResponse;
    }
}