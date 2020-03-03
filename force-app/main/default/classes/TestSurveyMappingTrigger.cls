@isTest
public class TestSurveyMappingTrigger {
   
    private static testMethod void smInsertion() {
        Id accRec = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        Id conRec = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        
         List<Contact> conList = new List<Contact>
                                { new Contact(LastName = 'Raam', Email = 'test@test.com',RecordTypeId = conRec),
                                  new Contact(LastName = 'Seetha', Email = 'test@test12.com', RecordTypeId = conRec),
                                  new Contact(LastName = 'Seeth', Email = 'test@test3.com', RecordTypeId = conRec),
                                  new Contact(LastName = 'Seethama', Email = 'test22@test.com', RecordTypeId = conRec) 
                                };
        insert conList;   
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name='Resource', ivybase__Related_User__c = UserInfo.getUserId());
        insert res;
                 
        List<Account> accList = new List<Account> 
                                { new Account(Name = 'Sree',recordTypeId = accRec, active__c = 'Yes',Is_Dream_List__c=true),
                                new Account(Name = 'Sri',recordTypeId = accRec, active__c = 'Yes',Is_Dream_List__c=true)};
        insert accList;
        System.assert(accList.size() == 2);
        List<ivybase__Survey__c> surveyList = new List<ivybase__Survey__c> {
                                     new ivybase__Survey__c(Name = 'test sur', ivybase__Type__c = 'Store', ivybase__HHT_Menu__c = 'Activity Menu'),
                                     new ivybase__Survey__c(Name = 'test survey', ivybase__Type__c = 'User', ivybase__HHT_Menu__c = 'Home Menu',ivybase__User_Type__c = 'Seller')};
        insert surveyList;
        List<ivybase__Standard_List_Master__c> stdList = new List<ivybase__Standard_List_Master__c> {
                                                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Channel', ivybase__List_Type__c = 'CHANNEL_HIERARCHY'),
                                                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Channel', ivybase__List_Type__c = 'CHANNEL_HIERARCHY') };
        insert stdlist;
        List<ivybase__Store_Hierarchy__c> shList = new List<ivybase__Store_Hierarchy__c> {
                                          new ivybase__Store_Hierarchy__c(Name = 'Teststore', ivybase__Active__c = 'Yes'),
                                          new ivybase__Store_Hierarchy__c(Name = 'Teststoreone', ivybase__Active__c = 'Yes'),
                                          new ivybase__Store_Hierarchy__c(Name = 'TeststoreTwo', ivybase__Active__c = 'Yes'),
                                          new ivybase__Store_Hierarchy__c(Name = 'Teststorethree', ivybase__Active__c = 'Yes')};
        insert shList;
        List<Account> accList1 = [SELECT Id FROM Account];
        List<ivybase__Location_Hierarchy__c> lhList = new List<ivybase__Location_Hierarchy__c> {
                                             new ivybase__Location_Hierarchy__c(Name = 'lh1', ivybase__Active__c = 'Yes'),
                                             new ivybase__Location_Hierarchy__c(Name = 'lh2', ivybase__Active__c = 'Yes')};
        insert lhList;
        List<ivybase__Survey_Mapping__c > smList = new List<ivybase__Survey_Mapping__c > {
                                          new ivybase__Survey_Mapping__c(Name = 'test surOne', ivybase__Survey__c = surveyList[0].Id, ivybase__Store_Hierarchy__c = shList[0].id),
                                          new ivybase__Survey_Mapping__c(Name = 'test surTwo', ivybase__Survey__c = surveyList[0].Id, ivybase__Store_Hierarchy__c = shList[1].id),
                                          new ivybase__Survey_Mapping__c(Name = 'test surThree', ivybase__Survey__c = surveyList[0].Id, ivybase__Store_Hierarchy__c = shList[2].id),
                                          new ivybase__Survey_Mapping__c(Name = 'test surThree', ivybase__Survey__c = surveyList[1].Id, ivybase__User__c = conList[0].id,ivybase__Resource__c = res.Id),
                                          new ivybase__Survey_Mapping__c(Name = 'test surfour', ivybase__Survey__c = surveyList[1].Id, ivybase__User__c = conList[1].id,ivybase__Resource__c = res.Id),
                                          new ivybase__Survey_Mapping__c(Name = 'test surfour', ivybase__Survey__c = surveyList[0].Id, ivybase__Location_Hierarchy__c = lhList[0].id),
                                          new ivybase__Survey_Mapping__c(Name = 'test surfour', ivybase__Survey__c = surveyList[0].Id, ivybase__Location_Hierarchy__c = lhList[1].id)
                                          
                                          
                                          
                                          };
        insert smList;
        smList[0].ivybase__Store_Hierarchy__c = shList[3].id;
        //update smList;
        List<contact> conList2 = [SELECT Id FROM contact];
        List<ivybase__Survey_Mapping__c > smList2 = [SELECT Name, ivybase__Survey__c, ivybase__User__c,ivybase__Location_Hierarchy__c,ivybase__Store_Hierarchy__c FROM ivybase__Survey_Mapping__c ];
        smList2[3].ivybase__User__c = conList2[1].id;
        try {
            update smlist2; 
        }
        catch(Exception e) {
            System.assert(e.getmessage() != null);
        }
        List<ivybase__Store_Hierarchy__c> shList2 = [SELECT Id FROM ivybase__Store_Hierarchy__c];
        smList2[2].ivybase__Store_Hierarchy__c = shList2[3].id;
        try {
            update smlist2; 
        } catch(Exception e) {
            System.assert(e.getmessage().contains('Survey already mapped to this Store Hierarchy'));
        }
      
    }        
    public static testMethod void testStoreHierarchy () {
        
        
        ivybase__Survey__c surv1 = new ivybase__Survey__c();
        surv1.Name = 'test sur';
        surv1.ivybase__Type__c = 'Store';
        surv1.ivybase__HHT_Menu__c = 'Activity Menu';
        insert surv1;
        
        ivybase__Store_Hierarchy__c sh  = new ivybase__Store_Hierarchy__c();
        sh.Name = 'Teststore';
        sh.ivybase__Active__c = 'Yes';
        insert sh;
        
        ivybase__Store_Hierarchy__c sh1  = new ivybase__Store_Hierarchy__c();
        sh1.Name = 'Teststoreone';
        sh1.ivybase__Active__c = 'Yes';
        insert sh1;
        
        ivybase__Store_Hierarchy__c sh2  = new ivybase__Store_Hierarchy__c();
        sh2.Name = 'TeststoreTwo';
        sh2.ivybase__Active__c = 'Yes';
        insert sh2;
        
        ivybase__Survey_Mapping__c sur1 = new ivybase__Survey_Mapping__c();
        sur1.Name = 'test sur one';
        sur1.ivybase__Survey__c = surv1.Id;
        sur1.ivybase__Store_Hierarchy__c = sh.Id;
        insert sur1;
        
        ivybase__Survey_Mapping__c sur3 = new ivybase__Survey_Mapping__c();
        sur3.Name = 'test sur';
        sur3.ivybase__Survey__c = surv1.Id;
        sur3.ivybase__Store_Hierarchy__c = sh.Id;
        
        try {
            insert sur3;
        } catch(exception e) {
            System.assert(e.getMessage().contains('Survey already mapped to this Store Hierarchy'));
        }
    }
    
