@RestResource(UrlMapping='/v1/SalesTarget/Masters/')
global with sharing class RestSalesTarget {
    @httpGet
     global static RExAPIResponseDomain.MultipleResponseInfo getpromotionplanMasterInfo(){
        RExAPIResponseDomain.MultipleResponseInfo SalesTargetResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        SalesTargetResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo SalesTarget = new RExAPIResponseDomain.ResponseInfo();
         
         //getting the user andTraget Value for Service class
         List<Sales_Forecast__c> STList = PromotionalPlanningService.getNextMonthPromotionalPlan();//This method returns the approved sales forcecasting details
         SalesTarget = SalesTargetTranslator.objectToSalesTarget(STList,null);
         SalesTargetResponse.Tables.add(SalesTarget);
         return SalesTargetResponse;
     }
}