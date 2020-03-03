@isTest
private class TESTRESTSKULevelMinMaxClass {

    private static testMethod void testSKULevelMinMax(){
    
        ivybase__Resource_Type__c restype= TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,resType.id);   
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY',ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        
        res.ivybase__Location_Hierarchy__c = i1.Id;
        update res;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        insert ph;
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test','Signature', false ,'Yes');     
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test','Sub_Brand', false ,'Yes');     
        //subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function = TestUtility.createTestProductHierarchy('Test','Function', false ,'Yes');     
        function.ivybase__Parent__c = classP.Id;
        insert function;
       
        ivybase__Location__c loc = new ivybase__Location__c(name='test',Market_ISO__c = 'MY',ivybase__Active__c = 'Yes',RecordTypeId =[SELECT Id FROM RecordType WHERE DeveloperName = 'Warehouse' AND sobjecttype='ivybase__Location__c' LIMIT 1].Id);
        insert loc;
        
        Account acc = TestUtility.createTestAccount('1' , 'Test Acc' , '123456789' , '111222333' , res.id , 'Retail_Account' , 'Yes' );
        insert acc;
        
        Division__c div = new Division__c(Name='Loreal Professional',Division_Code__c='LP',Market_ISO__c = 'MY');
        insert div;
        
        Division__c div2 = new Division__c(Name='Kerastase',Division_Code__c='KERA',Market_ISO__c = 'MY');
        insert div2;
        
        DivisionLocation__c divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.Id,Division__c = div.Id,Market_ISO__c = 'MY');
        insert divLoc;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',function.Id,'Testdesc', false ,'Yes');
        p1.Division__c = div.Id;
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('TestdsduploadTwo',function.Id,'Testdesc', false ,'Yes');
        p2.Division__c = div.Id;
        insert p2;
        
        Set<String> internalIdSet = new Set<String>();
        internalIdSet.add(string.valueOf(p1.ivybase__InternalId__c));
        
        ivybase__Location_Stock__c stock= new ivybase__Location_Stock__c(ivybase__VanLoad_Mobile_Uid__c=null,ivybase__Location__c=loc.Id,Market_ISO__c='MY',ivybase__Product__c= p1.Id ,ivybase__Type__c='Stock Check',ivybase__UOM1__c=3);   
        insert stock; 
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'LP', ivybase__List_Name__c = 'Loreal Professional', ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'KERA', ivybase__List_Name__c = 'Kerastase', ivybase__List_Type__c = 'DIVISION_TYPE',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
        }; 
        insert stdMasterList;        
         Trigger_Logic_Configuration__c cs = new Trigger_Logic_Configuration__c();
        cs.name='MinMaxSKUCappingTrigger';
        cs.Deactive_Logic__c=false;
        insert cs; 
        Min_Max_Product_Capping__c mmProdCap = new Min_Max_Product_Capping__c();
        mmProdCap.Maximum_Qty__c = 10;
        mmProdCap.Minimum_Qty__c = 5;
        mmProdCap.Product__c = p1.Id;
        mmProdCap.Start_Date__c = System.today();
        mmProdCap.End_Date__c = System.today().addDays(+10);
        mmProdCap.Is_Active__c = true;
        mmProdCap.Salon__c = acc.Id;
        insert mmProdCap;
        
        Min_Max_Product_Capping__c mmProdCap1 = new Min_Max_Product_Capping__c();
        mmProdCap1.Maximum_Qty__c = 10;
        mmProdCap1.Minimum_Qty__c = 5;
        mmProdCap1.Product_Hierarchy__c = Brand.Id;
        mmProdCap1.Start_Date__c = System.today();
        mmProdCap1.End_Date__c = System.today().addDays(+10);
        mmProdCap1.Is_Active__c = true;
        mmProdCap1.Division__c = div.Id;
        
        insert mmProdCap1;
        
        Min_Max_Product_Capping__c mmProdCap2 = new Min_Max_Product_Capping__c();
        mmProdCap2.Start_Date__c = System.today();
        mmProdCap2.End_Date__c = System.today().addDays(+10);
        mmProdCap2.Product__c = p2.Id;
        mmProdCap2.Is_Active__c = true;
        mmProdCap2.Salon__c = acc.Id;
        insert mmProdCap2;
        
          
        
        Test.startTest();
        RESTSKULevelMinMaxClass.getMinmaxInfo();
        Test.stopTest();
        
    }
    
    @isTest
    private static void  testSKULevelMinMaxException() {
        Trigger_Logic_Configuration__c cs = new Trigger_Logic_Configuration__c();
        cs.name='MinMaxSKUCappingTrigger';
        cs.Deactive_Logic__c=false;
        insert cs;
        
        Test.starttest();
        User u1 = TestUtility.getCharterFreeUser();
        
        System.runAs(u1){
            try{
                RESTSKULevelMinMaxClass.getMinmaxInfo();
            } Catch(Exception ex) {
            
            }
        }
        Test.stoptest();
    }
       
}