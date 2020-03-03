public class DigitalContentMappingService { 

    public static List<ivybase__Digital_Content_Mapping__c> getAllContentMappingList(Map<String, Set<String>> hierarchyNamewithSetOfIdsMap) {

        
        ivybase__Resource__c res = ResourceService.getSellerId(UserInfo.getUserId());
        List< ivybase__Digital_Content_Mapping__c> digitalContentMapListInfo = new List< ivybase__Digital_Content_Mapping__c>();
        Set<String> storeHierarchyIds = new Set<String>();
        Set<String> accountIds = new Set<String>();
        //---adddedddd ----------
        set<id> userTerritoryId= new set<id>();
        List<ivybase__Location_Hierarchy__c> userteritorylist= LocationMasterService.getUserTerritory();
        if(userteritorylist!=null && userteritorylist.size()>0){
            for(ivybase__Location_Hierarchy__c loc:userteritorylist){ 
                userTerritoryId.add(loc.id);
            }
        }
        set<id> userdivid=DivisionSerivce.getDivisionForUserTerritory(userTerritoryId);
        //-----------end------------
        if(hierarchyNamewithSetOfIdsMap != NULL){

            if (hierarchyNamewithSetOfIdsMap.containskey('Store')) {
                storeHierarchyIds = hierarchyNamewithSetOfIdsMap.get('Store');
            }
            if (hierarchyNamewithSetOfIdsMap.containskey('Account')) {
                accountIds = hierarchyNamewithSetOfIdsMap.get('Account');
            }

            System.debug('storeHierarchyIds'+storeHierarchyIds);
            String[] digitalFields = new String[] {'ivybase__Product_Hierarchy__c','ivybase__Retailer__c','ivybase__Store_Hierarchy__c','ivybase__User__c'}; 
            String[] chkFields = new String[] {'ivybase__Internal_Id__c'};
            //----division filter added in if condition and query filter
            if (userdivid!=null && SecurityUtility.checkIsAccessible('ivybase__Digital_Content_Mapping__c', digitalFields ) && SecurityUtility.checkIsAccessible('Account', chkFields )
                && SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', chkFields ) && SecurityUtility.checkIsAccessible('ivybase__Digital_Content__c', chkFields )) {
                digitalContentMapListInfo = [ SELECT ivybase__Product_Hierarchy__c,ivybase__Product_Hierarchy__r.ivybase__Internal_Id__c,
                                             Name,
                                             ivybase__Retailer__c,ivybase__Retailer__r.ivybase__Internal_Id__c,
                                             ivybase__Store_Hierarchy__c,ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c,
                                             ivybase__User__c,Id,ivybase__Digital_Content__c,Standard_List_Master__r.Name,Standard_List_Master__r.ivybase__List_Code__c,
                                             ivybase__Digital_Content__r.ivybase__Internal_Id__c, Location_Hierarchy__c	,ivybase__Resource_Type__c,Division__c,Division__r.name,ivybase__Digital_Content__r.recordType.DeveloperName
                                             FROM ivybase__Digital_Content_Mapping__c 
                                             WHERE ( ivybase__Store_Hierarchy__c IN:storeHierarchyIds 
                                                    OR ivybase__Retailer__c IN :accountIds OR Location_Hierarchy__c =:res.ivybase__Location_Hierarchy__c 
                                                    OR Division__c IN:userdivid OR ivybase__User__c =: UserInfo.getUserId() ) AND  Standard_List_Master__c != NULL AND( (StartDate__c<=:date.today() AND EndDate__c>=:date.today()) OR ((StartDate__c=Null OR StartDate__c<=:date.today()) AND (EndDate__c=Null OR EndDate__c>=:date.today())) )
                                            ];//OR ivybase__Resource_Type__c != NULL 
                System.debug('size:::'+digitalContentMapListInfo.size());
                System.debug('digitalContentMapListInfo::'+digitalContentMapListInfo);
                return digitalContentMapListInfo;

            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                //return null;
            }
        }
        return digitalContentMapListInfo;

    }
    public static List<ivybase__Digital_Content__c> getAllContentList(Set<Id> digitalcontentIds) {

        List< ivybase__Digital_Content__c> digitalContentListInfo = new List< ivybase__Digital_Content__c>();
        String[] digitalFields = new String[] {'ivybase__Internal_Id__c','ivybase__Description__c','ivybase__Image_Url__c','ivybase__image_Name__c','ivybase__Image_Path__c'}; 

        if(digitalcontentIds != NULL && digitalcontentIds.size() > 0) {
            if (SecurityUtility.checkIsAccessible('ivybase__Digital_Content__c', digitalFields )) {
                digitalContentListInfo = [ SELECT ivybase__Internal_Id__c,
                                          Name,
                                          ivybase__Description__c,
                                          ivybase__Image_Url__c,
                                          CreatedDate ,
                                          ivybase__image_Name__c,
                                          ivybase__Image_Path__c
                                          FROM ivybase__Digital_Content__c
                                          WHERE Id IN :digitalcontentIds];

            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                //return null;
            }
        }
        system.debug('digitalContentListInfo'+digitalContentListInfo);
        return digitalContentListInfo;

    }
    public static List<ivybase__Digital_Content_Mapping__c> getAllContentMappingProductSKUList(Set<Id> digitalcontentIds) {

        List<ivybase__Digital_Content_Mapping__c> digitalContentMapListInfo = new List<ivybase__Digital_Content_Mapping__c>();
        String[] chkFields = new String[] {'ivybase__Internal_Id__c'};
        String[] digitalFields = new String[] {'Product_Master__c','ivybase__Retailer__c','ivybase__Store_Hierarchy__c','User__c'}; 

        if(digitalcontentIds != NULL && digitalcontentIds.size() > 0) {
            if (SecurityUtility.checkIsAccessible('ivybase__Digital_Content_Mapping__c', digitalFields) && SecurityUtility.checkIsAccessible('Account', chkFields) && SecurityUtility.checkIsAccessible('ivybase__Product__c', chkFields) 
                && SecurityUtility.checkIsAccessible('ivybase__Store_Hierarchy__c', chkFields ) && SecurityUtility.checkIsAccessible('ivybase__Digital_Content__c', chkFields )){
                //------addded product hirarchy filter in Query---------
                digitalContentMapListInfo = [ SELECT ivybase__Product_Hierarchy__c,
                                             Name,
                                             Product_Master__r.ivybase__InternalId__c,
                                             Id,ivybase__Digital_Content__c,
                                             ivybase__Digital_Content__r.ivybase__Internal_Id__c
                                             FROM ivybase__Digital_Content_Mapping__c 
                                             WHERE  (Product_Master__c != null OR ivybase__Product_Hierarchy__c!=null) AND ivybase__Digital_Content__c IN :digitalcontentIds];


            }else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                //return null;
            }
        }
        system.debug('digitalContentMapListInfo'+digitalContentMapListInfo);
        return digitalContentMapListInfo;
    }

    public static map<string,string> getAllContentData(Set<string> digitalcontentInternalIds) {

        map<string,string> DigitalContentIdInternalIdMAp = new map<string,string>();
        List< ivybase__Digital_Content__c> digitalContentListInfo = new List< ivybase__Digital_Content__c>();
        String[] digitalFields = new String[] {'ivybase__Internal_Id__c'}; 

        if(digitalcontentInternalIds != NULL && digitalcontentInternalIds.size() > 0) {
            if (SecurityUtility.checkIsAccessible('ivybase__Digital_Content__c', digitalFields )) {
                digitalContentListInfo = [ SELECT id,ivybase__Internal_Id__c
                                          FROM ivybase__Digital_Content__c
                                          WHERE Id IN :digitalcontentInternalIds];
                if(digitalContentListInfo.size()>0){
                    for(ivybase__Digital_Content__c dc :digitalContentListInfo){
                       DigitalContentIdInternalIdMAp.put(dc.ivybase__Internal_Id__c,dc.id);
                    }
                }

            }else 
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
           // system.debug('digitalContentListInfo'+digitalContentListInfo);
    return DigitalContentIdInternalIdMAp;
    }



}