/*last edited on 03052019*/
@isTest
private class TESTOrdersPerRepPerDayBatch {

    private static testMethod void testOrdersPerResp(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        ivybase__Location_Hierarchy__c locnat= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locnat.RecordTypeId = RT.get('National').getRecordTypeId();
        locnat.ivybase__Resource_Type__c = restype.id;
        insert locnat;
        res.ivybase__Location_Hierarchy__c = locnat.Id;
        update res;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c = Date.today();
        order.ivydsd__Order_Status__c = 'Ordered';
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id; 
        insert order;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 100 , 0 , 0 , 10 , 0 , 0 );
        insert oli;
        
        Target_Actual__c target = new Target_Actual__c(Resource__c=res.Id,Actual__c=100,
                                                       Achievement__c=10,Month__c=Date.today().month(),
                                                      Parameter_type__c='Avg No Of Orders' ,Market_ISO__c='MY');
        target.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        target.Market_ISO__c = 'MY';
        insert target;
        
        ivybase__Holiday__c holiday = new ivybase__Holiday__c(ivybase__Start__c=Date.today().addDays(-4),ivybase__End__c=Date.today().adddays(-1),
                                                              ivybase__Description__c='Diwali',Market_ISO__c='MY',Location_Hierarchy__c=locnat.Id);
        insert holiday;
        ivybase__Holiday__c holiday2 = new ivybase__Holiday__c(ivybase__Start__c=Date.today().addDays(-4),ivybase__End__c=Date.today().adddays(-4),
                                                              ivybase__Description__c='Vinayaka Chathurdi',Market_ISO__c='MY',Location_Hierarchy__c=locnat.Id);
        insert holiday2;
        
        CalculateDaysDiffExcludingHoliday days = new CalculateDaysDiffExcludingHoliday();
        Integer noOfholidays = days.CalculateWorkingDays(Date.today().addDays(-3),Date.today().addDays(-3));
        
        Batch_SwitchOff__c cs = new Batch_SwitchOff__c();
        cs.name='VisitsPerRepPerDayBatch';
        cs.SwitchOff__c=false;
        insert cs;
        
