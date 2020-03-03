global with sharing class SurveyQuestionService {
    
    global static Map<String, Id> getSuveryQuestionUsingSurveyandQuestionInternalId(Set<String> surveyInternalIds, Set<String> questionInternalIds) {
        Map<String, Id> surveyandQuestionInternalIdWithSurveyQuestionIdMap = new Map<String, Id>();
        String[] ck1Fields = new String[] {'ivybase__Question_Id__c','ivybase__Question__c','ivybase__Survey__c'};
        String[] ck2Fields = new String[] {'ivybase__Internal_Id__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', ck1Fields) && SecurityUtility.checkIsAccessible('ivybase__Survey__c', ck2Fields)) { 
            for (ivybase__Survey_Question__c sq :[SELECT Id, ivybase__Question_Id__c, ivybase__Question__c, 
                                                ivybase__Question__r.ivybase__Question_Id__c, ivybase__Survey__c, 
                                                ivybase__Survey__r.ivybase__Internal_Id__c
                                         FROM
                                             ivybase__Survey_Question__c
                                         WHERE
                                             ivybase__Survey__r.ivybase__Internal_Id__c IN:surveyInternalIds
                                         OR 
                                             (ivybase__Question__c != null AND ivybase__Question__r.ivybase__Question_Id__c IN:questionInternalIds)                                     
                                         ]) {
                
                surveyandQuestionInternalIdWithSurveyQuestionIdMap.put(sq.ivybase__Survey__r.ivybase__Internal_Id__c +'' +sq.ivybase__Question__r.ivybase__Question_Id__c, sq.Id);
            }
            return surveyandQuestionInternalIdWithSurveyQuestionIdMap;
        }  else {
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','ivybase__Survey_Question__c,ivybase__Survey__c');
         
        }
    }
    
     public static Set<Id> getquesIdfromsurveyques(Set<Id> quesId){
        
        Set<Id> quesIdset = new Set<Id>();
        String[] ck1Fields = new String[] {'ivybase__Question__c'};
        String[] ck2Fields = new String[] {'ivybase__Question_Type__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', ck1Fields) && SecurityUtility.checkIsAccessible('ivybase__Question__c', ck2Fields)) { 
            for(ivybase__Survey_Question__c sq :[SELECT Id,ivybase__Question__c FROM ivybase__Survey_Question__c WHERE ivybase__Question__c IN:quesId AND ivybase__Question__r.ivybase__Question_Type__c = 'Option']){
               quesIdset.add(sq.ivybase__Question__c);
            }
            return quesIdset;
        }  else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
        
    }
}