public with sharing class SuggestedQuantityService{
    
    public static List<ivydsd__Suggested_Quantity__c> getAllSuggesqty(){
    
        String[] sugqtyFields = new String[]{'ivydsd__Retailer__c','ivydsd__Quantity__c','ivydsd__Product__c'};
        String[] ckinterId = new String[]{'ivybase__InternalId__c'};
        String[] accinterId = new String[]{'ivybase__Internal_Id__c'};
        
        if (SecurityUtility.checkIsAccessible('ivydsd__Suggested_Quantity__c', sugqtyFields) && SecurityUtility.checkIsAccessible('Account', accinterId) && SecurityUtility.checkIsAccessible('ivybase__Product__c', ckinterId)){
            
            List<ivydsd__Suggested_Quantity__c> sugqtyList = [SELECT Id,Name,ivydsd__Retailer__c,ivydsd__Product__c,ivydsd__Quantity__c,ivydsd__Retailer__r.ivybase__Internal_Id__c,ivydsd__Product__r.ivybase__InternalId__c FROM ivydsd__Suggested_Quantity__c LIMIT 50000];
            return sugqtyList;
            
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        } 
        
   }
}