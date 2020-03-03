@RestResource(urlMapping='/v1/SurveyGroup/Masters/*')
global with sharing class RESTSurveyGroup {
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getSurveyGroupInfo() {
        RExAPIResponseDomain.MultipleResponseInfo surveyGrp;
        RestRequest req = Restcontext.request;
        Map<String,String> getHeaders = req.Headers;
        
        List<ivybase__Question_Answer_Option__c> questionAnsOptionList = new List<ivybase__Question_Answer_Option__c>();
        List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList = new List<ivybase__Question_Answer_Option__c>();
        Set<Id> optionsQuestionIdSet = new Set<Id>();
        
        SurveyDomain.SurveyMappingswithSurveyIdsInfo surveyMapswithSurveyIds;
        Set<Id> surveyIdSet ;
        Map<Id, ivybase__Survey__c> surveyMap;
        Set<Id> surveySet; 
        List<ivybase__Survey_Mapping__c> surveyCriteriaMapping;
        
        SurveyDomain.surveyFilterObjectIds surveyFlt = new SurveyDomain.surveyFilterObjectIds();
        
        try {
        ivybase__Resource__c resource = ResourceService.getSellerId(UserInfo.getUserId());
        Id sellerId = null;
        Id SupervisorId = null;
        if (resource != null) {
            sellerId = resource.Id;
            system.debug('sellerId'+sellerId);
            if (resource.ivybase__Reports_To__c != null) {
                SupervisorId = resource.ivybase__Reports_To__c;
            }
        }
                
        if (sellerId != null) {
            surveyFlt = SurveyService.getSellerStoreHierarchyIds(sellerId);
        }
       system.debug('surveyFlt'+surveyFlt);
            
        /*system.debug('SupervisorId'+ SupervisorId);
        system.debug('surveyFlt.SellerIds'+ surveyFlt.SellerIds);
        system.debug('surveyFlt.storeIds'+ surveyFlt.storeIds);
        system.debug('surveyFlt.storeHierarchyIds'+ surveyFlt.storeHierarchyIds);
        system.debug('surveyFlt.locationIds'+ surveyFlt.locationIds);*/
        surveyMapswithSurveyIds = SurveyService.getSurveyMappingwithSurveyIds(surveyFlt.storeIds, surveyFlt.storeHierarchyIds, surveyFlt.locationIds, surveyFlt.SellerIds,SupervisorId );//survey
        
        system.debug('surveyMapswithSurveyIds'+ surveyMapswithSurveyIds);    
            
        if (surveyMapswithSurveyIds != null ) {
            if (surveyMapswithSurveyIds.surveyMappingList != null && surveyMapswithSurveyIds.surveyMappingList.size() > 0) {
                surveyCriteriaMapping = surveyMapswithSurveyIds.surveyMappingList;
            }
        }
        system.debug('surveyCriteriaMapping'+ surveyCriteriaMapping);
        surveySet = surveyMapswithSurveyIds != null && surveyMapswithSurveyIds.surveyIdSet != null && surveyMapswithSurveyIds.surveyIdSet.size() > 0 ? surveyMapswithSurveyIds.surveyIdSet : null;  
        SurveyDomain.SurveyQuestionsWithQuestionIdSetInfo surveyQuestions = SurveyService.getSurveyMapping(surveySet);  //survey mapping
        
        system.debug('surveyQuestions'+ surveyQuestions);
        system.debug('surveyQuestions.questionIdSet ->'+ surveyQuestions.questionIdSet);
            
        Map<Id, ivybase__Question__c> questionIdwithQuestionMap = new Map<Id, ivybase__Question__c> ();
        Map<Id, String> questionIdwithSurveyHhtMenuMap = new Map<Id, String>();
        Map<Id, Set<String>> questionIdwithSurveyInternalIdMap = new Map<Id, Set<String>>();
        
        Set<Id> depquesset = new Set<Id>();
        if (surveyQuestions != null && surveyQuestions.questionIdSet != null && surveyQuestions.questionIdSet.size() > 0) {
            questionIdwithQuestionMap = SurveyService.getQuestions(surveyQuestions.questionIdSet); // Question master
            
            system.debug('questionIdwithQuestionMap '+ questionIdwithQuestionMap);
            
            questionIdwithSurveyHhtMenuMap = surveyQuestions.questionIdwithSurveyHhtMenuMap;
            questionIdwithSurveyInternalIdMap = surveyQuestions.questionIdwithSurveyInternalIdMap;
            if (questionIdwithQuestionMap != null && questionIdwithQuestionMap.size() > 0) {
                Integer count = 0;
                Boolean isFlag = true;
                Set<Id> tempQuestionIdSet = new Set<Id>();
                tempQuestionIdSet = questionIdwithQuestionMap.KeySet();
                
                system.debug('tempQuestionIdSet ->'+ tempQuestionIdSet);
                do {
                    List<ivybase__Question_Answer_Option__c> quAnOpList = new List<ivybase__Question_Answer_Option__c>();                    
                    quAnOpList = SurveyService.getOptions(tempQuestionIdSet); 
                   system.debug('quAnOpList->'+ quAnOpList);
                    
                    tempQuestionIdSet = new Set<Id>();
                    if (quAnOpList != null && quAnOpList.size() > 0) {
                        questionAnsOptionList.addAll(quAnOpList); // Added Question Answer Options
                        
                        SurveyDomain.QuestionIdwithQuestionAnswerOptionInfo tempQuesitonIdwithQAOInfo = SurveyService.getOptionDQM(quAnOpList);
                        if (tempQuesitonIdwithQAOInfo != null && tempQuesitonIdwithQAOInfo.quesAnsOptionList != null 
                                && tempQuesitonIdwithQAOInfo.quesAnsOptionList.size() > 0) {
                            
                            List<ivybase__Question_Answer_Option__c> tempDepQuesAnswerOptionList = tempQuesitonIdwithQAOInfo.quesAnsOptionList; // OptionDQM
                            if (tempDepQuesAnswerOptionList != null && tempDepQuesAnswerOptionList.size() > 0) {
                                dependentQuestionAnsOptionList.addAll(tempDepQuesAnswerOptionList); // Added Dependent Question Answer Options 
                                //generate module value
                                for (ivybase__Question_Answer_Option__c depQuestion :tempDepQuesAnswerOptionList) {
                                    if (questionIdwithSurveyHhtMenuMap != null && questionIdwithSurveyHhtMenuMap.size() > 0 
                                            && questionIdwithSurveyHhtMenuMap.containsKey(depQuestion.ivybase__Question__c)) {
                                            
                                        questionIdwithSurveyHhtMenuMap.put(depQuestion.ivybase__Dependent_Question__c,questionIdwithSurveyHhtMenuMap.get(depQuestion.ivybase__Question__c));          
                                    }
                                    
                                    if (questionIdwithSurveyInternalIdMap != null && questionIdwithSurveyInternalIdMap.size() > 0 
                                            && questionIdwithSurveyInternalIdMap.containsKey(depQuestion.ivybase__Question__c)) {
                                        
                                        if (!questionIdwithSurveyInternalIdMap.containsKey(depQuestion.ivybase__Dependent_Question__c)) {
                                            questionIdwithSurveyInternalIdMap.put(depQuestion.ivybase__Dependent_Question__c, new Set<String>());
                                            
                                        } 
                                        questionIdwithSurveyInternalIdMap.get(depQuestion.ivybase__Dependent_Question__c).addAll(questionIdwithSurveyInternalIdMap.get(depQuestion.ivybase__Question__c));          
                                    }
                                }
                            } else {
                                isFlag = false;
                            }
                            
                            
                            if (tempQuesitonIdwithQAOInfo.QuestionIds != null && tempQuesitonIdwithQAOInfo.QuestionIds.size() > 0) {
                                tempQuestionIdSet = tempQuesitonIdwithQAOInfo.QuestionIds;
                            } else {
                                isFlag = false;
                            }
                        }
                    } else {
                        isFlag = false;
                    }
                    count++;
                } while (isFlag && count < 6);                
            }
        } 
        
        for (ivybase__Question_Answer_Option__c ansOp: questionAnsOptionList) {
            optionsQuestionIdSet.add(ansOp.ivybase__Question__c);
        }
        Map<String, String> listCodewithListIdMap = SurveyService.surveyStdList();  
        system.debug('listCodewithListIdMap'+listCodewithListIdMap);
        List<ivybase__Survey__c> surveyList = surveyMap != null && surveyMap.size() > 0 ? surveyMap.values() : null;
        List<ivybase__Survey_Question__c> surveyQuestionList = surveyQuestions != null ? surveyQuestions.surveyQuestionList : null;
        List<ivybase__Question__c> questionList = questionIdwithQuestionMap != null && questionIdwithQuestionMap.size() > 0 ? questionIdwithQuestionMap.values() : null;
        
        /*system.debug('surveyCriteriaMapping'+ surveyCriteriaMapping);
        system.debug('surveyQuestionList' + surveyQuestionList);
        system.debug('surveyCriteriaMapping'+ surveyCriteriaMapping);
        system.debug('questionList'+ questionList);
        system.debug('questionAnsOptionList '+ questionAnsOptionList);
        system.debug('dependentQuestionAnsOptionList'+ dependentQuestionAnsOptionList);
        system.debug('listCodewithListIdMap'+ listCodewithListIdMap);*/    
        surveyGrp = SurveyTranslator.objectToSurveyGroup(surveyCriteriaMapping, surveyQuestionList, surveyCriteriaMapping , questionList, questionAnsOptionList, dependentQuestionAnsOptionList, listCodewithListIdMap,questionIdwithSurveyHhtMenuMap, optionsQuestionIdSet,questionIdwithSurveyInternalIdMap, null);
        
        } catch (SecurityUtility.ExtSFDCAccessControlException ex) {
            system.debug('in catch');
            surveyGrp = SurveyTranslator.objectToSurveyGroup(null, null, null, null, null, null, null, null, null,null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
           //DownloadLogStatusTranslator.trackDownloadLogStatus('Failure','Error:'+ex.getMessage()+'-2-'+ex.getTypeName()+'-3-'+ex.getLineNumber()+'-4-'+ex.getStackTraceString()+'Object Name : '+ ex.objectName,'RESTSurveyGroup',' getSurveyGroupInfo',String.valueOf(ex.getMessage()),'Download',getHeaders);
        } catch (Exception ex1) {
            system.debug('in catch2'+ex1.getLineNumber() + ex1.getStackTraceString());
           surveyGrp = SurveyTranslator.objectToSurveyGroup(null, null, null, null, null, null, null, null, null,null, CommonUtility.mobileAppErrorCodesMap.get('INTERNAL_SERVER_ERROR'));
           // DownloadLogStatusTranslator.trackDownloadLogStatus('Failure','Error:'+ex1.getMessage()+'-2-'+ex1.getTypeName()+'-3-'+ex1.getLineNumber()+'-4-'+ex1.getStackTraceString(),'RESTSurveyGroup','getSurveyGroupInfo',null,'Download',getHeaders); 
        }
        return surveyGrp;
    } 
    
    
}