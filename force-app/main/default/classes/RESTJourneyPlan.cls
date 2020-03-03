@RestResource(UrlMapping='/v1/JourneyPlan/Masters/')
global with sharing class RESTJourneyPlan{
    public static map<string,string> getJP_ActivtyFromStandardListMaaster(String [] lstMstrFields){
        List<ivybase__Standard_List_Master__c> SLMList = new List<ivybase__Standard_List_Master__c>();
        if(SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', lstMstrFields)){
        List<String> listType = new List<String>();
        listType.add('APPROVAL_STATUS');
         SLMList  = StandardListMasterservice.getStandardListUsingListType(listType);
        }
         system.debug('SLMList---'+SLMList);
        map<string,string> statusMapListCode = new map<string,string>();
        for(ivybase__Standard_List_Master__c stMaster: SLMList){
                statusMapListCode.put(stMaster.ivybase__List_Name__c,stMaster.ivybase__List_Code__c);
        }
        return statusMapListCode;
    }
    @httpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getJourneyplanMasterInfo(){
        RExAPIResponseDomain.MultipleResponseInfo JourneyplanResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        
        String[] lstMstrFields = new String[]{'ivybase__List_Code__c','ivybase__List_Type__c','ivybase__List_Name__c','Name'};
            
        map<string,string> statusMapListCode = getJP_ActivtyFromStandardListMaaster(lstMstrFields);
        
        JourneyplanResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo Journeyplan = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo JourneyMarketVisit = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo JourneyPlanActivity = new RExAPIResponseDomain.ResponseInfo();
        List<JourneyPlanActivity__c> journeyPlanStoreVisit=new List<JourneyPlanActivity__c>();
        List<JourneyPlanActivity__c> JourneyActivityList=new List<JourneyPlanActivity__c>();
        try{
            List<JourneyPlan__c> jpList = JourneyPlanService.getJourneyPlan();
            System.debug('jpList'+jpList);
            List<Id> jpId = new List<Id>();
            //get all Id
            for(JourneyPlan__c jp:jpList)
            {
                jpId.add(jp.id);
            }
            system.debug('jpId'+jpId);
            try{
            journeyPlanStoreVisit = JourneyPlanMarketVisitService.getJourneyPlanMarketVisit(jpId);
                system.debug('journeyPlanStoreVisit'+journeyPlanStoreVisit);
            JourneyMarketVisit=JourneyPlanMarketVisitTranslator.translateJourneyMarketVisit(journeyPlanStoreVisit, null);
            }
            catch(Exception e)
            {
                system.debug('Journey plan market visit'+e.getMessage());
                JourneyMarketVisit=JourneyPlanMarketVisitTranslator.translateJourneyMarketVisit(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            } 
            try{
             JourneyActivityList = JourneyPlanActivityService.getJourneyPlanActivity(jpId);
             JourneyPlanActivity = JourneyPlanActivityTranslator.objectToJourneyPlanActivity(JourneyActivityList, null);
            }
            catch(Exception e)
            {
                system.debug('Journey plan Activity '+e.getMessage());
            JourneyPlanActivity = JourneyPlanActivityTranslator.objectToJourneyPlanActivity(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS')); 
            }
            Journeyplan=JourneyPlanTranslator.objectToJourneyPlan(jpList,statusMapListCode,null);
            system.debug('JourneyPlanActivity'+JourneyPlanActivity);
            JourneyplanResponse.Tables.add(Journeyplan);
            JourneyplanResponse.Tables.add(JourneyMarketVisit);
            JourneyplanResponse.Tables.add(JourneyPlanActivity);
            
        }
        Catch(Exception ex){
            system.debug('exception'+ex.getMessage());
           Journeyplan=JourneyPlanTranslator.objectToJourneyPlan(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
           JourneyMarketVisit=JourneyPlanMarketVisitTranslator.translateJourneyMarketVisit(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS')); 
            JourneyPlanActivity = JourneyPlanActivityTranslator.objectToJourneyPlanActivity(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            JourneyplanResponse.Tables.add(Journeyplan);
            JourneyplanResponse.Tables.add(JourneyMarketVisit);
            JourneyplanResponse.Tables.add(JourneyPlanActivity);
        }
        return JourneyplanResponse;
    }
}