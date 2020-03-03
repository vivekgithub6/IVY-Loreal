@isTest
private class TESTRestKPIMaster {
    private static testMethod void testKPI(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        res.Market_ISO__c = 'PH';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        ph.Market_ISO__c = 'PH';  
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');
        Signature.Market_ISO__c = 'PH';    
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.Market_ISO__c = 'PH';
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');   
        subBrand.Market_ISO__c = 'PH';  
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');  
        reference.Market_ISO__c = 'PH';   
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.Market_ISO__c = 'PH';
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.Market_ISO__c = 'PH';
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.Market_ISO__c = 'PH';
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.Market_ISO__c = 'PH';
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');    
        function1.Market_ISO__c = 'PH';
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'PH';
        insert proSKU;
        
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'PH';
        insert locNational;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'PH';
        insert locHr;
        
        Division__c  division = new Division__c (name='Loreal Professional', Market_ISO__c = 'PH');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'PH');
        insert divLoc;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd',Market_ISO__c = 'PH',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR',Market_ISO__c = 'PH',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'PH'),
            new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'PH'),
            new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'PH') 
        };
        insert shyList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Account acc = new Account(Name='aaa', Market_ISO__c = 'PH', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id,Converted_to_Normal_Saloon__c=true);
        insert acc;
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'PH',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'PH',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale1;
        
        ivybase__Standard_List_Master__c inoiceStandard = new ivybase__Standard_List_Master__c(ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__List_Name__c='Loreal Professional',ivybase__List_Code__c = 'LP');
        insert inoiceStandard;
        
        ivybase__Standard_List_Master__c incStand = new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Incentive', ivybase__List_Name__c = 'Incentive', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=inoiceStandard.Id);
        insert  incStand;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Turnover', ivybase__List_Name__c = 'Turnover', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sub Brand', ivybase__List_Name__c = 'Sub Brand', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Incentive', ivybase__List_Name__c = 'Incentive', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=inoiceStandard.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Key Bets', ivybase__List_Name__c = 'Key Bets', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sales', ivybase__List_Name__c = 'Sales', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sell-In %', ivybase__List_Name__c = 'Sell-In %', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Variable- (LP: SMARTBOND)', ivybase__List_Name__c = 'Variable- (LP: SMARTBOND)', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Activation', ivybase__List_Name__c = 'Activation', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'ISMS', ivybase__List_Name__c = 'ISMS', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Fusio Dose', ivybase__List_Name__c = 'Fusio Dose', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Inventory_Check', ivybase__List_Name__c = 'Inventory_Check', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sales KPIs(Kera)', ivybase__List_Name__c = 'Sales KPIs(Kera)', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Conquest', ivybase__List_Name__c = 'Conquest', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'MX', ivybase__List_Name__c = 'MX', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'No of visits/Rep/Day', ivybase__List_Name__c = 'No of visits/Rep/Day', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'No of orders/Rep/ Day', ivybase__List_Name__c = 'No of orders/Rep/ Day', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Average Strike rate', ivybase__List_Name__c = 'Average Strike rate', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
        
        
        
        Turnover__c turnOver = new Turnover__c(Account__c=acc.Id, Market_ISO__c = 'MY', Month__c=Date.today().month(),Year__c=Date.Today().Year(),Product_Hierarchy__c=subAxe.Id,Resource__c=res.Id);
        insert turnOver; 
        
        Message__c msg = new Message__c(Active__c=true,Message__c='Test Message',Valid_From__c=Date.today());
        insert msg;
        
        MessageMapping__c msgMapping  = new MessageMapping__c(Message__c=msg.Id,Resource__c=res.Id);
        insert msgMapping;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Mobile_Order_Number__c = '12345';
        order.ivydsd__Order_Date__c = Date.today();
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        order.Market_ISO__c = 'PH';
        insert order;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','KPI_Group');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        pg1.Market_ISO__c = 'PH';
        insert pg1;
        
        ivybase__Product_Group__c pgMX=TestUtility.createTestProductGroup('TestProductGroupMX','Yes','KPI_Group');
        pgMX.ivybase__Grouping_Type__c = 'MX';
        pgMX.Market_ISO__c = 'PH';
        insert pgMX;
        
        ivybase__Product_Group__c pgISMS=TestUtility.createTestProductGroup('TestProductGroupISMS','Yes','KPI_Group');
        pgISMS.ivybase__Grouping_Type__c = 'ISMS';
        pgISMS.Market_ISO__c = 'PH';
        insert pgISMS;
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','KPI_Group');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Market_ISO__c = 'PH';
        insert pgFusio;
        
        ivybase__Product_Group__c pgColox=TestUtility.createTestProductGroup('TestpgColox','Yes','KPI_Group');
        pgColox.ivybase__Grouping_Type__c = 'Colox Penetration';
        pgColox.Market_ISO__c = 'PH';
        insert pgColox;
        
        ivybase__Product_Group__c Extensioniste =TestUtility.createTestProductGroup('TestProductGroupExtensioniste','Yes','KPI_Group');
        Extensioniste.ivybase__Grouping_Type__c = 'Extensioniste';
        Extensioniste.Market_ISO__c = 'PH';
        insert Extensioniste;
        
        ivybase__Product_Group__c SalesKPIKera =TestUtility.createTestProductGroup('TestProductGroupSalesKPIKera','Yes','KPI_Group');
        SalesKPIKera.ivybase__Grouping_Type__c = 'Sales KPIs(Kera)';
        SalesKPIKera.Market_ISO__c = 'PH';
        insert SalesKPIKera;
        
        ivybase__Product_Group__c Top20MajiPG =TestUtility.createTestProductGroup('TestProductGroupTop20MajiPG','Yes','KPI_Group');
        Top20MajiPG.ivybase__Grouping_Type__c = 'Top 20 MAJI Shades';
        Top20MajiPG.Market_ISO__c = 'PH';
        insert Top20MajiPG;
        
        ivybase__Product_Group__c SMARTBondColox=TestUtility.createTestProductGroup('TestProductGroupSMARTBondColox','Yes','KPI_Group');
        SMARTBondColox.ivybase__Grouping_Type__c = 'SMART Bond';
        SMARTBondColox.Market_ISO__c = 'PH';
        insert SMARTBondColox;
        
        ivybase__Product_Group__c Powermix =TestUtility.createTestProductGroup('TestProductGroupPowermix','Yes','KPI_Group');
        Powermix.ivybase__Grouping_Type__c = 'Powermix';
        Powermix.Market_ISO__c = 'PH';
        insert Powermix;
        
        ivybase__Product_Group__c Top20SKUs=TestUtility.createTestProductGroup('TestProductGroupTop20SKUs','Yes','KPI_Group');
        Top20SKUs.ivybase__Grouping_Type__c = 'Top 20 SKUs';
        Top20SKUs.Market_ISO__c = 'PH';
        insert Top20SKUs;
        
        ivybase__Product_Group__c FusioDose =TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','KPI_Group');
        FusioDose.ivybase__Grouping_Type__c = 'Fusio Dose';
        FusioDose.Market_ISO__c = 'PH';
        insert FusioDose;
        
        Target_Actual__c keybets1 = new Target_Actual__c(Product_Group__c=Top20MajiPG.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Colox penetration',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets1;
        
        Target_Actual__c keybets2 = new Target_Actual__c(Product_Group__c=SMARTBondColox.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Colox penetration',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets2;
        
        Target_Actual__c keybets3 = new Target_Actual__c(Product_Group__c=Powermix.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets3.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets3;
        
        Target_Actual__c keybets4 = new Target_Actual__c(Product_Group__c=Top20SKUs.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets4.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets4;
        
        Target_Actual__c keybets5 = new Target_Actual__c(Product_Group__c=FusioDose.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets5.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets5;
        
        Target_Actual__c con1 = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Conquest monthly',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        con1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert con1;
        
        Target_Actual__c con2 = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Conquest Purchase',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        con2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert con2;
        
        Target_Actual__c Coverage = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        Coverage.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert Coverage;
        
        Target_Actual__c inventory = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        inventory.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Inventory_Check' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert inventory;
        
        Target_Actual__c activation = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        activation.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Activation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert activation;
        
        Target_Actual__c quantity = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        quantity.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Quantity' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert quantity;
        
        Target_Actual__c mxTarget = new Target_Actual__c(Product_Group__c=pgMX.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        mxTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert mxTarget;
        
        Target_Actual__c ismsTarget = new Target_Actual__c(Product_Group__c=pgISMS.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        ismsTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert ismsTarget;
        
        Target_Actual__c FusioTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        FusioTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert FusioTarget;
        
        Target_Actual__c ColoxTarget = new Target_Actual__c(Product_Group__c=pgColox.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        ColoxTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert ColoxTarget;
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Target achievement',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget;
        
        Target_Actual__c salesTarget1 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Quarter incentive',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesTarget1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget1;
        
        Target_Actual__c ExtensionisteTa = new Target_Actual__c(Product_Group__c=Extensioniste.Id,Parameter_type__c = 'Quarter incentive',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        ExtensionisteTa.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert ExtensionisteTa;
        
        Target_Actual__c SalesKPIKeraTa = new Target_Actual__c(Product_Group__c=SalesKPIKera.Id,Parameter_type__c = 'Quarter incentive',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        SalesKPIKeraTa.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert SalesKPIKeraTa;
        
        
        List<Target_Division__c> targetDivList = new List<Target_Division__c>{
            new Target_Division__c(Name='Test Division1',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=con1.Id),
            new Target_Division__c(Name='Test Division11',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=con2.Id),
            new Target_Division__c(Name='Test Division12',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets1.Id),
            new Target_Division__c(Name='Test Division13',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets2.Id),
            new Target_Division__c(Name='Test Division14',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets3.Id),
            new Target_Division__c(Name='Test Division15',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets4.Id),
            new Target_Division__c(Name='Test Division16',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets5.Id),
            new Target_Division__c(Name='Test Division2',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=inventory.Id),
            new Target_Division__c(Name='Test Division3',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=salesTarget.Id),
            new Target_Division__c(Name='Test Division31',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=salesTarget1.Id),
            new Target_Division__c(Name='Test Division4',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=activation.Id),
            new Target_Division__c(Name='Test Division5',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=mxTarget.Id),
            new Target_Division__c(Name='Test Division5',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=ColoxTarget.Id),
            new Target_Division__c(Name='Test Division6',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=ismsTarget.Id),
            new Target_Division__c(Name='Test Division61',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=FusioTarget.Id),
            new Target_Division__c(Name='Test Division62',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=quantity.Id),
            new Target_Division__c(Name='Test Division63',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=ExtensionisteTa.Id),
            new Target_Division__c(Name='Test Division64',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=SalesKPIKeraTa.Id)
        };
        insert targetDivList;  
        
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Date__c=Date.today(),Target__c=1000.0, Territory__c=locHr.Id,Status__c='Draft',SuperVisorComments__c='Test Comments');
        insert salesForecast;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(Name='Test Scheme',Market_ISO__c='MY',ivydsd__Scheme_Type__c  ='QTY',ivydsd__Active__c='Yes',ivydsd__Code__c='SCHEME',
                                                         Product_Hierarchy__c=ph.Id,ivydsd__Description__c='Test Description',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c = Date.today().addYears(5),ivydsd__Scheme_Buy_Logic__c='ANY'); 
        insert scheme;
        
        List<ivybase__Standard_List_Master__c> stdMasterList1 = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DT', ivybase__List_Name__c = 'Bill', ivybase__List_Type__c = 'DISCOUNT_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DAT', ivybase__List_Name__c = 'Item', ivybase__List_Type__c = 'DISCOUNT_APPLY_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'INVOICE', ivybase__List_Name__c = 'Invoice', ivybase__List_Type__c = 'DISCOUNT_MODULE_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                
                }; 
                    insert stdMasterList1;
        
        Sales_Forecast_Detail__c SFCDetailNewLaunch  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList1[0].Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailNewLaunch.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'New_Launch' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailNewLaunch;
        
        Sales_Forecast_Detail__c SFCDetailPromotion  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList1[0].Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailPromotion.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Promotion' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailPromotion;
        
        
        Test.startTest();
        RestKPIMaster.getKPIdata();
        test.stopTest();
        
    }
    
    private static testMethod void testKPISG(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        res.Market_ISO__c = 'SG';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        ph.Market_ISO__c = 'SG';  
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');
        Signature.Market_ISO__c = 'SG';    
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.Market_ISO__c = 'SG';
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');   
        subBrand.Market_ISO__c = 'SG';  
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');  
        reference.Market_ISO__c = 'SG';   
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.Market_ISO__c = 'SG';
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.Market_ISO__c = 'SG';
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.Market_ISO__c = 'SG';
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.Market_ISO__c = 'SG';
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');    
        function1.Market_ISO__c = 'SG';
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'SG';
        insert proSKU;
        
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'SG';
        insert locNational;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'SG';
        insert locHr;
        
        Division__c  division = new Division__c (name='Loreal Professional', Market_ISO__c = 'SG');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'SG');
        insert divLoc;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd',Market_ISO__c = 'SG',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR',Market_ISO__c = 'SG',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'SG'),
            new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'SG'),
            new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'SG') 
        };
        insert shyList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Account acc = new Account(Name='aaa', Market_ISO__c = 'SG', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id,Converted_to_Normal_Saloon__c=true);
        insert acc;
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'SG',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'SG',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale1;
        
        ivybase__Standard_List_Master__c inoiceStandard = new ivybase__Standard_List_Master__c(ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__List_Name__c='Loreal Professional',ivybase__List_Code__c = 'LP');
        insert inoiceStandard;
        
        ivybase__Standard_List_Master__c incStand = new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Incentive', ivybase__List_Name__c = 'Incentive', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=inoiceStandard.Id);
        insert  incStand;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Turnover', ivybase__List_Name__c = 'Turnover', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sub Brand', ivybase__List_Name__c = 'Sub Brand', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Incentive', ivybase__List_Name__c = 'Incentive', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=inoiceStandard.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Key Bets', ivybase__List_Name__c = 'Key Bets', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sales', ivybase__List_Name__c = 'Sales', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sell-In %', ivybase__List_Name__c = 'Sell-In %', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Variable- (LP: SMARTBOND)', ivybase__List_Name__c = 'Variable- (LP: SMARTBOND)', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Activation', ivybase__List_Name__c = 'Activation', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'ISMS', ivybase__List_Name__c = 'ISMS', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Fusio Dose', ivybase__List_Name__c = 'Fusio Dose', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Inventory_Check', ivybase__List_Name__c = 'Inventory_Check', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sales KPIs(Kera)', ivybase__List_Name__c = 'Sales KPIs(Kera)', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Conquest', ivybase__List_Name__c = 'Conquest', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'MX', ivybase__List_Name__c = 'MX', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'No of visits/Rep/Day', ivybase__List_Name__c = 'No of visits/Rep/Day', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'No of orders/Rep/ Day', ivybase__List_Name__c = 'No of orders/Rep/ Day', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Average Strike rate', ivybase__List_Name__c = 'Average Strike rate', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
        
        
        
        Turnover__c turnOver = new Turnover__c(Account__c=acc.Id, Market_ISO__c = 'SG', Month__c=Date.today().month(),Year__c=Date.Today().Year(),Product_Hierarchy__c=subAxe.Id,Resource__c=res.Id);
        insert turnOver; 
        
        Message__c msg = new Message__c(Active__c=true,Message__c='Test Message',Valid_From__c=Date.today());
        insert msg;
        
        MessageMapping__c msgMapping  = new MessageMapping__c(Message__c=msg.Id,Resource__c=res.Id);
        insert msgMapping;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Mobile_Order_Number__c = '12345';
        order.ivydsd__Order_Date__c = Date.today();
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        order.Market_ISO__c = 'SG';
        insert order;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','KPI_Group');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        pg1.Market_ISO__c = 'SG';
        insert pg1;
        
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','KPI_Group');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Market_ISO__c = 'SG';
        insert pgFusio;
        
        ivybase__Product_Group__c SCALPPg =TestUtility.createTestProductGroup('TestProductGroupSCALPPg','Yes','KPI_Group');
        SCALPPg.ivybase__Grouping_Type__c = 'SCALP';
        SCALPPg.Market_ISO__c = 'SG';
        insert SCALPPg;
        
        ivybase__Product_Group__c ColorIncentive =TestUtility.createTestProductGroup('TestProductGroupPowermix','Yes','KPI_Group');
        ColorIncentive.ivybase__Grouping_Type__c = 'Color Incentive';
        ColorIncentive.Market_ISO__c = 'SG';
        insert ColorIncentive;
        
        ivybase__Product_Group__c Top20SKUs=TestUtility.createTestProductGroup('TestProductGroupTop20SKUs','Yes','KPI_Group');
        Top20SKUs.ivybase__Grouping_Type__c = 'Top 20 SKUs';
        Top20SKUs.Market_ISO__c = 'SG';
        insert Top20SKUs;
        
        Target_Actual__c Coverage = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        Coverage.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SG_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert Coverage;
        
        Target_Actual__c Topsku = new Target_Actual__c(Product_Group__c=Top20SKUs.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        Topsku.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SG_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert Topsku;
        
        Target_Actual__c reactivation = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        reactivation.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Reactivation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert reactivation;
        
        Target_Actual__c colorIncentiveTarget = new Target_Actual__c(Product_Group__c=ColorIncentive.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        colorIncentiveTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SG_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert colorIncentiveTarget;
        
        Target_Actual__c FusioTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        FusioTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SG_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert FusioTarget;
        
        Target_Actual__c SCALPPgTarget = new Target_Actual__c(Product_Group__c=SCALPPg.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        SCALPPgTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'SG_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert SCALPPgTarget;
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'TurnOver Incentive',Target__c=1000,Market_ISO__c = 'SG',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget;
        
        
        List<Target_Division__c> targetDivList = new List<Target_Division__c>{
            new Target_Division__c(Name='Test Division1',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=Coverage.Id),
            new Target_Division__c(Name='Test Division11',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=Topsku.Id),
            new Target_Division__c(Name='Test Division12',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=reactivation.Id),
            new Target_Division__c(Name='Test Division13',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=colorIncentiveTarget.Id),
            new Target_Division__c(Name='Test Division14',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=FusioTarget.Id),
            new Target_Division__c(Name='Test Division15',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=SCALPPgTarget.Id),
            new Target_Division__c(Name='Test Division16',Market_ISO__c = 'SG',Division__c=division.Id,Target_Actual__c=salesTarget.Id)
        };
        insert targetDivList;  
        
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Date__c=Date.today(), Target__c=1000.0,Territory__c=locHr.Id,Status__c='Draft',SuperVisorComments__c='Test Comments');
        insert salesForecast;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(Name='Test Scheme',Market_ISO__c='MY',ivydsd__Scheme_Type__c  ='QTY',ivydsd__Active__c='Yes',ivydsd__Code__c='SCHEME',
                                                         Product_Hierarchy__c=ph.Id,ivydsd__Description__c='Test Description',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c = Date.today().addYears(5),ivydsd__Scheme_Buy_Logic__c='ANY'); 
        insert scheme;
        
        List<ivybase__Standard_List_Master__c> stdMasterList1 = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DT', ivybase__List_Name__c = 'Bill', ivybase__List_Type__c = 'DISCOUNT_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DAT', ivybase__List_Name__c = 'Item', ivybase__List_Type__c = 'DISCOUNT_APPLY_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'INVOICE', ivybase__List_Name__c = 'Invoice', ivybase__List_Type__c = 'DISCOUNT_MODULE_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                
                }; 
                    insert stdMasterList1;
        
        Sales_Forecast_Detail__c SFCDetailNewLaunch  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList1[0].Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailNewLaunch.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'New_Launch' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailNewLaunch;
        
        Sales_Forecast_Detail__c SFCDetailPromotion  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList1[0].Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailPromotion.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Promotion' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailPromotion;
        
        
        Test.startTest();
        RestKPIMaster.getKPIdata();
        test.stopTest();
        
    }
    
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
    
    private static testMethod void testKPI1(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        res.Market_ISO__c = 'PH';
        insert res;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes'); 
        ph.Market_ISO__c = 'PH';  
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');
        Signature.Market_ISO__c = 'PH';    
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.Market_ISO__c = 'PH';
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');   
        subBrand.Market_ISO__c = 'PH';  
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');  
        reference.Market_ISO__c = 'PH';   
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.Market_ISO__c = 'PH';
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.Market_ISO__c = 'PH';
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.Market_ISO__c = 'PH';
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.Market_ISO__c = 'PH';
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');    
        function1.Market_ISO__c = 'PH';
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        
        ivybase__Product__c proSKU = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        proSKU.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName ='Product_SKU' AND sobjecttype='ivybase__Product__c' LIMIT 1].Id;
        proSKU.Market_ISO__c = 'PH';
        insert proSKU;
        
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        locNational.Market_ISO__c = 'PH';
        insert locNational;
        
        res.ivybase__Location_Hierarchy__c = locNational.Id;
        res.ivybase__Resource_Type__c = restype.Id;
        update res;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Territory',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        locHr.Market_ISO__c = 'PH';
        insert locHr;
        
        Division__c  division = new Division__c (name='Loreal Professional', Market_ISO__c = 'PH');
        insert division;
        
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'PH');
        insert divLoc;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd',Market_ISO__c = 'PH',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
        ivybase__Location_Hierarchy__c i2=new ivybase__Location_Hierarchy__c(name = 'RRR',Market_ISO__c = 'PH',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('Regional').getRecordTypeId(),ivybase__Parent__c=i1.id);
        
        insert i2;
        List<ivybase__Store_Hierarchy__c> shyList = new List<ivybase__Store_Hierarchy__c>{
            new ivybase__Store_Hierarchy__c(name = 'jjj', ivybase__Active__c = 'yes',Market_ISO__c = 'PH'),
            new ivybase__Store_Hierarchy__c(name = 'kkk', ivybase__Active__c = 'yes',Market_ISO__c = 'PH'),
            new ivybase__Store_Hierarchy__c(name = 'lll', ivybase__Active__c = 'yes',Market_ISO__c = 'PH') 
        };
        insert shyList;
        
        Id accrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Retail_Account').getRecordTypeId();
        
        Account acc = new Account(Name='aaa', Market_ISO__c = 'PH', recordTypeId=accrecordTypeId, ivybase__Active__c='Yes', ivybase__Location_Hierarchy__c=i2.Id, ivybase__Store_Hierarchy__c=shyList[0].Id,Converted_to_Normal_Saloon__c=true);
        insert acc;
        SKU_SaloonSale__c skuasaloonsale= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'PH',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale;
        SKU_SaloonSale__c skuasaloonsale1= new SKU_SaloonSale__c(Product_Master__c=proSKU.id,Market_ISO__c = 'PH',Account__c=acc.id,SaleAmount__c=1,InvoiceDate__c=Date.today());
        insert skuasaloonsale1;
        
        ivybase__Standard_List_Master__c inoiceStandard = new ivybase__Standard_List_Master__c(ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__List_Name__c='Loreal Professional',ivybase__List_Code__c = 'LP');
        insert inoiceStandard;
        
        ivybase__Standard_List_Master__c incStand = new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Incentive', ivybase__List_Name__c = 'Incentive', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=inoiceStandard.Id);
        insert  incStand;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Turnover', ivybase__List_Name__c = 'Turnover', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sub Brand', ivybase__List_Name__c = 'Sub Brand', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Incentive', ivybase__List_Name__c = 'Incentive', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=inoiceStandard.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Key Bets', ivybase__List_Name__c = 'Key Bets', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sales', ivybase__List_Name__c = 'Sales', ivybase__List_Type__c = 'KPI_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sell-In %', ivybase__List_Name__c = 'Sell-In %', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Variable- (LP: SMARTBOND)', ivybase__List_Name__c = 'Variable- (LP: SMARTBOND)', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Activation', ivybase__List_Name__c = 'Activation', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'ISMS', ivybase__List_Name__c = 'ISMS', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Fusio Dose', ivybase__List_Name__c = 'Fusio Dose', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Inventory_Check', ivybase__List_Name__c = 'Inventory_Check', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Sales KPIs(Kera)', ivybase__List_Name__c = 'Sales KPIs(Kera)', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Conquest', ivybase__List_Name__c = 'Conquest', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'MX', ivybase__List_Name__c = 'MX', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Parent_Id__c=incStand.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'No of visits/Rep/Day', ivybase__List_Name__c = 'No of visits/Rep/Day', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'No of orders/Rep/ Day', ivybase__List_Name__c = 'No of orders/Rep/ Day', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Average Strike rate', ivybase__List_Name__c = 'Average Strike rate', ivybase__List_Type__c = 'KPI_DETAIL_TYPE',ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Resource_Type__c=restype.Id)
        }; 
        insert stdMasterList;
        
        
        
        Turnover__c turnOver = new Turnover__c(Account__c=acc.Id, Market_ISO__c = 'MY', Month__c=Date.today().month(),Year__c=Date.Today().Year(),Product_Hierarchy__c=subAxe.Id,Resource__c=res.Id);
        insert turnOver; 
        
        Message__c msg = new Message__c(Active__c=true,Message__c='Test Message',Valid_From__c=Date.today());
        insert msg;
        
        MessageMapping__c msgMapping  = new MessageMapping__c(Message__c=msg.Id,Resource__c=res.Id);
        insert msgMapping;
        
        Contact con = TestUtility.createTestContact('Test','Contact',  userId, 'GBP' , 'test12345@testmail.com','PreSeller','Merchandiser' );
        insert con;
        
        ivydsd__Order__c order = TestUtility.createTestOrder(acc.id,'Ordered',con.id,'1');   
        order.ivydsd__Mobile_Order_Number__c = '12345';
        order.ivydsd__Order_Date__c = Date.today();
        order.Division__c=division.id;
        order.ivydsd__Resource__c = res.Id;
        order.Market_ISO__c = 'PH';
        insert order;
        ivybase__Product_Group__c pg1=TestUtility.createTestProductGroup('TestProductGroup','Yes','KPI_Group');
        pg1.ivybase__Grouping_Type__c = 'New Launch';
        pg1.Market_ISO__c = 'PH';
        insert pg1;
        
        ivybase__Product_Group__c pgMX=TestUtility.createTestProductGroup('TestProductGroupMX','Yes','KPI_Group');
        pgMX.ivybase__Grouping_Type__c = 'MX';
        pgMX.Market_ISO__c = 'PH';
        insert pgMX;
        
        ivybase__Product_Group__c pgISMS=TestUtility.createTestProductGroup('TestProductGroupISMS','Yes','KPI_Group');
        pgISMS.ivybase__Grouping_Type__c = 'ISMS';
        pgISMS.Market_ISO__c = 'PH';
        insert pgISMS;
        ivybase__Product_Group__c pgFusio=TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','KPI_Group');
        pgFusio.ivybase__Grouping_Type__c = 'Fusio Dose';
        pgFusio.Market_ISO__c = 'PH';
        insert pgFusio;
        
        ivybase__Product_Group__c pgColox=TestUtility.createTestProductGroup('TestpgColox','Yes','KPI_Group');
        pgColox.ivybase__Grouping_Type__c = 'Colox Penetration';
        pgColox.Market_ISO__c = 'PH';
        insert pgColox;
        
        ivybase__Product_Group__c Extensioniste =TestUtility.createTestProductGroup('TestProductGroupExtensioniste','Yes','KPI_Group');
        Extensioniste.ivybase__Grouping_Type__c = 'Extensioniste';
        Extensioniste.Market_ISO__c = 'PH';
        insert Extensioniste;
        
        ivybase__Product_Group__c SalesKPIKera =TestUtility.createTestProductGroup('TestProductGroupSalesKPIKera','Yes','KPI_Group');
        SalesKPIKera.ivybase__Grouping_Type__c = 'Sales KPIs(Kera)';
        SalesKPIKera.Market_ISO__c = 'PH';
        insert SalesKPIKera;
        
        ivybase__Product_Group__c Top20MajiPG =TestUtility.createTestProductGroup('TestProductGroupTop20MajiPG','Yes','KPI_Group');
        Top20MajiPG.ivybase__Grouping_Type__c = 'Top 20 MAJI Shades';
        Top20MajiPG.Market_ISO__c = 'PH';
        insert Top20MajiPG;
        
        ivybase__Product_Group__c SMARTBondColox=TestUtility.createTestProductGroup('TestProductGroupSMARTBondColox','Yes','KPI_Group');
        SMARTBondColox.ivybase__Grouping_Type__c = 'SMART Bond';
        SMARTBondColox.Market_ISO__c = 'PH';
        insert SMARTBondColox;
        
        ivybase__Product_Group__c Powermix =TestUtility.createTestProductGroup('TestProductGroupPowermix','Yes','KPI_Group');
        Powermix.ivybase__Grouping_Type__c = 'Powermix';
        Powermix.Market_ISO__c = 'PH';
        insert Powermix;
        
        ivybase__Product_Group__c Top20SKUs=TestUtility.createTestProductGroup('TestProductGroupTop20SKUs','Yes','KPI_Group');
        Top20SKUs.ivybase__Grouping_Type__c = 'Top 20 SKUs';
        Top20SKUs.Market_ISO__c = 'PH';
        insert Top20SKUs;
        
        ivybase__Product_Group__c FusioDose =TestUtility.createTestProductGroup('TestProductGroupFusio','Yes','KPI_Group');
        FusioDose.ivybase__Grouping_Type__c = 'Fusio Dose';
        FusioDose.Market_ISO__c = 'PH';
        insert FusioDose;
        
        Target_Actual__c keybets1 = new Target_Actual__c(Product_Group__c=Top20MajiPG.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Colox penetration',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets1;
        
        Target_Actual__c keybets2 = new Target_Actual__c(Product_Group__c=SMARTBondColox.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Colox penetration',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets2;
        
        Target_Actual__c keybets3 = new Target_Actual__c(Product_Group__c=Powermix.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets3.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets3;
        
        Target_Actual__c keybets4 = new Target_Actual__c(Product_Group__c=Top20SKUs.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets4.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets4;
        
        Target_Actual__c keybets5 = new Target_Actual__c(Product_Group__c=FusioDose.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        keybets5.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Keybets_Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert keybets5;
        
        Target_Actual__c con1 = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Conquest monthly',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        con1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert con1;
        
        Target_Actual__c con2 = new Target_Actual__c(Product_Group__c=pg1.Id,Target__c=1000,Market_ISO__c = 'PH',Parameter_type__c = 'Conquest Purchase',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        con2.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Conquest' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert con2;
        
        Target_Actual__c Coverage = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        Coverage.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert Coverage;
        
        Target_Actual__c inventory = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        inventory.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Inventory_Check' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert inventory;
        
        Target_Actual__c activation = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        activation.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Activation' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert activation;
        
        Target_Actual__c quantity = new Target_Actual__c(Product_Group__c=pg1.Id,Parameter_type__c = 'Avg No Of Orders',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        quantity.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Quantity' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert quantity;
        
        Target_Actual__c mxTarget = new Target_Actual__c(Product_Group__c=pgMX.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        mxTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert mxTarget;
        
        Target_Actual__c ismsTarget = new Target_Actual__c(Product_Group__c=pgISMS.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        ismsTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert ismsTarget;
        
        Target_Actual__c FusioTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        FusioTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert FusioTarget;
        
        Target_Actual__c ColoxTarget = new Target_Actual__c(Product_Group__c=pgColox.Id,Parameter_type__c = 'Colox penetration',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        ColoxTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Coverage' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert ColoxTarget;
        
        Target_Actual__c salesTarget = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Target achievement',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesTarget.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget;
        
        Target_Actual__c salesTarget1 = new Target_Actual__c(Product_Group__c=pgFusio.Id,Parameter_type__c = 'Quarter incentive',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        salesTarget1.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert salesTarget1;
        
        Target_Actual__c ExtensionisteTa = new Target_Actual__c(Product_Group__c=Extensioniste.Id,Parameter_type__c = 'Quarter incentive',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        ExtensionisteTa.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert ExtensionisteTa;
        
        Target_Actual__c SalesKPIKeraTa = new Target_Actual__c(Product_Group__c=SalesKPIKera.Id,Parameter_type__c = 'Quarter incentive',Target__c=1000,Market_ISO__c = 'PH',Actual__c=1000,Resource__c=res.Id,Month__c=Date.today().Month());
        SalesKPIKeraTa.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Sales_Target' AND sobjecttype='Target_Actual__c' LIMIT 1].Id;
        insert SalesKPIKeraTa;
        
        
        List<Target_Division__c> targetDivList = new List<Target_Division__c>{
            new Target_Division__c(Name='Test Division1',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=con1.Id),
            new Target_Division__c(Name='Test Division11',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=con2.Id),
            new Target_Division__c(Name='Test Division12',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets1.Id),
            new Target_Division__c(Name='Test Division13',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets2.Id),
            new Target_Division__c(Name='Test Division14',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets3.Id),
            new Target_Division__c(Name='Test Division15',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets4.Id),
            new Target_Division__c(Name='Test Division16',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=keybets5.Id),
            new Target_Division__c(Name='Test Division2',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=inventory.Id),
            new Target_Division__c(Name='Test Division3',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=salesTarget.Id),
            new Target_Division__c(Name='Test Division31',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=salesTarget1.Id),
            new Target_Division__c(Name='Test Division4',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=activation.Id),
            new Target_Division__c(Name='Test Division5',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=mxTarget.Id),
            new Target_Division__c(Name='Test Division5',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=ColoxTarget.Id),
            new Target_Division__c(Name='Test Division6',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=ismsTarget.Id),
            new Target_Division__c(Name='Test Division61',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=FusioTarget.Id),
            new Target_Division__c(Name='Test Division62',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=quantity.Id),
            new Target_Division__c(Name='Test Division63',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=ExtensionisteTa.Id),
            new Target_Division__c(Name='Test Division64',Market_ISO__c = 'PH',Division__c=division.Id,Target_Actual__c=SalesKPIKeraTa.Id)
        };
        insert targetDivList;  
        
        
        Sales_Forecast__c salesForecast = new Sales_Forecast__c(Date__c=Date.today(),Target__c=1000.0, Territory__c=locHr.Id,Status__c='Approved',SuperVisorComments__c='Test Comments');
        insert salesForecast;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(Name='Test Scheme',Market_ISO__c='MY',ivydsd__Scheme_Type__c  ='QTY',ivydsd__Active__c='Yes',ivydsd__Code__c='SCHEME',
                                                         Product_Hierarchy__c=ph.Id,ivydsd__Description__c='Test Description',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c = Date.today().addYears(5),ivydsd__Scheme_Buy_Logic__c='ANY'); 
        insert scheme;
        
        List<ivybase__Standard_List_Master__c> stdMasterList1 = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DT', ivybase__List_Name__c = 'Bill', ivybase__List_Type__c = 'DISCOUNT_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'DAT', ivybase__List_Name__c = 'Item', ivybase__List_Type__c = 'DISCOUNT_APPLY_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'INVOICE', ivybase__List_Name__c = 'Invoice', ivybase__List_Type__c = 'DISCOUNT_MODULE_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)                
        }; 
        insert stdMasterList1;
        
        Sales_Forecast_Detail__c SFCDetailNewLaunch  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList1[0].Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailNewLaunch.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'New_Launch' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailNewLaunch;
        
        Sales_Forecast_Detail__c SFCDetailPromotion  = new Sales_Forecast_Detail__c(Product_Hierarchy__c=ph.Id,Scheme__c=scheme.Id,Quantity__c=100,Sales_Forecast__c=salesForecast.Id,Standard_List_Master__c=stdMasterList1[0].Id,Store__c=acc.Id,Target__c=1000);
        SFCDetailPromotion.RecordTypeId = [SELECT Id FROM RecordType WHERE DeveloperName = 'Promotion' AND sobjecttype='Sales_Forecast_Detail__c' LIMIT 1].Id;
        insert SFCDetailPromotion;
        
        
        Test.startTest();
        RestKPIMaster.getKPIdata();
        test.stopTest();
        
    }
       
}