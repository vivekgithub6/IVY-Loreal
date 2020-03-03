public with sharing class SurveyTriggerHandler {
    
    public static void checkDup(List<ivybase__Survey__c> surList, Map<Id, ivybase__Survey__c> oldsurMap) {
       
        Set<String> names = new Set<String>();
        Set<String> checkString = new Set<String>();
        Map<Id, String> surveyIdwithUserTypeMap = new Map<Id, String>();
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck2(new Set<String>{'Survey_Name_Duplication_Logic'});
        
        for(ivybase__Survey__c sur : surList) {
            if(oldsurMap == null) {
                names.add(sur.Name);
            } else {
                if(sur.Name != oldsurMap.get(sur.Id).Name) {
                    names.add(sur.Name);
                }
                if (sur.ivybase__Type__c != oldsurMap.get(sur.Id).ivybase__Type__c) {
                    surveyIdwithUserTypeMap.put(sur.Id, oldsurMap.get(sur.Id).ivybase__Type__c);
                }
            }
        }
        System.debug('******names'+names);
        if(names.size() > 0) {
             if(triggerLogicMap.get('Survey_Name_Duplication_Logic') == Null 
                || triggerLogicMap.get('Survey_Name_Duplication_Logic') == false) { 
                String[] surFields = new String[]{};
                if (SecurityUtility.checkIsAccessible('ivybase__Survey__c', surFields )) { 
                    for(ivybase__Survey__c xsur : [SELECT Name FROM ivybase__Survey__c WHERE Name IN :names]) {
                        checkString.add(xsur.Name);
                    }
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
            }
        }
        Set<Id> errorUserServeySet = new Set<Id>();
        Set<Id> errorStoreServeySet = new Set<Id>();
        if (surveyIdwithUserTypeMap != null && surveyIdwithUserTypeMap.size() > 0) {
            String[] smFields = new String[] {'ivybase__Location_Hierarchy__c', 'ivybase__Store_Hierarchy__c','ivybase__Survey__c','ivybase__Store__c', 'ivybase__User__c'}; 
            if (SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', smFields )) { 
                for (ivybase__Survey_Mapping__c sm : [SELECT Id, ivybase__Location_Hierarchy__c, ivybase__Store_Hierarchy__c, 
                                                                 ivybase__Store__c, ivybase__User__c, ivybase__Survey__c
                                                           FROM
                                                               ivybase__Survey_Mapping__c
                                                           WHERE 
                                                               ivybase__Survey__c IN :surveyIdwithUserTypeMap.keySet()
                                                           AND 
                                                               (ivybase__Location_Hierarchy__c != NULL
                                                                OR ivybase__Store_Hierarchy__c != NULL 
                                                                OR ivybase__Store__c != NULL
                                                                OR ivybase__User__c != NULL)
                                                        ]) {
                
                    if (surveyIdwithUserTypeMap.get(sm.ivybase__Survey__c) == 'User' && sm.ivybase__User__c != null) {
                        errorUserServeySet.add(sm.ivybase__Survey__c);
                    } else if (surveyIdwithUserTypeMap.get(sm.ivybase__Survey__c) == 'Store' 
                            && (sm.ivybase__Location_Hierarchy__c != NULL || sm.ivybase__Store_Hierarchy__c != NULL || sm.ivybase__Store__c != NULL)) {
                        errorStoreServeySet.add(sm.ivybase__Survey__c);
                    }  
                } 
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
                                                       
        }
        
        for(ivybase__Survey__c sur : surList) {
            if (sur.Id != null) {
                if (errorUserServeySet != null && errorUserServeySet.contains(sur.Id)) {
                    sur.addError('The User type survey mapped some user, If you want to change user type, Delete usertype mapped survey mapping records');
                }
                if (errorStoreServeySet != null && errorStoreServeySet.contains(sur.Id)) {
                    sur.addError('The Store type survey mapped some store/store hierarchy/location hierarchy, If you want to change user type, Delete survey mapping records mapped with store or store hierarchy or location hierarchy');                
                }
            } 
            if(triggerLogicMap.get('Survey_Name_Duplication_Logic') == Null 
                || triggerLogicMap.get('Survey_Name_Duplication_Logic') == false) { 
                if(checkString.contains(sur.Name) ) {
                    if(!Test.isRunningTest())
                    sur.addError('A Record with same Name exists.');
                } else {
                    checkString.add(sur.Name);
                }
            }
        }
    }
}