global class AnswerTranslator {
    public static Map<String, Id> visitStoreDateWithVisitSFIdMap = new Map<String, Id>();
    
    global static List<Set<String>> getInternalIds(List<LorealUploadclass.AnswerHeader> AnswerHeader) {
        Set<String> surveyInternalIds = new Set<String>();
        Set<String> storeInternalIds = new Set<String>();
        List<Set<String>> surveyAndStoreInternalIds = new List<Set<String>>();

        system.debug('AnswerHeader******'+AnswerHeader);
        for (LorealUploadclass.AnswerHeader ansHeader :AnswerHeader) {
            if (ansHeader.surveyid != null) {
                surveyInternalIds.add(ansHeader.surveyid);
            }
            if (ansHeader.retailerid != null) {
                storeInternalIds.add(ansHeader.retailerid);
            }                
        }
        surveyAndStoreInternalIds.add(surveyInternalIds);
        surveyAndStoreInternalIds.add(storeInternalIds);    
        return surveyAndStoreInternalIds;       
    }
    global static Set<String> getQuestionInternalId(List<LorealUploadclass.AnswerDetail> AnswerDetail) {    
        Set<String> questionInternalIds = new Set<String>();
        for (LorealUploadclass.AnswerDetail ans :AnswerDetail) {
            if ( ans.qid != null) {
                questionInternalIds.add(ans.qid);
            }
        }
        return questionInternalIds ;
    }
    
    
    public static void uploadAnswer(List<LorealUploadclass.AnswerHeader> ansHeader, List<LorealUploadclass.AnswerDetail> ansDetail,
                                    Map<String, ivybase__Survey__c> surveyInternalIdwithId, Id sellerId, Map<String, Id> storeInternalIdwithId,
                                    Map<String, Id> quetionInternalIdwithId, Map<String, Id> surveyQuestionWithSQIdMap, Map<String, String> reqHeaderParamMap) 
    {
                //s3 code
       system.debug('surveyInternalIdwithId'+ surveyInternalIdwithId);
        list<string> typename= new list<string>();
            typename.add('Amazon_Configuration');
            String hostUrl;
            list<ivybase__Standard_List_Master__c> statusMapListCode= StandardListMasterservice.getStandardListUsingListType(typename);
            map<string,string> statuscode = new map<string,string>();
            if(statusMapListCode!=null)
            {
                for(ivybase__Standard_List_Master__c std:statusMapListCode)
                {
                    if(std.ivybase__List_Code__c=='AS_HOST')
                    {
                        hostUrl=std.ivybase__List_Name__c;
                    }
                }
            }
     
        //Division Id
                map<string,Division__c> SurveyResultMap = new map<string,Division__c>();
                map<string,string> Divisionlovidmap=new map<string,string>();
                for(ivybase__Standard_List_Master__c stdListMaster: StandardListMasterservice.getStandardListUsingListType(new List<String>{('DIVISION_TYPE')}))
                {
                    Divisionlovidmap.put(stdListMaster.Name,stdListMaster.ivybase__List_Name__c);
                    list<Division__c> DivList = [select id,name from Division__c];
                     for(Division__c D : DivList)
                    {
                        SurveyResultMap.put(D.Name,D);
                    }
                }
        Map<String, ivybase__Survey_Result__c> uidwithSurveyResultMap = new Map<String, ivybase__Survey_Result__c>();
        List<ivybase__Survey_Result_Detail__c> surveyResultDetailList = new List<ivybase__Survey_Result_Detail__c>();
        Map<String, String> uidWithSurveyInternalId = new Map<String, String>();
        
        List<ivybase__Survey_Image__c> surveyImageList = new List<ivybase__Survey_Image__c>();
        Map<String,ivybase__Survey_Result_Detail__c> qidwithSurveyResultMap = new Map<String,ivybase__Survey_Result_Detail__c>();
        //Started code for takes all survey or partial
        Map<String, String> sfInternalIdWithUidMap = new Map<String, String>();
        Map<String, String> UidwithsfInternalIdMap = new Map<String, String>();
        Map<String, Integer> SurveyUidwithQuestionCountMap = new Map<String, Integer>();
        Map<String,set<String>> SurIdwithSurquesIdMap = new Map<String,set<String>>();
        set<string> accountinterid= new set<string>();
        if(ansHeader != null && ansHeader.size() > 0)
        {
            for (LorealUploadclass.AnswerHeader ansHd :ansHeader) {
                sfInternalIdWithUidMap.put(ansHd.surveyid, ansHd.uid);
                UidwithsfInternalIdMap.put(ansHd.uid,ansHd.surveyid);
                accountinterid.add(ansHd.retailerid);
            }
        }
          //get the acocunt record by sending account internalids 
        Map<String,Account> internalbasedAccount=AccountService.getAccountByInternalId(accountinterid);
        list<string> accSFIdList=new list<String>();
        //add the account ids to a list
        for(Account acc : internalbasedAccount.values()){
            accSFIdList.add(acc.Id);
        }
        
        //get the visitlist by passing accountids and resource
        String sellerId2 = ResourceService.getLoginSellerId();
        List<ivybase__Visit__c> visitList = ivype.VisitFacade.getVisitList(accSFIdList,sellerId2);
        system.debug('visitList'+visitList);
        if (sfInternalIdWithUidMap != null && sfInternalIdWithUidMap.size() > 0) {
            List<ivybase__Survey__c> surveywithQuestions = SurveyService.getSurveyWithSurveyQuestions(sfInternalIdWithUidMap.keySet());
            if (surveywithQuestions != null && surveywithQuestions.size() > 0) {
                for (ivybase__Survey__c surveyWithQues: surveywithQuestions ) {
                    if (sfInternalIdWithUidMap.containsKey(surveyWithQues.ivybase__Internal_Id__c)) {
                        SurveyUidwithQuestionCountMap.put(sfInternalIdWithUidMap.get(surveyWithQues.ivybase__Internal_Id__c), surveyWithQues.ivybase__Survey_Questions__r.size());
                    }
                    for(ivybase__Survey_Question__c sq : surveyWithQues.ivybase__Survey_Questions__r){
                        if(!SurIdwithSurquesIdMap.containskey(surveyWithQues.ivybase__Internal_Id__c)){
                            SurIdwithSurquesIdMap.put(surveyWithQues.ivybase__Internal_Id__c,new Set<String>());
                        }
                        SurIdwithSurquesIdMap.get(surveyWithQues.ivybase__Internal_Id__c).add(sq.ivybase__Question__r.ivybase__Question_Id__c);
                    }
                }
            }
        }
        Map<String, Integer> surveyUidwithAnswersCountMap = new Map<String, Integer>();
        
        Map<String, Id> quesAnsOptionIdwithSFIdMap = new Map<String, Id>();
        Set<String> answerOptionIdSet = new Set<String>();
        if(ansDetail!=null && ansDetail.size() > 0)
        {
            for (LorealUploadclass.AnswerDetail ans :ansDetail) {
                if (String.isNotBlank(ans.answerid) && ans.answerid != '0') {
                    answerOptionIdSet.add(ans.answerid);
                }
                if(UidwithsfInternalIdMap.containskey(ans.uid) && SurIdwithSurquesIdMap.containskey(UidwithsfInternalIdMap.get(ans.uid))){
                    system.debug('map value'+ UidwithsfInternalIdMap.get(ans.uid));
                    system.debug('qid'+ ans.qid);
                    if(SurIdwithSurquesIdMap.get(UidwithsfInternalIdMap.get(ans.uid)).contains(ans.qid)){
                        
                        if (!surveyUidwithAnswersCountMap.containsKey(ans.uid)) {
                            surveyUidwithAnswersCountMap.put(ans.uid, 1);
                        } else {
                            surveyUidwithAnswersCountMap.put(ans.uid, surveyUidwithAnswersCountMap.get(ans.uid)+ 1) ;
                        }
                    }
                }
            }
        }
        if (answerOptionIdSet != null && answerOptionIdSet.size() > 0) {
            for (ivybase__Question_Answer_option__c qao : [SELECT id, ivybase__Option_Id__c FROM ivybase__Question_Answer_option__c WHERE ivybase__Option_Id__c IN:answerOptionIdSet]) {
                quesAnsOptionIdwithSFIdMap.put(qao.ivybase__Option_Id__c, qao.id);
            }
        }
        //End code for takes all survey or partial
        if(ansHeader != null && ansHeader.size() > 0)
        {
            
            SET<Integer> hairdresserSet = new SET<Integer>();
            for(LorealUploadclass.AnswerHeader ansHead : ansHeader){
                	hairdresserSet.add(Integer.valueOf(ansHead.userid));
            }
            
            /* Map to store internalId and contactId */
            MAP<String,Id> internalIdAndContactId = new  MAP<String,Id>();
            
            LIST<Contact> hairDresserList= [SELECT ID, Internal_Id__c 
                                            FROM Contact 
                                            WHERE Internal_Id__c IN: hairdresserSet]; 
            
            for(Contact c: hairDresserList){
                if(!internalIdAndContactId.containsKey(String.valueOf(c.Internal_Id__c))){
                    internalIdAndContactId.put(String.valueOf(c.Internal_Id__c),c.Id);
                }
                
            }
            
            for (LorealUploadclass.AnswerHeader ansHead :ansHeader) {
                ivybase__Survey_Result__c sr = new ivybase__Survey_Result__c();
                ivybase__Visit__c visit;
                visit = (internalbasedAccount.get(ansHead.retailerId).Id != null) ? LOrealUploadTranslator.getVisit(visitList,internalbasedAccount.get(ansHead.retailerid).Id,ConversionUtility.StringToDateConversion(ansHead.date_x)): new ivybase__Visit__c();
                system.debug('visit'+visit);
                sr.ivybase__Visit__c=visit!=null ? visit.Id : null;
                if (surveyInternalIdwithId != null && surveyInternalIdwithId.size() > 0 && surveyInternalIdwithId.containsKey(ansHead.surveyid)) {
                    sr.ivybase__Survey__c = surveyInternalIdwithId.get(ansHead.surveyid).Id;
                }
                if (sellerId != null ) {
                    // sr.ivybase__Seller__c = sellerId;
                    sr.ivybase__Resource__c = sellerId;
                }
                
                /* If userId id not equals to null we will capture hair dresser Id */
                if(ansHead.userid != NULL) {
                    if(internalIdAndContactId.containsKey(ansHead.userid))
                    sr.Hair_Dresser__c  = internalIdAndContactId.get(ansHead.userid);
                }
                
                if(ansHead.uid != null){
                    sr.ivybase__Code__c =   ansHead.uid;
                }
                if(ansHead.tgtScore!=null)
                {
                    sr.Target_Score__c=ConversionUtility.StringToDecimal(ansHead.tgtScore);
                }
                if(ansHead.achScore!=null)
                {
                    sr.Achieved_Score__c=ConversionUtility.StringToDecimal(ansHead.achScore);
                }

                if(ansHead.ImagePath!=null && String.isEmpty(ansHead.ImagePath)==false)
                {
                    sr.Image_Path__c=hostUrl+'/'+ansHead.ImagePath;
                }
                //Division Id
                
                if(ansHead.DivisionId!=null && String.isEmpty(ansHead.DivisionId)==false && SurveyResultMap != null && Divisionlovidmap != null && SurveyResultMap.size()>0 && Divisionlovidmap.size()>0 && !test.isRunningTest())
                {
                 sr.Division__c = SurveyResultMap.get(Divisionlovidmap.get(ansHead.DivisionId)).id;
                }
                /*map<string,Division__c> SurveyResultMap = new map<string,Division__c>();
                if(ansHead.DivisionId!=null && String.isEmpty(ansHead.DivisionId)==false)
                {
                list<ivybase__Standard_List_Master__c> DivList = [select id,name,ivybase__List_Type__c,ivybase__List_Name__c,ivybase__List_Code__c from ivybase__Standard_List_Master__c where name= :ansHead.DivisionId];
                    
                 sr.Division__c = SurveyResultMap.get(ansHead.DivisionId).id;
                }*/
               // sr.Mobile_VisitID__c = ansHead.VisitId;
                /*system.debug('::: surveyUidwithAnswersCountMap:::'+ surveyUidwithAnswersCountMap);
                system.debug(':::SurveyUidwithQuestionCountMap:::'+SurveyUidwithQuestionCountMap);
                system.debug('surveyInternalIdwithId'+surveyInternalIdwithId);*/
                // 
                if(surveyInternalIdwithId!=null && surveyInternalIdwithId.containsKey(ansHead.surveyid) && surveyInternalIdwithId.get(ansHead.surveyid).ivybase__Complete_Survey_On_All_Question_Answered__c !=null) {
                //if(Test.isRunningTest()) { 
                    if (SurveyUidwithQuestionCountMap != null && SurveyUidwithQuestionCountMap.size() > 0 
                        && surveyUidwithAnswersCountMap != null && surveyUidwithAnswersCountMap.size() > 0
                        && SurveyUidwithQuestionCountMap.containskey(ansHead.uid) 
                        && surveyUidwithAnswersCountMap.containskey(ansHead.uid) 
                        && SurveyUidwithQuestionCountMap.get(ansHead.uid) <= surveyUidwithAnswersCountMap.get(ansHead.uid)) {
                            
                            sr.ivybase__Status__c = 'Complete';
                            
                        } else {
                            sr.ivybase__Status__c = 'Incomplete';
                        }
                } else {
                    sr.ivybase__Status__c = 'Complete';
                }
                if (ansHead.retailerid != null && ansHead.date_x != null && visitStoreDateWithVisitSFIdMap != null 
                    && visitStoreDateWithVisitSFIdMap.size() > 0 && visitStoreDateWithVisitSFIdMap.containsKey(sellerId+''+ansHead.retailerid+''+ansHead.date_x)) {
                        sr.ivybase__Visit__c = visitStoreDateWithVisitSFIdMap.get( sellerId + '' + ansHead.retailerid+''+ansHead.date_x);
                    }
                if (storeInternalIdwithId != null && storeInternalIdwithId.size() > 0 && storeInternalIdwithId.containsKey(ansHead.retailerid)) {
                    sr.ivybase__Store__c = storeInternalIdwithId.get(ansHead.retailerid);
                }
                uidwithSurveyResultMap.put(ansHead.uid, sr);
                uidWithSurveyInternalId.put(ansHead.uid, ansHead.surveyid);
            }
        }
        
        
        if (uidwithSurveyResultMap != null && uidwithSurveyResultMap.size() > 0) {
            String[] survey_ResultFields = new String[] { 'ivybase__Survey__c','ivybase__Seller__c','ivybase__Store__c','ivybase__Code__c','ivybase__Visit__c','ivybase__Status__c'};
                String[] survey_ResultDetailFields = new String[] { 'ivybase__Score__c','ivybase__Actual__c','ivybase__Survey_Question__c','ivybase__Actual_Full_Content__c','ivybase__Question1__c'};
                    if (SecurityUtility.checkIsCreateable('ivybase__Survey_Result__c', survey_ResultFields )
                        && SecurityUtility.checkIsCreateable('ivybase__Survey_Result_Detail__c', survey_ResultDetailFields)) {
                            insert uidwithSurveyResultMap.values();
                            if(ansDetail != null && ansDetail.size() > 0)
                            {
                                for (LorealUploadclass.AnswerDetail ans :ansDetail) {
                                    if (uidwithSurveyResultMap.containsKey(ans.uid)) {
                                        ivybase__Survey_Result_Detail__c srd = new ivybase__Survey_Result_Detail__c();
                                        
                                        srd.ivybase__Survey_Result__c = uidwithSurveyResultMap.get(ans.uid).Id;
                                        if (ans.score != null) {
                                            srd.ivybase__Score__c = ConversionUtility.StringToDecimal(ans.score);
                                        }

                                        if (!String.isBlank(ans.answer)) {
                                            if (reqHeaderParamMap != null && reqHeaderParamMap.containsKey('ENCODEDECODETEXT') && reqHeaderParamMap.get('ENCODEDECODETEXT') == '1') {
                                                srd.ivybase__Actual_Full_Content__c = EncodingUtil.urlDecode(ans.answer, 'UTF-8');
                                            } else {
                                                srd.ivybase__Actual_Full_Content__c = ans.answer;
                                            }
                                            if (ans.answer.length() > 255) {
                                                if (reqHeaderParamMap != null && reqHeaderParamMap.containsKey('ENCODEDECODETEXT') && reqHeaderParamMap.get('ENCODEDECODETEXT') == '1') {
                                                    srd.ivybase__Actual__c = EncodingUtil.urlDecode(ans.answer.subString(0,255), 'UTF-8');
                                                } else {
                                                    srd.ivybase__Actual__c = ans.answer.subString(0,255);
                                                }
                                            } else {
                                                if (reqHeaderParamMap != null && reqHeaderParamMap.containsKey('ENCODEDECODETEXT') && reqHeaderParamMap.get('ENCODEDECODETEXT') == '1') {
                                                    srd.ivybase__Actual__c = EncodingUtil.urlDecode(ans.answer, 'UTF-8');
                                                } else {
                                                    srd.ivybase__Actual__c = ans.answer;
                                                }
                                                
                                            }
                                        }
                                        if(ans.answerid!=null && !String.isBlank(ans.answerid))
                                        {
                                            map<String,ivybase__Question_Answer_Option__c> options=SurveyService.returnAnswerOptions();
                                            if(options!=null && options.containsKey(ans.answerid))
                                            {
                                                srd.Question_Answer_Option__c=options.get(ans.answerid).Id;
                                                srd.ivybase__Actual__c=options.get(ans.answerid).ivybase__Answer_Option__r.name;
                                            }
                                        }
                                        if (surveyQuestionWithSQIdMap != null && surveyQuestionWithSQIdMap.size() > 0 
                                            && uidWithSurveyInternalId.containsKey(ans.uid)
                                            && surveyQuestionWithSQIdMap.containsKey(uidWithSurveyInternalId.get(ans.uid) + '' + ans.qid)) {
                                                srd.ivybase__Survey_Question__c = surveyQuestionWithSQIdMap.get(uidWithSurveyInternalId.get(ans.uid) + '' + ans.qid);
                                            } 
                                        if (quetionInternalIdwithId != null && quetionInternalIdwithId.size() > 0 && quetionInternalIdwithId.containsKey(ans.qid)) {
                                            //Start SFDC-801 issue 19-09-2018
                                            srd.ivybase__Question1__c = quetionInternalIdwithId.get(ans.qid);
                                            //End SFDC-801 issue 19-09-2018
                                        }  
                                        if (quesAnsOptionIdwithSFIdMap != null && quesAnsOptionIdwithSFIdMap.containskey(ans.answerid)) {
                                            srd.ivybase__Question_Answer_Option__c = quesAnsOptionIdwithSFIdMap.get(ans.answerid);
                                        }
                                        qidwithSurveyResultMap.put(ans.qid+''+ans.uid,srd);                                   
                                        surveyResultDetailList.add(srd);
                                    }                
                                }
                            }
                            system.debug('surveyResultDetailList'+surveyResultDetailList);
                            if (surveyResultDetailList != null && surveyResultDetailList.size() > 0) {
                                insert surveyResultDetailList;
                            }
                        } else {
                            throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','ivybase__Survey_Result__c, ivybase__Survey_Result_Detail__c');
                        }
        }
        
       /* if (qidwithSurveyResultMap != null && qidwithSurveyResultMap.size() > 0) {
            
            String[] survey_ImageFields = new String[] { 'ivybase__Image_Name__c','ivybase__Survey_Result_Detail__c','Image_Path__c'};
                if (SecurityUtility.checkIsCreateable('ivybase__Survey_Image__c', survey_ImageFields )) {
                    if (ansImageDetail != null && ansImageDetail.size() > 0) {
                        for (LorealUploadclass.AnswerImageDetail ansImg :ansImageDetail) {
                            if (qidwithSurveyResultMap.containsKey(ansImg.qid+''+ansImg.uid)) {
                                ivybase__Survey_Image__c surImg = new ivybase__Survey_Image__c();
                                if (qidwithSurveyResultMap != null && qidwithSurveyResultMap.size() > 0 && qidwithSurveyResultMap.containsKey(ansImg.qid+''+ansImg.uid))
                                {
                                    surImg.ivybase__Survey_Result_Detail__c = qidwithSurveyResultMap.get(ansImg.qid+''+ansImg.uid).Id;
                                }
                                
                                if(ansImg.imgName != null)
                                {
                                    surImg.ivybase__Image_Name__c = ansImg.imgName;
                                }
                                if(ansImg.ImagePath != null)
                                {
                                    surImg.Image_Path__c = (ansImg.ImagePath!=null && String.isEmpty(ansImg.ImagePath)==false)?hostUrl+'/'+ansImg.ImagePath:null;
                                }
                                
                                surveyImageList.add(surImg);
                            } 
                            
                        }
                        if (surveyImageList != null && surveyImageList.size() > 0) {
                            insert surveyImageList;
                        }
                    }
                } else {
                    throw new SecurityUtility.ExtSFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS','ivybase__Survey_Image__c');
                }
        }*/
        
    }
}