public with sharing class ModuleWiseLastVisitService {    
    //Start - SFDC-821 Module wise last visit
    
    public static List<ivybase__ModuleWise_Last_Visit__c> getModuleWiseLastVisits(String module,Set<Id> storeIds) {
        
        List<String> ModuleWiseLastVisitFields = new List<String>{'ivybase__Module__c', 'ivybase__Store__c', 'ivybase__Last_Visit__c', 'ivybase__Survey_Result__c'};
        
        if (SecurityUtility.checkIsAccessible('ivybase__ModuleWise_Last_Visit__c', ModuleWiseLastVisitFields )) {                                
            List<ivybase__ModuleWise_Last_Visit__c> modulevisits = new List<ivybase__ModuleWise_Last_Visit__c>();
            modulevisits = [SELECT Id,name,ivybase__Module__c,ivybase__Store__c,ivybase__Last_Visit__c, ivybase__Survey_Result__c from ivybase__ModuleWise_Last_Visit__c 
                                                                where ivybase__Store__c IN:storeIds
                                                                and ivybase__Module__c =:module];
            return modulevisits;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__ModuleWise_Last_Visit__c', ModuleWiseLastVisitFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
        }
    }
    
    public static List<ivybase__ModuleWise_Last_Visit__c> getModuleWiseLastVisitSurvey(String module,Set<Id> storeIds, set<Id> surveyIds) {
        List<String> ModuleWiseLastVisitFields = new List<String>{'ivybase__Module__c', 'ivybase__Store__c','ivybase__Last_Visit__c','ivybase__Survey__c','ivybase__Survey_Result__c'};
        
        if (SecurityUtility.checkIsAccessible('ivybase__ModuleWise_Last_Visit__c', ModuleWiseLastVisitFields )) {  
            List<ivybase__ModuleWise_Last_Visit__c> modulevisits = new List<ivybase__ModuleWise_Last_Visit__c>();
            modulevisits = [SELECT Id,name,ivybase__Module__c,ivybase__Store__c,ivybase__Last_Visit__c,ivybase__Survey__c,ivybase__Survey_Result__c from ivybase__ModuleWise_Last_Visit__c 
                                                                where ivybase__Store__c IN:storeIds
                                                                and ivybase__Survey__c IN:surveyIds
                                                                and ivybase__Module__c =:module];
            return modulevisits;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
}