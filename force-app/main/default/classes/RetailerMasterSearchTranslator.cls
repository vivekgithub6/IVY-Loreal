public with sharing class RetailerMasterSearchTranslator {
    
    public static RExAPIResponseDomain.ResponseInfo  sendAccounts(LIST<Account> accountList, String errorCode) {
        
        RExAPIResponseDomain.ResponseInfo responseInfo = new RExAPIResponseDomain.ResponseInfo();
        responseInfo.Field = new List<String>{'name', 'id', 'Code', 'Address'};
        responseInfo.ErrorCode = errorCode == NULL ? '0' : errorCode;
        responseInfo.Next = '0'; 
        responseInfo.Master = 'masterType';
        
        List<List<String>> priceProductList = new List<List<String>>();
        
        if(errorCode == null){
            for(Account acc: accountList) {
                LIST<String> tempList = new LIST<String>();
                
                tempList.add(acc.Name != NULL && acc.Name != '' ? acc.Name : ''); 
                tempList.add(String.valueOf(acc.ivybase__Internal_Id__c));
                tempList.add(acc.Sold_To_Party_Number__c);
                tempList.add(acc.Store_Address__c  != NULL && acc.Store_Address__c != '' ? acc.Store_Address__c.replaceAll('(\\r|\\n)+', '') : '');
                priceProductList.add(tempList);
            }
            system.debug('priceProductList'+ priceProductList);
            responseInfo.Data = priceProductList;
            
            
            
        } else {
            
            
        }
        return responseInfo ;
    }
    
}