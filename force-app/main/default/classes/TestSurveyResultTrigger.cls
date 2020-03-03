@isTest
private class TestSurveyResultTrigger {
    static TestMethod void createModuleRec() {
        Test.startTest();
        Id retailAccountRTId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account') != null ? Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId() : null;
        ivybase__Resource__c res = new ivybase__Resource__c(Name = 'test 1', ivybase__Related_User__c = userinfo.getUserId());
        insert res;
        Account a = new Account (name = 'Test', ivybase__Active__c = 'Yes', RecordTypeId = retailAccountRTId);
        insert a;
        
        ivybase__Visit__c v = new ivybase__Visit__c (ivybase__Resource__c = res.Id, ivybase__Store__c = a.Id, ivybase__Status__c = 'Completed');
        insert v;
        
        ivybase__Question__c q= new ivybase__Question__c(Name = 'Test', ivybase__Question__c= 'What is your question?' );
        insert q;
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Channel';
        slm1.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm1;
        
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
                                    new Account(Name = 'testone', ivybase__Active__c = 'Yes', ivybase__Resource__c = res.Id,
                                                ivybase__Store_Hierarchy__c  = storeHierarchies[0].Id, RecordTypeId=accRecType),
                                    new Account(Name = 'testtwo', ivybase__Active__c = 'Yes',ivybase__Resource__c = res.Id,
                                                ivybase__Store_Hierarchy__c  = storeHierarchies[1].Id, RecordTypeId=accRecType),
                                    new Account(Name = 'testthree', ivybase__Active__c = 'Yes',ivybase__Resource__c = res.Id,
                                                ivybase__Store_Hierarchy__c  = storeHierarchies[2].Id, RecordTypeId=accRecType),
                                    new Account(Name = 'testfour', ivybase__Active__c = 'Yes',ivybase__Resource__c = res.Id,
                                                ivybase__Location_Hierarchy__c = locationHierarchies[0].Id, RecordTypeId=accRecType),
                                    new Account(Name = 'testfive', ivybase__Active__c = 'Yes',ivybase__Resource__c = res.Id,
                                                ivybase__Location_Hierarchy__c = locationHierarchies[1].Id, RecordTypeId=accRecType)                                    
                                };
        insert accList;
        
        for(Account acc : accList) {
            acc.ivybase__Active__c = 'Yes';
        }
        update accList;
        
        List<ivybase__Survey__c> surveyList = new List<ivybase__Survey__c> {
            new ivybase__Survey__c(Name = 'Surveyone', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true,ivybase__From__c = System.today(),ivybase__To__c = System.today(),ivybase__Sequence_Number__c = 1,ivybase__Maximum_Bonus_Points__c = 10),
            new ivybase__Survey__c(Name = 'Surveytwo', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true),
            new ivybase__Survey__c(Name = 'Surveythree', ivybase__Type__c = 'User', ivybase__User_Type__c = 'Seller', ivybase__HHT_Menu__c = 'Home Menu', ivybase__Active__c=true),
            new ivybase__Survey__c(Name = 'Surveyfour', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true),
            new ivybase__Survey__c(Name = 'Surveyfive', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu', ivybase__Active__c=true)                                              
        };
       
        insert surveyList;
        
        /*Resource__c res = new Resource__c(Name='Resource', Related_User__c = UserInfo.getUserId());
        insert res;*/
        
        List<ivybase__Survey_Mapping__c> surveyMappingList = new List<ivybase__Survey_Mapping__c> {
            new ivybase__Survey_Mapping__c(Name = 'Surveymapone',ivybase__Survey__c = surveyList[0].Id, ivybase__Store_Hierarchy__c = storeHierarchies[0].Id),
            new ivybase__Survey_Mapping__c(Name = 'Surveymapto',ivybase__Survey__c = surveyList[1].Id, ivybase__Store_Hierarchy__c = storeHierarchies[1].Id),
            new ivybase__Survey_Mapping__c(Name = 'Surveymatre',ivybase__Survey__c = surveyList[2].Id, ivybase__Resource__c = res.Id),
            new ivybase__Survey_Mapping__c(Name = 'Surveymafr',ivybase__Survey__c = surveyList[4].Id, ivybase__Location_Hierarchy__c = locationHierarchies[0].Id),
            new ivybase__Survey_Mapping__c(Name = 'Surveymapfv',ivybase__Survey__c = surveyList[0].Id, ivybase__Location_Hierarchy__c = locationHierarchies[1].Id)
        };
        
        insert surveyMappingList;                
        
        List<ivybase__Question__c> questionList = new List<ivybase__Question__c> {
                                            new ivybase__Question__c(Name = 'question1', ivybase__Is_Mandatory__c = true, ivybase__Is_Evidence_Required__c = true, ivybase__Minimum_Number_of_Evidences__c = 1, ivybase__Maximum_Number_of_Evidences__c = 3,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Option'),
                                            new ivybase__Question__c(Name = 'question2', ivybase__Is_Mandatory__c = true, ivybase__Is_Evidence_Required__c = true, ivybase__Minimum_Number_of_Evidences__c = 1, ivybase__Maximum_Number_of_Evidences__c = 3,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Option'),
                                            new ivybase__Question__c(Name = 'question3', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue'),
                                            new ivybase__Question__c(Name = 'question4', ivybase__Is_Mandatory__c = false, ivybase__Is_Evidence_Required__c = false,ivybase__Question__c = 'Testqueue',ivybase__Question_Type__c = 'Option')
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
                                            new ivybase__Survey_Question__c (ivybase__Question__c = questionList[3].Id, ivybase__Survey__c = surveyList[3].Id)                                            
                                        };
        insert surQuesList;
        List<ivybase__Survey_Result__c> survey_ResultList = new List<ivybase__Survey_Result__c> {
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[0].Id, ivybase__Visit__c = v.Id),
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[1].Id, ivybase__Visit__c = v.Id),
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[2].Id, ivybase__Visit__c = v.Id),
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[3].Id, ivybase__Visit__c = v.Id)
                                                
                                        };
        insert survey_ResultList;
        
        List<ivybase__Survey_Result__c> survey_ResultList2 = new List<ivybase__Survey_Result__c> {
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[0].Id, ivybase__Visit__c = v.Id),
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[1].Id, ivybase__Visit__c = v.Id),
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[2].Id, ivybase__Visit__c = v.Id),
                                                new ivybase__Survey_Result__c(ivybase__Survey__c = surveyList[3].Id, ivybase__Visit__c = v.Id)
                                                
                                        };
        insert survey_ResultList2;
        system.debug('current user'+UserInfo.getUserId());
        SurveyResultTriggerHandler.moduleWiseLastVisit(survey_ResultList);
        SurveyResultTriggerHandler.moduleWiseLastVisit(survey_ResultList2);
        ModuleWiseLastVisitService.getModuleWiseLastVisits('tets', new SET<Id>());
        
        
        Test.stopTest();        
        
    }
}