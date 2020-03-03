/*
 * Block comments with details of changes
 */
@RestResource(UrlMapping='/v1/RestSalonFrequencyMapping/Masters/')
global with sharing class RestSalonFrequencyMapping{
   @httpGet
    global static RExAPIResponseDomain.ResponseInfo getSalonFrequencyMasterInfo(){
          RExAPIResponseDomain.ResponseInfo salonFrequency = new RExAPIResponseDomain.ResponseInfo();
           try{
            List<SalonFrequencyDivMapping__c> SalonFrequencyDivMappingList = SalonFrequencyService.getSalonFrequencyService();
            salonFrequency=SalonFrequencyMappingTranslator.objectToJson(SalonFrequencyDivMappingList,null);
                  }Catch(Exception ex){
            system.debug('exception'+ex.getMessage()+ex.getStackTraceString());
           salonFrequency=SalonFrequencyMappingTranslator.objectToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
             }
        return salonFrequency;
    }
}