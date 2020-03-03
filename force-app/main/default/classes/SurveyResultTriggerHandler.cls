public with sharing class SurveyResultTriggerHandler {
    /*************************************************************
    * @description Upsert the ModuleWiseLastVisit for 'Survey' module for given Store
       It will work only for transaction uploaded from mobile
       Method will work only for per day per visit.If multiple visits are created for a day then the method needs to be modified accordingly
    * @param newSurveyResultList Trigger.new values 
    *************************************************************/
     public static void moduleWiseLastVisit(List<ivybase__Survey_Result__c> newSurveyResultList){
        system.debug('newSurveyResultList'+newSurveyResultList);
        Set<Id> visitIds =  new Set<Id>();
        Set<Id> surveyIds =  new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        Map<Id,Id> VisitStoreIdMap = new Map<Id,Id>();
        Map<String,ivybase__Survey_Result__c> surveyAndVisitMap = new Map<String,ivybase__Survey_Result__c>();
        Map<String,Id> storeAndSurveycomboMap = new Map<String,Id>();
        Map<Id, ivybase__Visit__c> visitIdWthVisitMap = new Map<Id, ivybase__Visit__c>();
        Map<String, ivybase__Survey_Result__c> surveyComboWthVisitMap = new Map<String, ivybase__Survey_Result__c>();
        Map<String, ivybase__ModuleWise_Last_Visit__c> surveyComboWthModuleWiseMap = new Map<String, ivybase__ModuleWise_Last_Visit__c>();
               
        List<ivybase__ModuleWise_Last_Visit__c> updatemoduleWiseVisit = new List<ivybase__ModuleWise_Last_Visit__c>();
        List<ivybase__ModuleWise_Last_Visit__c> moduleWiseVisitList = new List<ivybase__ModuleWise_Last_Visit__c>();
        
        String StoreIdAndSurveyIdcombo = '';
        String SurveyAndVisitcombo = '';
        
       List<String> mwlvInsertFields = new List<String> {'ivybase__module__c','ivybase__last_visit__c','ivybase__survey__c','ivybase__survey_result__c','ivybase__store__c'};
          // List<String> mwlvInsertFields = new List<String> {'ivybase__last_visit__c'};
        List<String> mwlvUpdateFields = new List<String> {'ivybase__Last_Visit__c','ivybase__Survey_Result__c'};
        if (SecurityUtility.checkIsCreateable('ivybase__ModuleWise_Last_Visit__c', mwlvInsertFields) && SecurityUtility.checkIsEditable('ivybase__ModuleWise_Last_Visit__c', mwlvInsertFields) ) {
            
            for(ivybase__Survey_Result__c survey: newSurveyResultList){
            
                if (survey.ivybase__Visit__c != null && survey.ivybase__Survey__c != null) {
                    
                    visitIds.add(survey.ivybase__Visit__c);
                    surveyIds.add(survey.ivybase__Survey__c);
                    SurveyAndVisitcombo = survey.ivybase__Survey__c + '~' + survey.ivybase__Visit__c;
                    SurveyAndVisitMap.put(SurveyAndVisitcombo ,survey);
                    accIdSet.add(survey.ivybase__Store__c);
                }
            }
                   
            List<ivybase__Visit__c> visitList = VisitService.getVisitByIds(visitIds);
            
            if(visitList != null && visitList .size() > 0) {
                
                visitIdWthVisitMap = new  Map<Id, ivybase__Visit__c>(visitList);
            }
            ivybase__Visit__c  visit = null;
            
            for(String SurveyAndVisitCombo1 :SurveyAndVisitMap.keySet()){
                
                if (SurveyAndVisitMap.get(SurveyAndVisitCombo1) != null 
                        && visitIdWthVisitMap.get(SurveyAndVisitMap.get(SurveyAndVisitCombo1).ivybase__Visit__c) != null) { 
                    
                    String surveyAndStoreCombo = SurveyAndVisitCombo1.split('~')[0] + '~' + visitIdWthVisitMap.get(SurveyAndVisitMap.get(SurveyAndVisitCombo1).ivybase__Visit__c).ivybase__Store__c;
                    if(!surveyComboWthVisitMap.containsKey(surveyAndStoreCombo) ||
                           (surveyComboWthVisitMap.containsKey(surveyAndStoreCombo) 
                               && visitIdWthVisitMap.get(surveyComboWthVisitMap.get(surveyAndStoreCombo).ivybase__Visit__c).ivybase__Visit_Date__c < visitIdWthVisitMap.get(SurveyAndVisitMap.get(SurveyAndVisitCombo1).ivybase__Visit__c).ivybase__Visit_Date__c
                           )) {
                    
                        surveyComboWthVisitMap.put(surveyAndStoreCombo, SurveyAndVisitMap.get(SurveyAndVisitCombo1));
                    }
                }
                          
            }
            
            System.debug('::::surveyComboWthModuleWiseMap ' +surveyComboWthModuleWiseMap);
            System.debug('::::surveyComboWthVisitMap ' +surveyComboWthVisitMap);
            
            List<ivybase__ModuleWise_Last_Visit__c> moduleWiseList = ModuleWiseLastVisitService.getModuleWiseLastVisitSurvey('Survey',accIdSet,surveyIds);
            
            if(moduleWiseList != null && moduleWiseList.size() > 0) {
                
                for(ivybase__ModuleWise_Last_Visit__c modWiseLastVisit : moduleWiseList) {
                    
                    surveyComboWthModuleWiseMap.put(modWiseLastVisit.ivybase__Survey__c+'~'+modWiseLastVisit.ivybase__Store__c, modWiseLastVisit);
                }
            }
            
            for(String storeAndSurveyCombo : surveyComboWthVisitMap.keySet()) {
            
                ivybase__ModuleWise_Last_Visit__c moduleWiseVisit = surveyComboWthModuleWiseMap.get(storeAndSurveyCombo);
                ivybase__Survey_Result__c surveyResult = surveyComboWthVisitMap.get(storeAndSurveyCombo);
                
                if(surveyResult != null){
                    
                    if(moduleWiseVisit == null) {
                    
                          ivybase__ModuleWise_Last_Visit__c mod = new ivybase__ModuleWise_Last_Visit__c();
                          mod.ivybase__Module__c = 'Survey';
                          mod.ivybase__Last_Visit__c = surveyResult.ivybase__Visit__c ;
                          mod.ivybase__Survey__c = surveyResult.ivybase__Survey__c;
                          mod.ivybase__Survey_Result__c = surveyResult.Id;
                          mod.ivybase__Store__c = surveyResult.ivybase__Store__c;
                          moduleWiseVisitList.add(mod);                     
                    }else{  
                       
                          ivybase__ModuleWise_Last_Visit__c mod = new ivybase__ModuleWise_Last_Visit__c(Id = moduleWiseVisit.Id);
                          mod.ivybase__Last_Visit__c = surveyResult.ivybase__Visit__c;
                          mod.ivybase__Survey_Result__c = surveyResult.Id;
                          moduleWiseVisitList.add(mod);
                    }
                }
                 
            }
            
            if(moduleWiseVisitList.size()>0){
    
                upsert moduleWiseVisitList;
            }            
            
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
 }