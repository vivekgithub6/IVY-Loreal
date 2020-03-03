@RestResource(urlMapping ='/v1/ActualWorkingDaysKPI/' )
global with sharing class RestActualWorkingDaysKPI {
    
    @HttpGet
    global static RExAPIResponseDomain.ResponseInfo getWorkingDaysKPI(){
        RExAPIResponseDomain.ResponseInfo res = new RExAPIResponseDomain.ResponseInfo();
        
        try{
            
            AggregateResult[] queriedRecords = ActualWorkingDaysKPIService.getRecords(ResourceService.getLoginSellerId()); 
            res =  ActualWorkingDaysKPITranslator.translateData(queriedRecords,NULL);
        
        } catch(Exception e) {
            ActualWorkingDaysKPITranslator.translateData(NULL,e.getMessage());
            
        }
        return res;
    }
}