@isTest
public class TestRESTSurveyGroup {
    static testMethod void surveyGroup1() {
        
        RestRequest req = new RestRequest(); 
        req.httpMethod = 'Get';
        req.addHeader('Content-Type', 'application/json'); 
        req.addHeader('HeaderInformation','application/json');
        RestContext.request = req;
        
        Id userid = userinfo.getUserId();
        Id RecordTypeId =  Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        Contact con = new Contact(lastName = 'Test', ivybase__Related_User__c = userid,Email = 'test@gmail.com',RecordTypeId =RecordTypeId);
        insert con;
        
        
        ivybase__Resource_Type__c restype1 = new ivybase__Resource_Type__c(name = 'Sales rep');
        insert restype1;
        
        ivybase__Resource__c resource = new ivybase__Resource__c(Name = 'Test', ivybase__Related_User__c = userid,ivybase__Resource_Type__c=restype1.Id);
        insert resource;
        System.debug('*****userid'+userid+'**'+resource.ivybase__Related_User__c);
        
        System.debug('*****query'+[SELECT Id FROM Contact WHERE ivybase__Related_User__c = :userid]);
        
        
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Channel';
        slm1.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm1;
        List<ivybase__Standard_List_Master__c> standardmaster = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Kerastase',ivybase__List_Code__c='KERA', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Loreal Professional',ivybase__List_Code__c='LP', ivybase__List_Type__c = 'DIVISION_TYPE' ,ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Matrix',ivybase__List_Code__c='MX', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Redken and Pureology',ivybase__List_Code__c='R & P', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Currency',ivybase__List_Code__c='CURRENCY', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Email',ivybase__List_Code__c='EMAIL', ivybase__List_Type__c = 'QUESTION_TYPE' ,ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Free Text',ivybase__List_Code__c='FREE_TEXT', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Numeric',ivybase__List_Code__c='NUM', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Option',ivybase__List_Code__c='OPT', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Phone Number',ivybase__List_Code__c='PH_NO', ivybase__List_Type__c = 'QUESTION_TYPE' ,ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Text',ivybase__List_Code__c='TEXT', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Multiple Select',ivybase__List_Code__c='MULTISELECT', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Percentage',ivybase__List_Code__c='PERC', ivybase__List_Type__c = 'QUESTION_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Special',ivybase__List_Code__c='SPECIAL', ivybase__List_Type__c = 'SURVEY_TYPE', ivybase__Resource_Type__c = restype1.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Standard',ivybase__List_Code__c='STANDARD', ivybase__List_Type__c = 'SURVEY_TYPE', ivybase__Resource_Type__c = restype1.Id)
                
                };
                    insert standardmaster;
        List<ivybase__Store_Hierarchy__c> storeHierarchies = new List<ivybase__Store_Hierarchy__c> {
            new ivybase__Store_Hierarchy__c(Name = 'sh1',ivybase__Active__c = 'Yes'),
                new ivybase__Store_Hierarchy__c(Name = 'sh2',ivybase__Active__c = 'Yes'),
                new ivybase__Store_Hierarchy__c(Name = 'sh3',ivybase__Active__c = 'Yes'),
                new ivybase__Store_Hierarchy__c(Name = 'sh4',ivybase__Active__c = 'Yes')
                };
                    insert storeHierarchies;
        List<ivybase__Location_Hierarchy__c> locationHierarchies = new List<ivybase__Location_Hierarchy__c> {
            new ivybase__Location_Hierarchy__c(Name = 'loc1',ivybase__Active__c = 'Yes'),
                new ivybase__Location_Hierarchy__c(Name = 'loc2',ivybase__Active__c = 'Yes'),
                new ivybase__Location_Hierarchy__c(Name = 'loc3',ivybase__Active__c = 'Yes')
                };
                    insert locationHierarchies;
        
        String accRecType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        List<Account> accList = new List<Account> {
            new Account(Name = 'testone', ivybase__Active__c = 'Yes', ivybase__Seller_Name__c = con.Id,ivybase__Resource__c = resource.Id,
                        ivybase__Store_Hierarchy__c = storeHierarchies[0].Id, RecordTypeId=accRecType,Is_Conquest__c=true,Market_ISO__c = 'JPN', No_of_Stylist__c = 1, Color_Price__c = 12),
                new Account(Name = 'testtwo', ivybase__Active__c = 'Yes', ivybase__Seller_Name__c = con.Id,ivybase__Resource__c = resource.Id,
                            ivybase__Store_Hierarchy__c = storeHierarchies[1].Id, RecordTypeId=accRecType),
                new Account(Name = 'testthree', ivybase__Active__c = 'Yes', ivybase__Seller_Name__c = con.Id,ivybase__Resource__c = resource.Id,
                            ivybase__Store_Hierarchy__c = storeHierarchies[2].Id, RecordTypeId=accRecType),
                new Account(Name = 'testfour', ivybase__Active__c = 'Yes', ivybase__Seller_Name__c = con.Id,ivybase__Resource__c = resource.Id,
                            ivybase__Location_Hierarchy__c = locationHierarchies[0].Id, RecordTypeId=accRecType),
                new Account(Name = 'testfive', ivybase__Active__c = 'Yes', ivybase__Seller_Name__c = con.Id,ivybase__Resource__c = resource.Id,
                            ivybase__Location_Hierarchy__c = locationHierarchies[1].Id, RecordTypeId=accRecType)                                    
                };
                    insert accList;
        
        for(Account acc : accList) {
            acc.ivybase__Active__c = 'Yes';
        }
        update accList;
        
        List<ivybase__Survey__c> surveyList = new List<ivybase__Survey__c> {
            new ivybase__Survey__c(Name = 'Surveyone', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true,ivybase__From__c = System.today(),ivybase__To__c = System.today(),ivybase__Sequence_Number__c = 1,ivybase__Maximum_Bonus_Points__c  = 10),
                new ivybase__Survey__c(Name = 'Surveytwo', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true),
                new ivybase__Survey__c(Name = 'Surveythree', ivybase__Type__c = 'User', ivybase__User_Type__c = 'Seller', ivybase__HHT_Menu__c = 'Home Menu', ivybase__Active__c=true),
                new ivybase__Survey__c(Name = 'Surveyfour', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true),
                new ivybase__Survey__c(Name = 'Surveyfive', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true,ivybase__Frequency_Type__c='Weekly')                                              
                };
                    
                    insert surveyList;
        
        /*Resource__c res = new Resource__c(Name='Resource', Related_User__c = UserInfo.getUserId());
insert res;*/
        
        List<ivybase__Survey_Mapping__c> surveyMappingList = new List<ivybase__Survey_Mapping__c> {
            new ivybase__Survey_Mapping__c(Name = 'Surveymapone',ivybase__Survey__c = surveyList[0].Id, ivybase__Store__c = accList[0].Id),
                new ivybase__Survey_Mapping__c(Name = 'Surveymapto',ivybase__Survey__c = surveyList[1].Id, ivybase__Store_Hierarchy__c = storeHierarchies[1].Id),
                new ivybase__Survey_Mapping__c(Name = 'Surveymatre',ivybase__Survey__c = surveyList[2].Id, ivybase__User__c = con.Id,ivybase__Resource__c = resource.Id),
                //new ivybase__Survey_Mapping__c(Name = 'Surveymafr',ivybase__Survey__c = surveyList[4].Id, ivybase__User__c = con.Id),
                new ivybase__Survey_Mapping__c(Name = 'Surveymapfv',ivybase__Survey__c = surveyList[0].Id, ivybase__Location_Hierarchy__c = locationHierarchies[1].Id)
                };
                    
                    insert surveyMappingList;                
        
        List<ivybase__Question__c> questionList = new List<ivybase__Question__c> {
            new ivybase__Question__c(Name = 'question1', ivybase__Is_Mandatory__c = true, ivybase__Is_Evidence_Required__c = true, ivybase__Minimum_Number_of_Evidences__c = 1, ivybase__Maximum_Number_of_Evidences__c = 3,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Option'),
                new ivybase__Question__c(Name = 'question2', ivybase__Is_Mandatory__c = true, ivybase__Is_Evidence_Required__c = true, ivybase__Minimum_Number_of_Evidences__c = 1, ivybase__Maximum_Number_of_Evidences__c = 3,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Option'),
                new ivybase__Question__c(Name = 'question3', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue'),
                new ivybase__Question__c(Name = 'question4', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Option'),
                new ivybase__Question__c(Name = 'question5', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Text'),
                new ivybase__Question__c(Name = 'question6', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Numeric'),
                new ivybase__Question__c(Name = 'question7', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Multiple Select')    
                };                  
                    insert questionList;
        
        List<ivybase__Answer_Option__c> ansOpList = new List<ivybase__Answer_Option__c> {
            new ivybase__Answer_Option__c(Name = 'op1'),
                new ivybase__Answer_Option__c(Name = 'op2'),
                new ivybase__Answer_Option__c(Name = 'op3'),
                new ivybase__Answer_Option__c(Name = 'op4'),
                new ivybase__Answer_Option__c(Name = 'op5')
                };
                    insert ansOpList;
        List<ivybase__Answer_Option__c> ansOpList1 = new List<ivybase__Answer_Option__c> {
            new ivybase__Answer_Option__c(Name = 'ansOpList1op1'),
                new ivybase__Answer_Option__c(Name = 'ansOpList1op2'),
                new ivybase__Answer_Option__c(Name = 'ansOpList1op3'),
                new ivybase__Answer_Option__c(Name = 'ansOpList1op4'),
                new ivybase__Answer_Option__c(Name = 'ansOpList1op5')
                };
                    insert ansOpList1;
        set<id> AOId = new set<id>();
        for(integer i = 0;i<3;i++)
        {
            AOId.add(ansOpList1[i].id);
        }
        SurveyTranslator.deleteAnswerOptions(AOId);
        
        List<ivybase__Question_Answer_Option__c> quesAnsOpList = new List<ivybase__Question_Answer_Option__c> {
            new ivybase__Question_Answer_Option__c(ivybase__Dependent_Question__c = questionList[3].Id, ivybase__Question__c = questionList[0].Id, ivybase__Answer_Option__c = ansOpList[0].Id,Score__c = 20),
                new ivybase__Question_Answer_Option__c(ivybase__Dependent_Question__c = questionList[2].Id, ivybase__Question__c = questionList[1].Id, ivybase__Answer_Option__c = ansOpList[1].Id,Score__c = 30),
                new ivybase__Question_Answer_Option__c(ivybase__Question__c = questionList[3].Id, ivybase__Answer_Option__c = ansOpList[2].Id,Score__c = 10)
                };
                    insert quesAnsOpList;    
        
        ivybase__Question_Group__c qGroup = new ivybase__Question_Group__c();
        qGroup.Name = 'Test Question Group';
        insert qGroup;
        
        List<ivybase__Survey_Question__c> surQuesList = new List<ivybase__Survey_Question__c> {
            new ivybase__Survey_Question__c (ivybase__Question__c = questionList[0].Id, ivybase__Survey__c = surveyList[0].Id,ivybase__Question_Group__c = qGroup.Id),
                
                new ivybase__Survey_Question__c (ivybase__Question__c = questionList[1].Id, ivybase__Survey__c = surveyList[1].Id),
                new ivybase__Survey_Question__c (ivybase__Question__c = questionList[2].Id, ivybase__Survey__c = surveyList[2].Id),
                new ivybase__Survey_Question__c (ivybase__Question__c = questionList[3].Id, ivybase__Survey__c = surveyList[3].Id,ivybase__Sequence_Number__c=1)                                            
                };
        insert surQuesList;
        
        ivybase__Survey_Question__c newSurveyQuestion = new ivybase__Survey_Question__c(ivybase__Question__c = questionList[0].Id, ivybase__Survey__c = surveyList[0].Id,ivybase__Question_Group__c = qGroup.Id);
        //Database.insert(newSurveyQuestion);
        
        set<string> QuestionId = new set<string>();
        for(ivybase__Question__c Qid :questionList)
        {
            QuestionId.add(Qid.id);
        }
        
        list<ivybase__Survey_Result__c> SurveyResultList = new list<ivybase__Survey_Result__c>();
        for(integer i=0;i<5;i++)
        {
            ivybase__Survey_Result__c SR = new ivybase__Survey_Result__c();
            SR.Image_Path__c = 'img/logo214.svg';
            SR.ivybase__Resource__c = resource.id;
            SR.ivybase__Survey__c = surveyList[0].Id ; 
            SR.ivybase__Status__c = 'Complete';
            SR.ivybase__Store__c = accList[0].id;
            SR.Achieved_Score__c = 5;
            SR.Target_Score__c = 7;
            SurveyResultList.add(SR);
        }
        insert SurveyResultList;
        SurveyTranslator.objectToSurveyHistory(SurveyResultList,null);
        
        list<ivybase__Survey_Result_Detail__c> SurveyResultDetailList = new list<ivybase__Survey_Result_Detail__c>();
       
        
        for(integer i=0;i<1;i++)
        {
            ivybase__Survey_Result_Detail__c SRD = new ivybase__Survey_Result_Detail__c();
            SRD.ivybase__Survey_Result__c = SurveyResultList[0].id;
            SRD.ivybase__Survey_Question__c = surQuesList[0].id;
            srd.ivybase__Question1__c = questionList[0].Id;
            //SRD.ivybase__Question__c = questionList[0].Id;
            SRD.ivybase__Actual_Full_Content__c = 'Test Actual';
            SurveyResultDetailList.add(SRD); 
        }
        try{
        insert SurveyResultDetailList;
        } catch ( Exception e){
            system.debug(e);
        }
        SurveyTranslator.objectTolastvisitSurvey(SurveyResultDetailList,null);
        
        list<ivybase__Survey_Image__c> SurveyImageList = new list<ivybase__Survey_Image__c>();
        for(integer i=0;i<1;i++)
        {
            ivybase__Survey_Image__c SI = new ivybase__Survey_Image__c();
            SI.ivybase__Survey_Result_Detail__c = SurveyResultDetailList[0].id;
            SI.Image_Path__c = 'img/logo214.svg';
            SurveyImageList.add(SI);
        }
        insert SurveyImageList;
        SurveyTranslator.objectTolastvisitSurveyImage(SurveyImageList,null);
        
        ivybase__Standard_List_Master__c slm = new ivybase__Standard_List_Master__c();
        slm.ivybase__List_Type__c = 'SURVEY_CRITERIA_TYPE';
        slm.ivybase__List_Name__c ='Option';
        slm.ivybase__List_Code__c ='SPECIAL';
        insert slm;                           
        
        RExAPIResponseDomain.MultipleResponseInfo multipleSurveyResponse = RESTSurveyGroup.getSurveyGroupInfo();
        System.assert(multipleSurveyResponse != null);
        
        List<ivybase__Question__c> questionList1 = [SELECT Id, ivybase__Question_Id__c FROM ivybase__Question__c LIMIT 5];
        Set<String> questionInternalIdSet = new Set<String>{questionList1[0].ivybase__Question_Id__c, questionList1[1].ivybase__Question_Id__c, questionList1[2].ivybase__Question_Id__c};
            SurveyService.getSurveyWithSurveyQuestions(questionInternalIdSet);
        
        List<ivybase__Survey__c> surveyList1 = [SELECT Id ,ivybase__Internal_Id__c FROM ivybase__Survey__c LIMIT 5];
        Set<String> surveyInternalIds = new Set<String>{surveyList1[0].ivybase__Internal_Id__c,surveyList1[1].ivybase__Internal_Id__c,surveyList1[2].ivybase__Internal_Id__c};
            SurveyService.getSurveyWithSurveyQuestions(surveyInternalIds);
        SurveyService.getSurveyIds(surveyInternalIds);
        SurveyService.getSellerStoreHierarchyIds();
        SurveyService.getSurveyMappingwithSurveyIds2(null,null,null,null,null);
        SurveyService.getdepques(quesAnsOpList);
        SurveyService.getSurveyQuestionsByInternalId(QuestionId);
        SurveyService.getAllOptions();
        //SurveyTranslator.surveyRecords2(surveyMappingList,null);
        String Searchstring='Absyz';
        SurveyService.getAllOptions(Searchstring);
        SurveyService.getSurveyResultwithSurveyIds(null,null,null,null,null);
        SurveyService.returnAnswerOptions();
        //SurveyMappingTriggerHandler.checkDup(surveyMappingList,null);
       //   SurveyTranslator.objectToSurveyGroup2(surveyMappingList,surQuesList,surveyMappingList,questionList,quesAnsOpList,quesAnsOpList,null,null,null,null,null,null);
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales rep');
        insert restype;
        
        id GetuserId = UserInfo.getUserId();
        user u =[select id,name from User where id =:GetuserId];
        system.runAs(u){
            
            try{
                RExAPIResponseDomain.MultipleResponseInfo multipleSurveyResponse1 = RESTSurveyGroup.getSurveyGroupInfo();
                System.assert(multipleSurveyResponse1 != null);
            }catch(Exception e){}
            
        }
    }
    static testMethod void surveyGroup2() {
        List<ivybase__Survey_Mapping__c>  SM = new List<ivybase__Survey_Mapping__c>();
        SurveyTranslator.surveyRecords(SM);
        List<ivybase__Survey_Question__c> SQ = new List<ivybase__Survey_Question__c>();
        List<ivybase__Question_Answer_Option__c> QAO = new List<ivybase__Question_Answer_Option__c>();
        set<id> QAID = new set<id>();
        SurveyTranslator.surveyQuestions(SQ,QAO,QAID);
        //List<ivybase__Survey_Mapping__c> SM = new List<ivybase__Survey_Mapping__c>();
        Map<string,string> ListCodeNameMap = new map<string,string>();
        SurveyTranslator.surveyCriteria(SM,ListCodeNameMap);
        List<ivybase__Question__c> QS = new List<ivybase__Question__c>();
        SurveyTranslator.questions(QS,ListCodeNameMap,null,null,QAID);
        SurveyTranslator.questionsAnswerOption(QAO);
        SurveyTranslator.dependentQuestions(QAO);
        SurveyTranslator.getOptionScoreMapping(QAO,null);
        SurveyService.insertOption('TestOption');
        SurveyService.getSurveyQuestionsByInternalId(null);
        //SurveyMappingTriggerHandler.checkDup(null,null);
        SurveyTranslator.surveyRecords2(null,null);
        SurveyTranslator.objectToSurveyGroup2(null,null,null,null,null,null,null,null,null,null,null,null);
        
    }
}