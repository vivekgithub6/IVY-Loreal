public class DigitalContentMasterService {
public static List<ivybase__Digital_Content_Mapping__c> getAllContentMappingList(Map<String, Set<String>> hierarchyNamewithSetOfIdsMap) {
    
        List<ivybase__Digital_Content_Mapping__c> digitalContentMapListInfo = new List<ivybase__Digital_Content_Mapping__c>();
        Set<String> storeHierarchyIds = new Set<String>();
        Set<String> accountIds = new Set<String>();
        
        if(hierarchyNamewithSetOfIdsMap != NULL && hierarchyNamewithSetOfIdsMap.size() > 0){
           
            if (hierarchyNamewithSetOfIdsMap.containskey('Store')) {
                storeHierarchyIds = hierarchyNamewithSetOfIdsMap.get('Store');
            }
            if (hierarchyNamewithSetOfIdsMap.containskey('Account')) {
                accountIds = hierarchyNamewithSetOfIdsMap.get('Account');
            }
                
            System.debug('storeHierarchyIds'+storeHierarchyIds);
            String[] digitalFields = new String[] {'ivybase__Product_Hierarchy__c','ivybase__Retailer__c','ivybase__Store_Hierarchy__c','ivybase__User__c'}; 
            String[] chkFields = new String[] {'ivybase__Internal_Id__c'};
            
            if (SecurityUtility.checkIsAccessible('ivybase__Digital_Content_Mapping__c', digitalFields ) && SecurityUtility.checkIsAccessible('Account', chkFields )
                        && SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', chkFields ) && SecurityUtility.checkIsAccessible('ivybase__Digital_Content__c', chkFields )) {
                digitalContentMapListInfo = [ SELECT ivybase__Product_Hierarchy__c,
                                               Name,
                                               ivybase__Retailer__c,ivybase__Retailer__r.ivybase__Internal_Id__c,
                                               ivybase__Store_Hierarchy__c,ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c,
                                               ivybase__User__c,Id,ivybase__Digital_Content__c,
                                               ivybase__Digital_Content__r.ivybase__Internal_Id__c,ivybase__Resource_Type__c
                                              FROM ivybase__Digital_Content_Mapping__c 
                                              WHERE  ivybase__Store_Hierarchy__c IN:storeHierarchyIds 
                                               OR ivybase__Retailer__c IN :accountIds 
                                               OR ivybase__User__c =: UserInfo.getUserId()
                                               OR ivybase__Resource_Type__c != NULL
                                              ];
                
                return digitalContentMapListInfo;
                
            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                //return null;
           }
       }
       return digitalContentMapListInfo;
       
    }
}