        Test.startTest();
        OrdersPerRepPerDayBatch batch = new OrdersPerRepPerDayBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
    private static testMethod void testOrdersPerResp1(){
    
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        ivybase__Location_Hierarchy__c locnat= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locnat.RecordTypeId = RT.get('National').getRecordTypeId();
        locnat.ivybase__Resource_Type__c = restype.id;
        insert locnat;
        res.ivybase__Location_Hierarchy__c = locnat.Id;
        update res;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        acc.ivybase__Location_Hierarchy__c = locHr.Id;
        acc.Converted_to_Normal_Saloon__c = true;
        acc.Dream_List_Status__c ='Test';
        acc.Progress_Percentage__c = 100;
        insert acc;
        update acc;
        
        Account acc1 = TestUtility.createTestAccount('2' , 'Test Acc 1' , '123456783' , '111222344' , res.id , 'Retail_Account' , 'Yes' );
        acc1.ivybase__Location_Hierarchy__c = locHr.Id;
        acc1.Converted_to_Normal_Saloon__c = true;
        acc1.Dream_List_Status__c ='Test';
        acc1.Progress_Percentage__c = 100;
        insert acc1;
        update acc1;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','Top20sku');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        insert pg1;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Order_Date__c = Date.today();
        order.ivydsd__Order_Status__c = 'Ordered';
        order.ivydsd__Resource__c = res.Id;
        order.Division__c=division.id; 
        insert order;
        
        ivydsd__Order_Line_item__c oli = TestUtility.createTestOrderLineItem(order.id , p1.id, 100 , 0 , 0 , 10 , 0 , 0 );
        insert oli;
        
        Target_Actual__c target = new Target_Actual__c(Resource__c=res.Id,Actual__c=100,
                                                       Achievement__c=10,Month__c=Date.today().month(),
                                                      Parameter_type__c='Avg No Of Orders');
        target.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        target.Market_ISO__c = 'MY';
        insert target;
        
        ivybase__Holiday__c holiday = new ivybase__Holiday__c(ivybase__Start__c=Date.today().addDays(-4),ivybase__End__c=Date.today().adddays(-1),
                                                              ivybase__Description__c='Diwali',Market_ISO__c='MY',Location_Hierarchy__c=locnat.Id);
        insert holiday;
        ivybase__Holiday__c holiday2 = new ivybase__Holiday__c(ivybase__Start__c=Date.today().addDays(-4),ivybase__End__c=Date.today().adddays(-4),
                                                              ivybase__Description__c='Vinayaka Chathurdi',Market_ISO__c='MY',Location_Hierarchy__c=locnat.Id);
        insert holiday2;
        
        List<ivybase__Standard_List_Master__c> assets = new List<ivybase__Standard_List_Master__c>{
                 
            new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Leave',ivybase__List_Code__c='PL', ivybase__List_Type__c = 'JP_ACTIVITY', ivybase__Location_Hierarchy__c = locnat.Id, ivybase__Resource_Type__c = restype.Id)
    
        };
        insert assets;
            
        JourneyPlan__c journeyPlan = new JourneyPlan__c();
        journeyPlan.Year__c=2018;
        journeyPlan.Tid__c='555';
        journeyPlan.Territory__c=locHr.Id;
        journeyPlan.Status__c='Draft';
        journeyPlan.Month__c=Date.today().Month();
        journeyPlan.SupervisorComments__c='Test Comments';
        Date d=Date.newInstance(2018,6,17);
        journeyPlan.Date__c=Date.today();
        journeyPlan.Market_ISO__c = 'MY';
        insert journeyPlan;
        
        JourneyPlan__c journeyPlan2 = new JourneyPlan__c();
        journeyPlan2.Year__c=2018;
        journeyPlan2.Tid__c='535';
        journeyPlan2.Territory__c=locHr.Id;
        journeyPlan2.Status__c='Draft';
        journeyPlan2.Month__c=Date.today().Month();
        journeyPlan2.SupervisorComments__c='Test Comments';
        Date d2=Date.newInstance(2018,10,27);
        journeyPlan2.Date__c=Date.today();
        journeyPlan2.Market_ISO__c = 'MY';
        insert journeyPlan2;
        
        JourneyPlanActivity__c journeyPlanActivty = new JourneyPlanActivity__c();
        journeyPlanActivty.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty.Date__c=Date.today();
        journeyPlanActivty.JourneyPlan__c=journeyPlan.id;
        journeyPlanActivty.Name=journeyPlan.Tid__c;
        journeyPlanActivty.TypeId__c=assets[0].id;
        journeyPlanActivty.Store__c = acc.Id;
        journeyPlanActivty.Market_ISO__c = 'MY';
        insert journeyPlanActivty;
        
        JourneyPlanActivity__c journeyPlanActivty2 = new JourneyPlanActivity__c();
        journeyPlanActivty2.Comments__c='sdsdsd';
        journeyPlanActivty.WorkWithUserId__c='2342';
        journeyPlanActivty2.Date__c=Date.today();
        journeyPlanActivty2.JourneyPlan__c=journeyPlan2.id;
        journeyPlanActivty2.Name=journeyPlan.Tid__c;
        journeyPlanActivty2.TypeId__c=assets[0].id;
        journeyPlanActivty2.Store__c = acc1.Id;   
        journeyPlanActivty2.Market_ISO__c = 'MY';
        insert journeyPlanActivty2;
        
        CalculateDaysDiffExcludingHoliday days = new CalculateDaysDiffExcludingHoliday();
        Integer noOfholidays = days.CalculateWorkingDays(Date.today().addDays(-3),Date.today().addDays(-3));
        
        Test.startTest();
        OrdersPerRepPerDayBatch batch = new OrdersPerRepPerDayBatch();
        Database.executeBatch(batch);
        Test.stopTest();
    }

}