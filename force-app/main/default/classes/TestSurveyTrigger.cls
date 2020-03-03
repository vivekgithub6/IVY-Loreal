@isTest
public class TestSurveyTrigger {
    @testSetUp static void setUp() { 
              
        List<ivybase__Location_Hierarchy__c> lhList = new List<ivybase__Location_Hierarchy__c> {
                                             new ivybase__Location_Hierarchy__c(Name = 'lh1', ivybase__Active__c     = 'Yes')};
        insert lhList;
        
        List<ivybase__Product_Hierarchy__c> pHierarchyList = new List<ivybase__Product_Hierarchy__c>
                                                     { new ivybase__Product_Hierarchy__c(ivybase__Active__c = 'Yes',ivybase__Is_Competitor__c = false),
                                                     new ivybase__Product_Hierarchy__c(ivybase__Active__c = 'Yes',ivybase__Is_Competitor__c = true)};
        insert pHierarchyList;
                                   
        List<ivybase__Store_Hierarchy__c> shList = new List<ivybase__Store_Hierarchy__c> {
                                          new ivybase__Store_Hierarchy__c(Name = 'Sh1', ivybase__Active__c  = 'Yes'),
                                          new ivybase__Store_Hierarchy__c(Name = 'Sh2', ivybase__Active__c  = 'Yes'),
                                          new ivybase__Store_Hierarchy__c(Name = 'Sh3', ivybase__Active__c  = 'Yes')};
        insert shList; 
                                                                                                                                                
        List<ivybase__Survey__c> surveyList1 = new List<ivybase__Survey__c> {
                                     new ivybase__Survey__c(Name = 'test sur', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu'),
                                     new ivybase__Survey__c(Name = 'sm', ivybase__Type__c = 'User', ivybase__HHT_Menu__c = 'Home Menu',ivybase__User_Type__c = 'Supervisor'),
                                     new ivybase__Survey__c(Name = 'sms', ivybase__Type__c = 'User', ivybase__HHT_Menu__c = 'Home Menu',ivybase__User_Type__c = 'Seller'),
                                     new ivybase__Survey__c(Name = 'tests', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu') };
        insert surveyList1;
        
        ivybase__Survey__c svy = new ivybase__Survey__c(Name = 'test surtest', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu');
        insert svy;
        
        System.assert(SurveyList1.size() == 4);
        
    }
    
    public static testMethod void dupeNameCheckOnSurveyInsert() {         
        
        List<ivybase__Survey__c> surveyList = new List<ivybase__Survey__c> {
                                     new ivybase__Survey__c(Name = 'testsu', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu')};
        insert surveyList;
        
        //Throws an Exception while inserting with already existing survey name.
        List<ivybase__Survey__c> surveyList1 = new List<ivybase__Survey__c> {
                                     new ivybase__Survey__c(Name = 'testsu', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu')};
        try {
            insert surveyList1;
        } catch(Exception e) {
            System.assert(e.getMessage().contains('A Record with same Name exists.'));
        } 
        
        //Throws validation error while inserting survey name with number.                             
        List<ivybase__Survey__c> surveyList3 = new List<ivybase__Survey__c> {
                                     new ivybase__Survey__c(Name = 'testsurve1', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu'),
                                     new ivybase__Survey__c(Name = 'testsurvey2', ivybase__Type__c = 'User', ivybase__HHT_Menu__c = 'Home Menu')};
        try {                             
            insert surveyList3;
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Cannot contain numeric values.'));
        } 
        
        //Throws validation error while inserting survey with improper type.                             
        List<ivybase__Survey__c> surveyList4 = new List<ivybase__Survey__c> {
                                     new ivybase__Survey__c(Name = 'testsurve', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Home Menu'),
                                     new ivybase__Survey__c(Name = 'testsurveys', ivybase__Type__c = 'User', ivybase__HHT_Menu__c = 'Home Menu')};
        try {                             
            insert surveyList4;
        } catch(Exception e) {
            System.assert(e.getMessage().contains('Please select appropriate Survey Type'));
        } 
    }
    
    public static testMethod void dupeNameCheckOnSurveyUpdate() {
    
    //Throws an Exception while updating with already existing name.
        List<ivybase__Survey__c> surveyList = [SELECT Name, ivybase__Type__c FROM ivybase__Survey__c WHERE Id != null];
            surveyList[1].name =  surveyList[0].name;
        try {                             
            update surveyList;
        } catch(Exception e) {
            System.assert(e.getMessage().contains('A Record with same Name exists.'));
        } 
        
    }                     
    
    public static testMethod void updateSellerType() { 
        
        List<ivybase__Survey__c> surveyList = [SELECT Name, ivybase__Type__c FROM ivybase__Survey__c WHERE Id != null];
        List<ivybase__Store_Hierarchy__c> shList = [SELECT Name, ivybase__Active__c FROM ivybase__Store_Hierarchy__c WHERE Id != null]; 
        List<ivybase__Product_Hierarchy__c> pHierarchyList = [SELECT Name, ivybase__Active__c, ivybase__Is_Competitor__c FROM ivybase__Product_Hierarchy__c WHERE Id != null];                                
        List<ivybase__Survey_Mapping__c> smList1 = new List<ivybase__Survey_Mapping__c> {
                                          new ivybase__Survey_Mapping__c( Name = 'sm', ivybase__Product_Hierarchy__c = pHierarchyList[0].id,ivybase__Survey__c = surveyList[0].id,ivybase__Store_Hierarchy__c = shList[0].id )
                                          };
        SurveyTriggerHandler.checkDup(surveyList,null);
        insert smList1;
        //Throws an Exception while changing survey Type 
        surveyList[1].Name = 'ss';
        surveyList[0].Name = 'Survey';
        surveyList[0].ivybase__Type__c = 'User';
        surveyList[0].ivybase__HHT_Menu__c = 'Home Menu';
        surveyList[0].ivybase__User_Type__c = 'Seller';
        
        
        
        
        
        try {
            update surveyList;
            //update surveyList2;
        }
        catch(Exception e ) {
            System.assert(e.getMessage().contains('The Store type survey mapped some store/store hierarchy/location hierarchy, If you want to change user type, Delete survey mapping records mapped with store or store hierarchy or location hierarchy'));
        }
        try{
            List<ivybase__Survey__c> abc= new List<ivybase__Survey__c>();
            List<ivybase__Survey__c> surveyList2 = [SELECT Name, ivybase__Type__c FROM ivybase__Survey__c WHERE Id != null and name='sm'];
            system.debug('surveyList2'+ surveyList2);
            surveyList2[0].ivybase__Type__c = 'Store';
            abc.add(surveyList2[0]);
            system.debug('abc'+ abc);
            update abc;
        }
        catch(Exception e ) {
            //System.assert(e.getMessage().contains('The Store type survey mapped some store/store hierarchy/location hierarchy, If you want to change user type, Delete survey mapping records mapped with store or store hierarchy or location hierarchy'));
        }
    } 
    
    public static testMethod void updateUserType() {
        
        Id conRec = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        
        Contact con = new Contact(RecordTypeId = conRec,Lastname = 'Raam'); 
        insert con;
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name='Resource', ivybase__Related_User__c  = UserInfo.getUserId());
        insert res;
        
        ivybase__Survey__c surv2 = new ivybase__Survey__c(Name = 'tests sur',ivybase__User_Type__c = 'Seller', ivybase__Type__c = 'User', ivybase__HHT_Menu__c = 'Home Menu' );
        insert surv2;
        
        ivybase__Survey_Mapping__c sur8 = new ivybase__Survey_Mapping__c(Name = 'testerTwo',ivybase__Survey__c = surv2.Id,ivybase__User__c = con.Id,ivybase__Resource__c = res.Id);
        insert sur8;
        
        //Throws an validation error while making User_Type null for user Survey Type.
        surv2.ivybase__User_Type__c = null;
        try {
            update surv2;
        } catch(Exception e) {
            System.assert(e.getMessage().contains('User Type field can be populated only when the Survey Type field is User. Also, if Survey Type is User, User Type should not be blank.'));
        }    
        
        //Throws an Exception while changing  survey Type
        surv2.ivybase__Type__c = 'Store';
        surv2.ivybase__HHT_Menu__c = 'Activity Menu';
        surv2.ivybase__User_Type__c = null;
        
        try{
            update surv2;
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('The User type survey mapped some user, If you want to change user type, Delete usertype mapped survey mapping records'));
        }
    }  
}