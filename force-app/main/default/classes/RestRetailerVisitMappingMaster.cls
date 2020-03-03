@RestResource(UrlMapping='/v1/RetailerClientMapping/Masters/')
global with sharing class RestRetailerVisitMappingMaster {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRetailerCleintMappingInfo(){
        RExAPIResponseDomain.ResponseInfo retClientMappingResp = new RExAPIResponseDomain.ResponseInfo();
        
        try{
            
            List<JourneyPlanActivity__c> journeyPlanDetRecords = RetailerVisitService.getRetailervisitmap();
             Decimal userid=[select ivybase__Internal_Id__c from user where id=:userinfo.getUserId()].ivybase__Internal_Id__c;
              retClientMappingResp = RetailerVisitTranslator.objectToJourneyPlanDetail(journeyPlanDetRecords,userid,null);
            
        }catch(Exception ex){
            retClientMappingResp = RetailerVisitTranslator.objectToJourneyPlanDetail(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));   
        }
            
        return retClientMappingResp; 
        
    }

}