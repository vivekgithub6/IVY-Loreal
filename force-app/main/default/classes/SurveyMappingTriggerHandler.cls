public with sharing class SurveyMappingTriggerHandler {
    
 /*   public static Set<String> check;
    public static Set<Id> surveyMappingIds;
    Public Static Map<String, ivybase__Survey_Mapping__c> checkduplicatewithIdMap;
    public static void checkDup(List<ivybase__Survey_Mapping__c> surList, Map<Id, ivybase__Survey_Mapping__c> oldsurMap) {
       
        Set<Id> surIds = new Set<Id>();
        system.debug(':::start1 ::::');
        if (check == null) {
            check = new Set<String>();
        }
        if (surveyMappingIds == null) {
            surveyMappingIds = new Set<Id> ();
        }
        if ( checkduplicatewithIdMap == null ) { 
            checkduplicatewithIdMap = new Map<String, ivybase__Survey_Mapping__c>();
        }
        Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck2(
                                                new Set<String>{'Survey_Mapping_User_Duplication_Logic','Survey_Mapping_Store_Duplication_Logic','Survey_Mapping_SHie_Duplication_Logic','Survey_Mapping_LHie_Duplication_Logic'});
        
        if(triggerLogicMap.get('Survey_Mapping_User_Duplication_Logic') != TRUE || 
           triggerLogicMap.get('Survey_Mapping_Store_Duplication_Logic') != TRUE ||
           triggerLogicMap.get('Survey_Mapping_SHie_Duplication_Logic') != TRUE || 
           triggerLogicMap.get('Survey_Mapping_LHie_Duplication_Logic') != TRUE){
               if(surList != null && surList.size()>0){
            for(ivybase__Survey_Mapping__c sur : surList) {
                if (sur.Id != null) {
                    surveyMappingIds.add(sur.Id);
                }
                
                if(oldsurMap == null) {
                    surIds.add(sur.ivybase__Survey__c);
                } else {
                    
                    if((sur.ivybase__User__c != null && sur.ivybase__User__c != oldSurMap.get(sur.Id).ivybase__User__c)
                       || (sur.ivybase__Survey__c != oldSurMap.get(sur.Id).ivybase__Survey__c)
                       || (sur.ivybase__Store__c != null && sur.ivybase__Store__c != oldSurMap.get(sur.Id).ivybase__Store__c)
                       || (sur.ivybase__Store_Hierarchy__c != null && sur.ivybase__Store_Hierarchy__c != oldSurMap.get(sur.Id).ivybase__Store_Hierarchy__c)
                       || (sur.ivybase__Location_Hierarchy__c != null && sur.ivybase__Location_Hierarchy__c != oldSurMap.get(sur.Id).ivybase__Location_Hierarchy__c)) {
                        surIds.add(sur.ivybase__Survey__c);
                    }
                }
                
                if(triggerLogicMap.get('Survey_Mapping_User_Duplication_Logic') == NULL 
                    || triggerLogicMap.get('Survey_Mapping_User_Duplication_Logic') == FALSE){ 
                        if(sur.ivybase__User__c != null) {
                            if(check.contains(sur.ivybase__Survey__c+''+sur.ivybase__User__c)) {
                                sur.addError('Survey already mapped to this user');
                            } else {
                                check.add(sur.ivybase__Survey__c+''+sur.ivybase__User__c);
                                checkduplicatewithIdMap.put(sur.ivybase__Survey__c+''+sur.ivybase__User__c, sur);
                            }
                        }
                 }
                 
                 if(triggerLogicMap.get('Survey_Mapping_Store_Duplication_Logic') == NULL 
                    || triggerLogicMap.get('Survey_Mapping_Store_Duplication_Logic') == FALSE){ 
                
                    if(sur.ivybase__Store__c != null) {
                        if(check.contains(sur.ivybase__Survey__c+''+sur.ivybase__Store__c)) {
                            sur.addError('Survey already mapped to this Store');
                        } else {
                            check.add(sur.ivybase__Survey__c+''+sur.ivybase__Store__c);
                            checkduplicatewithIdMap.put(sur.ivybase__Survey__c+''+sur.ivybase__Store__c, sur);
                        }
                    }
                }
                
                if(triggerLogicMap.get('Survey_Mapping_SHie_Duplication_Logic') == NULL 
                    || triggerLogicMap.get('Survey_Mapping_SHie_Duplication_Logic') == FALSE){ 
                    if(sur.ivybase__Store_Hierarchy__c != null) {
                        if(check.contains(sur.ivybase__Survey__c+''+sur.ivybase__Store_Hierarchy__c)) {
                            sur.addError('Survey already mapped to this Store Hierarchy');
                        } else {
                            check.add(sur.ivybase__Survey__c+''+sur.ivybase__Store_Hierarchy__c);
                            checkduplicatewithIdMap.put(sur.ivybase__Survey__c+''+sur.ivybase__Store_Hierarchy__c, sur);
                        }
                    }
                }
                
                if(triggerLogicMap.get('Survey_Mapping_LHie_Duplication_Logic') == NULL 
                    || triggerLogicMap.get('Survey_Mapping_LHie_Duplication_Logic') == FALSE){ 
                    if(sur.ivybase__Location_Hierarchy__c != null) {
                        if(check.contains(sur.ivybase__Survey__c+''+sur.ivybase__Location_Hierarchy__c)) {
                            sur.addError('Survey already mapped to this Location Hierarchy');
                        } else {
                            check.add(sur.ivybase__Survey__c+''+sur.ivybase__Location_Hierarchy__c);
                            checkduplicatewithIdMap.put(sur.ivybase__Survey__c+''+sur.ivybase__Location_Hierarchy__c, sur);
                        }
                    }
                }
            }
               }
            system.debug('::::test;:::');
            if(surids.size() > 0 && check.size() > 0) {
                
                String[] ckFields = new String[] {'ivybase__Survey__c','ivybase__User__c','ivybase__Store__c','ivybase__Store_Hierarchy__c','ivybase__Location_Hierarchy__c'}; 
                if (SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', ckFields)) { 
                    for(ivybase__Survey_Mapping__c xsur : [SELECT Id, ivybase__Survey__c, ivybase__User__c, ivybase__Store__c, ivybase__Store_Hierarchy__c, ivybase__Location_Hierarchy__c
                                                  FROM ivybase__Survey_Mapping__c 
                                                  WHERE ivybase__Survey__c IN :surIds AND Id NOT IN :surveyMappingIds
                                                  AND (ivybase__Dup_Survey_Store__c IN:check
                                                       OR ivybase__Dup_Survey_User__c IN:check
                                                       OR ivybase__Dup_Survey_Store_Hierarchy__c IN:check
                                                       OR ivybase__Dup_Survey_Location_Hierarchy__c IN:check)
                                                   ]) {
                        
                        surveyMappingIds.add(xsur.Id);
                        if(triggerLogicMap.get('Survey_Mapping_User_Duplication_Logic') == NULL 
                            || triggerLogicMap.get('Survey_Mapping_User_Duplication_Logic') == FALSE){ 
                                if(xsur.ivybase__User__c != null) {
                                    if(check.contains(xsur.ivybase__Survey__c+''+xsur.ivybase__User__c)) {
                                        if (checkduplicatewithIdMap.containsKey(xsur.ivybase__Survey__c+''+xsur.ivybase__User__c)) {
                                            checkduplicatewithIdMap.get(xsur.ivybase__Survey__c+''+xsur.ivybase__User__c).addError('Survey already mapped to this user');
                                        }
                                    } else {
                                        check.add(xsur.ivybase__Survey__c+''+xsur.ivybase__User__c);
                                    }
                                }
                         }
                         
                         if(triggerLogicMap.get('Survey_Mapping_Store_Duplication_Logic') == NULL 
                            || triggerLogicMap.get('Survey_Mapping_Store_Duplication_Logic') == FALSE){ 
                        
                            if(xsur.ivybase__Store__c != null) {
                                if(check.contains(xsur.ivybase__Survey__c+''+xsur.ivybase__Store__c)) {
                                    if (checkduplicatewithIdMap.containsKey(xsur.ivybase__Survey__c+''+xsur.ivybase__Store__c)) {
                                        checkduplicatewithIdMap.get(xsur.ivybase__Survey__c+''+xsur.ivybase__Store__c).addError('Survey already mapped to this Store');
                                    }
                                } else {
                                    check.add(xsur.ivybase__Survey__c+''+xsur.ivybase__Store__c);
                                }
                            }
                        }
                        
                        if(triggerLogicMap.get('Survey_Mapping_SHie_Duplication_Logic') == NULL 
                            || triggerLogicMap.get('Survey_Mapping_SHie_Duplication_Logic') == FALSE){ 
                            if(xsur.ivybase__Store_Hierarchy__c != null) {
                                if(check.contains(xsur.ivybase__Survey__c+''+xsur.ivybase__Store_Hierarchy__c)) {
                                    if (checkduplicatewithIdMap.containsKey(xsur.ivybase__Survey__c+''+xsur.ivybase__Store_Hierarchy__c)) {
                                        checkduplicatewithIdMap.get(xsur.ivybase__Survey__c+''+xsur.ivybase__Store_Hierarchy__c).addError('Survey already mapped to this Store Hierarchy');
                                    }
                                } else {
                                    check.add(xsur.ivybase__Survey__c+''+xsur.ivybase__Store_Hierarchy__c);
                                }
                            }
                        }
                        
                        if(triggerLogicMap.get('Survey_Mapping_LHie_Duplication_Logic') == NULL 
                            || triggerLogicMap.get('Survey_Mapping_LHie_Duplication_Logic') == FALSE){ 
                            if(xsur.ivybase__Location_Hierarchy__c != null) {
                                if(check.contains(xsur.ivybase__Survey__c+''+xsur.ivybase__Location_Hierarchy__c)) {
                                    if (checkduplicatewithIdMap.containsKey(xsur.ivybase__Survey__c+''+xsur.ivybase__Location_Hierarchy__c)) {
                                        checkduplicatewithIdMap.get(xsur.ivybase__Survey__c+''+xsur.ivybase__Location_Hierarchy__c).addError('Survey already mapped to this Location Hierarchy');
                                    }
                                } else {
                                    check.add(xsur.ivybase__Survey__c+''+xsur.ivybase__Location_Hierarchy__c);
                                }
                            }
                        }
                    }
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
            }
        }
    }*/
}