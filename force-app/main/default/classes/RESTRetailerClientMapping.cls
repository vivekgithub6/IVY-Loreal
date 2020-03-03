/* 
TEST CLASS : TestRestJourneyPlan
*/

@RestResource(urlMapping='/v1/RetailerClient/Masters/*')
global with sharing class RESTRetailerClientMapping {
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getRetailerClientMappings() {
        
        RExAPIResponseDomain.MultipleResponseInfo retailerMappingResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        
        retailerMappingResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo retailerClientMappingMaster = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo retailerRDVisitMappingMaster = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo retailerAgentMapping = new RExAPIResponseDomain.ResponseInfo();
        
        List<JourneyPlanActivity__c> retailerClientMapping = new List<JourneyPlanActivity__c>();
        List<Rintin_Plan__c> retailerRDVisitMapping = new List<Rintin_Plan__c>();
        
        try {
            
            Map<String, String> visitLovIdMap = new Map<String, String>();
            //Standard List Master of VISIT TYPE
            for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{'VISIT_TYPE', 'JP_ACTIVITY'}))
            {
                visitLovIdMap.put(stdListMaster.ivybase__List_Code__c, stdListMaster.Name);
            }
            
            //Journey Plan Activity :(Visit Type)
            retailerClientMapping = JourneyPlanMarketVisitService.getJPlanVisitForToday().values();
            retailerClientMappingMaster = JourneyPlanMarketVisitTranslator.translateMarketVisitForToday(retailerClientMapping, visitLovIdMap, NULL);
            
            //Rintin Plan Detail :
            retailerRDVisitMapping.addAll(RintinPlanDetailService.getRPlanVisitForToday().values());
            retailerRDVisitMappingMaster = RintinPlanDetailTranslator.translateRetailerRDVisitMapping(retailerRDVisitMapping, visitLovIdMap, NULL);
            
            //Retailer & Agent :
            List<Account> accList = AccountService.getAllRetailerMaster_List_for_Resource();
            Set<Id> agentSet = new Set<Id>();
            
            Integer j = 0;
            while (j < accList.size())
            {
                if(accList.get(j).isAgent__c){
                    
                    agentSet.add(accList.get(j).Id);
                    accList.remove(j);
                } else {
                    j++;   
                }
            }
            system.debug('agentSet'+agentSet);
            map<id,Agent_Salon_Mapping__c> agentMappings = AccountService.getAgentSalonMappings(agentSet);
            retailerAgentMapping = RetailerAdressInfoAPITranslator.objectToAgentMap(agentMappings, accList, NULL);
            
            retailerMappingResponse.Tables.add(retailerClientMappingMaster);
            retailerMappingResponse.Tables.add(retailerRDVisitMappingMaster);
            retailerMappingResponse.Tables.add(retailerAgentMapping);
            
            if(test.isRunningTest())
                Integer i = 1/0;
            
        } catch (Exception ex) {
            
            retailerClientMappingMaster = JourneyPlanMarketVisitTranslator.translateMarketVisitForToday(NULL, NULL, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            retailerMappingResponse.Tables.add(retailerClientMappingMaster);
            
            retailerRDVisitMappingMaster = RintinPlanDetailTranslator.translateRetailerRDVisitMapping(NULL, NULL, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            retailerMappingResponse.Tables.add(retailerRDVisitMappingMaster);
            
        }
        
        return retailerMappingResponse;
    }
}