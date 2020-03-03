global with sharing class SurveyService {

    public static Map<String, String> surveyStdList() {

        String[] slmFields = new String[] {'ivybase__List_Type__c', 'ivybase__List_Code__c', 'ivybase__Parent_Id__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', slmFields)) { 
            Map<String, String> listCodeWithStdIdMap = new Map<String, String>();

            List<ivybase__Standard_List_Master__c> listofSlm = StandardListMasterService.getSurveyCriteriaStds(new List<String> {'SURVEY_CRITERIA_TYPE','QUESTION_TYPE'}, new List<String> {'Option', 'Text', 'Numeric', 'Date', 'Multiple Select', 'Email','Free Text','Currency','Phone Number','Poll'}, new List<String> {'SPECIAL','STANDARD'});
            if (listofSlm != null) { 
                for(ivybase__Standard_List_Master__c slm : listofSlm ) {
                    listCodeWithStdIdMap.put(slm.ivybase__List_Code__c, slm.Name);            
                }
            }
            return listCodeWithStdIdMap;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Standard_List_Master__c', slmFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            //return null;
        }
    }

    public static void updateSurveyTotalWeight(Set<Id> surveyIds) {
        if (surveyIds != null && surveyIds.size() > 0) {
            Map<Id, Decimal> surveyIdwithTotalWeightMap = new Map<Id, Decimal>();

            for (ivybase__Survey_Question__c sq : [SELECT Id, ivybase__Survey__c, Score_Weight__c,ivybase__Question_Score_Weight__c  FROM ivybase__Survey_Question__c WHERE ivybase__Survey__c IN:surveyIds AND Score_Weight__c > 0]) {
                if (!surveyIdwithTotalWeightMap.containsKey(sq.ivybase__Survey__c)) {
                    surveyIdwithTotalWeightMap.put(sq.ivybase__Survey__c, 0);
                }
                surveyIdwithTotalWeightMap.put(sq.ivybase__Survey__c, surveyIdwithTotalWeightMap.get(sq.ivybase__Survey__c) + sq.ivybase__Question_Score_Weight__c);
            }

            List<ivybase__Survey__c> surveyUpdateList = new List<ivybase__Survey__c>();

            for (Id sId :surveyIds) {
                ivybase__Survey__c newSurvey = new ivybase__Survey__c(Id = sId, ivybase__Sum_Of_Weight__c = surveyIdwithTotalWeightMap.get(sid));
                surveyUpdateList.add(newSurvey);
            }   
            if (surveyUpdateList.size() > 0) {
                update surveyUpdateList;
            }
        }
    }
    public static SurveyDomain.surveyFilterObjectIds getSellerStoreHierarchyIds(Id sellerId) {
        system.debug('getSellerStoreHierarchyIds method called');
        String[] accFields = new String[] {'ivybase__Store_Hierarchy__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Seller_Name__c','ivybase__Resource__c'}; 
        if (SecurityUtility.checkIsAccessible('Account', accFields)) { 
            system.debug('inside security');
            SurveyDomain.surveyFilterObjectIds surveyFlt = new SurveyDomain.surveyFilterObjectIds();

            Set<Id> storeHierarchySet = new Set<Id>();
            Set<Id> locationHierarchySet = new Set<Id>();
            Set<Id> storeSet = new Set<Id>();
            Set<Id> sellerIdSet = new Set<Id>();
            Map<String, Set<String>> locAndStoreHieMap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
            sellerIdSet.add(sellerId);
            for (Account acc : AccountService.getAllRetailerMaster_List_for_Resource()) {
                storeSet.add(acc.Id);
            }
            system.debug('locAndStoreHieMap123'+locAndStoreHieMap.get('Location'));
            surveyFlt.storeIds = storeSet;
            surveyFlt.storeHierarchyIds = locAndStoreHieMap.get('Store');
            surveyFlt.locationIds = locAndStoreHieMap.get('Location');
            
            system.debug('surveyFlt.locationIds ->'+ surveyFlt.locationIds);
            surveyFlt.sellerIds = sellerIdSet;
            system.debug('surveyFlt'+surveyFlt);
            return surveyFlt;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('Account', accFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            //return null;
        }
    }

    public static SurveyDomain.surveyFilterObjectIds getSellerStoreHierarchyIds() {

        SurveyDomain.surveyFilterObjectIds surveyFlt = new SurveyDomain.surveyFilterObjectIds();
        Set<Id> sellerIdSet = new Set<Id>();

        ivybase__Global_Configuration__mdt  gc = GlobalConfigurationService.getGlobalConfig();
        Boolean isRouteStoreMapping = gc != null && gc.ivybase__Active_Route_Store_Mapping__c;
        //Boolean isRouteStoreMapping= true;
        Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = new Map<String, Set<String>>();
        Map<Id, Account> accMap = new Map<Id, Account>(AccountService.getAllRetailerMaster_List_for_Resource());

        System.debug(':::accMap:::' + accMap);

        if (!isRouteStoreMapping) {
            system.debug('inside if');
            Id sellerId = ResourceService.getLoginSellerId();
            sellerIdSet.add(sellerId);
            hierarchyNamewithSetOfIdsMap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
        } else {
            //Id loginUserId = UserInfo.getUserId();
            ivybase__Resource__c res = ResourceService.getSellerId(UserInfo.getUserId());// SFDC-887
            Id sellerId = res != null && res.Id != null ? res.Id : null;
            Id loginUserId = res != null && res.ivybase__Related_User__c != null ? res.ivybase__Related_User__c : userInfo.getUserId();
            if (sellerId != null) {
                sellerIdSet.add(sellerId);
            }
            hierarchyNamewithSetOfIdsMap = AccountService.getHierarchyIdsbysellerId_Map(loginUserId);
        }

        System.debug('hierarchyNamewithSetOfIdsMap135' + hierarchyNamewithSetOfIdsMap);
        surveyFlt.storeIds = accMap.keySet();
        surveyFlt.storeHierarchyIds = hierarchyNamewithSetOfIdsMap.get('Store');
        surveyFlt.locationIds = hierarchyNamewithSetOfIdsMap.get('Location');
        surveyFlt.sellerIds = sellerIdSet;
        System.debug('surveyFlt::::::::::::::' + surveyFlt);
        return surveyFlt;

    }

    public static SurveyDomain.SurveyMappingswithSurveyIdsInfo getSurveyMappingwithSurveyIds(Set<Id> storeIds, Set<String> storeHierarchyIds, Set<String> locationIds, Set<Id> sellerIds,Id supervisorId) {

        System.debug(storeHierarchyIds + ':::' + storeIds + ':::' + locationIds + ':::' + sellerIds);
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
       
        system.debug('surveyProcessDate-->'+ surveyProcessDate);
        
        String[] surveymapFields = new String[] {'ivybase__Store_Hierarchy__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Survey__c', 'ivybase__Store__c', 'ivybase__User__c','Criteria_Type__c','Division__c'}; 
        String[] salonCategoryFields=new String[]{'Location_Hierarchy__c'};
        string[]  DivisionFields = new string[]{'Name','Internal_Id__c'}; 
        
        system.debug('before if');
        system.debug('locationIds ->'+ locationIds);
        
        system.debug(' survey mapping'+ SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', surveymapFields));
        system.debug(' salon category '+ SecurityUtility.checkIsAccessible('Salon_Catagory__c', salonCategoryFields));
        system.debug(' division '+ SecurityUtility.checkIsAccessible('Division__c', DivisionFields));
        
        
        if (SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', surveymapFields) && SecurityUtility.checkIsAccessible('Salon_Catagory__c', salonCategoryFields) && SecurityUtility.checkIsAccessible('Division__c', DivisionFields)) { 
                //  if ( SecurityUtility.checkIsAccessible('Salon_Catagory__c', salonCategoryFields) && SecurityUtility.checkIsAccessible('Division__c', DivisionFields)) { 

            SurveyDomain.SurveyMappingswithSurveyIdsInfo surveyMapwithIds = new SurveyDomain.SurveyMappingswithSurveyIdsInfo();
            List<ivybase__Survey_Mapping__c> surveyMappingList = new List<ivybase__Survey_Mapping__c>();
            Set<Id> surveyIds = new Set<Id>();
            Set<Id> surIds = new Set<Id>();
            Set<Id> oneTimeSurIds = new Set<Id>();
            Set<Id> ReslocationHierarchy = new Set<Id>();
            List<ivybase__Resource__c> resource = [select id,ivybase__Related_User__c,ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:UserInfo.getUserId()];

            system.debug('inside if');
            
            for(ivybase__Resource__c r:resource)
            {
                ReslocationHierarchy.add(r.ivybase__Location_Hierarchy__c);
            }
            //Get One Time Survey Ids
            for (ivybase__Survey_Mapping__c smm : [SELECT Id,
                                                   ivybase__Survey__c,
                                                   ivybase__Internal_Id__c,
                                                   Criteria_Type__c
                                                   FROM ivybase__Survey_Mapping__c
                                                   WHERE 
                                                   ivybase__Survey__c != null
                                                   AND
                                                   ivybase__Survey__r.ivybase__Is_One_Time_Survey__c = true
                                                   AND
                                                   ivybase__Survey__r.ivybase__Active__c = true
                                                   AND 
                                                   (ivybase__Survey__r.ivybase__To__c = NULL OR ivybase__Survey__r.ivybase__To__c >= :surveyProcessDate)
                                                   AND 
                                                   (ivybase__Survey__r.ivybase__From__c = NULL OR ivybase__Survey__r.ivybase__From__c <= :surveyProcessDate)
                                                   AND 
                                                   ( 
                                                       //(ivybase__Store_Hierarchy__c != NULL AND ivybase__Store_Hierarchy__c IN:storeHierarchyIds)
                                                       //OR (ivybase__Store__c != NULL AND ivybase__Store__c IN:storeIds)
                                                       (ivybase__Location_Hierarchy__c != NULL AND ivybase__Location_Hierarchy__c IN:locationIds)
                                                       //OR (ivybase__Territory__c != NULL AND ivybase__Territory__c IN:locationIds)
                                                       //OR (ivybase__Resource__c != null AND ivybase__Resource__c IN:sellerIds)
                                                       //OR (ivybase__Resource__c != null AND ivybase__Resource__c =:supervisorId)
                                                       OR (Salon_Category__r.Location_Hierarchy__c in :ReslocationHierarchy)
                                                       //OR (Division__c != null)
                                                   )
                                                  ]) {
                surIds.add(smm.ivybase__Survey__c);
            }

            system.debug('surIds ->'+ surIds);
            
            //Check One Time Survey Completed
            for(ivybase__Survey_Result__c oneSurRes : [SELECT Id, ivybase__Survey__c
                                                       FROM ivybase__Survey_Result__c
                                                       WHERE
                                                       ivybase__Survey__c IN :surIds
                                                       AND
                                                       ivybase__Resource__c IN :sellerIds
                                                      ]) {
                oneTimeSurIds.add(oneSurRes.ivybase__Survey__c);
            }


            for (ivybase__Survey_Mapping__c sm :[ SELECT Id, ivybase__Store_Hierarchy__c, 
                                                 ivybase__Internal_Id__c,
                                                 ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c,
                                                 ivybase__Location_Hierarchy__c, 
                                                 ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c,
                                                 ivybase__Survey__c, 
                                                 ivybase__Survey__r.ivybase__Internal_Id__c,
                                                 ivybase__Store__c,
                                                 ivybase__Store__r.ivybase__Internal_Id__c,
                                                 ivybase__User__c, 
                                                 ivybase__Survey__r.Name,
                                                 ivybase__Survey__r.ivybase__Active__c,
                                                 ivybase__Survey__r.ivybase__From__c, 
                                                 ivybase__Survey__r.ivybase__To__c, 
                                                 ivybase__Survey__r.ivybase__Maximum_Bonus_Points__c ,
                                                 ivybase__Survey__r.ivybase__Frequency_Type__c,
                                                 ivybase__Survey__r.ivybase__Sequence_Number__c,
                                                 ivybase__Survey__r.ivybase__HHT_Menu__c,
                                                 ivybase__Store_Hierarchy__r.RecordType.DeveloperName,
                                                 Criteria_Type__c,
                                                 Salon_Category__c,
                                                 Salon_Category__r.Location_Hierarchy__c,
                                                 Division__c,
                                                 Division__r.Name,
                                                 Division__r.Internal_Id__c
                                                 FROM ivybase__Survey_Mapping__c
                                                 WHERE 
                                                 ivybase__Survey__c != null
                                                 AND
                                                 ivybase__Survey__r.ivybase__Active__c = true
                                                 AND 
                                                 ivybase__Survey__c NOT IN :oneTimeSurIds
                                                 AND
                                                 (ivybase__Survey__r.ivybase__To__c = NULL OR ivybase__Survey__r.ivybase__To__c >=:surveyProcessDate)
                                                 AND 
                                                 (ivybase__Survey__r.ivybase__From__c = NULL  OR ivybase__Survey__r.ivybase__From__c <= :surveyProcessDate)
                                                 AND 
                                                 ( 
                                                     //(ivybase__Store_Hierarchy__c != NULL AND ivybase__Store_Hierarchy__c IN:storeHierarchyIds)
                                                     //OR (ivybase__Store__c != NULL AND ivybase__Store__c IN:storeIds)
                                                     (ivybase__Location_Hierarchy__c != NULL AND ivybase__Location_Hierarchy__c IN:locationIds)
                                                     //OR (ivybase__Territory__c != NULL AND ivybase__Territory__c IN:locationIds)
                                                     //OR (ivybase__Resource__c != null AND ivybase__Resource__c IN:sellerIds)
                                                     //OR (ivybase__Resource__c != null AND ivybase__Resource__c =:supervisorId)
                                                     OR (Salon_Category__r.Location_Hierarchy__c in :ReslocationHierarchy)
                                                     //OR (Division__c != null)
                                                 )
                                                ]) {

                surveyMappingList.add(sm);
                system.debug('surveyMappingList'+surveyMappingList);
                surveyIds.add(sm.ivybase__Survey__c);                                
            }
            surveyMapwithIds.surveyMappingList = surveyMappingList;
            surveyMapwithIds.surveyIdSet = surveyIds;
            return surveyMapwithIds;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey_Mapping__c', surveymapFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            // return null;
        }

    }

    public static SurveyDomain.SurveyMappingswithSurveyIdsInfo getSurveyMappingwithSurveyIds2(Set<Id> storeIds, 
                                                                                              Set<String> storeHierarchyIds, 
                                                                                              Set<String> locationIds,
                                                                                              Set<Id> sellerIds,
                                                                                              Id supervisorId) {

        System.debug(storeHierarchyIds + 'storeHierarchyIds -:::' + storeIds + 'storeIds- :::' + locationIds + 'locationIds-:::' + sellerIds);
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        String[] surveymapFields = new String[] {'ivybase__Store_Hierarchy__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Survey__c', 'ivybase__Store__c', 'ivybase__User__c','Criteria_Type__c'}; 
        String[] surveyFields = new String[] {'ivybase__Frequency_Type__c','ivybase__Internal_Id__c','ivybase__Active__c','ivybase__From__c','ivybase__To__c','ivybase__Maximum_Bonus_Points__c','ivybase__Sequence_Number__c','ivybase__HHT_Menu__c','ivybase__Is_One_Time_Survey__c','ivybase__Complete_Survey_On_All_Question_Answered__c','ivybase__Frequency_Type__c'};
        String[] salonCategoryFields=new String[]{'Location_Hierarchy__c'};
       
        system.debug('Survey_Mapping -->'+ SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', surveymapFields));
        system.debug('ivybase__Survey-->'+ SecurityUtility.checkIsAccessible('ivybase__Survey__c', surveyFields));
        system.debug('Salon_Catagory-->'+ SecurityUtility.checkIsAccessible('Salon_Catagory__c', salonCategoryFields));
        
        if (SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', surveymapFields) && SecurityUtility.checkIsAccessible('ivybase__Survey__c', surveyFields) && SecurityUtility.checkIsAccessible('Salon_Catagory__c', salonCategoryFields)) { 
            SurveyDomain.SurveyMappingswithSurveyIdsInfo surveyMapwithIds = new SurveyDomain.SurveyMappingswithSurveyIdsInfo();
            List<ivybase__Survey_Mapping__c > surveyMappingList = new List<ivybase__Survey_Mapping__c   >();
            Set<Id> surveyIds = new Set<Id>();
            Set<Id> surIds = new Set<Id>();
            Set<Id> oneTimeSurIds = new Set<Id>();
            Set<Id> ReslocationHierarchy = new Set<Id>();
            // additional salon category code
            List<ivybase__Resource__c> resource = [select id,ivybase__Related_User__c,ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:UserInfo.getUserId()];

            for(ivybase__Resource__c r:resource)
            {
                ReslocationHierarchy.add(r.ivybase__Location_Hierarchy__c);
            }
            system.debug('-----ReslocationHierarchy'+ReslocationHierarchy);
            for (ivybase__Survey_Mapping__c  sm :[ SELECT Id, ivybase__Store_Hierarchy__c, 
                                                  ivybase__Internal_Id__c,
                                                  ivybase__Store_Hierarchy__r.ivybase__Internal_Id__c,
                                                  ivybase__Location_Hierarchy__c, 
                                                  ivybase__Location_Hierarchy__r.ivybase__Internal_Id__c,
                                                  ivybase__Survey__c, 
                                                  ivybase__Survey__r.ivybase__Internal_Id__c,
                                                  ivybase__Store__c,
                                                  ivybase__Store__r.ivybase__Internal_Id__c,
                                                  ivybase__User__c, 
                                                  ivybase__Survey__r.Name,
                                                  ivybase__Survey__r.ivybase__Active__c,
                                                  ivybase__Survey__r.ivybase__From__c, 
                                                  ivybase__Survey__r.ivybase__To__c, 
                                                  ivybase__Survey__r.ivybase__Maximum_Bonus_Points__c ,
                                                  ivybase__Survey__r.ivybase__Sequence_Number__c,
                                                  ivybase__Survey__r.ivybase__HHT_Menu__c,
                                                  ivybase__Survey__r.ivybase__Frequency_Type__c,
                                                  ivybase__Store_Hierarchy__r.RecordType.DeveloperName,
                                                  Criteria_Type__c,
                                                  Salon_Category__c,
                                                  Salon_Category__r.Location_Hierarchy__c,
                                                  Division__c,
                                                  Division__r.Name,
                                                  Division__r.Internal_Id__c
                                                  FROM ivybase__Survey_Mapping__c    
                                                  WHERE 
                                                  ivybase__Survey__c != null
                                                  AND
                                                  ivybase__Survey__r.ivybase__Active__c = true
                                                  AND
                                                  (ivybase__Survey__r.ivybase__To__c = NULL OR ivybase__Survey__r.ivybase__To__c >=:surveyProcessDate)
                                                  AND 
                                                  (ivybase__Survey__r.ivybase__From__c = NULL  OR ivybase__Survey__r.ivybase__From__c <= :surveyProcessDate)
                                                  AND 
                                                  ( 
                                                      (ivybase__Store_Hierarchy__c != NULL AND ivybase__Store_Hierarchy__c IN:storeHierarchyIds)
                                                      OR (ivybase__Store__c != NULL AND ivybase__Store__c IN:storeIds)
                                                      OR (ivybase__Location_Hierarchy__c != NULL AND ivybase__Location_Hierarchy__c IN:locationIds)
                                                      OR (ivybase__Territory__c != NULL AND ivybase__Territory__c IN:locationIds)
                                                      OR (ivybase__Resource__c != null AND ivybase__Resource__c IN:sellerIds)
                                                      OR (ivybase__Resource__c != null AND ivybase__Resource__c =:supervisorId)
                                                      OR (Salon_Category__r.Location_Hierarchy__c in :ReslocationHierarchy)
                                                      OR(Division__c != null)
                                                  )


                                                 ]) {

                surveyMappingList.add(sm);
                surveyIds.add(sm.ivybase__Survey__c);                                
            }


            surveyMapwithIds.surveyMappingList = surveyMappingList;
            surveyMapwithIds.surveyIdSet = surveyIds;
            return surveyMapwithIds;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey_Mapping__c', surveymapFields);
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey__c', surveyFields);

            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            // return null;
        }

    }

    public static SurveyDomain.SurveyQuestionsWithQuestionIdSetInfo getSurveyMapping(Set<Id> surveyIdSet) {
        /*
"RetailerId",
"SurveyId",    //Survey__r.Internal_Id__c
"QId",         //Question__r.Question_Id__c
"Weight",      //
"GroupName",   //Question_Group__r.Name
"Sequence",    //Sequence_Number__c
"isScore"
*/
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        String[] surveyquesFields = new String[] {'ivybase__Survey_Code__c', 'ivybase__Survey__c', 'ivybase__Question__c', 'ivybase__IsScore__c', 'ivybase__Question_Group__c', 'ivybase__Sequence_Number__c', 'ivybase__Question_Score_Weight__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', surveyquesFields)) { 
            List<ivybase__Survey_Question__c> surveyQuesList = new List<ivybase__Survey_Question__c>();
            Set<Id> questionIdSet = new Set<Id>();
            Map<Id, String> questionIdwithSurveyHhtMenuMap = new Map<Id, String>();
            Map<Id, Set<String>> questionIdwithSurveyInternalIdMap = new Map<Id, Set<String>> ();
            if (surveyIdSet != null && surveyIdSet.size() > 0) {
                for (ivybase__Survey_Question__c sq : [SELECT Id, 
                                                       ivybase__Survey_Code__c,
                                                       ivybase__Survey__c,
                                                       ivybase__Survey__r.ivybase__Internal_Id__c,
                                                       ivybase__Survey__r.ivybase__HHT_Menu__c,
                                                       ivybase__Question__c,
                                                       ivybase__Question__r.ivybase__Question_Id__c,
                                                       ivybase__Question_Group__c,
                                                       ivybase__Question_Group__r.Name,
                                                       ivybase__Sequence_Number__c,
                                                       ivybase__IsScore__c,
                                                       Score_Weight__c
                                                       FROM
                                                       ivybase__Survey_Question__c
                                                       WHERE 
                                                       ivybase__Survey__c != null
                                                       AND ivybase__Survey__c IN:surveyIdSet
                                                       AND ivybase__Question__c != null
                                                       AND ((ivybase__From__c = null OR ivybase__From__c <= :surveyProcessDate) AND (ivybase__To__c = null OR ivybase__To__c >= :surveyProcessDate))]) {

                    surveyQuesList.add(sq);
                    questionIdSet.add(sq.ivybase__Question__c);    
                    questionIdwithSurveyHhtMenuMap.put(sq.ivybase__Question__c, sq.ivybase__Survey__r.ivybase__HHT_Menu__c);
                    if ( !questionIdwithSurveyInternalIdMap.containsKey(sq.ivybase__Question__c)) {
                        questionIdwithSurveyInternalIdMap.put(sq.ivybase__Question__c, new Set<String>());                                             
                    }
                    questionIdwithSurveyInternalIdMap.get(sq.ivybase__Question__c).add(sq.ivybase__Survey__r.ivybase__Internal_Id__c);                                              
                }
            }

            SurveyDomain.SurveyQuestionsWithQuestionIdSetInfo surveyQuestions = new SurveyDomain.SurveyQuestionsWithQuestionIdSetInfo();
            surveyQuestions.surveyQuestionList = surveyQuesList.size() > 0 ? surveyQuesList : null;
            surveyQuestions.questionIdSet = questionIdSet.size() > 0 ? questionIdSet : null;
            surveyQuestions.questionIdwithSurveyHhtMenuMap = questionIdwithSurveyHhtMenuMap;
            surveyQuestions.questionIdwithSurveyInternalIdMap = questionIdwithSurveyInternalIdMap;

            return surveyQuestions;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey_Question__c', surveyquesFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            // return null;
        }
    }


    public static Map<Id, ivybase__Question__c> getQuestions(Set<Id> questionIds) {
        /*
"QId",            //Question_Id__c
"QText",          //Question__c
"QType",          //Question_Type__c
"BrandID",        //
"Module",         //
"IsMand",         //
"IsPhotoReq",     //Is_Evidence_Required__c
"minPhoto",       //Minimum_Number_of_Evidences__c
"maxPhoto",       //Maximum_Number_of_Evidences__c
"IsBonus"         //Is_Bonus_Question__c
*/

        String[] quesFields = new String[] {'ivybase__Question_Id__c', 'ivybase__Question__c', 'ivybase__Question_Type__c', 'ivybase__Is_Evidence_Required__c', 
                                            'ivybase__Minimum_Number_of_Evidences__c', 'ivybase__Maximum_Number_of_Evidences__c', 'ivybase__Is_Bonus_Question__c', 'ivybase__Is_Mandatory__c'}; 
        String[] prodHierarchyFields = new String[] {'ivybase__Internal_Id__c'};       
        if (SecurityUtility.checkIsAccessible('ivybase__Question__c', quesFields)) { 
            if (questionIds != null && questionIds.size() > 0) {
                Map<Id, ivybase__Question__c> questionsMap = new Map<Id, ivybase__Question__c>([SELECT Id,
                                                                                                ivybase__Question_Id__c,
                                                                                                ivybase__Question__c,
                                                                                                ivybase__Question_Type__c,
                                                                                                ivybase__Is_Evidence_Required__c,
                                                                                                ivybase__Minimum_Number_of_Evidences__c,
                                                                                                ivybase__Maximum_Number_of_Evidences__c,
                                                                                                ivybase__Is_Bonus_Question__c,
                                                                                                ivybase__Is_Mandatory__c,
                                                                                                ivybase__Product_Hierarchy__c,
                                                                                                ivybase__Product_Hierarchy__r.ivybase__Internal_Id__c
                                                                                                FROM
                                                                                                ivybase__Question__c
                                                                                                WHERE Id IN:questionIds]);                                                 
                return questionsMap;
            } else {
                return null;
            }
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Question__c', quesFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            //return null;
        }
    }

    public static List<ivybase__Question_Answer_Option__c> getOptions(Set<Id> questionIdSet) {
        /*
"QId",              //Question__r.Question_Id__c,
"OptionId",         //Option_Id__c
"OptionText"        //Answer_Option__r.Name 
*/

        
        
        system.debug('questionIdSet'+ questionIdSet);
        
        String[] ansFields = new String[] {'ivybase__Question__c', 'ivybase__Option_Id__c', 'ivybase__Answer_Option__c','ivybase__Dependent_Question__c','ivybase__Score__c', 'ivybase__Is_Excluded__c'}; 
        
        system.debug('Question_Answer_Option -->'+ SecurityUtility.checkIsAccessible('ivybase__Question_Answer_Option__c', ansFields));
        
        if (SecurityUtility.checkIsAccessible('ivybase__Question_Answer_Option__c', ansFields)) { 
            if (questionIdSet != null && questionIdSet.size() > 0) {
                List<ivybase__Question_Answer_Option__c> questionOptionList = [SELECT ID,
                                                                               ivybase__Question__c,
                                                                               ivybase__Question__r.ivybase__Question_Id__c,
                                                                               ivybase__Option_Id__c,
                                                                               ivybase__Answer_Option__c,
                                                                               ivybase__Answer_Option__r.Name,
                                                                               ivybase__Dependent_Question__c,
                                                                               Score__c,
                                                                               ivybase__Is_Excluded__c,
                                                                               ivybase__Dependent_Question__r.Id,
                                                                               ivybase__Dependent_Question__r.ivybase__Question_Id__c,
                                                                               ivybase__Dependent_Question__r.ivybase__Question__c,//start new code for show dependent question
                                                                               ivybase__Dependent_Question__r.ivybase__Question_Type__c,
                                                                               ivybase__Dependent_Question__r.ivybase__Is_Evidence_Required__c,
                                                                               ivybase__Dependent_Question__r.ivybase__Minimum_Number_of_Evidences__c,
                                                                               ivybase__Dependent_Question__r.ivybase__Maximum_Number_of_Evidences__c,
                                                                               ivybase__Dependent_Question__r.ivybase__Is_Bonus_Question__c,
                                                                               ivybase__Dependent_Question__r.ivybase__Is_Mandatory__c
                                                                               FROM 
                                                                               ivybase__Question_Answer_Option__c
                                                                               WHERE 
                                                                               ivybase__Question__c IN:questionIdSet];
                return questionOptionList;
            } else {
                return null;
            }
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Question_Answer_Option__c', ansFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
            //  return null;
        }
    }
    public static SurveyDomain.QuestionIdwithQuestionAnswerOptionInfo getOptionDQM(List<ivybase__Question_Answer_Option__c> quesAnsOpList) {
        /*
"OptionId", // Option_Id__c
"DQId"      //Dependent_Question__r.Question_Id__c
*/
        SurveyDomain.QuestionIdwithQuestionAnswerOptionInfo questionIdswithQuestionAnswerOptions = new SurveyDomain.QuestionIdwithQuestionAnswerOptionInfo();
        List<ivybase__Question_Answer_Option__c> dependentQuestionAnsOptionList = new List<ivybase__Question_Answer_Option__c> ();
        Set<Id> questionIdSet= new Set<Id>();
        if (quesAnsOpList != null ) {
            for (ivybase__Question_Answer_Option__c qaop :quesAnsOpList) {
                if (qaop.ivybase__Dependent_Question__c != null) {
                    dependentQuestionAnsOptionList.add(qaop);
                    questionIdSet.add(qaop.ivybase__Dependent_Question__c);
                }
            }
            questionIdswithQuestionAnswerOptions.QuestionIds = questionIdSet;
            questionIdswithQuestionAnswerOptions.quesAnsOptionList = dependentQuestionAnsOptionList;
        }
        return questionIdswithQuestionAnswerOptions;
    }

    public static Set<Id> getdepques(List<ivybase__Question_Answer_Option__c> quesAnsOpList){

        Set<Id> quesset = new Set<Id>();
        for(ivybase__Question_Answer_Option__c qaop :quesAnsOpList){
            quesset.add(qaop.ivybase__Dependent_Question__c);
        }

        return quesset;

    }

    public static Map<String, ivybase__Survey__c> getSurveyIds(Set<String> internalIds) {

        String[] surveyFields = new String[] {'ivybase__Internal_Id__c  '}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Survey__c', surveyFields)) { 
            if (internalIds != null && internalIds.size() > 0) {
                Map<String, ivybase__Survey__c> surveyInternalIdwithSurveyIdMap = new Map<String, ivybase__Survey__c>();
                for (ivybase__Survey__c sur: [SELECT Id, ivybase__Internal_Id__c,ivybase__Complete_Survey_On_All_Question_Answered__c,ivybase__Frequency_Type__c
                                              FROM ivybase__Survey__c WHERE ivybase__Internal_Id__c IN:internalIds]) {
                    surveyInternalIdwithSurveyIdMap.put(sur.ivybase__Internal_Id__c , sur);
                }    
                return surveyInternalIdwithSurveyIdMap ;
            } else {
                return null;
            }
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            // return null;
        }
    }

    public static Map<String, Id> getSurveyQuestionsByInternalId(Set<String> questionInternalIdSet) {
        String[] survey_QuestionFields = new String[] {'ivybase__Question_Id__c'};

        DateTime systemCurrentDateTime = system.now();

        if (SecurityUtility.checkIsAccessible('ivybase__Question__c', survey_QuestionFields)) {
            Map<String, Id> questionInternalIdAndSFIdMap = new Map<String, Id>();
            if (questionInternalIdSet != null && questionInternalIdSet.size() > 0) {
                for (ivybase__Question__c serveyQuestion :[ SELECT Id, 
                                                           ivybase__Question_Id__c
                                                           FROM ivybase__Question__c
                                                           WHERE ivybase__Question_Id__c IN :questionInternalIdSet]) {

                    questionInternalIdAndSFIdMap.put(serveyQuestion.ivybase__Question_Id__c, serveyQuestion.Id);                            
                }
            }
            return questionInternalIdAndSFIdMap ;
        } else {
            system.debug('Question is not accessible');
            return null;
        }
    }

    public static List<ivybase__Answer_Option__c> getAllOptions() {
        String[] ansopFields = new String[] {'Id','Name'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Answer_Option__c', ansopFields)) {
            List<ivybase__Answer_Option__c> allOptionsList = [SELECT
                                                              Id,
                                                              Name
                                                              FROM
                                                              ivybase__Answer_Option__c
                                                              LIMIT 1000
                                                             ];

            return allOptionsList;
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        } 
    }

    public static List<ivybase__Answer_Option__c> getAllOptions(String searchPattern) {
        searchPattern = '%' + searchPattern + '%';
        String[] ansopFields = new String[] {'Id','Name'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Answer_Option__c', ansopFields)) {
            List<ivybase__Answer_Option__c> allOptionsList = [SELECT
                                                              Id,
                                                              Name
                                                              FROM
                                                              ivybase__Answer_Option__c
                                                              WHERE
                                                              Name LIKE :searchPattern
                                                              LIMIT 1000
                                                             ];

            return allOptionsList;
        }else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            //return null;
        } 
    }

    public static ivybase__Answer_Option__c insertOption(String optionName) {
        ivybase__Answer_Option__c option = new ivybase__Answer_Option__c();
        option.Name = optionName;
        List<String> ansOpFields = new List<String>();
        if (SecurityUtility.checkIsCreateable('ivybase__Answer_Option__c', ansOpFields)) {
            insert option;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        return option;
    }

    public static List<ivybase__Survey__c> getSurveyWithSurveyQuestions(Set<String> surveyInternalIds) {
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        String[] surveyFields = new String[] {'ivybase__Internal_Id__c'};
        String[] surveyQuestionFields = new String[] {'ivybase__Question_Id__c','ivybase__From__c','ivybase__To__c'};

        if (SecurityUtility.checkIsAccessible('ivybase__Survey__c', surveyFields) 
            && SecurityUtility.checkIsAccessible('ivybase__Survey_Question__c', surveyQuestionFields )) {
            return [SELECT Id, ivybase__Internal_Id__c, 
                    (SELECT Id, ivybase__Question_Id__c,ivybase__Question__r.ivybase__Question_Id__c
                     FROM ivybase__Survey_Questions__r 
                     WHERE ivybase__Question__c != NULL 
                     AND 
                     ((ivybase__From__c = null OR ivybase__From__c <= :surveyProcessDate) 
                      AND (ivybase__To__c = null OR ivybase__To__c >= :surveyProcessDate)
                     )
                    ) 
                    FROM ivybase__Survey__c 
                    WHERE 
                    ivybase__Internal_Id__c IN:surveyInternalIds
                   ];
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        //return null;
    }


    public static List<ivybase__Survey_Result__c> getSurveyResultwithSurveyIds(Set<Id> storeIds, 
                                                                               Set<String> storeHierarchyIds, 
                                                                               Set<String> locationIds,
                                                                               Set<Id> sellerIds,
                                                                               Id supervisorId) {

        set<Id>  ReslocationHierarchy = new set<Id> ();                                                                     
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        String[] surveymapFields = new String[] {'ivybase__Store_Hierarchy__c', 'ivybase__Location_Hierarchy__c', 'ivybase__Survey__c', 'ivybase__Store__c', 'ivybase__User__c'}; 
        String[] surveyResultFields = new String[] {'ivybase__Survey__c','ivybase__Store__c','Target_Score__c','Achieved_Score__c'};
        String[] surveyFields = new String[] {'ivybase__Frequency_Type__c','ivybase__Internal_Id__c','ivybase__Complete_Survey_On_All_Question_Answered__c'};
        String[] salonCategoryFields=new String[]{'Location_Hierarchy__c'};
        List<ivybase__Resource__c> resource = [select id,ivybase__Related_User__c,ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:UserInfo.getUserId()];

        for(ivybase__Resource__c r:resource)
        {
            ReslocationHierarchy.add(r.ivybase__Location_Hierarchy__c);
        }
        if (SecurityUtility.checkIsAccessible('ivybase__Survey_Mapping__c', surveymapFields)
            && SecurityUtility.checkIsAccessible('ivybase__Survey_Result__c', surveyResultFields)
            && SecurityUtility.checkIsAccessible('ivybase__Survey__c', surveyFields) && SecurityUtility.checkIsAccessible('Salon_Catagory__c', salonCategoryFields)) { 

            Set<Id> surIds = new Set<Id>();
            List<ivybase__Survey_Result__c> surveyResultList = new List<ivybase__Survey_Result__c>();
            Map<String,Integer> tempmap = new Map<String,Integer>{'Monday'=>0,'Tuesday'=>-1,'Wednesday'=>-2,'Thursday'=>-3,'Friday'=>-4,'Saturday'=>-5,'Sunday'=>-6};
            Set<String> surveyStoreIdSet = new Set<String>();

            for (ivybase__Survey_Mapping__c smm : [SELECT Id,
                                                   ivybase__Survey__c,
                                                   ivybase__Internal_Id__c,
                                                   ivybase__Survey__r.ivybase__Frequency_Type__c
                                                   FROM ivybase__Survey_Mapping__c
                                                   WHERE 
                                                   ivybase__Survey__c != null
                                                   AND
                                                   ivybase__Survey__r.ivybase__Frequency_Type__c != NULL
                                                   AND
                                                   ivybase__Survey__r.ivybase__Active__c  = true
                                                   AND 
                                                   (ivybase__Survey__r.ivybase__To__c = NULL OR ivybase__Survey__r.ivybase__To__c >= :surveyProcessDate)
                                                   AND 
                                                   (ivybase__Survey__r.ivybase__From__c = NULL OR ivybase__Survey__r.ivybase__From__c <= :surveyProcessDate)
                                                   AND 
                                                   ( 
                                                       (ivybase__Store_Hierarchy__c != NULL AND ivybase__Store_Hierarchy__c IN:storeHierarchyIds)
                                                       OR (ivybase__Store__c != NULL AND ivybase__Store__c IN:storeIds)
                                                       OR (ivybase__Location_Hierarchy__c != NULL AND ivybase__Location_Hierarchy__c IN:locationIds)
                                                       OR (ivybase__Territory__c != NULL AND ivybase__Territory__c IN:locationIds)
                                                       OR (ivybase__Resource__c != null AND ivybase__Resource__c IN:sellerIds)
                                                       OR (ivybase__Resource__c != null AND ivybase__Resource__c =:supervisorId)

                                                   )
                                                  ]) {
                surIds.add(smm.ivybase__Survey__c);
            }

            Datetime currentDay = System.now();
            Datetime startOfWeek = System.today().addDays(tempmap.get(DateTime.newInstance(System.today(), Time.newInstance(0, 0, 0, 0)).format('EEEE')));
            Datetime startOfMonth = System.today().toStartofMonth();
            Datetime minDate = startOfMonth;
            if(minDate > startOfWeek){

                minDate = startOfWeek;          
            }       

            for(ivybase__Survey_Result__c SurRes : [SELECT Id, ivybase__Survey__c, ivybase__Survey__r.ivybase__Frequency_Type__c,ivybase__Store__c,CreatedDate,
                                                    ivybase__Survey__r.ivybase__Internal_Id__c,ivybase__Store__r.ivybase__Internal_Id__c,Target_Score__c,Achieved_Score__c
                                                    FROM ivybase__Survey_Result__c
                                                    WHERE
                                                    ivybase__Survey__c IN :surIds
                                                    AND
                                                    ivybase__Resource__c IN :sellerIds
                                                    AND 
                                                    CreatedDate >= :minDate
                                                    ORDER BY 
                                                    CreatedDate DESC
                                                   ]) {

                DateTime createdDateTime = SurRes.CreatedDate;
                Date createdDate = date.newinstance(createdDateTime.year(), createdDateTime.month(), createdDateTime.day());

                if(((SurRes.ivybase__Survey__r.ivybase__Frequency_Type__c == 'Weekly' && SurRes.CreatedDate >= startOfWeek && SurRes.CreatedDate <= currentDay)
                    || (SurRes.ivybase__Survey__r.ivybase__Frequency_Type__c == 'Monthly' && SurRes.CreatedDate >= startOfMonth && SurRes.CreatedDate <= currentDay)
                    || (SurRes.ivybase__Survey__r.ivybase__Frequency_Type__c == 'Daily' && createdDate == System.today()))
                   && !surveyStoreIdSet.contains(SurRes.ivybase__Survey__c+'-'+SurRes.ivybase__Store__c)){

                    surveyResultList.add(SurRes);
                    surveyStoreIdSet.add(SurRes.ivybase__Survey__c+'-'+SurRes.ivybase__Store__c);
                }
            } 
            return surveyResultList;
        } else {
            String nonAccessObjFld = '';
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey_Mapping__c', surveymapFields);
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey_Result__c', surveyResultFields);
            nonAccessObjFld += SecurityUtility.check_Is_Accessible('ivybase__Survey__c', surveyFields);
            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS',nonAccessObjFld);
        }

    }
    public static map<String,ivybase__Question_Answer_Option__c> returnAnswerOptions()
    {
        map<string,ivybase__Question_Answer_Option__c> answerOptionMap=new map<string,ivybase__Question_Answer_Option__c>();
        String[] answerOptionFields = new String[] {'ivybase__Option_Id__c','ivybase__Answer_Option__c'}; 
        if (SecurityUtility.checkIsAccessible('ivybase__Question_Answer_Option__c', answerOptionFields))
        {

            list<ivybase__Question_Answer_Option__c> options=[select id,ivybase__Option_Id__c,ivybase__Answer_Option__r.name from ivybase__Question_Answer_Option__c];
            for(ivybase__Question_Answer_Option__c op:options)
            {
                answerOptionMap.put(op.ivybase__Option_Id__c,op);
            }
        }
        else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
        return answerOptionMap;
    }

}