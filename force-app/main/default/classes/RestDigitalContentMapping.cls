@RestResource(urlMapping='/v1/DigitalContentMapping/Masters/')
Global with sharing class RestDigitalContentMapping {

    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getDigitalContentMasters() {
        RExAPIResponseDomain.MultipleResponseInfo digitalContentResponse = new RExAPIResponseDomain.MultipleResponseInfo();        
        digitalContentResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();  
        try {            
            List<RExAPIResponseDomain.ResponseInfo> tableList = new List<RExAPIResponseDomain.ResponseInfo>();

            // Id sellerId = ContactService.getLoginSellerId();
            Id sellerId = ResourceService.getLoginSellerId();
            system.debug('sellerId'+sellerId);
            map<string,string> Divisionlovidmap= new map<string,string>();//getting division ids
            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')}))
            {
                Divisionlovidmap.put(stdListMaster.ivybase__List_Name__c, stdListMaster.Name);
            }
            Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
            Set<Id> digitalcontentIds = new Set<Id>();
            system.debug('hierarchyNamewithSetOfIdsMap'+hierarchyNamewithSetOfIdsMap);
            RExAPIResponseDomain.ResponseInfo digitalContentMapInfo = new RExAPIResponseDomain.ResponseInfo ();
            List<ivybase__Digital_Content_Mapping__c> digitalContentMapList = DigitalContentMappingService.getAllContentMappingList( hierarchyNamewithSetOfIdsMap );
            digitalContentMapInfo = DigitialContentMappingTranslator.objectToMappingInfo(digitalContentMapList, Divisionlovidmap,null); 
            tableList.add(digitalContentMapInfo);

            for(ivybase__Digital_Content_Mapping__c dcm : digitalContentMapList){
                digitalcontentIds.add(dcm.ivybase__Digital_Content__c);
            }

            RExAPIResponseDomain.ResponseInfo digitalContentInfo = new RExAPIResponseDomain.ResponseInfo ();
            List<ivybase__Digital_Content__c> digitalContentList = DigitalContentMappingService.getAllContentList(digitalcontentIds);
            digitalContentInfo = DigitialContentMappingTranslator.objectToInfo(digitalContentList, null); 
            tableList.add(digitalContentInfo);

            RExAPIResponseDomain.ResponseInfo digitalContentProductMapInfo = new RExAPIResponseDomain.ResponseInfo ();
            List<ivybase__Digital_Content_Mapping__c> digitalContentProductMapList = DigitalContentMappingService.getAllContentMappingProductSKUList(digitalcontentIds);
            digitalContentProductMapInfo = DigitialContentMappingTranslator.objectToProductInfo(digitalContentProductMapList, null); 
            tableList.add(digitalContentProductMapInfo);
            ivybase__Resource__c res=ResourceService.getSellerId(userinfo.getuserid());
            system.debug('iso'+res.Market_ISO__c);
           if(res.Market_ISO__c=='JPN' || test.isRunningTest()) {   
            RExAPIResponseDomain.ResponseInfo digitalContentTrainMapInfo = new RExAPIResponseDomain.ResponseInfo ();
            digitalContentTrainMapInfo = DigitialContentMappingTranslator.objectToTrainingInfo(digitalContentMapList, Divisionlovidmap,null); 
           tableList.add(digitalContentTrainMapInfo);
          }
            digitalContentResponse.Tables = tableList;


        } catch (Exception ex) {
            system.debug('Exception'+ex);
        }
        Return digitalContentResponse;
    }
}