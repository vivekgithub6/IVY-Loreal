@isTest
public class TestRestJourneyPlan{
    public static user createTestUser(string userLastName,string alias,Id profileId){
        
        User u = new User();
        u.Alias = alias;
        u.Email = alias+'123@testorg123.com';
        u.EmailEncodingKey ='UTF-8';
        u.LastName = userLastName;
        u.LanguageLocaleKey ='en_US';                             
        u.LocaleSidKey ='en_US';
        u.ProfileId = profileId;                           
        u.TimeZoneSidKey ='America/Los_Angeles';
        u.UserName = u.Email;
        u.Market_ISO__c = 'MY';
        return u;
    }
    public static List<ivybase__Standard_List_Master__c>  createTestStandardListMasterATSM(ID locationId, Id ResTypeId){
        
        List<ivybase__Standard_List_Master__c> assets = new List<ivybase__Standard_List_Master__c>{
            
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Inst. Requested',ivybase__List_Code__c='INSREQ',ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Removed',ivybase__List_Code__c='REM', ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Maintenance',ivybase__List_Code__c='AMR', ivybase__List_Type__c = 'APPROVAL_STATUS', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Loreal Professional',ivybase__List_Code__c='LP', ivybase__List_Type__c = 'DIVISION_TYPE', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Business Visit',ivybase__List_Code__c='VISIT_BUSINESS', ivybase__List_Type__c = 'VISIT_TYPE', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Rinitin Visit',ivybase__List_Code__c='VISIT_RINITIN', ivybase__List_Type__c = 'VISIT_TYPE', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId),
                new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Doko Visit',ivybase__List_Code__c='VISIT_DOKO', ivybase__List_Type__c = 'VISIT_TYPE', ivybase__Location_Hierarchy__c = locationId, ivybase__Resource_Type__c = ResTypeId)
                
                };
                    insert assets;
        return assets;
    }
    
    
    
    public static Account createTestAccount(String storeCode, String accName , String contactEmail,
                                            String phone , String fax , id resID , String recordTypeName , String isActive) {
                                                
                                                Account acc = new Account();
                                                acc.ivybase__StoreCode__c =storeCode;
                                                acc.Name = accName;
                                                acc.ivybase__Contact_Email__c = contactEmail ;
                                                acc.Phone = phone;
                                                acc.Fax = fax;
                                                acc.ivybase__Status__c='Active';
                                                acc.ivybase__Resource__c = resID;
                                                acc.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = : recordTypeName Limit 1].Id;
                                                acc.ivybase__Active__c = isActive;
                                                return acc;
                                            }
    
    
    public static void setUp(){
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //User u = TestRestJourneyPlan.createTestUser('GokulR','sGR',p.id);
        //insert u;
        //
        User usr = [SELECT Id, Market_ISO__c, CurrencyIsoCode FROM User WHERE Id = :UserInfo.getUserId()];
        ivybase__Resource_Type__c resourceType=TestUtility.createTestResourceType('Test');
        resourceType.CurrencyIsoCode = usr.CurrencyIsoCode;
        insert resourceType;
        system.debug('curUserId'+userinfo.getUserId());
        ivybase__Resource__c resource = TestUtility.createTestResource('Test Resource',userInfo.getUserId(),resourceType.id);
        resource.CurrencyIsoCode = usr.CurrencyIsoCode;
        resource.Market_ISO__c = usr.Market_ISO__c;
        insert resource;
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        locationHierarchy.CurrencyIsoCode = usr.CurrencyIsoCode;
        locationHierarchy.Market_ISO__c = usr.Market_ISO__c;
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
        
        Account a = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        Account a1 = TestUtility.createTestAccount('2' , 'Test Acc2' , '223456789' , '211222333' , resource.id , 'Retail_Account' , 'Yes' );
        
        a.CurrencyIsoCode = usr.CurrencyIsoCode;
        a.Market_ISO__c = usr.Market_ISO__c;
        a1.CurrencyIsoCode = usr.CurrencyIsoCode;
        a1.Market_ISO__c = usr.Market_ISO__c;
        
        insert a;
        insert a1;
        
        system.debug('Veer acc1  '+a);
        system.debug('Veer acc2  '+a1);
        
        //Agent 
        Account a3Agent = TestUtility.createTestAccount('3' , 'Test Account3' , '3445546789' , '4353532132' , resource.id , 'Retail_Account' , 'Yes' );
        a3Agent.IsAgent__c =  TRUE;
        a3Agent.CurrencyIsoCode = usr.CurrencyIsoCode;
        a3Agent.Market_ISO__c = usr.Market_ISO__c;
        insert a3Agent;
        
        List<Agent_Salon_Mapping__c> agentMapList = new List<Agent_Salon_Mapping__c>();
        
        Agent_Salon_Mapping__c agentMap1 = new Agent_Salon_Mapping__c();
        agentMap1.Agent__c = a3Agent.Id;
        agentMap1.Salon__c = a.Id;
        agentMapList.add(agentMap1);
        
        insert agentMapList;
        
        ivybase__Max_Internal_Id_Value__c max_internal = new ivybase__Max_Internal_Id_Value__c(ivybase__Max_Internal_Id__c = 1083246, Name = 'Contact', CurrencyIsoCode = usr.CurrencyIsoCode);
        insert max_internal;
        
        Contact con1 = TestUtility.createTestContact('Test','Buddy', usr.Id , usr.currencyIsoCode, 'testBuddy@salesforce.com',
                                                     NULL, 'Retailer_Contact' );
        insert con1;    
        
        List<ivybase__Standard_List_Master__c> assets=TestRestJourneyPlan.createTestStandardListMasterATSM(locationHierarchy.id,resourceType.id);
        
        List<JourneyPlanActivity__c> planActivityList = new List<JourneyPlanActivity__c> ();
        List<JourneyPlanMarket_Visit__c> planVisitList = new List<JourneyPlanMarket_Visit__c> ();
            
        JourneyPlan__c journeyPlan = new JourneyPlan__c();
        journeyPlan.Year__c = system.today().year();
        journeyPlan.Tid__c='555';
        journeyPlan.Territory__c=locationHierarchy.id;
        journeyPlan.Status__c='Draft';
        journeyPlan.Month__c=06;
        journeyPlan.SupervisorComments__c='Test Comments';
        Date d = system.today().addDays(-4); //Date.newInstance(system.today().year(), system.today().month(), 15);
        journeyPlan.Date__c = system.today().addDays(-4);
        journeyPlan.Market_ISO__c = 'MY';
        journeyPlan.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlan.Market_ISO__c = usr.Market_ISO__c;
        insert journeyPlan;
        
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c();
        journeyPlan2.Year__c = system.today().year();
        journeyPlan2.Tid__c='535';
        journeyPlan2.Territory__c=locationHierarchy.id;
        journeyPlan2.Status__c='Draft';
        journeyPlan2.Month__c=10;
        journeyPlan2.SupervisorComments__c='Test Comments';
        Date d2 = system.today().addMonths(-1);  //Date.newInstance(system.today().year(), system.today().month()+2, 27);
        journeyPlan2.Date__c = system.today().addMonths(-1);
        journeyPlan2.Market_ISO__c = 'MY';
        journeyPlan2.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlan2.Market_ISO__c = usr.Market_ISO__c;
        insert journeyPlan2;
        
        JourneyPlan__c journeyPlan3 = new JourneyPlan__c();
        journeyPlan3.Year__c = system.today().year();
        journeyPlan3.Tid__c='5390';
        journeyPlan3.Territory__c=locationHierarchy.id;
        journeyPlan3.Status__c='Draft';
        journeyPlan3.Month__c=10;
        journeyPlan3.SupervisorComments__c='Test Comments';
        journeyPlan3.Date__c = system.today();
        journeyPlan3.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlan3.Market_ISO__c = usr.Market_ISO__c;
        journeyPlan3.Status__c = 'Approved';
        insert journeyPlan3;
        
        JourneyPlanActivity__c journeyPlanActivty4 = new JourneyPlanActivity__c();
        journeyPlanActivty4.Comments__c='sdsdsd';
        journeyPlanActivty4.WorkWithUserId__c='2342';
        journeyPlanActivty4.Date__c = system.today();
        journeyPlanActivty4.JourneyPlan__c = journeyPlan3.id;
        journeyPlanActivty4.Name = journeyPlan.Tid__c;
        journeyPlanActivty4.TypeId__c=assets[0].id;
        journeyPlanActivty4.Store__c = a.Id;
        journeyPlanActivty4.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlanActivty4.Market_ISO__c = usr.Market_ISO__c;
        planActivityList.add(journeyPlanActivty4);
        
        
        JourneyPlanActivity__c journeyPlanActivty = new JourneyPlanActivity__c();
        journeyPlanActivty.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty.Date__c = system.today().addDays(-4);
        journeyPlanActivty.JourneyPlan__c = journeyPlan.id;
        journeyPlanActivty.Name = journeyPlan.Tid__c;
        journeyPlanActivty.TypeId__c=assets[0].id;
        journeyPlanActivty.Store__c = a.Id;
        //journeyPlanActivty.Market_ISO__c = 'MY';
        journeyPlanActivty.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlanActivty.Market_ISO__c = usr.Market_ISO__c;
        //insert journeyPlanActivty;
        planActivityList.add(journeyPlanActivty);
        
        JourneyPlanActivity__c journeyPlanActivty2 = new JourneyPlanActivity__c();
        journeyPlanActivty2.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty2.Date__c = d2;
        journeyPlanActivty2.JourneyPlan__c = journeyPlan2.id;
        journeyPlanActivty2.Name=journeyPlan.Tid__c;
        journeyPlanActivty2.TypeId__c=assets[0].id;
        journeyPlanActivty2.Store__c = a1.Id;   
        //journeyPlanActivty2.Market_ISO__c = 'MY';
        journeyPlanActivty2.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlanActivty2.Market_ISO__c = usr.Market_ISO__c;
        //insert journeyPlanActivty2;
        planActivityList.add(journeyPlanActivty2);
        
        JourneyPlanActivity__c journeyPlanActivty3 = new JourneyPlanActivity__c();
        journeyPlanActivty3.Comments__c='sdsdsd';
        journeyPlanActivty3.WorkWithUserId__c='2342';
        journeyPlanActivty3.Date__c = system.today();
        journeyPlanActivty3.JourneyPlan__c = journeyPlan.id;
        journeyPlanActivty3.Name = journeyPlan.Tid__c;
        journeyPlanActivty3.TypeId__c=assets[0].id;
        journeyPlanActivty3.Store__c = a.Id;
        //journeyPlanActivty3.Market_ISO__c = 'MY';
        journeyPlanActivty3.CurrencyIsoCode = usr.CurrencyIsoCode;
        journeyPlanActivty3.Market_ISO__c = usr.Market_ISO__c;
        //insert journeyPlanActivty3;
        planActivityList.add(journeyPlanActivty3);
        
        JourneyPlanMarket_Visit__c marketVisit = new JourneyPlanMarket_Visit__c();
        marketVisit.name=journeyPlan.Tid__c;
        marketVisit.Date__c = d;
        marketVisit.JourneyPlan__c=journeyPlan.id;
        marketVisit.Store__c=a.id;
        marketVisit.Market_ISO__c = 'MY';
        marketVisit.CurrencyIsoCode = usr.CurrencyIsoCode;
        marketVisit.Market_ISO__c = usr.Market_ISO__c;
        //insert marketVisit;
        planVisitList.add(marketVisit);
        
        JourneyPlanMarket_Visit__c marketVisit2 = new JourneyPlanMarket_Visit__c();
        marketVisit2.name=journeyPlan.Tid__c;
        marketVisit2.Date__c = d;
        marketVisit2.JourneyPlan__c = journeyPlan.id;
        marketVisit2.Store__c=a1.id;
        marketVisit2.Market_ISO__c = 'MY';
        marketVisit2.CurrencyIsoCode = usr.CurrencyIsoCode;
        marketVisit2.Market_ISO__c = usr.Market_ISO__c;
        //insert marketVisit2;
        planVisitList.add(marketVisit2);
        
        JourneyPlanMarket_Visit__c marketVisit3 = new JourneyPlanMarket_Visit__c();
        marketVisit3.name=journeyPlan2.Tid__c;
        marketVisit3.Date__c = d2;
        marketVisit3.JourneyPlan__c=journeyPlan2.id;
        marketVisit3.Store__c=a.id;
        marketVisit3.Market_ISO__c = 'MY';
        marketVisit3.CurrencyIsoCode = usr.CurrencyIsoCode;
        marketVisit3.Market_ISO__c = usr.Market_ISO__c;
        //insert marketVisit3;
        planVisitList.add(marketVisit3);
        
        JourneyPlanMarket_Visit__c marketVisit4 = new JourneyPlanMarket_Visit__c();
        marketVisit4.name=journeyPlan2.Tid__c;
        marketVisit4.Date__c = d2;
        marketVisit4.JourneyPlan__c=journeyPlan2.id;
        marketVisit4.Store__c=a1.id;
        marketVisit4.Market_ISO__c = 'MY';
        marketVisit4.CurrencyIsoCode = usr.CurrencyIsoCode;
        marketVisit4.Market_ISO__c = usr.Market_ISO__c;
        //insert marketVisit4;
        planVisitList.add(marketVisit4);
        
        insert planActivityList;
        insert planVisitList;
        
        // Rintin Plan starts
        Rintin_Plan__c rintinPlan1 = TestUtility.createRintinPlan(journeyPlan.Id);
        rintinPlan1.CurrencyIsoCode = usr.CurrencyIsoCode;
        rintinPlan1.Date__c = system.today();
        insert rintinPlan1;
        
        Rintin_Plan__c rintinPlan2 = TestUtility.createRintinPlan(journeyPlan.Id);
        rintinPlan2.CurrencyIsoCode = usr.CurrencyIsoCode;
        rintinPlan2.Tid__c = NULL;
        insert rintinPlan2;
        
        List<Rintin_Plan_Details__c> rintinPlandetailList = new List<Rintin_Plan_Details__c>();
        
        Rintin_Plan_Details__c rintinPlanDetail1 = TestUtility.createRintinPlanDetail(a3Agent.Id, con1.Id, rintinPlan1.Id, FALSE, a.Id);
        rintinPlanDetail1.CurrencyIsoCode = usr.CurrencyIsoCode;
		rintinPlandetailList.add(rintinPlanDetail1);
        
        Rintin_Plan_Details__c rintinPlanDetail2 = TestUtility.createRintinPlanDetail(NULL, NULL, rintinPlan2.Id, TRUE, a.Id);
        rintinPlanDetail2.CurrencyIsoCode = usr.CurrencyIsoCode;
		rintinPlandetailList.add(rintinPlanDetail2); 
        
        Rintin_Plan__c rintinPlan3 = TestUtility.createRintinPlan(journeyPlan.Id);
        rintinPlan3.CurrencyIsoCode = usr.CurrencyIsoCode;
        rintinPlan3.Date__c = system.Today();
        insert rintinPlan3;
        
        Rintin_Plan_Details__c rintinPlanDetail3 = TestUtility.createRintinPlanDetail(NULL, NULL, rintinPlan3.Id, TRUE, a.Id);
        rintinPlanDetail3.CurrencyIsoCode = usr.CurrencyIsoCode;
		rintinPlandetailList.add(rintinPlanDetail3);
        
        insert rintinPlandetailList;
       
        Rintin_Plan__c rintinPlan4 = TestUtility.createRintinPlan(journeyPlan.Id);
        rintinPlan4.CurrencyIsoCode = usr.CurrencyIsoCode;
        rintinPlan4.Date__c = system.Today();
        insert rintinPlan4;
    }
    
    public static void setUp2(){
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //User u = TestRestJourneyPlan.createTestUser('GokulR','sGR',p.id);
        //insert u;
        ivybase__Resource_Type__c resourceType=TestUtility.createTestResourceType('Test');
        insert resourceType;
        system.debug('curUserId'+userinfo.getUserId());
        ivybase__Resource__c resource = TestUtility.createTestResource('Test Resource',userInfo.getUserId(),resourceType.id);
        insert resource;
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
        
        Account a = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        Account a1 = TestUtility.createTestAccount('2' , 'Test Acc2' , '223456789' , '211222333' , resource.id , 'Retail_Account' , 'Yes' );
        
        insert a;
        insert a1;
        List<ivybase__Standard_List_Master__c> assets=TestRestJourneyPlan.createTestStandardListMasterATSM(locationHierarchy.id,resourceType.id);
        
        JourneyPlan__c journeyPlan = new JourneyPlan__c();
        journeyPlan.Year__c=2018;
        journeyPlan.Tid__c='555';
        journeyPlan.Territory__c=locationHierarchy.id;
        journeyPlan.Status__c='Draft';
        journeyPlan.Month__c=06;
        journeyPlan.SupervisorComments__c='Test Comments';
        Date d=Date.newInstance(2018,6,17);
        journeyPlan.Date__c=Date.today();
        journeyPlan.Market_ISO__c = 'MY';
        insert journeyPlan;
        
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c();
        journeyPlan2.Year__c=2018;
        //journeyPlan2.Tid__c='535';
        journeyPlan2.Territory__c=locationHierarchy.id;
        journeyPlan2.Status__c='Draft';
        journeyPlan2.Month__c=10;
        journeyPlan2.SupervisorComments__c='Test Comments';
        //Date d2=Date.newInstance(2018,10,27);
        journeyPlan2.Date__c=Date.today().addDays(+2);
        journeyPlan2.Market_ISO__c = 'MY';
        insert journeyPlan2;
        
        JourneyPlan__c journeyPlan3 = new JourneyPlan__c();
        journeyPlan3.Year__c=2018;
        journeyPlan3.Tid__c='555';
        journeyPlan3.Territory__c=locationHierarchy.id;
        journeyPlan3.Status__c='Draft';
        journeyPlan3.Month__c=06;
        journeyPlan3.SupervisorComments__c='Test Comments';
        //Date d=Date.newInstance(2018,6,17);
        journeyPlan3.Date__c=Date.today();
        journeyPlan3.Market_ISO__c = 'MY';
        insert journeyPlan3;
        
        JourneyPlan__c journeyPlan4 = new JourneyPlan__c();
        journeyPlan4.Year__c=2018;
        //journeyPlan4.Tid__c='535';
        journeyPlan4.Territory__c=locationHierarchy.id;
        journeyPlan4.Status__c='Draft';
        journeyPlan4.Month__c=10;
        journeyPlan4.SupervisorComments__c='Test Comments';
        Date d2=Date.newInstance(2018,10,27);
        journeyPlan4.Date__c=Date.today().addDays(+2);
        journeyPlan4.Market_ISO__c = 'MY';
        insert journeyPlan4;
        
        JourneyPlanActivity__c journeyPlanActivty = new JourneyPlanActivity__c();
        journeyPlanActivty.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty.Date__c=Date.today().addDays(+2);
        journeyPlanActivty.JourneyPlan__c=journeyPlan.id;
        journeyPlanActivty.Name=journeyPlan.Tid__c;
        //journeyPlanActivty.TypeId__c=assets[0].id;
        journeyPlanActivty.Store__c = a.Id;
        journeyPlanActivty.Market_ISO__c = 'MY';
        insert journeyPlanActivty;
        
        JourneyPlanActivity__c journeyPlanActivty2 = new JourneyPlanActivity__c();
        journeyPlanActivty2.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty2.Date__c=Date.today();
        journeyPlanActivty2.JourneyPlan__c=journeyPlan2.id;
        journeyPlanActivty2.Name=journeyPlan.Tid__c;
        //journeyPlanActivty2.TypeId__c=assets[0].id;
        journeyPlanActivty2.Store__c = a1.Id;   
        journeyPlanActivty2.Market_ISO__c = 'MY';
        insert journeyPlanActivty2;
        
        JourneyPlanActivity__c journeyPlanActivty3 = new JourneyPlanActivity__c();
        journeyPlanActivty3.Comments__c='sdsdsd';
        journeyPlanActivty3.WorkWithUserId__c='2342';
        journeyPlanActivty3.Date__c=Date.today().addDays(+2);
        journeyPlanActivty3.JourneyPlan__c=journeyPlan3.id;
        journeyPlanActivty3.Name=journeyPlan.Tid__c;
        journeyPlanActivty3.TypeId__c=assets[0].id;
        //journeyPlanActivty3.Store__c = a.Id;
        journeyPlanActivty3.Market_ISO__c = 'MY';
        insert journeyPlanActivty3;
        
        JourneyPlanActivity__c journeyPlanActivty4 = new JourneyPlanActivity__c();
        journeyPlanActivty4.Comments__c='sdsdsd';
        journeyPlanActivty4.WorkWithUserId__c='2342';
        journeyPlanActivty4.Date__c=Date.today();
        journeyPlanActivty4.JourneyPlan__c=journeyPlan4.id;
        journeyPlanActivty4.Name=journeyPlan.Tid__c;
        journeyPlanActivty4.TypeId__c=assets[0].id;
        //journeyPlanActivty4.Store__c = a1.Id;   
        journeyPlanActivty4.Market_ISO__c = 'MY';
        insert journeyPlanActivty4;
        
        JourneyPlanMarket_Visit__c marketVisit = new JourneyPlanMarket_Visit__c();
        marketVisit.name=journeyPlan.Tid__c;
        marketVisit.Date__c=d;
        marketVisit.JourneyPlan__c=journeyPlan.id;
        marketVisit.Store__c=a.id;
        marketVisit.Market_ISO__c = 'MY';
        insert marketVisit;
        
        JourneyPlanMarket_Visit__c marketVisit2 = new JourneyPlanMarket_Visit__c();
        marketVisit2.name=journeyPlan.Tid__c;
        marketVisit2.Date__c=d;
        marketVisit2.JourneyPlan__c=journeyPlan.id;
        marketVisit2.Store__c=a1.id;
        marketVisit2.Market_ISO__c = 'MY';
        insert marketVisit2;
        
        JourneyPlanMarket_Visit__c marketVisit3 = new JourneyPlanMarket_Visit__c();
        marketVisit3.name=journeyPlan2.Tid__c;
        marketVisit3.Date__c=d2;
        marketVisit3.JourneyPlan__c=journeyPlan2.id;
        marketVisit3.Store__c=a.id;
        marketVisit3.Market_ISO__c = 'MY';
        insert marketVisit3;
        
        JourneyPlanMarket_Visit__c marketVisit4 = new JourneyPlanMarket_Visit__c();
        marketVisit4.name=journeyPlan2.Tid__c;
        marketVisit4.Date__c=d2;
        marketVisit4.JourneyPlan__c=journeyPlan2.id;
        marketVisit4.Store__c=a1.id;
        marketVisit4.Market_ISO__c = 'MY';
        insert marketVisit4;
        
    }
    
    public static void setUp3(){
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //User u = TestRestJourneyPlan.createTestUser('GokulR','sGR',p.id);
        //insert u;
        ivybase__Resource_Type__c resourceType=TestUtility.createTestResourceType('Test');
        insert resourceType;
        system.debug('curUserId'+userinfo.getUserId());
        ivybase__Resource__c resource = TestUtility.createTestResource('Test Resource',userInfo.getUserId(),resourceType.id);
        insert resource;
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
        
        Account a = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        Account a1 = TestUtility.createTestAccount('2' , 'Test Acc2' , '223456789' , '211222333' , resource.id , 'Retail_Account' , 'Yes' );
        
        insert a;
        insert a1;
        List<ivybase__Standard_List_Master__c> assets=TestRestJourneyPlan.createTestStandardListMasterATSM(locationHierarchy.id,resourceType.id);
        
        JourneyPlan__c journeyPlan = new JourneyPlan__c();
        journeyPlan.Year__c=2018;
        journeyPlan.Tid__c='555';
        journeyPlan.Territory__c=locationHierarchy.id;
        journeyPlan.Status__c='Draft';
        journeyPlan.Month__c=06;
        journeyPlan.SupervisorComments__c='Test Comments';
        Date d=Date.newInstance(2018,6,17);
        journeyPlan.Date__c=Date.today();
        journeyPlan.Market_ISO__c = 'MY';
        insert journeyPlan;
        
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c();
        journeyPlan2.Year__c=2018;
        journeyPlan2.Tid__c='535';
        journeyPlan2.Territory__c=locationHierarchy.id;
        journeyPlan2.Status__c='Draft';
        journeyPlan2.Month__c=10;
        journeyPlan2.SupervisorComments__c='Test Comments';
        Date d2=Date.newInstance(2018,10,27);
        journeyPlan2.Date__c=Date.today().addDays(+2);
        journeyPlan2.Market_ISO__c = 'MY';
        insert journeyPlan2;
        
        JourneyPlanActivity__c journeyPlanActivty = new JourneyPlanActivity__c();
        journeyPlanActivty.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty.Date__c=Date.today().addDays(+2);
        journeyPlanActivty.JourneyPlan__c=journeyPlan.id;
        journeyPlanActivty.Name=journeyPlan.Tid__c;
        journeyPlanActivty.TypeId__c=assets[0].id;
        //journeyPlanActivty.Store__c = a.Id;
        journeyPlanActivty.Market_ISO__c = 'MY';
        insert journeyPlanActivty;
        
        JourneyPlanActivity__c journeyPlanActivty2 = new JourneyPlanActivity__c();
        journeyPlanActivty2.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty2.Date__c=Date.today();
        journeyPlanActivty2.JourneyPlan__c=journeyPlan2.id;
        journeyPlanActivty2.Name=journeyPlan.Tid__c;
        journeyPlanActivty2.TypeId__c=assets[0].id;
        //journeyPlanActivty2.Store__c = a1.Id;   
        journeyPlanActivty2.Market_ISO__c = 'MY';
        insert journeyPlanActivty2;
        
        JourneyPlanMarket_Visit__c marketVisit = new JourneyPlanMarket_Visit__c();
        marketVisit.name=journeyPlan.Tid__c;
        marketVisit.Date__c=d;
        marketVisit.JourneyPlan__c=journeyPlan.id;
        marketVisit.Store__c=a.id;
        marketVisit.Market_ISO__c = 'MY';
        insert marketVisit;
        
        JourneyPlanMarket_Visit__c marketVisit2 = new JourneyPlanMarket_Visit__c();
        marketVisit2.name=journeyPlan.Tid__c;
        marketVisit2.Date__c=d;
        marketVisit2.JourneyPlan__c=journeyPlan.id;
        marketVisit2.Store__c=a1.id;
        marketVisit2.Market_ISO__c = 'MY';
        insert marketVisit2;
        
        JourneyPlanMarket_Visit__c marketVisit3 = new JourneyPlanMarket_Visit__c();
        marketVisit3.name=journeyPlan2.Tid__c;
        marketVisit3.Date__c=d2;
        marketVisit3.JourneyPlan__c=journeyPlan2.id;
        marketVisit3.Store__c=a.id;
        marketVisit3.Market_ISO__c = 'MY';
        insert marketVisit3;
        
        JourneyPlanMarket_Visit__c marketVisit4 = new JourneyPlanMarket_Visit__c();
        marketVisit4.name=journeyPlan2.Tid__c;
        marketVisit4.Date__c=d2;
        marketVisit4.JourneyPlan__c=journeyPlan2.id;
        marketVisit4.Store__c=a1.id;
        marketVisit4.Market_ISO__c = 'MY';
        insert marketVisit4;
        
        
        
    }
    
    public static void setUp1(){
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //User u = TestRestJourneyPlan.createTestUser('GokulR','sGR',p.id);
        //insert u;
        ivybase__Resource_Type__c resourceType=TestUtility.createTestResourceType('Test');
        insert resourceType;
        system.debug('curUserId'+userinfo.getUserId());
        ivybase__Resource__c resource = TestUtility.createTestResource('Test Resource',userInfo.getUserId(),resourceType.id);
        insert resource;
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
        
        List<ivybase__Standard_List_Master__c> assets=TestRestJourneyPlan.createTestStandardListMasterATSM(locationHierarchy.id,resourceType.id);
        
        Date d=Date.newInstance(2018,6,17);
        JourneyPlan__c journeyPlan = new JourneyPlan__c(Territory__c=locationHierarchy.id,Date__c=d,Month__c=d.month(),Year__c=d.year());
        journeyPlan.Market_ISO__c = 'MY';
        insert journeyPlan;
        
        Date d2=Date.newInstance(2018,7,27);
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c(Territory__c=locationHierarchy.id,Date__c=d2,Month__c=d2.month(),Year__c=d2.year());
        journeyPlan2.Market_ISO__c = 'MY';
        insert journeyPlan2;
        
        JourneyPlanActivity__c journeyPlanActivty = new JourneyPlanActivity__c();
        journeyPlanActivty.JourneyPlan__c=journeyPlan.id;
        journeyPlanActivty.Market_ISO__c = 'MY';
        insert journeyPlanActivty;
        
        JourneyPlanActivity__c journeyPlanActivty2 = new JourneyPlanActivity__c();
        journeyPlanActivty2.JourneyPlan__c=journeyPlan2.id;
        journeyPlanActivty2.Market_ISO__c = 'MY';
        insert journeyPlanActivty2;
        
        Account a = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , resource.id , 'Retail_Account' , 'Yes' );
        Account a1 = TestUtility.createTestAccount('2' , 'Test Acc2', '223456789' , '211222333' , resource.id , 'Retail_Account' , 'Yes' );
        
        JourneyPlanMarket_Visit__c marketVisit = new JourneyPlanMarket_Visit__c();
        marketVisit.JourneyPlan__c=journeyPlan.id;
        marketVisit.Market_ISO__c = 'MY';
        insert marketVisit;
        
        JourneyPlanMarket_Visit__c marketVisit2 = new JourneyPlanMarket_Visit__c();
        marketVisit2.JourneyPlan__c=journeyPlan.id;
        marketVisit2.Market_ISO__c = 'MY';
        insert marketVisit2;
        
        JourneyPlanMarket_Visit__c marketVisit3 = new JourneyPlanMarket_Visit__c();
        marketVisit3.JourneyPlan__c=journeyPlan2.id;
        marketVisit3.Market_ISO__c = 'MY';
        insert marketVisit3;
        
        JourneyPlanMarket_Visit__c marketVisit4 = new JourneyPlanMarket_Visit__c();
        marketVisit4.JourneyPlan__c=journeyPlan2.id;
        marketVisit4.Market_ISO__c = 'MY';
        insert marketVisit4;
        
    }
    static testMethod void testMethod1()
    {
        Test.startTest();
        setUp();
        RExAPIResponseDomain.MultipleResponseInfo result = RESTJourneyPlan.getJourneyplanMasterInfo();
        RExAPIResponseDomain.MultipleResponseInfo resultRintinPlan = RESTRintinPlan.getJourneyplanMasterInfo();
        system.assertNotEquals(null,result);
        RExAPIResponseDomain.MultipleResponseInfo retailerClientMapping = RESTRetailerClientMapping.getRetailerClientMappings();
        
        Test.stopTest();
    }
    static testMethod void testMethod2()
    {
        Test.startTest();
        setUp1();
        RExAPIResponseDomain.MultipleResponseInfo result = RESTJourneyPlan.getJourneyplanMasterInfo();
        system.assertNotEquals(null,result);
        Test.stopTest();
    }
    static testMethod void testMethod3()
    {
        Test.startTest();
        setUp2();
        RExAPIResponseDomain.MultipleResponseInfo result = RESTJourneyPlan.getJourneyplanMasterInfo();
        system.assertNotEquals(null,result);
        
        Test.stopTest();
    }
    static testMethod void testMethod4()
    {
        Test.startTest();
        setUp3();
        RExAPIResponseDomain.MultipleResponseInfo result = RESTJourneyPlan.getJourneyplanMasterInfo();
        system.assertNotEquals(null,result);
        Test.stopTest();
    }
    
    static testMethod void testMethod5()
    {
        Test.startTest();
        setUp();
        RExAPIResponseDomain.MultipleResponseInfo retailerClientMapping = RESTRetailerClientMapping.getRetailerClientMappings();
        Test.stopTest();
    }
    
    static testMethod void testMethod6()
    {
        Test.startTest();
        setUp();
        RExAPIResponseDomain.MultipleResponseInfo resultRintinPlan = RESTRintinPlan.getJourneyplanMasterInfo();
        
        Map<String, List<LorealUploadclass.RintinDokoVisitDetailInfo>> TidAndHeaderMap = new Map<String, List<LorealUploadclass.RintinDokoVisitDetailInfo>>();
        
        List<LorealUploadclass.RintinDokoVisitDetailInfo> infoList = new List<LorealUploadclass.RintinDokoVisitDetailInfo>();
        LorealUploadclass.RintinDokoVisitDetailInfo inf = new LorealUploadclass.RintinDokoVisitDetailInfo();
        inf.Tid = '123';
        inf.Rid = '1231';
        inf.HRid = '1544';
        inf.Agentid = '12123';
		infoList.add(inf);
        
        TidAndHeaderMap.put('12212',infoList);
        
        Map<String, Id> TidAndSalesforceIdMap = new Map<String, Id>();
       
       /* ivybase__Resource_Type__c resourceType=TestUtility.createTestResourceType('Test');
        insert resourceType;
        system.debug('curUserId'+userinfo.getUserId());
        ivybase__Resource__c resource = TestUtility.createTestResource('Test Resource',userInfo.getUserId(),resourceType.id);
        insert resource;
        ivybase__Location_Hierarchy__c locationHierarchy = TestUtility.createTestLocationHierarchy('Location Territory',resource.id);
        insert locationHierarchy;
        resource.ivybase__Location_Hierarchy__c=locationHierarchy.id;
        update resource;
        
        
        Date d2=Date.newInstance(2018,7,27);
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c(Territory__c=locationHierarchy.id,Date__c=d2,Month__c=d2.month(),Year__c=d2.year());
        journeyPlan2.Market_ISO__c = 'MY';
        insert journeyPlan2;
        
        JourneyPlanMarket_Visit__c marketVisit4 = new JourneyPlanMarket_Visit__c();
        marketVisit4.JourneyPlan__c=journeyPlan2.id;
        marketVisit4.Market_ISO__c = 'MY';
        insert marketVisit4;
        TidAndSalesforceIdMap.put('1123',marketVisit4.Id);
        
        
         RintinPlanTranslator.RintinDokoActualsDetailMethod(TidAndHeaderMap,NULL,NULL,NULL);*/
        Test.stopTest();
    }
    
    @isTest
    private static void  testRestJourneyPlanException() {
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
                RintinPlanService.getRPlanVisitForToday();
                RExAPIResponseDomain.MultipleResponseInfo result = RESTJourneyPlan.getJourneyplanMasterInfo();
            }Catch(Exception ex) {
            }
        }
        Test.stoptest();
    }
}