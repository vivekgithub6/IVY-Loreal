@RestResource(UrlMapping='/v1/DreamListMaster/Masters/')
global with sharing class RestDreamListMaster {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRetailerCleintMappingInfo(){
        RExAPIResponseDomain.ResponseInfo retDreamlistResp = new RExAPIResponseDomain.ResponseInfo();
        
        try{
             Id sellerId = ResourceService.getLoginSellerId();
            List<Account> DreamList = DreamListService.getDreamList(sellerId);
             List<Account> ConquestList = DreamListService.getConquest();
           DreamList.addall(ConquestList);
            system.debug('DreamList'+DreamList.size());
             retDreamlistResp = DreamListTranslator.objectToJsonInfo(DreamList,null);
            
        }catch(Exception ex){
            retDreamlistResp = DreamListTranslator.objectToJsonInfo(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS')); 
        }
            
        return retDreamlistResp; 
        
    }

}