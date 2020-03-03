@isTest
Private class SellerMessageBoardService_Test {
    private static testMethod void testInvoiceService(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.Market_ISO__c = 'PH';
        insert res;
        
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','KPI_Group');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        pg1.Market_ISO__c = 'PH';
        insert pg1;
        
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','KPI_Group');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Market_ISO__c = 'PH';
        insert pgFusio;
        
        List<Target_Actual__c> taList = new List<Target_Actual__c>();
        Target_Actual__c con2 = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Conquest Purchase',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        con2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(con2);
        
        Target_Actual__c TOperRep = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='');
        TOperRep.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(TOperRep);
        
        Target_Actual__c SFATO = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Average Turnover Per Order');
        SFATO.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(SFATO);
        
        Target_Actual__c SAPTurnOver = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Active No Of Customers');
        SAPTurnOver.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(SAPTurnOver);
        
        Target_Actual__c covRate = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='');
        covRate.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(covRate);
        
        Target_Actual__c reactRate = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Reactivation-rate');
        reactRate.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(reactRate);
        
        Target_Actual__c monthly = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Monthly Activation rate');
        monthly.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(monthly);
        
        Target_Actual__c gainClients = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Gain of new clients');
        gainClients.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(gainClients);
        
        Target_Actual__c lossClients = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Loss of Clients');
        lossClients.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(lossClients);
        
        Target_Actual__c colox = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Colox penetration');
        colox.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(colox);
        
        
        Target_Actual__c TOperClient = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Average turnover per salon');
        TOperClient.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(TOperClient);
        
        Target_Actual__c OrdRepDay = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Avg No Of Orders');
        OrdRepDay.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(OrdRepDay);
        
        Target_Actual__c VisRepDay = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Avg No Of Visits');
        VisRepDay.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(VisRepDay);
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Target achievement',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(salesTarget); 
        
        Target_Actual__c strikeRate = new Target_Actual__c(Product_Group__c=pg1.Id,Market_ISO__c = 'PH',Target__c=1000,Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month(),Parameter_type__c='Average Strike rate');
        strikeRate.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_KPI' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        taList.add(strikeRate);
        
        insert taList;
        
        Test.startTest();
        RestKPIMaster.getKPIdata();
        test.stopTest();
    }
}