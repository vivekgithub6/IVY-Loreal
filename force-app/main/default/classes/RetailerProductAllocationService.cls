public with sharing class RetailerProductAllocationService {
    public static List<RetailerProductAllocation__c> get_product_Allocation(Set<Id> retailer)
    {
        
     String[] fields = new String[]{'Id','To__c','Quantity__c','Product_Master__c','From__c','Account__c'};  
         if(SecurityUtility.checkIsAccessible('RetailerProductAllocation__c', fields)){
            List<RetailerProductAllocation__c> product = [SELECT Id,
                                                          Name,
                                                          To__c,
                                                          Quantity__c,
                                                          Product_Master__c,
                                                          From__c,
                                                          Account__r.ivybase__Internal_Id__c,
                                                          Product_Master__r.ivybase__InternalId__c,
                                                          Account__c FROM RetailerProductAllocation__c
                                                          WHERE Account__c IN :retailer
                                                          AND ((From__c = null OR From__c <= TODAY) AND (To__c=null OR To__c >= TODAY))
                                                         ];
             return product;
         }
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
    }
}