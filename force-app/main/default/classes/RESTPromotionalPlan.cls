@RestResource(UrlMapping='/v1/PromotionalPlan/Masters/')
global with sharing class RESTPromotionalPlan {
    @httpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getpromotionplanMasterInfo(){
        RExAPIResponseDomain.MultipleResponseInfo promtionalplanResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        String[] lstMstrFields = new String[]{'ivybase__List_Code__c','ivybase__List_Type__c','ivybase__List_Name__c','Name'};
            
        map<string,string> statusMapListCode = RESTJourneyPlan.getJP_ActivtyFromStandardListMaaster(lstMstrFields);
        system.debug('statusMapListCode   '+statusMapListCode);
        
        promtionalplanResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo promotionalplan = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo PromotionalPlanningDetails = new RExAPIResponseDomain.ResponseInfo();
         list<Sales_Forecast_Detail__c> promoplan= new list<Sales_Forecast_Detail__c>();
        List<Sales_Forecast__c> ppList = PromotionalPlanningService.getNextMonthPromotionalPlan();
        
        
        system.debug('ppList'+ppList);
        
        set<id> ppid= new set<id>();
        for(Sales_Forecast__c pp:ppList){
            ppid.add(pp.id);
        }
        //sending Pid to Service class to query the childs
        promoplan = PromotionalPlanningDetailsService.getPromotionalPlanningDetails(ppid);
        
        /*set<id> NormalorderIds = new set<id>();
        set<id> schemeTargetIds= new set<id>();
         for(Sales_Forecast_Detail__c sfdlist:promoplan){
             if(sfdlist.Total_Normal_Target__c!=null){
                 NormalorderIds.add(sfdlist.id);
             }else if(sfdlist.Total_Scheme_Target__c!=null){
                 schemeTargetIds.add(sfdlist.id);
             }
        }*/
        
        promotionalplan=PromotionalPlanningTranslator.objectToPromotionalPlan(ppList,statusMapListCode,null);
        PromotionalPlanningDetails = PromotionalPlanningTranslator.objectToPromotionalPlanDetail(promoplan,null);
        promtionalplanResponse.Tables.add(promotionalplan);
        promtionalplanResponse.Tables.add(PromotionalPlanningDetails);
       
        return promtionalplanResponse;
    }
}