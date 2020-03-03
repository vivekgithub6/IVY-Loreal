@RestResource(urlMapping='/v1/MinimumOrdervalue/')
global with sharing class RestMinOrderValue {
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getMinorderDetails() {
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo minorder = new RExAPIResponseDomain.ResponseInfo();
        try{
        List<Minimum_Order_Amount__c> minorderlist= MinOrderValueService.getMinOrderAmount();
        minorder=MinOrderValueTranslator.objectToMinOrderValue(minorderlist, null);
        response.Tables.add(minorder); 
        }catch(Exception ex){
            system.debug('exception'+ex.getMessage());
        }
       return response; 
    }
}