    private static testMethod void testLocation(){ 
        ivybase__Location_Hierarchy__c lh  = new ivybase__Location_Hierarchy__c();
        lh.Name = 'Teststore';
        lh.ivybase__Active__c = 'Yes';
        insert lh;
        
        ivybase__Survey__c surv1 = new ivybase__Survey__c();
        surv1.Name = 'test sur';
        surv1.ivybase__Type__c = 'Store';
        surv1.ivybase__HHT_Menu__c = 'Activity Menu';
        insert surv1;
                
        ivybase__Survey_Mapping__c sur4 = new ivybase__Survey_Mapping__c();
        sur4.Name = 'survey';
        sur4.ivybase__Survey__c = surv1.Id;
        sur4.ivybase__Location_Hierarchy__c = lh.Id;
        insert sur4;
        
        ivybase__Survey_Mapping__c sur5 = new ivybase__Survey_Mapping__c();
        sur5.Name = 'test';
        sur5.ivybase__Survey__c = surv1.Id;
        sur5.ivybase__Location_Hierarchy__c = lh.Id;
        
        try {
            insert sur5;
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('Survey already mapped to this Location Hierarchy'));
        }
    }
    
    private static testMethod void testStore() {
        
        Id accRec = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId(); 
        
        Account acc = new Account();
        acc.RecordTypeId = accRec;
        acc.name = 'Raam';
        acc.Is_Dream_List__c = true;
        insert acc;
        
        acc.ivybase__Active__c = 'Yes';
        update acc;
        
        ivybase__Survey__c surv1 = new ivybase__Survey__c();
        surv1.Name = 'test sur';
        surv1.ivybase__Type__c = 'Store';
        surv1.ivybase__HHT_Menu__c = 'Activity Menu';
        insert surv1;
        
        ivybase__Survey_Mapping__c sur6 = new ivybase__Survey_Mapping__c();
        sur6.Name = 'testOne';
        sur6.ivybase__Survey__c = surv1.Id;
        sur6.ivybase__Store__c = acc.Id;
        insert sur6;
        
        ivybase__Survey_Mapping__c sur7 = new ivybase__Survey_Mapping__c();
        sur7.Name = 'testsTwo';
        sur7.ivybase__Survey__c = surv1.Id;
        sur7.ivybase__Store__c = acc.Id;
        
        
        
        try {
            insert sur7;
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('Survey already mapped to this Store'));
        }
    }        
            
        
        
                  
    private static testMethod void testUser() {
     
        Id conRec = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        
        Contact con = new Contact();
        con.RecordTypeId = conRec;
        con.Lastname = 'Raam';
        insert con;
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name='Resource', ivybase__Related_User__c = UserInfo.getUserId());
        insert res;
        
        ivybase__Survey__c surv2 = new ivybase__Survey__c();
        surv2.Name = 'tests sur';
        surv2.ivybase__Type__c = 'User';
        surv2.ivybase__HHT_Menu__c = 'Home Menu';
        surv2.ivybase__User_Type__c = 'Seller';
        insert surv2;
        
        ivybase__Survey_Mapping__c sur8 = new ivybase__Survey_Mapping__c();
        sur8.Name = 'testerTwo';
        sur8.ivybase__Survey__c = surv2.Id;
        sur8.ivybase__User__c = con.Id;
        sur8.ivybase__Resource__c = res.Id;
        insert sur8;
        
        ivybase__Survey_Mapping__c sur9 = new ivybase__Survey_Mapping__c();
        sur9.Name = 'testTwo';
        sur9.ivybase__Survey__c = surv2.Id;
        sur9.ivybase__User__c = con.Id;
        sur9.ivybase__Resource__c = res.Id;
        try {
            insert sur9;
        }
        catch(Exception e) {
            System.assert(e.getMessage().contains('Survey already mapped to this user'));    
        } 
    } 
                       
    private static testMethod void updateWithSameName() {        
        
        ivybase__Survey__c surv1 = new ivybase__Survey__c();
        surv1.Name = 'test sur';
        surv1.ivybase__Type__c = 'Store';
        surv1.ivybase__HHT_Menu__c = 'Activity Menu';
        insert surv1;
        
        ivybase__Store_Hierarchy__c sh  = new ivybase__Store_Hierarchy__c();
        sh.Name = 'Teststore';
        sh.ivybase__Active__c = 'Yes';
        insert sh;
        
        ivybase__Store_Hierarchy__c sh1  = new ivybase__Store_Hierarchy__c();
        sh1.Name = 'Teststoreone';
        sh1.ivybase__Active__c = 'Yes';
        insert sh1;
        
        ivybase__Store_Hierarchy__c sh2  = new ivybase__Store_Hierarchy__c();
        sh2.Name = 'Teststoretwo';
        sh2.ivybase__Active__c = 'Yes';
        insert sh2;
        
        
        ivybase__Standard_List_Master__c slm = new ivybase__Standard_List_Master__c();
        slm.ivybase__List_Name__c = 'Channel';
        slm.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm;
        
        ivybase__Survey_Mapping__c sur1 = new ivybase__Survey_Mapping__c();
        sur1.Name = 'test sur one';
        sur1.ivybase__Survey__c = surv1.Id;
        sur1.ivybase__Store_Hierarchy__c = sh.Id;
        insert sur1;
        
        sur1.ivybase__Store_Hierarchy__c  = sh2.id;
        update sur1;
        
        ivybase__Survey_Mapping__c sur2 = new ivybase__Survey_Mapping__c();
        sur2.Name = 'test suru';
        sur2.ivybase__Survey__c = surv1.Id;
        sur2.ivybase__Store_Hierarchy__c = sh1.Id;
        insert sur2;
        
        try {
            sur2.Name = 'test sur one';
            update sur2;
        } catch(exception e) {}
        
        system.assert(sur1.Id != null);
    }
    
}