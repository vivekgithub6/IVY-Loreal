global with sharing class SurveyTranslator {
    global static RExAPIResponseDomain.MultipleResponseInfo objectToSurveyGroup(List<ivybase__Survey_Mapping__c> surveyList,List<ivybase__Survey_Question__c> surveyQuestionList,List<ivybase__Survey_Mapping__c> surveyCriteriaMapping , List<ivybase__Question__c> questionList,List<ivybase__Question_Answer_Option__c> questionAnsOptionList,List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList,Map<String, String> listCodeListId,Map<Id, String> questionIdwithSurveyHhtMenuMap,Set<Id> optionsQuestionIdSet,Map<Id, Set<String>> questionIdwithSurveyInternalIdMap,String errorCode) {
        System.debug(':::surveyCriteriaMapping:::'+surveyCriteriaMapping);
        System.debug(':::surveyList:::'+surveyList);
        RExAPIResponseDomain.MultipleResponseInfo surGrp = new RExAPIResponseDomain.MultipleResponseInfo();
        List<RExAPIResponseDomain.ResponseInfo> surveyTables = new List<RExAPIResponseDomain.ResponseInfo>();

        // Survey Details
        RExAPIResponseDomain.ResponseInfo surveyTable = new RExAPIResponseDomain.ResponseInfo();
        surveyTable.Master = 'SurveyMaster'; 
        surveyTable.Field = new List<String> {'SurveyId','SurveyDesc','StartDate','EndDate','MenuCode','Sequence','BonusPoint'}; 
        surveyTable.Data = (surveyList != null && listCodeListId != null && errorCode == null) ? surveyRecords(surveyList) : new List<List<String>>();

        surveyTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyTable.Next = '0';
        surveyTables.add(surveyTable);

        // Survey Mapping Details
        RExAPIResponseDomain.ResponseInfo surveyMappingTable = new RExAPIResponseDomain.ResponseInfo();
        surveyMappingTable.Master = 'SurveyMapping'; 
        surveyMappingTable.Field = new List<String> {'RetailerId','SurveyId','QId','Weight','GroupName','Sequence','isScore'}; 
        surveyMappingTable.Data = (surveyQuestionList != null && errorCode == null) ? surveyQuestions(surveyQuestionList,dependentQuestionAnsOptionList, optionsQuestionIdSet) : new List<List<String>>();

        surveyMappingTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyMappingTable.Next = '0';
        surveyTables.add(surveyMappingTable);

        // Survey Criteria Mapping Details
        RExAPIResponseDomain.ResponseInfo surveyCriteriaMappingTable = new RExAPIResponseDomain.ResponseInfo();
        surveyCriteriaMappingTable.Master = 'SurveyCriteriaMapping'; 
        surveyCriteriaMappingTable.Field = new List<String> {'RetailerId','SurveyId','ChannelId','ClassId','LocId','CriteriaType','CriteriaID','GroupId','DivisionId'}; 
        surveyCriteriaMappingTable.Data = (surveyCriteriaMapping != null && errorCode == null) ? surveyCriteria(surveyCriteriaMapping, listCodeListId) : new List<List<String>>(); //Need to map data

        surveyCriteriaMappingTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyCriteriaMappingTable.Next = '0';
        surveyTables.add(surveyCriteriaMappingTable);

        // Question Details
        RExAPIResponseDomain.ResponseInfo questionTable = new RExAPIResponseDomain.ResponseInfo();
        questionTable.Master = 'QuestionMaster'; 
        questionTable.Field = new List<String> {'QId','QText','QType','BrandID','Module','IsMand','IsPhotoReq','minPhoto','maxPhoto','IsBonus'}; 
        questionTable.Data = (questionList != null && errorCode == null) ? questions(questionList,listCodeListId, questionIdwithSurveyHhtMenuMap, dependentQuestionAnsOptionList,optionsQuestionIdSet) : new List<List<String>>();

        questionTable.ErrorCode = errorCode == null ? '0' : errorCode;
        questionTable.Next = '0';
        surveyTables.add(questionTable);

        // Question answer option Details
        RExAPIResponseDomain.ResponseInfo questionAnswerOptionTable = new RExAPIResponseDomain.ResponseInfo();
        questionAnswerOptionTable.Master = 'OptionMaster'; 
        questionAnswerOptionTable.Field = new List<String> {'QId','OptionId','OptionText'}; 
        questionAnswerOptionTable.Data = (questionAnsOptionList != null && errorCode == null) ? questionsAnswerOption(questionAnsOptionList) : new List<List<String>>();

        questionAnswerOptionTable.ErrorCode = errorCode == null ? '0' : errorCode;
        questionAnswerOptionTable.Next = '0';
        surveyTables.add(questionAnswerOptionTable);


        // Dependent Question Details
        RExAPIResponseDomain.ResponseInfo dependentQuestionTable = new RExAPIResponseDomain.ResponseInfo();
        dependentQuestionTable.Master = 'OptionDQM'; 
        dependentQuestionTable.Field = new List<String> {'OptionId','DQId'}; 
        dependentQuestionTable.Data = (dependentQuestionAnsOptionList != null && errorCode == null) ? dependentQuestions(dependentQuestionAnsOptionList) : new List<List<String>>();

        dependentQuestionTable.ErrorCode = errorCode == null ? '0' : errorCode;
        dependentQuestionTable.Next = '0';
        surveyTables.add(dependentQuestionTable);

        //OptionScoreMapping details
        RExAPIResponseDomain.ResponseInfo optScrMapping = new RExAPIResponseDomain.ResponseInfo();
        optScrMapping.Master = 'OptionScoreMapping'; 
        optScrMapping.Field = new List<String> {'OptionId', 'score', 'SurveyId', 'IsExcluded'}; 
        optScrMapping.Data = (questionAnsOptionList != null && errorCode == null) ? getOptionScoreMapping(questionAnsOptionList,questionIdwithSurveyInternalIdMap) : new List<List<String>>();

        optScrMapping.ErrorCode = errorCode == null ? '0' : errorCode;
        optScrMapping.Next = '0';
        surveyTables.add(optScrMapping);

        surGrp.Tables = surveyTables;
        return surGrp;
    }

    global static List<List<String>> surveyRecords(List<ivybase__Survey_Mapping__c> surveyList) {
        system.debug('surveyList'+surveyList);
        List<List<String>> surveyRecList = new List<List<String>>();
        Set<Id> surveyIdSet = new Set<Id>();
        Map<String,String> surhhtmenuMap = new Map<String,String>();
        system.debug('HHTService.getSurveyHHTMenu()'+HHTService.getSurveyHHTMenu());
        /*for(ivybase__HHT_Menu_Master__mdt hhtmenu : HHTService.getSurveyHHTMenu()){
            surhhtmenuMap.put(hhtmenu.label,hhtmenu.DeveloperName);
        }*/
        
        /* To get HHT Menu records */
        for(ivybase__HHTMenu_Master__c hhtMenu : HHTService.getHHTMenuMethods() ){
            surhhtmenuMap.put(hhtmenu.Name,hhtmenu.Name);
            
        }
        
        
        system.debug('surhhtmenuMap'+surhhtmenuMap);
        if (surveyList != null && surveyList.size() > 0) {
            //List<List<String>> surveyRecList = new List<List<String>>();
            for (ivybase__Survey_Mapping__c sv :surveyList) {
                if (!surveyIdSet.contains(sv.ivybase__Survey__c)) {
                    List<String> surveyRec = new List<String>();
                    surveyRec.add(sv.ivybase__Survey__r.ivybase__Internal_Id__c);
                    surveyRec.add(sv.ivybase__Survey__r.Name);
                    if (sv.ivybase__Survey__r.ivybase__From__c != null) {
                        surveyRec.add(sv.ivybase__Survey__r.ivybase__From__c.Year()+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__From__c.month())+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__From__c.day()));
                    } else {
                        surveyRec.add('');
                    }
                    if (sv.ivybase__Survey__r.ivybase__To__c != null) {
                        surveyRec.add(sv.ivybase__Survey__r.ivybase__To__c.Year()+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__To__c.month())+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__To__c.day()));
                    } else {
                        surveyRec.add('');
                    }
                    
                    system.debug('surhhtmenuMap.containsKey(sv.ivybase__Survey__r.ivybase__HHT_Menu__c)'+ surhhtmenuMap.containsKey(sv.ivybase__Survey__r.ivybase__HHT_Menu__c));
                    if (sv.ivybase__Survey__r.ivybase__HHT_Menu__c != null && surhhtmenuMap.containsKey(sv.ivybase__Survey__r.ivybase__HHT_Menu__c)) {
                        system.debug('hhtmenu-Menu code'+sv.ivybase__Survey__r.ivybase__HHT_Menu__c);
                        surveyRec.add(surhhtmenuMap.get(sv.ivybase__Survey__r.ivybase__HHT_Menu__c));
                    }else{
                        surveyRec.add('');
                    }
                    //surveyRec.add(sv.ivybase__Survey__r.ivybase__HHT_Menu__c);
                    if (sv.ivybase__Survey__r.ivybase__Sequence_Number__c != null) {
                        surveyRec.add(''+sv.ivybase__Survey__r.ivybase__Sequence_Number__c);
                    } else {
                        surveyRec.add('');
                    }
                    if (sv.ivybase__Survey__r.ivybase__Maximum_Bonus_Points__c != null) {
                        surveyRec.add(''+sv.ivybase__Survey__r.ivybase__Maximum_Bonus_Points__c);
                    } else {
                        surveyRec.add('');
                    }
                    /*if (sv.ivybase__Survey__r.ivybase__Frequency_Type__c != null) {
                        surveyRec.add(''+sv.ivybase__Survey__r.ivybase__Frequency_Type__c);
                    } else {
                        surveyRec.add('');
                    }*/
                    surveyRecList.add(surveyRec);
                    surveyIdSet.add(sv.ivybase__Survey__c);
                }
            }
            return surveyRecList ;
        } else {
            return surveyRecList ;
        }

    }

    global static List<List<String>> surveyQuestions(List<ivybase__Survey_Question__c> surveyQuestionList, List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList, Set<Id> optionsQuestionIdSet) {

        List<List<String>> surveyRecList = new List<List<String>>();
        Set<String> surveyQuestionIdSet = new Set<String>();
        Map<String, List<String>> questionInternalIdwithListOfSurveyIdsMap = new Map<String, List<String>>();

        if (surveyQuestionList != null && surveyQuestionList.size() > 0) {
            for (ivybase__Survey_Question__c sq :surveyQuestionList) {
                List<String> surveyRec = new List<String>();
                surveyRec.add('0'); //RetailerId
                surveyRec.add(sq.ivybase__Survey__r.ivybase__Internal_Id__c); //SurveyId
                if (sq.ivybase__Question__c != null) {
                    surveyRec.add(sq.ivybase__Question__r.ivybase__Question_Id__c);//QId
                } 
                if (sq.Score_Weight__c != null) {
                    surveyRec.add(sq.Score_Weight__c+'');//Weight
                } else {
                    surveyRec.add('');
                }
                if (sq.ivybase__Question_Group__c != null) {
                    surveyRec.add(sq.ivybase__Question_Group__r.Name);//GroupName
                } else {
                    surveyRec.add('');
                }
                if (sq.ivybase__Sequence_Number__c != null) {
                    surveyRec.add(sq.ivybase__Sequence_Number__c+''); //Sequence
                } else {
                    surveyRec.add('');
                }
                if(sq.ivybase__IsScore__c == true) {
                    surveyRec.add('1'); //isScore
                } else {
                    surveyRec.add('0');
                }

                /*if (sq.Survey__c != null && sq.Question__c != null && sq.Survey__r.Internal_Id__c != null && sq.Question__r.Question_Id__c != null) {
surveyQuestionIdSet.add(sq.Survey__r.Internal_Id__c +'~'+sq.Question__r.Question_Id__c);
if (!questionInternalIdwithListOfSurveyIdsMap.containskey(sq.Question__r.Question_Id__c)) {
questionInternalIdwithListOfSurveyIdsMap.put(sq.Question__r.Question_Id__c, new List<String>());
}
questionInternalIdwithListOfSurveyIdsMap.get(sq.Question__r.Question_Id__c).add(sq.Survey__r.Internal_Id__c);
}*/
                surveyRecList.add(surveyRec);
            }
        }
        /*for (Question_Answer_Option__c qao : dependentQuestionAnsOptionList) {
if (qao.Question__c != null && qao.Question__r.Question_Id__c != null && questionInternalIdwithListOfSurveyIdsMap != null 
&& questionInternalIdwithListOfSurveyIdsMap.containsKey(qao.Question__r.Question_Id__c)) {

for (String surInternalid :questionInternalIdwithListOfSurveyIdsMap.get(qao.Question__r.Question_Id__c))  {
if (!surveyQuestionIdSet.contains(surInternalid +'~'+qao.Dependent_Question__r.Question_Id__c)) {
List<String> surveyRec = new List<String>();
surveyRec.add(''); //RetailerId
surveyRec.add(surInternalid); //SurveyId
surveyRec.add(qao.Dependent_Question__r.Question_Id__c);//QId

surveyRec.add('');//Weight
surveyRec.add('');//GroupName
surveyRec.add('');//Sequence
surveyRec.add('');//isScore
surveyRecList.add(surveyRec);
}
}                  
}  
}*/   

        return surveyRecList;

    }

    global static List<List<String>> surveyCriteria(List<ivybase__Survey_Mapping__c> surveyMappingRecs, Map<String, String> listCodeListId) {
        system.debug('listCodeListId'+listCodeListId);
        List<List<String>> surveyCriteriaList = new List<List<String>>();
        if (surveyMappingRecs != null && surveyMappingRecs.size() > 0) {
            /*"RetailerId",
"SurveyId",
"ChannelId",
"ClassId",
"LocId"*/

            for (ivybase__Survey_Mapping__c sm :surveyMappingRecs) {

                List<String> surveyMap = new List<String>();
                if (sm.ivybase__Store__c != null && sm.ivybase__Store__r.ivybase__Internal_Id__c != null ) {
                    surveyMap.add(String.valueOf(sm.ivybase__Store__r.ivybase__Internal_Id__c)); //RetailerId
                } else {
                    surveyMap.add('0');
                }
                if (sm.ivybase__Survey__c != null) {
                    surveyMap.add(sm.ivybase__Survey__r.ivybase__Internal_Id__c); //SurveyId
                } else {
                    surveyMap.add(''); //SurveyId
                }

                if (sm.ivybase__Store_Hierarchy__c != null) {
                    surveyMap.add(sm.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c); //ChannelId
                } else {
                    surveyMap.add('0'); //ChannelId
                }

                surveyMap.add(''); //ClassId

                if (sm.ivybase__Location_Hierarchy__c != null) {
                    surveyMap.add(sm.ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c); //LocId
                } else {
                    surveyMap.add('0'); //LocId
                } 
                //system.debug('criteria'+sm.Criteria_Type__c);
                if (sm.ivybase__Location_Hierarchy__c != null && sm.ivybase__Store_Hierarchy__c != null && listCodeListId.containsKey('CHANNEL_LOC')) {
                    surveyMap.add(listCodeListId.get('CHANNEL_LOC'));
                } else if (sm.ivybase__Location_Hierarchy__c != null && listCodeListId.containsKey('LOCATION')) {
                    surveyMap.add(listCodeListId.get('LOCATION'));
                } else if ( sm.ivybase__User__c != null 
                           && listCodeListId.containsKey('SALESMAN')) {
                    surveyMap.add(listCodeListId.get('SALESMAN'));
                } else if ( sm.ivybase__Store_Hierarchy__c != null 
                           && listCodeListId.containsKey('CHANNEL')) {
                    surveyMap.add(listCodeListId.get('CHANNEL'));
                } else if (  sm.ivybase__Store__c != null 
                           && listCodeListId.containsKey('RETAILER')) {
                    system.debug('inside retailer'+listCodeListId.get('RETAILER'));
                    surveyMap.add(listCodeListId.get('RETAILER'));
                }
                /* else if(sm.Criteria_Type__c!=null && sm.Criteria_Type__c=='SALON_ASSESMENTS'
&& listCodeListId.containskey('SALON_ASSESMENTS')){
surveyMap.add(listCodeListId.get('SALON_ASSESMENTS'));
}else if(sm.Criteria_Type__c!=null && sm.Criteria_Type__c=='MINI_COACHING'
&& listCodeListId.containskey('MINI_COACHING')){
surveyMap.add(listCodeListId.get('MINI_COACHING'));
}else if(sm.Criteria_Type__c!=null && sm.Criteria_Type__c=='JBP_BACK'
&& listCodeListId.containskey('JBP_BACK')){
surveyMap.add(listCodeListId.get('JBP_BACK'));
}*/
                else {
                    surveyMap.add('');                
                }

                if (sm.ivybase__Store__c != null && sm.ivybase__Store__r.ivybase__Internal_Id__c != null ) {
                    surveyMap.add(String.valueOf(sm.ivybase__Store__r.ivybase__Internal_Id__c)); //CriteriaId
                } else if (sm.ivybase__Store_Hierarchy__c != null) {
                    surveyMap.add(sm.ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c); //CriteriaId
                } else if (sm.ivybase__Location_Hierarchy__c != null) {
                    surveyMap.add(sm.ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c); //CriteriaId
                } else {
                    surveyMap.add('');                
                }

                surveyMap.add(sm.ivybase__Internal_Id__c); //GroupId
                //Division Id
                /*if(sm.Division__c != null && sm.Division__r.Name == 'Kerastase' && listCodeListId.containskey('KERA')){
                    surveyMap.add(listCodeListId.get('KERA'));
                } else if(sm.Division__c != null && sm.Division__r.Name == 'Loreal Professional' && listCodeListId.containskey('LP')){
                    surveyMap.add(listCodeListId.get('LP'));}
                else if(sm.Division__c != null && sm.Division__r.Name == 'Matrix' && listCodeListId.containskey('MX')){
                    surveyMap.add(listCodeListId.get('MX'));}
                else if(sm.Division__c != null && sm.Division__r.Name == 'Redken and Pureology' && listCodeListId.containskey('R & P')){
                    surveyMap.add(listCodeListId.get('R & P'));}

                if(sm.Division__c != null){
                    surveyMap.add(sm.Division__r.Internal_Id__c);
                }*/
                map<string,string> Divisionlovidmap=new map<string,string>();
                for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')})){
                    Divisionlovidmap.put(stdListMaster.ivybase__List_Name__c, stdListMaster.Name);
                }
                if(sm.Division__c != null){
                    surveyMap.add(Divisionlovidmap.get(sm.Division__r.name));
                }
                else {
                    surveyMap.add('');  
                }
                system.debug('surveyMap'+surveyMap);
                surveyCriteriaList.add(surveyMap);              
            }

            return surveyCriteriaList;

        } else {
            return surveyCriteriaList ;
        }
    }

    global static List<List<String>> questions(List<ivybase__Question__c> quesList, Map<String, String> listCodeListIdMap, Map<Id, String> questionIdwithSurveyHhtMenuMap, List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList, Set<Id> optionsQuestionIdSet ) {
        List<List<String>> questionList = new List<List<String>>();
        system.debug('listCodeListIdMap*****'+listCodeListIdMap);
        Set<Id> questionIdSet = new Set<Id>();System.debug('listCodeListIdMap:::::'+listCodeListIdMap.containskey('FREE_TEXT'));
        if (quesList != null && quesList.size() > 0) {            
            for (ivybase__Question__c qn :quesList) {
                if (qn.ivybase__Question_Type__c != 'Option' || (qn.ivybase__Question_Type__c == 'Option' && optionsQuestionIdSet != null && optionsQuestionIdSet.contains(qn.Id)) && !questionIdSet.contains(qn.Id)) {

                    List<String> question = new List<String>();
                    question.add(qn.ivybase__Question_Id__c);
                    if (qn.ivybase__Question__c != null) {
                        question.add(qn.ivybase__Question__c);
                    } else {
                        question.add('');
                    }
                    if (qn.ivybase__Question_Type__c != null && listCodeListIdMap != null && listCodeListIdMap.size() > 0) {
                        if (qn.ivybase__Question_Type__c == 'Option' && listCodeListIdMap.containskey('OPT')) {
                            question.add(listCodeListIdMap.get('OPT'));
                        } else if (qn.ivybase__Question_Type__c == 'Text' && listCodeListIdMap.containskey('TEXT')) {
                            question.add(listCodeListIdMap.get('TEXT'));
                        } else if (qn.ivybase__Question_Type__c == 'Numeric' && listCodeListIdMap.containskey('NUM')) {
                            question.add(listCodeListIdMap.get('NUM'));
                        } else if (qn.ivybase__Question_Type__c == 'Multiple Select' && listCodeListIdMap.containskey('MULTISELECT')) {
                            question.add(listCodeListIdMap.get('MULTISELECT'));
                        } else if (qn.ivybase__Question_Type__c == 'Store' && listCodeListIdMap.containskey('Store')) {
                            question.add(listCodeListIdMap.get('Store'));
                        }else if (qn.ivybase__Question_Type__c == 'User' && listCodeListIdMap.containskey('User')) {
                            question.add(listCodeListIdMap.get('User'));
                        }else {
                            question.add('');
                        }

                    } else {
                        question.add('');
                    }
                    if (qn.ivybase__Product_Hierarchy__c != null) {
                        question.add(''+qn.ivybase__Product_Hierarchy__r.ivybase__Internal_Id__c);
                    } else {
                        question.add('');
                    }

                    if (listCodeListIdMap != null && listCodeListIdMap.size() > 0 
                        && questionIdwithSurveyHhtMenuMap != null && questionIdwithSurveyHhtMenuMap.size() > 0
                        && questionIdwithSurveyHhtMenuMap.containskey(qn.Id)) {

                        String standorspecail = '';
                        if (questionIdwithSurveyHhtMenuMap.get(qn.Id) == 'Activity Menu' && listCodeListIdMap.containsKey('STANDARD')) {
                            question.add(listCodeListIdMap.get('STANDARD'));//module 
                        } else if ( questionIdwithSurveyHhtMenuMap.get(qn.Id) == 'Home Menu' && listCodeListIdMap.containsKey('SPECIAL')) {
                            question.add(listCodeListIdMap.get('SPECIAL'));
                        } else {
                            question.add('');//module
                        }

                    } else {
                        question.add('');//module
                    }
                    if (qn.ivybase__Is_Mandatory__c) {
                        question.add('1');// IsMand
                    } else {
                        question.add('0');//IsMand
                    }                
                    if (qn.ivybase__Is_Evidence_Required__c) {
                        question.add('1'); 
                    } else {
                        question.add('0');
                    }
                    if (qn.ivybase__Minimum_Number_of_Evidences__c != null) {
                        question.add(qn.ivybase__Minimum_Number_of_Evidences__c+''); 
                    } else {
                        question.add('');
                    }
                    if (qn.ivybase__Maximum_Number_of_Evidences__c!= null) {
                        question.add(qn.ivybase__Maximum_Number_of_Evidences__c+''); 
                    } else {
                        question.add('');
                    }
                    if (qn.ivybase__Is_Bonus_Question__c) {
                        question.add('1'); 
                    } else {
                        question.add('0');
                    }
                    questionList.add(question);
                    questionIdSet.add(qn.Id);
                }
            }

            for (ivybase__Question_Answer_Option__c qaop : dependentQuestionAnsOptionList) {
                if (qaop.ivybase__Dependent_Question__c != null && !questionIdSet.contains(qaop.ivybase__Dependent_Question__c)) {
                    List<String> question = new List<String>();
                    question.add(qaop.ivybase__Dependent_Question__r.ivybase__Question_Id__c);
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Question__c != null) {
                        question.add(qaop.ivybase__Dependent_Question__r.ivybase__Question__c);
                    } else {
                        question.add('');
                    }
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c != null && listCodeListIdMap != null && listCodeListIdMap.size() > 0) {
                        if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Option' && listCodeListIdMap.containskey('OPT')) {
                            question.add(listCodeListIdMap.get('OPT'));
                        } else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Text' && listCodeListIdMap.containskey('TEXT')) {
                            question.add(listCodeListIdMap.get('TEXT'));
                        } else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Numeric' && listCodeListIdMap.containskey('NUM')) {
                            question.add(listCodeListIdMap.get('NUM'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Date' && listCodeListIdMap.containskey('DATE')) {
                            question.add(listCodeListIdMap.get('DATE'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Multiple Select' && listCodeListIdMap.containskey('MULTISELECT')) {
                            question.add(listCodeListIdMap.get('MULTISELECT'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Email' && listCodeListIdMap.containskey('EMAIL')) {
                            question.add(listCodeListIdMap.get('EMAIL'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Store' && listCodeListIdMap.containskey('Store')) {
                            question.add(listCodeListIdMap.get('Store'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'User' && listCodeListIdMap.containskey('User')) {
                            question.add(listCodeListIdMap.get('User'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Poll' && listCodeListIdMap.containskey('POLL')) {
                            question.add(listCodeListIdMap.get('POLL'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Phone number' && listCodeListIdMap.containskey('PH_NO')) {
                            question.add(listCodeListIdMap.get('PH_NO'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Currency' && listCodeListIdMap.containskey('CURRENCY')) {
                            question.add(listCodeListIdMap.get('CURRENCY'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Free text' && listCodeListIdMap.containskey('FREE_TEXT')) {
                            question.add(listCodeListIdMap.get('FREE_TEXT'));
                        }else if (qaop.ivybase__Dependent_Question__r.ivybase__Question_Type__c == 'Email ID' && listCodeListIdMap.containskey('EMAIL')) {
                            question.add(listCodeListIdMap.get('EMAIL'));
                        }else {
                            question.add('');
                        }

                    } else {
                        question.add('');
                    }
                    question.add('');

                    if (listCodeListIdMap != null && listCodeListIdMap.size() > 0 
                        && questionIdwithSurveyHhtMenuMap != null && questionIdwithSurveyHhtMenuMap.size() > 0
                        && questionIdwithSurveyHhtMenuMap.containskey(qaop.ivybase__Question__c)) {

                        String standorspecail = '';
                        if (questionIdwithSurveyHhtMenuMap.get(qaop.ivybase__Question__c) == 'Activity Menu' && listCodeListIdMap.containsKey('STANDARD')) {
                            question.add(listCodeListIdMap.get('STANDARD'));//module 
                        } else if ( questionIdwithSurveyHhtMenuMap.get(qaop.ivybase__Question__c) == 'Home Menu' && listCodeListIdMap.containsKey('SPECIAL')) {
                            question.add(listCodeListIdMap.get('SPECIAL'));
                        } else {
                            question.add('');//module
                        }

                    } else {
                        question.add('');//module
                    }
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Is_Mandatory__c) {
                        question.add('1');// IsMand
                    } else {
                        question.add('0');//IsMand
                    }                
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Is_Evidence_Required__c) {
                        question.add('1'); 
                    } else {
                        question.add('0');
                    }
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Minimum_Number_of_Evidences__c != null) {
                        question.add(qaop.ivybase__Dependent_Question__r.ivybase__Minimum_Number_of_Evidences__c+''); 
                    } else {
                        question.add('');
                    }
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Maximum_Number_of_Evidences__c!= null) {
                        question.add(qaop.ivybase__Dependent_Question__r.ivybase__Maximum_Number_of_Evidences__c+''); 
                    } else {
                        question.add('');
                    }
                    if (qaop.ivybase__Dependent_Question__r.ivybase__Is_Bonus_Question__c) {
                        question.add('1'); 
                    } else {
                        question.add('0');
                    }
                    questionList.add(question);
                    questionIdSet.add(qaop.ivybase__Dependent_Question__c);
                }
            }
            return questionList;
        } else {
            return questionList;
        }
    }

    global static List<List<String>> questionsAnswerOption(List<ivybase__Question_Answer_Option__c> questionAnsOptionList) {

        List<List<String>> questionAnswerOptionList = new List<List<String>>();
        Set<String> questionNumOptionNumSet = new Set<String>();
        if (questionAnsOptionList!= null && questionAnsOptionList.size() > 0) {
            for (ivybase__Question_Answer_Option__c qnAnsOp :questionAnsOptionList) {
                if (!questionNumOptionNumSet.contains(qnAnsOp.ivybase__Question__r.ivybase__Question_Id__c+''+qnAnsOp.ivybase__Option_Id__c)) {
                    List<String> questionAnsOp = new List<String>();
                    questionAnsOp.add(qnAnsOp.ivybase__Question__r.ivybase__Question_Id__c);
                    questionAnsOp.add(qnAnsOp.ivybase__Option_Id__c);
                    if (qnAnsOp.ivybase__Answer_Option__c != null) {
                        questionAnsOp.add(qnAnsOp.ivybase__Answer_Option__r.Name); 
                    } else {
                        questionAnsOp.add('');
                    }
                    questionAnswerOptionList.add(questionAnsOp);
                    questionNumOptionNumSet.add(qnAnsOp.ivybase__Question__r.ivybase__Question_Id__c+''+qnAnsOp.ivybase__Option_Id__c);
                }
            }
            return questionAnswerOptionList ;
        } else {
            return questionAnswerOptionList ;
        }
    }

    global static List<List<String>> dependentQuestions(List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList) {

        List<List<String>> dependentQuestion = new List<List<String>>();
        Set<String> optionIdSet = new Set<String>();

        if (dependentQuestionAnsOptionList != null && dependentQuestionAnsOptionList.size() > 0) {
            for (ivybase__Question_Answer_Option__c qnAnsOp :dependentQuestionAnsOptionList) {
                if (!optionIdSet.contains(qnAnsOp.ivybase__Option_Id__c)) {
                    List<String> questionAnsOp = new List<String>();
                    questionAnsOp.add(qnAnsOp.ivybase__Option_Id__c);
                    if (qnAnsOp.ivybase__Dependent_Question__c != null) {
                        questionAnsOp.add(qnAnsOp.ivybase__Dependent_Question__r.ivybase__Question_Id__c); 
                    } else {
                        questionAnsOp.add('');
                    }
                    dependentQuestion.add(questionAnsOp);
                    optionIdSet.add(qnAnsOp.ivybase__Option_Id__c);
                }
            }
            return dependentQuestion;
        } else {
            return dependentQuestion;
        }
    }
    global static List<List<String>> getOptionScoreMapping(List<ivybase__Question_Answer_Option__c> questionAnsOptionList, Map<Id, Set<String>> questionIdwithSurveyInternalIdMap) {
        List<List<String>> optionQuestion = new List<List<String>>();
        Set<String> optionIdSet = new Set<String>();

        if (questionAnsOptionList != null && questionAnsOptionList.size() > 0 && questionIdwithSurveyInternalIdMap != null && questionIdwithSurveyInternalIdMap.size() > 0) {
            for (ivybase__Question_Answer_Option__c qnAnsOp :questionAnsOptionList) {
                if (!optionIdSet.contains(qnAnsOp.ivybase__Option_Id__c) && questionIdwithSurveyInternalIdMap.containsKey(qnAnsOp.ivybase__Question__c)) {
                    for (String surveyInternal :questionIdwithSurveyInternalIdMap.get(qnAnsOp.ivybase__Question__c)) { 
                        List<String> questionAnsOp = new List<String>();
                        questionAnsOp.add(qnAnsOp.ivybase__Option_Id__c);//OptionId

                        if (qnAnsOp.Score__c != null) {
                            questionAnsOp.add(qnAnsOp.Score__c+'');//score
                        } else {
                            questionAnsOp.add('');
                        }
                        questionAnsOp.add(surveyInternal); //SurveyId
                        if (qnAnsOp.ivybase__Is_Excluded__c) {
                            questionAnsOp.add('1');//IsExcluded
                        } else {
                            questionAnsOp.add('0');
                        }
                        optionQuestion.add(questionAnsOp);                        
                    }
                    optionIdSet.add(qnAnsOp.ivybase__Option_Id__c);
                }
            }
            return optionQuestion;
        } else {
            return optionQuestion;
        }
    }
    public static void deleteAnswerOptions(Set<Id> ansOptionIdSet) {
        List<ivybase__Answer_Option__c> answerOptionList = new List<ivybase__Answer_Option__c>();
        for(Id optionId : ansOptionIdSet) {
            answerOptionList.add(new ivybase__Answer_Option__c(Id = optionId));
        }
        if (SecurityUtility.checkIsDeletable('ivybase__Answer_Option__c')) {
            delete answerOptionList;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }

    // updated SFDC-778
    public static RExAPIResponseDomain.ResponseInfo objectTolastvisitSurvey(List<ivybase__Survey_Result_Detail__c> surveydetList, String errorcode) {

        RExAPIResponseDomain.ResponseInfo lastvisitsurveyTable = new RExAPIResponseDomain.ResponseInfo();
        lastvisitsurveyTable.Master = 'LastVisitSurvey'; 
        lastvisitsurveyTable.Field = new List<String> {'RetailerId','SurveyId','Qid','AnswerId','isExcluded','Answer','score','isSubQuest'}; 
        lastvisitsurveyTable.ErrorCode = errorCode == null ? '0' : errorCode;
        lastvisitsurveyTable.Next = '0';

        List<List<String>> lastsurveylist = new List<List<String>>();

        if(surveydetList != null && errorCode == null) {

            for (ivybase__Survey_Result_Detail__c srd : surveydetList) {

                List<String> tempsurveylist = new List<String>();
                tempsurveylist.add(srd.ivybase__Survey_Result__r.ivybase__Store__c != NULL ? String.ValueOf(srd.ivybase__Survey_Result__r.ivybase__Store__r.ivybase__Internal_Id__c) : '0');//Retailerid
                tempsurveylist.add(srd.ivybase__Survey_Result__r.ivybase__Survey__c != NULL ? srd.ivybase__Survey_Result__r.ivybase__Survey__r.ivybase__Internal_Id__c : '0');//SurveuId
                //SFDC-801
                tempsurveylist.add(srd.ivybase__Question1__c != NULL ? srd.ivybase__Question1__r.ivybase__Question_Id__c : '0');//Qid
                tempsurveylist.add(srd.ivybase__Question_Answer_Option__r.ivybase__Option_Id__c != NULL ? srd.ivybase__Question_Answer_Option__r.ivybase__Option_Id__c : '0');//AnswerId
                tempsurveylist.add(srd.ivybase__Question_Answer_Option__r.ivybase__Is_Excluded__c ? '1' : '0');//isExcluded
                //Start SFDC-737
                tempsurveylist.add(srd.ivybase__Actual_Full_Content__c != NULL ? EncodingAndDecodingUtil.encodeString(srd.ivybase__Actual_Full_Content__c) : (srd.ivybase__Actual__c != NULL ? EncodingAndDecodingUtil.encodeString(srd.ivybase__Actual__c) : ''));//Answer
                //End SFDC-737
                tempsurveylist.add(srd.ivybase__Score__c != NULL ? String.valueOf(srd.ivybase__Score__c) :'0');//score
                tempsurveylist.add(srd.ivybase__Survey_Question__c != null ? '0' : '1'); //isSubQuest // updated SFDC-778

                lastsurveylist.add(tempsurveylist);
            }

        }

        lastvisitsurveyTable.Data = lastsurveylist; 
        return lastvisitsurveyTable;
    }


    public static RExAPIResponseDomain.ResponseInfo objectTolastvisitSurveyImage(List<ivybase__Survey_Image__c> surveydetList, String errorcode) {

        RExAPIResponseDomain.ResponseInfo lastvisitsurveyImgTable = new RExAPIResponseDomain.ResponseInfo();
        lastvisitsurveyImgTable.Master = 'LastVisitSurveyImage'; 
        lastvisitsurveyImgTable.Field = new List<String> {'RetailerId','SurveyId','ImageName','QuestionId'}; 
        lastvisitsurveyImgTable.ErrorCode = errorCode == null ? '0' : errorCode;
        lastvisitsurveyImgTable.Next = '0';

        List<List<String>> lastsurveyImagelist = new List<List<String>>();

        if(surveydetList != null && errorCode == null) {

            for (ivybase__Survey_Image__c surImg : surveydetList) {
                List<String> tempsurveylist = new List<String>();
                tempsurveylist.add(surImg.ivybase__Survey_Result_Detail__r.ivybase__Survey_Result__r.ivybase__Store__c != NULL ? String.ValueOf(surImg.ivybase__Survey_Result_Detail__r.ivybase__Survey_Result__r.ivybase__Store__r.ivybase__Internal_Id__c) : '0');//RetailerId
                tempsurveylist.add(surImg.ivybase__Survey_Result_Detail__r.ivybase__Survey_Result__r.ivybase__Survey__c != NULL ? surImg.ivybase__Survey_Result_Detail__r.ivybase__Survey_Result__r.ivybase__Survey__r.ivybase__Internal_Id__c : '0');//SurveyId
                tempsurveylist.add(surImg.ivybase__Image_Name__c != NULL ? surImg.ivybase__Image_Name__c : '');//ImageName
                //SFDC-801 changed Question1__c instead of Question__c master detail
                tempsurveylist.add(surImg.ivybase__Survey_Result_Detail__r.ivybase__Question1__c != NULL ? surImg.ivybase__Survey_Result_Detail__r.ivybase__Question1__r.ivybase__Question_Id__c : '0');//QuestionId
                lastsurveyImagelist.add(tempsurveylist);
            }
        }
        lastvisitsurveyImgTable.Data = lastsurveyImagelist; 
        return lastvisitsurveyImgTable;
    }

    public static RExAPIResponseDomain.ResponseInfo objectToSurveyHistory(List<ivybase__Survey_Result__c> surveyResultList, String errorcode) {

        RExAPIResponseDomain.ResponseInfo surveyHistoryTable = new RExAPIResponseDomain.ResponseInfo();
        surveyHistoryTable.Master = 'SurveyHistory'; 
        surveyHistoryTable.Field = new List<String> {'SurveyId','RetailerId','Date'}; 
        surveyHistoryTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyHistoryTable.Next = '0';

        List<List<String>> surveyHistoryList = new List<List<String>>();

        if(surveyResultList != null && errorCode == null) {

            for (ivybase__Survey_Result__c surRes : surveyResultList) {
                List<String> tempsurveyReslist = new List<String>();
                tempsurveyReslist.add(surRes.ivybase__Survey__c != NULL ? surRes.ivybase__Survey__r.ivybase__Internal_Id__c : '0');//SurveyId
                tempsurveyReslist.add(surRes.ivybase__Store__c != NULL ? String.ValueOf(surRes.ivybase__Store__r.ivybase__Internal_Id__c) : '0');//RetailerId      
                tempsurveyReslist.add(surRes.CreatedDate !=null ?(surRes.createdDate.year()+'/'+CommonUtility.convertTwodigit(surRes.createdDate.Month())+'/'+CommonUtility.convertTwodigit(surRes.createdDate.day())):'');//Date            
                surveyHistoryList.add(tempsurveyReslist);
            }
        }
        surveyHistoryTable.Data = surveyHistoryList; 
        return surveyHistoryTable;
    }

    global static RExAPIResponseDomain.MultipleResponseInfo objectToSurveyGroup2(List<ivybase__Survey_Mapping__c> surveyList,
                                                                                 List<ivybase__Survey_Question__c> surveyQuestionList,
                                                                                 List<ivybase__Survey_Mapping__c> surveyCriteriaMapping ,
                                                                                 List<ivybase__Question__c> questionList,
                                                                                 List<ivybase__Question_Answer_Option__c> questionAnsOptionList,
                                                                                 List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList,
                                                                                 Map<String, String> listCodeListId,
                                                                                 Map<Id, String> questionIdwithSurveyHhtMenuMap,
                                                                                 Set<Id> optionsQuestionIdSet,
                                                                                 Map<Id, Set<String>> questionIdwithSurveyInternalIdMap,
                                                                                 Map<String,String> frequencyTypeMap,
                                                                                 String errorCode) {
        System.debug(':::surveyCriteriaMapping:::'+surveyCriteriaMapping);

        RExAPIResponseDomain.MultipleResponseInfo surGrp = new RExAPIResponseDomain.MultipleResponseInfo();
        List<RExAPIResponseDomain.ResponseInfo> surveyTables = new List<RExAPIResponseDomain.ResponseInfo>();

        // Survey Details
        RExAPIResponseDomain.ResponseInfo surveyTable = new RExAPIResponseDomain.ResponseInfo();
        surveyTable.Master = 'SurveyMaster'; 
        surveyTable.Field = new List<String> {'SurveyId','SurveyDesc','StartDate','EndDate','MenuCode','Sequence','BonusPoint','FrequencyType'}; 
        surveyTable.Data = (surveyList != null && listCodeListId != null && errorCode == null) ? surveyRecords2(surveyList,frequencyTypeMap) : new List<List<String>>();

        surveyTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyTable.Next = '0';
        surveyTables.add(surveyTable);

        // Survey Mapping Details
        RExAPIResponseDomain.ResponseInfo surveyMappingTable = new RExAPIResponseDomain.ResponseInfo();
        surveyMappingTable.Master = 'SurveyMapping'; 
        surveyMappingTable.Field = new List<String> {'RetailerId','SurveyId','QId','Weight','GroupName','Sequence','isScore'}; 
        surveyMappingTable.Data = (surveyQuestionList != null && errorCode == null) ? surveyQuestions(surveyQuestionList,dependentQuestionAnsOptionList, optionsQuestionIdSet) : new List<List<String>>();

        surveyMappingTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyMappingTable.Next = '0';
        surveyTables.add(surveyMappingTable);

        // Survey Criteria Mapping Details
        RExAPIResponseDomain.ResponseInfo surveyCriteriaMappingTable = new RExAPIResponseDomain.ResponseInfo();
        surveyCriteriaMappingTable.Master = 'SurveyCriteriaMapping'; 
        surveyCriteriaMappingTable.Field = new List<String> {'RetailerId','SurveyId','ChannelId','ClassId','LocId','CriteriaType','CriteriaID','GroupId','DivisionId'}; 
        surveyCriteriaMappingTable.Data = (surveyCriteriaMapping != null && errorCode == null) ? surveyCriteria(surveyCriteriaMapping, listCodeListId) : new List<List<String>>(); //Need to map data

        surveyCriteriaMappingTable.ErrorCode = errorCode == null ? '0' : errorCode;
        surveyCriteriaMappingTable.Next = '0';
        surveyTables.add(surveyCriteriaMappingTable);

        // Question Details
        RExAPIResponseDomain.ResponseInfo questionTable = new RExAPIResponseDomain.ResponseInfo();
        questionTable.Master = 'QuestionMaster'; 
        questionTable.Field = new List<String> {'QId','QText','QType','BrandID','Module','IsMand','IsPhotoReq','minPhoto','maxPhoto','IsBonus'}; 
        questionTable.Data = (questionList != null && errorCode == null) ? questions(questionList,listCodeListId, questionIdwithSurveyHhtMenuMap, dependentQuestionAnsOptionList,optionsQuestionIdSet) : new List<List<String>>();

        questionTable.ErrorCode = errorCode == null ? '0' : errorCode;
        questionTable.Next = '0';
        surveyTables.add(questionTable);

        // Question answer option Details
        RExAPIResponseDomain.ResponseInfo questionAnswerOptionTable = new RExAPIResponseDomain.ResponseInfo();
        questionAnswerOptionTable.Master = 'OptionMaster'; 
        questionAnswerOptionTable.Field = new List<String> {'QId','OptionId','OptionText'}; 
        questionAnswerOptionTable.Data = (questionAnsOptionList != null && errorCode == null) ? questionsAnswerOption(questionAnsOptionList) : new List<List<String>>();

        questionAnswerOptionTable.ErrorCode = errorCode == null ? '0' : errorCode;
        questionAnswerOptionTable.Next = '0';
        surveyTables.add(questionAnswerOptionTable);


        // Dependent Question Details
        RExAPIResponseDomain.ResponseInfo dependentQuestionTable = new RExAPIResponseDomain.ResponseInfo();
        dependentQuestionTable.Master = 'OptionDQM'; 
        dependentQuestionTable.Field = new List<String> {'OptionId','DQId'}; 
        dependentQuestionTable.Data = (dependentQuestionAnsOptionList != null && errorCode == null) ? dependentQuestions(dependentQuestionAnsOptionList) : new List<List<String>>();

        dependentQuestionTable.ErrorCode = errorCode == null ? '0' : errorCode;
        dependentQuestionTable.Next = '0';
        surveyTables.add(dependentQuestionTable);

        //OptionScoreMapping details
        RExAPIResponseDomain.ResponseInfo optScrMapping = new RExAPIResponseDomain.ResponseInfo();
        optScrMapping.Master = 'OptionScoreMapping'; 
        optScrMapping.Field = new List<String> {'OptionId', 'score', 'SurveyId', 'IsExcluded'}; 
        optScrMapping.Data = (questionAnsOptionList != null && errorCode == null) ? getOptionScoreMapping(questionAnsOptionList,questionIdwithSurveyInternalIdMap) : new List<List<String>>();

        optScrMapping.ErrorCode = errorCode == null ? '0' : errorCode;
        optScrMapping.Next = '0';
        surveyTables.add(optScrMapping);

        surGrp.Tables = surveyTables;
        return surGrp;
    }

    global static List<List<String>> surveyRecords2(List<ivybase__Survey_Mapping__c> surveyList, Map<String,String> frequencyTypeMap) {

        List<List<String>> surveyRecList = new List<List<String>>();
        Set<Id> surveyIdSet = new Set<Id>();
        Map<String,String> surhhtmenuMap = new Map<String,String>();

        /*for(ivybase__HHT_Menu_Master__mdt hhtmenu : HHTService.getSurveyHHTMenu()){
            surhhtmenuMap.put(hhtmenu.label,hhtmenu.DeveloperName);
        }*/
        
        /* To get HHT Menu records */
        for(ivybase__HHTMenu_Master__c hhtMenu : HHTService.getHHTMenuMethods() ){
            surhhtmenuMap.put(hhtmenu.Name,hhtmenu.Name);
        }
        
        
        if (surveyList != null && surveyList.size() > 0) {
            //List<List<String>> surveyRecList = new List<List<String>>();
            for (ivybase__Survey_Mapping__c sv :surveyList) {
                if (!surveyIdSet.contains(sv.ivybase__Survey__c)) {
                    List<String> surveyRec = new List<String>();
                    surveyRec.add(sv.ivybase__Survey__r.ivybase__Internal_Id__c);
                    surveyRec.add(sv.ivybase__Survey__r.Name);
                    if (sv.ivybase__Survey__r.ivybase__From__c != null) {
                        surveyRec.add(sv.ivybase__Survey__r.ivybase__From__c.Year()+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__From__c.month())+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__From__c.day()));
                    } else {
                        surveyRec.add('');
                    }
                    if (sv.ivybase__Survey__r.ivybase__To__c != null) {
                        surveyRec.add(sv.ivybase__Survey__r.ivybase__To__c.Year()+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__To__c.month())+'/'+CommonUtility.convertTwodigit(sv.ivybase__Survey__r.ivybase__To__c.day()));
                    } else {
                        surveyRec.add('');
                    }
                    if (sv.ivybase__Survey__r.ivybase__HHT_Menu__c != null && surhhtmenuMap.containsKey(sv.ivybase__Survey__r.ivybase__HHT_Menu__c)) {
                        surveyRec.add(surhhtmenuMap.get(sv.ivybase__Survey__r.ivybase__HHT_Menu__c));
                    }else{
                        surveyRec.add('');
                    }
                    //surveyRec.add(sv.ivybase__Survey__r.ivybase__HHT_Menu__c);
                    if (sv.ivybase__Survey__r.ivybase__Sequence_Number__c != null) {
                        surveyRec.add(''+sv.ivybase__Survey__r.ivybase__Sequence_Number__c);
                    } else {
                        surveyRec.add('');
                    }
                    if (sv.ivybase__Survey__r.ivybase__Maximum_Bonus_Points__c != null) {
                        surveyRec.add(''+sv.ivybase__Survey__r.ivybase__Maximum_Bonus_Points__c);
                    } else {
                        surveyRec.add('');
                    }
                    if(frequencyTypeMap !=null){
                        surveyRec.add(frequencyTypeMap.get(sv.ivybase__Survey__r.ivybase__Frequency_Type__c) != null ? frequencyTypeMap.get(sv.ivybase__Survey__r.ivybase__Frequency_Type__c) : (frequencyTypeMap.get('Multiple') != null) ? frequencyTypeMap.get('Multiple') : '');
                        surveyRecList.add(surveyRec);
                        surveyIdSet.add(sv.ivybase__Survey__c);}
                }
            }
            return surveyRecList ;
        } else {
            return surveyRecList ;
        }

    }

}