public with sharing class HHTService {
    
    public static List<ivybase__HHT_Menu_Master__mdt> getHHTMenu() {
        
        return [SELECT 
                DeveloperName, ivybase__Flag__c, ivybase__RField__c, ivybase__MName__c, ivybase__MNumber__c, ivybase__hasLink__c, ivybase__MenuType__c, ivybase__lang__c, ivybase__RField1__c, ivybase__RegExp__c 
                FROM 
                ivybase__HHT_Menu_Master__mdt LIMIT 50000
               ];
    }
    
    public static List<ivybase__HHTMenu_Master__c> getHHTMenu(Id resourcetypeId, Id locHierarchyId, Id resourceId) {
        
        String[] hhtmenuFields = new String[]{'ivybase__Flag__c','ivybase__hasLink__c','ivybase__RField__c', 'ivybase__MName__c', 'ivybase__MNumber__c','ivybase__MenuType__c', 'ivybase__lang__c', 'ivybase__RField1__c','ivybase__Resource_Type__c','ivybase__Resource__c'};
            
            if (SecurityUtility.checkIsAccessible('ivybase__HHTMenu_Master__c', hhtmenuFields)){
                system.debug(':resourcetypeId:::'+resourcetypeId+'::::locHierarchyId::'+locHierarchyId);
                
                List<ivybase__HHTMenu_Master__c> hhtmenuMasterList = [SELECT 
                                                             Name,ivybase__Flag__c, ivybase__RField__c, ivybase__MName__c, ivybase__MNumber__c, ivybase__hasLink__c, ivybase__MenuType__c, ivybase__lang__c, ivybase__RField1__c, ivybase__Flex__c, ivybase__RegExp__c,
                                                             ivybase__Store_Hierarchy__c, ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c, ivybase__Resource__c 
                                                             FROM 
                                                             ivybase__HHTMenu_Master__c 
                                                             WHERE 
                                                             ivybase__Resource__c != NULL
                                                             AND
                                                             ivybase__Resource__c = :resourceId
                                                            ];
                
                if(hhtmenuMasterList != NULL && hhtmenuMasterList.size() > 0){
                    return hhtmenuMasterList; 
                }else{
                    
                    return [SELECT 
                            Name,ivybase__Flag__c, ivybase__RField__c, ivybase__MName__c, ivybase__MNumber__c, ivybase__hasLink__c, ivybase__MenuType__c, ivybase__lang__c, ivybase__RField1__c, ivybase__Flex__c, ivybase__RegExp__c,
                            ivybase__Store_Hierarchy__c, ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c 
                            FROM 
                            ivybase__HHTMenu_Master__c 
                            WHERE 
                            ivybase__Resource_Type__c = :resourcetypeId 
                            AND
                            ivybase__Location_Hierarchy__c =:locHierarchyId
                            AND
                            ivybase__Resource__c = null
                           ];
                }
            } else {
                String nonAccessObjFld = '';
                nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__HHTMenu_Master__c', hhtmenuFields);
                throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            } 
    }
    
    public static List<ivybase__HHTModule_Master__c> getHHTModule(Id resourcetypeId, Id locHierarchyId, Id resourceId) {
        
        String[] hhtmoduleFields = new String[]{'ivybase__Flag__c','ivybase__RField__c','ivybase__MenuType__c','ivybase__Resource_Type__c','ivybase__Store_Hierarchy__c','ivybase__Resource__c','For_Switch_Seller__c'};
            
            if (SecurityUtility.checkIsAccessible('ivybase__HHTModule_Master__c', hhtmoduleFields)){
                system.debug(':resourcetypeId:::'+resourcetypeId+'::::locHierarchyId::'+locHierarchyId);
                
                List<ivybase__HHTModule_Master__c> hhtmoduleMasterList = [SELECT 
                                                                 Name,ivybase__Flag__c, ivybase__RField__c, ivybase__MenuType__c,ivybase__Resource_Type__c, ivybase__Store_Hierarchy__c, ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c, ivybase__Resource__c,For_Switch_Seller__c 
                                                                 FROM 
                                                                 ivybase__HHTModule_Master__c
                                                                 WHERE 
                                                                 ivybase__Resource__c != NULL
                                                                 AND
                                                                 ivybase__Resource__c = :resourceId
                                                                ];
                system.debug(hhtmoduleMasterList);
                if(hhtmoduleMasterList != NULL && hhtmoduleMasterList.size() > 0){
                    return hhtmoduleMasterList; 
                }else{
                    
                    return [SELECT 
                            Name,ivybase__Flag__c, ivybase__RField__c, ivybase__MenuType__c,ivybase__Resource_Type__c, ivybase__Store_Hierarchy__c, ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c,For_Switch_Seller__c
                            FROM 
                            ivybase__HHTModule_Master__c 
                            WHERE 
                            ivybase__Resource_Type__c = :resourcetypeId
                            AND
                            ivybase__Location_Hierarchy__c =:locHierarchyId
                            AND
                            ivybase__Resource__c = null
                           ];
                }
            } else {
                String nonAccessObjFld = '';
                nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__HHTModule_Master__c', hhtmoduleFields);
                throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            } 
    }
    
    public static List<ivybase__HHT_Module_Master__mdt> getHHTModule() {
        
        return [SELECT Id, Label, DeveloperName, ivybase__Flag__c, ivybase__MenuType__c, ivybase__RField__c
                FROM ivybase__HHT_Module_Master__mdt LIMIT 50000
               ];
    }
    
    public static List<ivybase__HHT_Menu_Master__mdt> getSurveyHHTMenu() {
        
        return [SELECT  label,DeveloperName
                FROM ivybase__HHT_Menu_Master__mdt
               ];
    }
    
    /* To send HHT Menu object records not metadata records */
    public static LIST<ivybase__HHTMenu_Master__c> getHHTMenuMethods() {
        
        return [SELECT ID,Name from ivybase__HHTMenu_Master__c limit 50000];
        
    }
    
}