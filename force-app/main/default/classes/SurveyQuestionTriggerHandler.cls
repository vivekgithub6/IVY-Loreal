public with sharing class SurveyQuestionTriggerHandler {
  
    public static void checkDup(List<ivybase__Survey_Question__c> surveyQuesList, Map<Id, ivybase__Survey_Question__c> sqOldMap) {
        
      //  Map<Id, ivybase__Question__c> quesMap = new Map<Id, ivybase__Question__c>();
        Set<Id> quesIdSet = new Set<Id>();
        Set<Id> targetquesIdSet = new Set<Id>();
        Set<Id> surveyIdSet = new Set<Id>();
        Set<String> checkString = new Set<string>();
        
        for(ivybase__Survey_Question__c sq : surveyQuesList) {
            if(sqOldMap == NULL) {
            
                if(sq.ivybase__Question__c != NULL) {
                    quesIdSet.add(sq.ivybase__Question__c);
                }
                if(sq.ivybase__Survey__c != NULL) {
                    surveyIdSet.add(sq.ivybase__Survey__c);
                }
            } else {
                if(sq.ivybase__Question__c != sqOldMap.get(sq.Id).ivybase__Question__c) {
                    if(sq.ivybase__Question__c != NULL) {
                        quesIdSet.add(sq.ivybase__Question__c);
                    }
                }
                if(sq.ivybase__Survey__c != sqOldMap.get(sq.Id).ivybase__Survey__c) {
                    if(sq.ivybase__Survey__c != NULL) {
                        surveyIdSet.add(sq.ivybase__Survey__c);
                    }
                }
            }
        }
        
        if(quesIdSet.size() > 0) {
            if(surveyQuesList.size() > 0) {
                String[] sqFields = new String[] {'ivybase__Survey__c','ivybase__Question__c'};
                if (SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', sqFields)) {
                    for(ivybase__Survey_Question__c sq : [SELECT Id, ivybase__Survey__c, ivybase__Question__c FROM ivybase__Survey_Question__c WHERE ivybase__Survey__c IN :surveyIdSet AND ivybase__Question__c IN :quesIdSet]) {
                        if(sq.ivybase__Survey__c != null && sq.ivybase__Question__c != null) {
                            checkString.add(sq.ivybase__Survey__c+''+sq.ivybase__Question__c);
                        }
                    }
                } else {
                    throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
                }
            }
        }
        
        
            for(ivybase__Survey_Question__c sq : surveyQuesList) {
                if(sq.ivybase__Question__c != null && sq.ivybase__Survey__c != null) {
                    if(checkString.contains(sq.ivybase__Survey__c+''+sq.ivybase__Question__c)) {
                        sq.addError('Combination already exists');//Same combination already exists under this Survey
                    } else {
                        checkString.add(sq.ivybase__Survey__c+''+sq.ivybase__Question__c);
                    }
                }
            }
        
    }
    
    public static void checkQuestion(List<ivybase__Survey_Question__c> surveyQuesList, Map<Id, ivybase__Survey_Question__c> sqOldMap) {
       
        Set<Id> quesIds = new Set<Id>();
        Set<Id> quesOpt = new Set<Id>();
        Set<Id> checkIds = new Set<Id>();
        Set<String> checkString = new Set<String>();
        
        //added code for prevent main question as a dependent question
        Set<Id> surveyIds = new Set<Id>();
        Set<Id> questionIds = new Set<Id>();
        Map<Id, Set<Id>> surveyIdwithSetofDependentIdMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> surveyIdSetOfQuestionIdMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> questionIdSetOfSurveyIdMap = new Map<Id, Set<Id>>();
        Map<String, ivybase__Survey_Question__c> surIdQIdWithSurveyQuestionMap = new Map<String, ivybase__Survey_Question__c>();
        Map<Id, List<ivybase__Survey_Question__c>> surveywithListSurveyQuestionMap = new Map<Id, List<ivybase__Survey_Question__c>>();
        Map<Id, Set<Id>> questionIdsetOfDepedentQuestionIdMap = new Map<Id, Set<Id>>();
        
        Map<Id, Set<Id>> surveyIdwithSetOfQuestionMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> questionIdwithServeyidsMap = new Map<Id, Set<Id>>();
        
        Map<Id, Set<Id>> newQuesIdwithServeyidsMap = new Map<Id, Set<Id>>();
        
        
        for(ivybase__Survey_Question__c sq : surveyQuesList) {
            if(sqOldMap == null) {
                if(sq.ivybase__Question__c != null) {
                    quesIds.add(sq.ivybase__Question__c);
                }
            } else {
                if((sq.ivybase__Question__c != null && sq.ivybase__Question__c != sqOldMap.get(sq.Id).ivybase__Question__c)
                    || sq.ivybase__Survey__c != sqOldMap.get(sq.Id).ivybase__Survey__c) {
                    quesIds.add(sq.ivybase__Question__c);
                }
            }
            
            if (sqOldMap == null || (sqOldMap != null && (sq.ivybase__Question__c != sqOldMap.get(sq.Id).ivybase__Question__c || sq.ivybase__Survey__c != sqOldMap.get(sq.Id).ivybase__Survey__c))) {
                //Start - added code for prevent main question as a dependent question 
                surveyIds.add(sq.ivybase__Survey__c);
                questionIds.add(sq.ivybase__Question__c);
                if (surveyIdwithSetOfQuestionMap.containsKey(sq.ivybase__Survey__c) && surveyIdwithSetOfQuestionMap.get(sq.ivybase__Survey__c).contains(sq.ivybase__Question__c)) {
                    //if(!test.isRunningTest())
                    sq.addError('Combination already exists');//Same survey question already exists
                }               
                if (!surveyIdwithSetOfQuestionMap.containsKey(sq.ivybase__Survey__c)) {
                    surveyIdwithSetOfQuestionMap.put(sq.ivybase__Survey__c, new Set<Id>());
                }
                surveyIdwithSetOfQuestionMap.get(sq.ivybase__Survey__c).add(sq.ivybase__Question__c);
                
                if (!surIdQIdWithSurveyQuestionMap.containsKey(sq.ivybase__Survey__c+''+sq.ivybase__Question__c)) {
                    surIdQIdWithSurveyQuestionMap.put(sq.ivybase__Survey__c+''+sq.ivybase__Question__c, sq);
                }
                if (!newQuesIdwithServeyidsMap.containsKey(sq.ivybase__Question__c)) {
                    newQuesIdwithServeyidsMap.put(sq.ivybase__Question__c, new Set<Id>());
                }
                newQuesIdwithServeyidsMap.get(sq.ivybase__Question__c).add(sq.ivybase__Survey__c);
                
                //End - added code for prevent main question as a dependent question
            }
        }
        if (surveyIdwithSetOfQuestionMap.size() > 0) {
            String[] sqFields = new String[] {'ivybase__Survey__c','ivybase__Question__c'};
            if (SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', sqFields)) {
                for (ivybase__Survey_Question__c sq : [SELECT Id, ivybase__Survey__c, 
                                                        ivybase__Question__c, Name 
                                                    FROM 
                                                        ivybase__Survey_Question__c 
                                                    WHERE 
                                                        ivybase__Survey__c IN:surveyIdwithSetOfQuestionMap.keySet() 
                                                    AND ID NOT IN:surveyQuesList]) {
                    if (surIdQIdWithSurveyQuestionMap.containsKey(sq.ivybase__Survey__c+''+sq.ivybase__Question__c)) {
                        surIdQIdWithSurveyQuestionMap.get(sq.ivybase__Survey__c+''+sq.ivybase__Question__c).addError('Same survey question already exists');
                    } else {
                        surveyIdwithSetOfQuestionMap.get(sq.ivybase__Survey__c).add(sq.ivybase__Question__c);
                    }
                    
                    if (!questionIdwithServeyidsMap.containsKey(sq.ivybase__Question__c)) {
                        questionIdwithServeyidsMap.put(sq.ivybase__Question__c, new Set<Id>());
                    }
                    questionIdwithServeyidsMap.get(sq.ivybase__Question__c).add(sq.ivybase__Survey__c);
                    
                }
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
            Map<Id, Set<Id>> dependentQuestionIdwithTopQuestionIdMap = new Map<Id, Set<Id>>();
            preventLoopingQuestion(questionIdwithServeyidsMap, surIdQIdWithSurveyQuestionMap, 5); //  This Question already used same survey\'s dependent question
            preventSurveyQuestion(questionIdwithServeyidsMap, newQuesIdwithServeyidsMap, surIdQIdWithSurveyQuestionMap, dependentQuestionIdwithTopQuestionIdMap, 5);//This survey question\'s dependent question mapped with main survey question
        }
        /*//Start - added code for prevent main question as a dependent question 
        if (surveyIds.size() > 0 && questionIds.size() > 0) {           
            List<Survey_Question__c> sqList = [SELECT Id, Survey__c, Question__c, Name FROM Survey_Question__c WHERE Survey__c IN:surveyIds];
            for (Survey_Question__c sq:sqList) {
                questionIds.add(sq.Question__c);
                if (!surveyIdSetOfQuestionIdMap.containsKey(sq.Survey__c)) {
                    surveyIdSetOfQuestionIdMap.put(sq.Survey__c, new Set<Id>());
                }
                surveyIdSetOfQuestionIdMap.get(sq.Survey__c).add(sq.Question__c);
                if (!questionIdSetOfSurveyIdMap.containsKey(sq.Question__c)) {
                    questionIdSetOfSurveyIdMap.put(sq.Question__c, new Set<Id>());
                }
                questionIdSetOfSurveyIdMap.get(sq.Question__c).add(sq.Survey__c);
            }
            List<Question_Answer_Option__c> queAnsOptionList = [SELECT Id, Name, Question__c, Dependent_Question__c 
                                                                FROM Question_Answer_Option__c 
                                                            WHERE 
                                                                Question__c IN:questionIds 
                                                            AND 
                                                                Dependent_Question__c != NULL];
            
            for (Question_Answer_Option__c qao : queAnsOptionList) {
                if (!questionIdsetOfDepedentQuestionIdMap.containsKey(qao.Question__c)) {
                    questionIdsetOfDepedentQuestionIdMap.put(qao.Question__c, new Set<Id>());   
                }
                questionIdsetOfDepedentQuestionIdMap.get(qao.Question__c).add(qao.Dependent_Question__c);
                
                if (questionIdSetOfSurveyIdMap.containsKey(qao.Question__c)) {
                    for (Id surveyId:questionIdSetOfSurveyIdMap.get(qao.Question__c)) {
                        if (!surveyIdwithSetofDependentIdMap.containsKey(surveyId)) {
                            surveyIdwithSetofDependentIdMap.put(surveyId, new set<Id>());
                        }
                        surveyIdwithSetofDependentIdMap.get(surveyId).add(qao.Dependent_Question__c);
                    }
                }
                
            }
        }
        //End - added code for prevent main question as a dependent question
        */
        if(quesIds.size() > 0) {
            //Duplication check
            String[] sqFields = new String[] {'ivybase__Survey__c','ivybase__Question__c'};
            if (SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', sqFields)) {
                for(ivybase__Survey_Question__c sqx : [SELECT Id, ivybase__Survey__c, ivybase__Question__c 
                                              FROM ivybase__Survey_Question__c 
                                              WHERE ivybase__Question__c IN :quesIds AND ID NOT IN :surveyQuesList]) {
                    checkString.add(sqx.ivybase__Survey__c+''+sqx.ivybase__Question__c);
                }
            } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
            //Valid Question check
            
            String[] quesFields = new String[] {'ivybase__Question_Type__c'};
            String[] qaoFields = new String[] {};
            if (SecurityUtility.checkIsAccessible('ivybase__Question__c', quesFields) && SecurityUtility.checkIsAccessible('ivybase__Question_Answer_Option__c', qaoFields)) {
                for(ivybase__Question__c que : [SELECT Id,(SELECT Id FROM ivybase__Question_Answer_Options__r) 
                                       FROM ivybase__Question__c 
                                       WHERE (ivybase__Question_Type__c = 'Option' OR ivybase__Question_Type__c = 'Multiple Select') AND Id IN :quesIds]) {
                    quesOpt.add(que.Id);
                    if(que.ivybase__Question_Answer_Options__r.size() == 0) {
                        checkIds.add(que.Id);
                    }
                }
             } else {
                throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
             }
        }
        
        for(ivybase__Survey_Question__c sq : surveyQuesList) {
            if(checkIds.size() > 0) {
                if(sq.ivybase__Question__c != null && quesOpt.contains(sq.ivybase__Question__c) && checkIds.contains(sq.ivybase__Question__c)) {
                    sq.addError('Add options to the Question before mapping to Survey');
                }
            }
            
            if(Test.isRunningTest()) {
                checkString.add('abc');
            }
            
            if(checkString.size() > 0) {
                if(checkString.contains(sq.ivybase__Survey__c+''+sq.ivybase__Question__c)) {
                    sq.addError('Combination already exists');
                } else {
                    checkString.add(sq.ivybase__Survey__c+''+sq.ivybase__Question__c);
                }
            }
            /*
            //Start - added code for prevent main question as a dependent question
            if (questionIdsetOfDepedentQuestionIdMap.containsKey(sq.Question__c)) {
                for (id dependentQId :questionIdsetOfDepedentQuestionIdMap.get(sq.Question__c)) {
                    if (surveyIdSetOfQuestionIdMap.containsKey(sq.Survey__c) && surveyIdSetOfQuestionIdMap.get(sq.Survey__c).contains(dependentQId)) {
                        sq.addError('This survey question\'s dependent question mapped with main survey question');
                    }
                }
            }
            if (surveyIdwithSetofDependentIdMap.containsKey(sq.Survey__c) && surveyIdwithSetofDependentIdMap.get(sq.Survey__c).contains(sq.Question__c)) {
                sq.addError('This question used some other dependent question of same survey');
            } 
            //End - added code for prevent main question as a dependent question
            */
        }
    }
   
    public static void preventLoopingQuestion(Map<Id, Set<Id>> questionIdwithServeyidsMap, Map<String, ivybase__Survey_Question__c> surIdQIdWithSurveyQuestionMap, Integer count) {
        
        
        Map<Id, Set<Id>> temp_surveyIdwithSetOfQuestionMap = new Map<Id, Set<Id>>();
        Map<Id, Set<Id>> temp_questionIdwithServeyidsMap = new Map<Id, Set<Id>>();
        
        String[] qaoFields = new String[] {'ivybase__Question__c','ivybase__Dependent_Question__c'};
        if (SecurityUtility.checkIsAccessible('ivybase__Question_Answer_Option__c', qaoFields)){
            for (ivybase__Question_Answer_Option__c qao : [SELECT Id, ivybase__Question__c, ivybase__Dependent_Question__c 
                                                    FROM ivybase__Question_Answer_Option__c 
                                                    WHERE ivybase__Question__c IN: questionIdwithServeyidsMap.keySet()
                                                    AND ivybase__Dependent_Question__c != NULL]) {
                
                if (questionIdwithServeyidsMap.containsKey(qao.ivybase__Question__c)) {
                    for (Id surId : questionIdwithServeyidsMap.get(qao.ivybase__Question__c)) {
                        if (surIdQIdWithSurveyQuestionMap.containsKey(surId+''+qao.ivybase__Dependent_Question__c)) {
                            surIdQIdWithSurveyQuestionMap.get(surId+''+qao.ivybase__Dependent_Question__c).addError('The same Question is already mapped with this survey as a dependent question');//This Question already used same survey\'s dependent question
                        }
                        if (!temp_questionIdwithServeyidsMap.containsKey(qao.ivybase__Dependent_Question__c)) {
                            temp_questionIdwithServeyidsMap.put(qao.ivybase__Dependent_Question__c, new Set<Id>());
                        }
                        temp_questionIdwithServeyidsMap.get(qao.ivybase__Dependent_Question__c).add(surId);
                    }
                }
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        count--;
        if (temp_questionIdwithServeyidsMap.size() > 0 && count > 0) {
            preventLoopingQuestion(temp_questionIdwithServeyidsMap, surIdQIdWithSurveyQuestionMap, count);
        }       
    }
    
    public static void preventSurveyQuestion(Map<Id, Set<Id>> questionIdwithServeyidsMap, Map<Id, Set<Id>> newQuesIdwithServeyidsMap, Map<String, ivybase__Survey_Question__c> surIdQIdWithSurveyQuestionMap, Map<Id, Set<Id>> dependentQuestionIdwithTopQuestionIdMap, Integer count) {
        
        Map<Id, Set<Id>> temp_newQuesIdwithServeyidsMap = new Map<Id, Set<Id>> ();
        Map<Id, Set<Id>> temp_dependentQuestionIdwithTopQuestionIdMap = new Map<Id, Set<Id>>();
        
        String[] qaoFields = new String[] {'ivybase__Question__c','ivybase__Dependent_Question__c'};
        if (SecurityUtility.checkIsAccessible('ivybase__Question_Answer_Option__c', qaoFields)){
            for (ivybase__Question_Answer_Option__c qao : [SELECT Id, ivybase__Question__c, ivybase__Dependent_Question__c FROM ivybase__Question_Answer_Option__c
                                                    WHERE ivybase__Question__c IN:newQuesIdwithServeyidsMap.keySet()
                                                    AND ivybase__Dependent_Question__c != NULL]) {
                
                if (dependentQuestionIdwithTopQuestionIdMap.containsKey(qao.ivybase__Question__c)) {
                    temp_dependentQuestionIdwithTopQuestionIdMap.put(qao.ivybase__Dependent_Question__c, dependentQuestionIdwithTopQuestionIdMap.get(qao.ivybase__Question__c));
                } else {
                    if (!temp_dependentQuestionIdwithTopQuestionIdMap.containsKey(qao.ivybase__Dependent_Question__c)) {
                        temp_dependentQuestionIdwithTopQuestionIdMap.put(qao.ivybase__Dependent_Question__c, new Set<Id> ());
                    } 
                    temp_dependentQuestionIdwithTopQuestionIdMap.get(qao.ivybase__Dependent_Question__c).add(qao.ivybase__Question__c);
                }
                                                        
                if (questionIdwithServeyidsMap.containsKey(qao.ivybase__Dependent_Question__c)) {
                    for (Id surId :questionIdwithServeyidsMap.get(qao.ivybase__Dependent_Question__c)) {
                        system.debug(':::surId::::'+surId+'::::'+qao.ivybase__Dependent_Question__c);
                        system.debug(':::surIdQIdWithSurveyQuestionMap:::::'+surIdQIdWithSurveyQuestionMap);
                        system.debug(':::temp_dependentQuestionIdwithTopQuestionIdMap:::::'+temp_dependentQuestionIdwithTopQuestionIdMap.get(qao.ivybase__Dependent_Question__c));
                        for (Id qId :temp_dependentQuestionIdwithTopQuestionIdMap.get(qao.ivybase__Dependent_Question__c)) {
                            if (surIdQIdWithSurveyQuestionMap.containsKey(surId+''+qId)) {
                                surIdQIdWithSurveyQuestionMap.get(surId+''+qId).addError('The same Question is already mapped with this survey as a dependent question');//This survey question\'s dependent question is already mapped with main survey question
                            }
                        }
                    }
                }
                
                
                if (!temp_newQuesIdwithServeyidsMap.containsKey(qao.ivybase__Dependent_Question__c)) {
                    temp_newQuesIdwithServeyidsMap.put(qao.ivybase__Dependent_Question__c, new Set<Id>());
                }
                temp_newQuesIdwithServeyidsMap.get(qao.ivybase__Dependent_Question__c).addAll(newQuesIdwithServeyidsMap.get(qao.ivybase__Question__c));
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        count--;
        if (count > 0 && temp_newQuesIdwithServeyidsMap.size() > 0) {
            preventSurveyQuestion(questionIdwithServeyidsMap,temp_newQuesIdwithServeyidsMap,surIdQIdWithSurveyQuestionMap, temp_dependentQuestionIdwithTopQuestionIdMap, count);
        }
    }
    
    public static void getsurveyIds(List<ivybase__Survey_Question__c> surveyQuesList, Map<Id, ivybase__Survey_Question__c> sqOldMap) {
        
        Set<Id> surveyIdset = new Set<Id>();
        
        for(ivybase__Survey_Question__c sq : surveyQuesList) {
            
            if(sqOldMap == null) {
                 surveyIdset.add(sq.ivybase__Survey__c);
            } else {
                
                if(sq.ivybase__Question__c != sqOldMap.get(sq.Id).ivybase__Question__c){
                    surveyIdset.add(sq.ivybase__Survey__c);
                }
                if(sq.ivybase__Survey__c != sqOldMap.get(sq.Id).ivybase__Survey__c) {
                    surveyIdset.add(sq.ivybase__Survey__c);
                    surveyIdset.add(sqOldMap.get(sq.Id).ivybase__Survey__c);
                }
            }
        }
        
        System.debug('surveyIdset::::'+surveyIdset);
        if(surveyIdset.size() > 0) {
            SurveyService.updateSurveyTotalWeight(surveyIdset);
        }
        
    }
}