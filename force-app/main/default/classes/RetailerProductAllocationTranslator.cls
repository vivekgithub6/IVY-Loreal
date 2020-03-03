public with sharing class RetailerProductAllocationTranslator {
     public static RExAPIResponseDomain.ResponseInfo objectToRetailerProductAllocation(List<RetailerProductAllocation__c> retailerProduct,String errorCode){
         RExAPIResponseDomain.ResponseInfo RetailerProductAllocationResponse = new RExAPIResponseDomain.ResponseInfo();
         RetailerProductAllocationResponse.Master = 'RetailerProductAllocation';
        RetailerProductAllocationResponse.Field = new List<String>{'Rid','Pid','Qty'};
      RetailerProductAllocationResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        RetailerProductAllocationResponse.Next = '0';
		
         List<List<String>> RetailerProductAllocationRecords = new List<List<String>>();
         if(retailerProduct != null && errorCode == null){
             for(RetailerProductAllocation__c productQuantity : retailerProduct){
                  List<String> RetailerProductInfo = new List<String>();
                //RId
                 if(productQuantity.Account__r.ivybase__Internal_Id__c != null){
                     RetailerProductInfo.add(String.valueOf(productQuantity.Account__r.ivybase__Internal_Id__c));
                 }else{
                    RetailerProductInfo.add(''); 
                 }
                 //PID
                 if(productQuantity.Product_Master__r.ivybase__InternalId__c != null){
                     RetailerProductInfo.add(String.valueof(productQuantity.Product_Master__r.ivybase__InternalId__c));
                 }else{
                    RetailerProductInfo.add(''); 
                 }
                 //Qty
                   if(productQuantity.Quantity__c != null){
                     RetailerProductInfo.add(String.valueof(productQuantity.Quantity__c));
                 }else{
                    RetailerProductInfo.add(''); 
                 }
                 
                 
             RetailerProductAllocationRecords.add(RetailerProductInfo);
             }
         }

         RetailerProductAllocationResponse.Data = RetailerProductAllocationRecords;
       return RetailerProductAllocationResponse;
     } 
}