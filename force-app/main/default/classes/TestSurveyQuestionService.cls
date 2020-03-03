@isTest
public class TestSurveyQuestionService {
    
    private static testMethod void testmethod1() {
        
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Id recordtypecon = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Merchandiser').getRecordTypeId();
        
        Contact con = new Contact(lastName = 'Test', ivybase__Related_User__c = UserInfo.getUserId() ,Email = 'test@gmail.com',RecordTypeId = recordtypecon);
        insert con;
        
        ivybase__Resource_Type__c restype = new ivybase__Resource_Type__c(Name = 'Merchandiser');
        insert restype;
        
        ivybase__Location_Hierarchy__c lh = new ivybase__Location_Hierarchy__c();
        lh.Name = 'TestlocHie';
        lh.ivybase__Active__c = 'Yes';
        insert lh;
        
        ivybase__Resource__c res = new ivybase__Resource__c(Name = 'Test', ivybase__Related_User__c = UserInfo.getUserId(),ivybase__Resource_Type__c = restype.Id,ivybase__Location_Hierarchy__c = lh.Id);
        insert res;
        
        List<Account> acclist = new List<Account>{new Account(Name = 'Test',recordTypeId = RecordTypeId),
            new Account(Name = 'Testone',ivybase__Active__c = 'Yes',recordTypeId = RecordTypeId, ivybase__Resource__c = res.Id),
            new Account(Name = 'Testtwo',ivybase__Active__c = 'Yes',recordTypeId = RecordTypeId, ivybase__Resource__c = res.Id),
            new Account(Name = 'Testthree',ivybase__Active__c = 'Yes'),
            new Account(Name = 'Testaccforvisit',recordTypeId = RecordTypeId)
            
            };
                insert acclist;
        acclist[0].ivybase__Active__c = 'Yes';
        acclist[1].ivybase__Active__c = 'Yes';
        acclist[4].ivybase__Active__c = 'Yes';
        update acclist;
        
        List<String> accIdList = new List<String>();
        
        for(Account acc : acclist){
            
            accIdList.add(acc.Id);
        }
        
        ivybase__Territory_Store_Mapping__c territoryMappingObject = new ivybase__Territory_Store_Mapping__c();
        territoryMappingObject.ivybase__From__c = System.today();
        territoryMappingObject.ivybase__To__c = System.today().addDays(2);
        territoryMappingObject.ivybase__Location_Hierarchy__c = lh.Id;
        territoryMappingObject.ivybase__Store__c = acclist[0].Id;
        insert territoryMappingObject;        
        
        
        Contact con1 = new Contact(lastName = 'Testcon', ivybase__Related_User__c = UserInfo.getUserId() ,Email = 'testcon@gmail.com',RecordTypeId = recordtypecon);
        //insert con1;
        
        string interId = String.Valueof([SELECT ivybase__Internal_Id__c FROM Account Where Id =:acclist[0].Id].ivybase__Internal_Id__c);
        
        List<ivybase__Visit__c> visitList = new List<ivybase__Visit__c>{
            new ivybase__Visit__c(Name = 'visname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-02-15'),ivybase__Store__c = acclist[0].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-15'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'Testvisname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-02-16'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-16'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'visitone',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-02-15'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-15'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'visitname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-08-22'),ivybase__Store__c = acclist[0].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-15'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'Testvisitname',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-08-22'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-16'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'visit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-02-15'),ivybase__Store__c = acclist[1].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-15'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'Testvisit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-02-16'),ivybase__Store__c = acclist[0].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-17'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'Testvisit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-08-22'),ivybase__Store__c = acclist[3].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-16'),ivybase__Resource__c = res.Id),
                new ivybase__Visit__c(Name = 'Testvisit',ivybase__Seller__c = con.Id,ivybase__Visit_Date__c = Date.Valueof('2017-08-22'),ivybase__Store__c = acclist[4].Id,ivybase__Original_Date__c=Date.Valueof('2017-02-28'),ivybase__Resource__c = res.Id)
                };
                    insert visitList;
        
        ivybase__Standard_List_Master__c slm = new ivybase__Standard_List_Master__c();
        slm.ivybase__List_Name__c = 'Testslm';
        slm.ivybase__List_Type__c = 'REASON';
        slm.ivybase__Location_Hierarchy__c = lh.Id;
        slm.ivybase__Resource_Type__c = restype.Id;
        // insert slm;
        
        List<ivybase__Standard_List_Master__c> slmList = new List<ivybase__Standard_List_Master__c>{
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'test1',ivybase__List_Type__c = 'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id ),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'test2',ivybase__List_Type__c =  'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id ),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'test3',ivybase__List_Type__c = 'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id ),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'test4',ivybase__List_Type__c =  'AMAZON_CONFIGURATION',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'test5',ivybase__List_Type__c = 'AMAZON_CONFIGURATION', ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_PL_REC', ivybase__List_Name__c = 'test6',ivybase__List_Type__c = 'PL',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_PL_REASON', ivybase__List_Name__c = 'test7',ivybase__List_Type__c = 'REASON',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id)
                };
                    
                    slmlist.add(slm);
        insert slmList;
        
        
        
        ivybase__Product_Hierarchy__c ph = new ivybase__Product_Hierarchy__c();
        ph.Name = 'Test';
        ph.ivybase__Active__c = 'Yes';
        ph.RecordTypeId = Schema.SObjectType.ivybase__Product_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Sub_Brand').getRecordTypeId();
        insert ph;
        
        
        List<ivybase__Product__c> productList = new List<ivybase__Product__c>();
        
        ivybase__Product__c p = new ivybase__Product__c();
        p.Name = 'Testprod';
        p.ivybase__parent__c = ph.Id;
        p.ivybase__Active__c = 'Yes';
        p.ivybase__Short_Description__c = 'Testdesc';
        productList.add(p);
        // insert p;
        
        ivybase__Product__c p1 = new ivybase__Product__c();
        p1.Name = 'Testproduct';
        p1.ivybase__parent__c = ph.Id;
        p1.ivybase__Is_Competitor__c = false;
        p1.ivybase__Active__c = 'Yes';
        p1.ivybase__Short_Description__c = 'Testdesc';
        productList.add(p1);
        insert productList;
        
        System.Assert(productList.size()==2);
        
        ivybase__Standard_List_Master__c slm1 = new ivybase__Standard_List_Master__c();
        slm1.ivybase__List_Name__c = 'Channel';
        slm1.ivybase__List_Type__c = 'CHANNEL_HIERARCHY';
        insert slm1;
        
        ivybase__Store_Hierarchy__c sh = new ivybase__Store_Hierarchy__c();
        sh.Name = 'TestStoreHie';
        sh.ivybase__Active__c = 'Yes';
        insert sh;
        
        ivybase__Survey__c s = new ivybase__Survey__c();
        s.Name = 'testsurvey';
        s.ivybase__From__c = System.Today();
        // s.ivybase__To__c = System.Today().addDays(10);
        s.ivybase__Type__c = 'Store';
        s.ivybase__HHT_Menu__c = 'Activity Menu';
        insert s;
        
        Salon_Catagory__c SC = new Salon_Catagory__c();
        SC.Name = 'A';
        SC.Location_Hierarchy__c = lh.id;
        SC.Salon_Catagoty__c = 'A';
        
        ivybase__Survey_Mapping__c SM = new ivybase__Survey_Mapping__c();
        SM.Name = 'Test Survey Mapping';
        SM.ivybase__Survey__c = s.id;
       
        //insert SM;      
        
        set<id> QId = new set<id>();
        list<ivybase__Question__c> Qlist = new list<ivybase__Question__c>();
        
        ivybase__Question__c q1 = new ivybase__Question__c();
        q1.Name = 'ques2';
        q1.ivybase__Question__c = 'Testques2';
        q1.ivybase__Question_Type__c ='Option';
        Qlist.add(q1);
        QId.add(q1.Id);
        ivybase__Question__c q2 = new ivybase__Question__c();
        q2.Name = 'ques';
        q2.ivybase__Question__c = 'Testques';
        q2.ivybase__Question_Type__c ='Option';
        Qlist.add(q2);
        QId.add(q2.Id);
        insert Qlist;
        
        ivybase__Answer_Option__c AP1 = new ivybase__Answer_Option__c();
        AP1.name = 'Test Answer Option 1';
        insert AP1;
        
        ivybase__Question_Answer_Option__c QA1 = new ivybase__Question_Answer_Option__c();
        QA1.ivybase__Question__c = Qlist[0].id;
        QA1.ivybase__Answer_Option__c = AP1.id;
        insert QA1;
        
        ivybase__Question_Answer_Option__c QA2 = new ivybase__Question_Answer_Option__c();
        QA2.ivybase__Question__c = Qlist[1].id;
        QA2.ivybase__Answer_Option__c = AP1.id;
        QA2.Score__c = 0.5;
        insert QA2;
        
        ivybase__Survey_Question__c sq = new ivybase__Survey_Question__c();
        sq.ivybase__Survey__c = s.Id;
        sq.ivybase__Question__c = Qlist[0].id;
        insert sq;
        
        
        ivybase__Location__c l = new ivybase__Location__c();
        l.Name ='Test loc';
        l.ivybase__Belongs_To__c  = acclist[1].Id;
        l.ivybase__Standard_List_Master__c = slmList[5].Id;
        l.RecordTypeId = Schema.SObjectType.ivybase__Location__c.getRecordTypeInfosByDeveloperName().get('In_Store').getRecordTypeId();
        insert l;
        
        
        List<ivybase__HHTMenu_Master__c> hhtmenuList = new List<ivybase__HHTMenu_Master__c>{
            new ivybase__HHTMenu_Master__c(Name = 'PROFILE01',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Account_Name__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE02',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Contact_Email__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE03',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Credit_Limit__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE04',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Credit_Period__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE05',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Location_Hierarchy__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE06',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Store_Hierarchy__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE07',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Lat_and_Long__latitude__s',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PROFILE08',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Lat_and_Long__longitude__s',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'AREA_NAME',ivybase__Flag__c = 1,ivybase__Flex__c = 'ivybase__Area_Name__c',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'NAME',ivybase__Flag__c = 1,ivybase__Flex__c = 'NAME',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id),
                new ivybase__HHTMenu_Master__c(Name = 'PHONE',ivybase__Flag__c = 1,ivybase__Flex__c = 'Phone',ivybase__MenuType__c = 'RETAILER_PROFILE',ivybase__Location_Hierarchy__c = lh.Id,ivybase__Resource_Type__c = restype.Id)
                };
                    
                    insert hhtmenuList;
        test.startTest();
        SurveyQuestionService.getquesIdfromsurveyques(QId);
        test.stopTest();
        
    }       
    
}