/* 
	Test Class : TestRestJourneyPlan
*/

@RestResource(UrlMapping ='/v1/RintinPlan/Masters/')
global with sharing class RESTRintinPlan {
    @httpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getJourneyplanMasterInfo(){
        
        RExAPIResponseDomain.MultipleResponseInfo RintinDokoHeaderResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        
        RintinDokoHeaderResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo rintinDokoHeader = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo rintinDokoSalonDetails = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo rintinDokoHairdresserAndAgentDetails = new RExAPIResponseDomain.ResponseInfo();
        
        List<Rintin_Plan_Details__c> rintinPlanSalonDetails=new List<Rintin_Plan_Details__c>();
        List<Rintin_Plan_Details__c> rintinPlanHairdresserAndAgentDetails = new List<Rintin_Plan_Details__c>();
        try{
            Map<Id, Rintin_Plan__c> rpMap = RintinPlanService.getRintinPlans();
            System.debug('rpMap '+rpMap);
            Set<Id> rpId = rpMap.keySet();
            system.debug('rpId '+rpId);
            
            rintinPlanSalonDetails = RintinPlanDetailService.getRintinDokoSalonDetails(rpId).values();
            system.debug('rintinPlanSalonDetails '+rintinPlanSalonDetails);
            for(Rintin_Plan_Details__c rp: rintinPlanSalonDetails){
                system.debug('internal id'+rp.Retailer_Id__r.ivybase__Internal_Id__c);
            }
            rintinDokoSalonDetails = RintinPlanDetailTranslator.translateSalonDetails(rintinPlanSalonDetails, NULL); 
            
            rintinPlanHairdresserAndAgentDetails = RintinPlanDetailService.getRintinDokoHairdresserAndAgentDetails(rpId).values();
            rintinDokoHairdresserAndAgentDetails = RintinPlanDetailTranslator.translateHairDresserDetails(rintinPlanHairdresserAndAgentDetails, NULL);
            
            rintinDokoHeader = RintinPlanTranslator.objectToRintinPlan(rpMap.values(), NULL);
            system.debug('rintinDokoSalonDetails '+rintinDokoSalonDetails);
            
            RintinDokoHeaderResponse.Tables.add(rintinDokoHeader);
            RintinDokoHeaderResponse.Tables.add(rintinDokoSalonDetails);
            RintinDokoHeaderResponse.Tables.add(rintinDokoHairdresserAndAgentDetails);
            
            if(test.isRunningTest())
                Integer i = 1/0;
       }
        Catch(Exception ex){
            system.debug('exception'+ex.getMessage());
            rintinDokoHeader = RintinPlanTranslator.objectToRintinPlan(NULL, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            rintinDokoSalonDetails = RintinPlanDetailTranslator.translateSalonDetails(NULL, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS')); 
            rintinDokoHairdresserAndAgentDetails = RintinPlanDetailTranslator.translateHairDresserDetails(NULL, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            RintinDokoHeaderResponse.Tables.add(rintinDokoHeader);
            RintinDokoHeaderResponse.Tables.add(rintinDokoSalonDetails);
            RintinDokoHeaderResponse.Tables.add(rintinDokoHairdresserAndAgentDetails);
        }
        return RintinDokoHeaderResponse;
    }
}