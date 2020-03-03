public class DigitalContentSchemeService {
   public static List<ivybase__Digital_Content_Mapping__c> getAllContentMappingSchemeList(Set<Id> digitalcontentIds) {
    
        List<ivybase__Digital_Content_Mapping__c> digitalContentMapListInfo = new List<ivybase__Digital_Content_Mapping__c>();
        String[] schemeFields = new String[] {'ivydsd__Internal_Id__c'};
            String[] Digconfields = new String[] {'ivybase__Internal_Id__c'};
        String[] digitalFields = new String[] {'ivybase__Digital_Content__r.ivybase__Internal_Id__c','ivybase__User__c'}; 
        
        if(digitalcontentIds != NULL && digitalcontentIds.size() > 0) {
            if (SecurityUtility.checkIsAccessible('ivybase__Digital_Content_Mapping__c', digitalFields)&& SecurityUtility.checkIsAccessible('ivydsd__Scheme__c', schemeFields )&& SecurityUtility.checkIsAccessible('ivybase__Digital_Content__c', Digconfields)){
                digitalContentMapListInfo = [ SELECT
                                             	Id,
                                               Name,
                                               Scheme__r.ivydsd__Internal_Id__c	,
                                               ivybase__Digital_Content__c,
                                               ivybase__Digital_Content__r.ivybase__Internal_Id__c,ivybase__Digital_Content__r.ivybase__Image_Url__c	
                                               FROM ivybase__Digital_Content_Mapping__c 
                                               WHERE  ivybase__Digital_Content__c != null AND scheme__c != null AND ivybase__Digital_Content__c IN :digitalcontentIds];
                 
                
            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                //return null;
            }
   }
        return digitalContentMapListInfo;
    }
    
   }