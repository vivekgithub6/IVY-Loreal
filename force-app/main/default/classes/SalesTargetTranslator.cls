public class SalesTargetTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToSalesTarget(List<Sales_Forecast__c> promotionplanlist,string errorcode){
        RExAPIResponseDomain.ResponseInfo SalesTargetResponse = new RExAPIResponseDomain.ResponseInfo();
        SalesTargetResponse.Master='SalesTarget';
        SalesTargetResponse.Field = new List<String>{'UserId','Target'};
        SalesTargetResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        SalesTargetResponse.Next = '0';
        
         List<List<String>> SalesTargetRecords = new List<List<String>>();
        system.debug('Test Exc'+promotionplanlist);
        if(promotionplanlist !=Null){
        //iterating the list of records which are passing from service class
         system.debug('Test Exc'+promotionplanlist);
            for(Sales_Forecast__c promotionalPlanrecordList :promotionplanlist ){
               
            List<String> salesTrgt = new List<String>();
            if(promotionalPlanrecordList.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c != null){
                     salesTrgt.add((promotionalPlanrecordList.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c).format());
                 }else{
                    salesTrgt.add(''); 
                 }
            if(promotionalPlanrecordList.Target__c!= null){
                     salesTrgt.add(String.valueOf(promotionalPlanrecordList.Target__c));
                 }else{
                    salesTrgt.add(''); 
                 }
                SalesTargetRecords.add(salesTrgt);  
            }
          
        }
        SalesTargetResponse.Data=SalesTargetRecords;
        return SalesTargetResponse;
    }
}