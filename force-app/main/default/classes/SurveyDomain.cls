global with sharing class SurveyDomain {
    
    global class surveyFilterObjectIds {
        global set<Id> storeIds;
        global set<String> storeHierarchyIds;
        global set<String> locationIds;
        global set<Id> sellerIds;
    }
    global class SurveyQuestionsWithQuestionIdSetInfo {
        global List<ivybase__Survey_Question__c> surveyQuestionList;
        global Set<Id> questionIdSet;
        global Map<id, String> questionIdwithSurveyHhtMenuMap;
        global Map<id, Set<String>> questionIdwithSurveyInternalIdMap;
    }
    global class SurveyMappingswithSurveyIdsInfo {
        global List<ivybase__Survey_Mapping__c> surveyMappingList;
        global set<Id> surveyIdSet;
    }
    global class QuestionIdwithQuestionAnswerOptionInfo {
        global Set<Id> QuestionIds;
        global List<ivybase__Question_Answer_Option__c> quesAnsOptionList;
    }
}