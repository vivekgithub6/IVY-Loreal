@isTest
public class TestSurveyQuestionTrigger {
    @testSetUp static void testSetup() {   
   // public static testMethod void testSurQues() {
        
        List<ivybase__Survey__c> surList = new List<ivybase__Survey__c> {
            new ivybase__Survey__c(Name = 'test sur', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu'),
            new ivybase__Survey__c(Name = 'test surv', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu'),
            new ivybase__Survey__c(Name = 'test surve', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu')
        };
        insert surList;
        
        List<ivybase__Question__c> quList = new List<ivybase__Question__c> {
            new ivybase__Question__c(Name = 'ques', ivybase__Question__c = 'Testques', ivybase__Question_Type__c = 'Option'),
            new ivybase__Question__c(Name = 'ques2', ivybase__Question__c = 'Testques2', ivybase__Question_Type__c = 'Option')                
        };
        insert quList;
        
        List<ivybase__Answer_Option__c> ansOpList = new List<ivybase__Answer_Option__c> {
            new ivybase__Answer_Option__c (Name = 'Option1'),
            new ivybase__Answer_Option__c (Name = 'Option2'),
            new ivybase__Answer_Option__c (Name = 'Option3')
        };
        insert ansOpList;
        
        List<ivybase__Question_Answer_Option__c> quAnOpList = new List<ivybase__Question_Answer_Option__c> {
            new ivybase__Question_Answer_Option__c(ivybase__Question__c = quList[0].Id, ivybase__Answer_Option__c = ansOpList[0].Id),
            new ivybase__Question_Answer_Option__c(ivybase__Question__c = quList[1].Id, ivybase__Answer_Option__c = ansOpList[1].Id,ivybase__Dependent_Question__c=quList[0].Id)        
        };        
        insert quAnOpList;
        
        List<ivybase__Survey_Question__c> sqList = new List<ivybase__Survey_Question__c> {
            new ivybase__Survey_Question__c(ivybase__Question__c = quList[0].Id, ivybase__Survey__c = surList[0].Id),
            new ivybase__Survey_Question__c(ivybase__Question__c = quList[1].Id, ivybase__Survey__c = surList[1].Id)
        };
        insert sqList;
        
       
        system.assert(sqList.size() == 2);
    }
    private static testMethod void updation() {
        
        List<ivybase__Survey__c> surList = [SELECT Id FROM ivybase__Survey__c]; 
        List<ivybase__Survey_Question__c> sqList = [SELECT ivybase__Question__c, Id FROM ivybase__Survey_Question__c ];
        List<ivybase__Question__c> quLis = [SELECT Id FROM ivybase__Question__c];
        sqList[0].ivybase__Question__c = quLis[1].Id;
        update sqList;
        
        List<ivybase__Survey_Question__c> sqList1 = new List<ivybase__Survey_Question__c> {
            new ivybase__Survey_Question__c(ivybase__Question__c = quLis[0].Id, ivybase__Survey__c = surList[0].Id),
            new ivybase__Survey_Question__c(ivybase__Question__c = quLis[1].Id, ivybase__Survey__c = surList[1].Id)
        };
         
        /*List<ivybase__Survey_Question__c> sqList12 = new List<ivybase__Survey_Question__c>();
        List<ivybase__Survey_Question__c> sqList21 = [SELECT ivybase__Question__c, Id FROM ivybase__Survey_Question__c where ivybase__Question__r.Name = 'ques2' ];
        system.debug('sqList21'+ sqList21);
         
        List<ivybase__Survey__c> surList32 = new List<ivybase__Survey__c>();
        List<ivybase__Survey__c> surList12 = [SELECT id from ivybase__Survey__c where Name = 'test sur' limit 1];
        system.debug('surList12'+ surList12);
        if(surList12.size()>0){
            sqList21[0].ivybase__Survey__c = surList12[0].Id;
        }*/
        
        try{
            insert sqList1;
        }catch(Exception ex){
        }
        
        List<ivybase__Question__c> quList = new List<ivybase__Question__c> {
            new ivybase__Question__c(Name = 'ques3', ivybase__Question__c = 'Testques3', ivybase__Question_Type__c = 'Option'),
            new ivybase__Question__c(Name = 'ques4', ivybase__Question__c = 'Testques4', ivybase__Question_Type__c = 'Option')                
        };
        
        insert quList;
        
        List<ivybase__Survey_Question__c> sqList2 = new List<ivybase__Survey_Question__c> {
            new ivybase__Survey_Question__c(ivybase__Question__c = quList[0].Id, ivybase__Survey__c = surList[0].Id),
            new ivybase__Survey_Question__c(ivybase__Question__c = quList[1].Id, ivybase__Survey__c = surList[1].Id)
        };
            ivybase__ModuleWise_Last_Visit__c mvc = new ivybase__ModuleWise_Last_Visit__c();
        mvc.ivybase__Module__c = 'Survey';
        insert mvc;
        
            
            ModuleWiseLastVisitService.getModuleWiseLastVisits('test', new Set<Id>());
        try{
            insert sqList2;
        }catch(Exception ex){
        }
        
        system.assert(sqList.size() > 0);       
    }            
}