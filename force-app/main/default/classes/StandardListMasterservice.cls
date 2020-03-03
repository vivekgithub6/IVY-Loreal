public class StandardListMasterservice {
    public static List<ivybase__Standard_List_Master__c> getStandardListUsingListType(list<String> listType) {
        String[] ckFields = new String[] {'ivybase__List_Code__c', 'ivybase__List_Name__c', 'ivybase__List_Type__c', 'ivybase__Parent_Id__c'}; 
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        system.debug('resource===>'+resource);
        
        
        Id resourcetypeId = null;        
        Id endmarketId = null;        
         Id locHierarchyId;
        if (resource != null) {
            endmarketId = resource.ivybase__Location_Hierarchy__c;
            resourcetypeId = resource.ivybase__Resource_Type__c;
            locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;
        }
        if (SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', ckFields)) { 
           List<ivybase__Standard_List_Master__c> rec= [SELECT  Id, 
                            Name,
                            ivybase__List_Code__c,
                            ivybase__List_Name__c,
                    ivybase__Encrypted_List_Name__c,
                            ivybase__List_Type__c,
                            ivybase__Parent_Id__c,
                            ivybase__Parent_Id__r.Name,
                    ivybase__Parent_Id__r.ivybase__List_Name__c,
                    ivybase__Flex1__c,
                    ivybase__Parent_Id__r.ivybase__Parent_Id__r.ivybase__List_Name__c,
                            ivybase__Resource_Type__c,
                            ivybase__Location_Hierarchy__c,ivybase__Display_Name__c 
                    FROM ivybase__Standard_List_Master__c
                    WHERE ivybase__List_Type__c != null
                    AND ivybase__List_Type__c in :listType
                    AND ivybase__Resource_Type__c =:resourcetypeId
                    AND ivybase__Location_Hierarchy__c =:locHierarchyId
                   ];
            system.debug('listType '+listType);
            system.debug('resourcetypeId '+resourcetypeId);
            system.debug('locHierarchyId '+locHierarchyId);
           for(ivybase__Standard_List_Master__c r:rec)
           {
               if(r.ivybase__Encrypted_List_Name__c!=null){
               r.ivybase__List_Name__c=r.ivybase__Encrypted_List_Name__c;
               }
           }
            return rec;
            
        } else {
            system.debug('Insode else for erer');
            //throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            return null;
        }
    }
    
    public static List< ivybase__Standard_List_Master__c > getAllClassTypeList() {
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        system.debug('resource' +resource);
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;
        system.debug('resourcetypeId' +resourcetypeId);
        system.debug('locHierarchyId' +locHierarchyId);
        String[] ckFields = new String[] {'ivybase__List_Code__c', 'ivybase__List_Name__c', 'ivybase__List_Type__c', 'ivybase__Parent_Id__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', ckFields)) { 
            return [SELECT Name,
                           ivybase__List_Code__c,
                           ivybase__List_Name__c,
                           ivybase__List_Type__c,
                           ivybase__Parent_Id__r.Name,
                           ivybase__Resource_Type__c,
                           ivybase__Location_Hierarchy__c
                    FROM 
                        ivybase__Standard_List_Master__c 
                    WHERE 
                        ivybase__List_Type__c = 'CHANNEL_HIERARCHY'
                    AND 
                        ivybase__Resource_Type__c =:resourcetypeId
                    AND 
                        ivybase__Location_Hierarchy__c =:locHierarchyId
                   ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
    }
    
    public static List<ivybase__Standard_List_Master__c> getAllStandard_List() {
        
        String[] ckFields = new String[] {'ivybase__List_Code__c', 'ivybase__List_Name__c', 'ivybase__List_Type__c', 'ivybase__Parent_Id__c'}; 
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;
        
        if (SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', ckFields)) { 
            return [SELECT  Id, 
                            Name,
                            ivybase__List_Code__c,
                            ivybase__List_Name__c,
                            ivybase__List_Type__c,
                            ivybase__Parent_Id__c,
                            ivybase__Parent_Id__r.Name
                    FROM ivybase__Standard_List_Master__c
                    WHERE 
                        ivybase__List_Type__c != null
                    AND ivybase__Resource_Type__c =:resourcetypeId
                    AND ivybase__Location_Hierarchy__c =:locHierarchyId
                    //ORDER BY List_Name__c ASC
                   ];
        } else {
        
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static List<ivybase__Standard_List_Master__c> getStandardListBylistType(String listType) {
    
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;

        String[] ckFields = new String[] {'ivybase__List_Code__c', 'ivybase__List_Name__c', 'ivybase__List_Type__c', 'ivybase__Parent_Id__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', ckFields)) { 
            return [SELECT  Id, 
                            Name,
                            ivybase__List_Code__c,
                            ivybase__List_Name__c,
                            ivybase__List_Type__c,
                            ivybase__Parent_Id__c,
                            ivybase__Parent_Id__r.Name,
                            ivybase__Resource_Type__c,
                            ivybase__Location_Hierarchy__c,
                    ivybase__Display_Name__c 
                    FROM 
                        ivybase__Standard_List_Master__c
                    WHERE 
                        ivybase__List_Type__c != null
                    AND 
                        ivybase__List_Type__c =:listType
                    AND 
                        ivybase__Resource_Type__c =:resourcetypeId
                    AND 
                        ivybase__Location_Hierarchy__c =:locHierarchyId
                   ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),
                                                                                                         'INSUFFICIENT_PERMISSIONS');
            //return null;
        }
    }
    
    /* 
	* Method added for Surveys

	*/
    public static List<ivybase__Standard_List_Master__c> getSurveyCriteriaStds(List<String> listTypes, List<String> listNames, List<String> listCodes) {
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id resourcetypeId = resource != null ? resource.ivybase__Resource_Type__c : null;
        Id locHierarchyId = resource != null ? resource.ivybase__Location_Hierarchy__c : null;
        
        return [SELECT Id, ivybase__List_Type__c, ivybase__List_Code__c, 
                        ivybase__Parent_Id__c, Name,
                        ivybase__Display_Name__c 
              FROM 
                  ivybase__Standard_List_Master__c
              WHERE 
                  ivybase__Resource_Type__c =:resourcetypeId
              AND 
                  ivybase__Location_Hierarchy__c =:locHierarchyId
              AND
                  (ivybase__List_Type__c IN: listTypes
                      OR
                          ivybase__List_Name__c IN: listNames
                      OR
                          ivybase__List_Code__c IN: listCodes
                  )
              ];
    }
    
    
}