@isTest
private class TESTJunctionRecordCreatorClass {
    
    @isTest
    private static void  testgetConfiguration() {
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes'); 
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone1',axe.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',Market_ISO__c='MY',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY');
        insert scheme;
        
        Test.startTest();
        JunctionCreatorWrapperClass junction = JunctionRecordCreatorClass.getConfiguration();
        System.debug('junction===='+junction);
        
        Scheme_Product_creator__mdt  schemeProductmdt = junction.config;
        
        JunctionRecordCreatorClass.getParentFieldDetails(schemeProductmdt.Product_Object_API_Name__c, schemeProductmdt.Product_Column_Name__c);        
        
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c(ivydsd__Group_Logic__c='ANY',ivydsd__Group_Type__c='BUY',
                                                                         ivydsd__Scheme__c=scheme.Id,Name='Scheme Group');
        insert schemeGroup;
        
        List<string> productIdList = new List<String>{p1.Id, p2.Id};
        JunctionRecordCreatorClass.insertjunctionrecords(productIdList, schemeGroup.Id, schemeProductmdt.Product_Column_Name__c, schemeProductmdt.Product_Object_API_Name__c);
        
        List<ivybase__Product_Hierarchy__c> phList = JunctionRecordCreatorClass.getProductHierarchyLevel1(schemeProductmdt.Product_Hierarchy_Level_1_Name__c);
        
        List<ivybase__Product_Hierarchy__c> ph1List = JunctionRecordCreatorClass.getProductHierarchyLevel2(Signature.ivybase__Internal_Id__c,schemeProductmdt.Product_Hierarchy_Level_2_Name__c, schemeProductmdt.Product_Hierarchy_Level_1_Name__c);
        
        JunctionRecordCreatorClass.getSKURecord('Test',schemeProductmdt.Product_Column_Name__c, null, schemeProductmdt.Product_Object_API_Name__c, Brand.ivybase__Internal_Id__c, schemeProductmdt.Product_Hierarchy_Level_2_Name__c, true, schemeGroup.Id);
 
        Test.stopTest();
        
        List<ivydsd__Scheme_Group_Product__c> sgp = [SELECT Id FROM ivydsd__Scheme_Group_Product__c WHERE ivydsd__Scheme_Group__c =: schemeGroup.Id];
        System.assertEquals(sgp.size(),2);
    }
    
    @isTest
    private static void  testgetConfiguration1() {
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes'); 
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone1',axe.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',Market_ISO__c='MY',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY');
        insert scheme;
        
        Test.startTest();
        JunctionCreatorWrapperClass junction = JunctionRecordCreatorClass.getConfiguration();
        System.debug('junction===='+junction);
        
        Scheme_Product_creator__mdt  schemeProductmdt = junction.config;
        
        JunctionRecordCreatorClass.getParentFieldDetails(schemeProductmdt.Product_Object_API_Name__c, schemeProductmdt.Product_Column_Name__c);        
        
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c(ivydsd__Group_Logic__c='ANY',ivydsd__Group_Type__c='BUY',
                                                                         ivydsd__Scheme__c=scheme.Id,Name='Scheme Group');
        insert schemeGroup;
        
        List<string> productIdList = new List<String>{p1.Id, p2.Id};
        JunctionRecordCreatorClass.insertjunctionrecords(productIdList, schemeGroup.Id, schemeProductmdt.Product_Column_Name__c, schemeProductmdt.Product_Object_API_Name__c);
        
        List<ivybase__Product_Hierarchy__c> phList = JunctionRecordCreatorClass.getProductHierarchyLevel1(schemeProductmdt.Product_Hierarchy_Level_1_Name__c);
        
        List<ivybase__Product_Hierarchy__c> ph1List = JunctionRecordCreatorClass.getProductHierarchyLevel2(Signature.ivybase__Internal_Id__c, null, null);
        
        JunctionRecordCreatorClass.getSKURecord('Test',schemeProductmdt.Product_Column_Name__c, null, schemeProductmdt.Product_Object_API_Name__c, '', null, true, schemeGroup.Id);
 
        Test.stopTest();
        
        List<ivydsd__Scheme_Group_Product__c> sgp = [SELECT Id FROM ivydsd__Scheme_Group_Product__c WHERE ivydsd__Scheme_Group__c =: schemeGroup.Id];
        System.assertEquals(sgp.size(),2);
    }
    
    @isTest
    private static void  testgetConfiguration2() {
        
        ivybase__Product_Hierarchy__c Signature = TestUtility.createTestProductHierarchy('Test2','Signature', false ,'Yes'); 
        insert Signature;
        ivybase__Product_Hierarchy__c Brand = TestUtility.createTestProductHierarchy('Test3','Brand', false ,'Yes'); 
        Brand.ivybase__Parent__c = Signature.Id;
        insert Brand;
        ivybase__Product_Hierarchy__c subBrand = TestUtility.createTestProductHierarchy('Test4','Sub_Brand', false ,'Yes');     
        subBrand.ivybase__Parent__c = Brand.Id;
        insert subBrand;
        ivybase__Product_Hierarchy__c reference = TestUtility.createTestProductHierarchy('Test5','Reference', false ,'Yes');     
        reference.ivybase__Parent__c = subBrand.Id;
        insert reference;
        ivybase__Product_Hierarchy__c naunce = TestUtility.createTestProductHierarchy('Test6','Nuance', false ,'Yes');     
        naunce.ivybase__Parent__c = reference.Id;
        insert naunce;
        ivybase__Product_Hierarchy__c axe = TestUtility.createTestProductHierarchy('Test7','Axe', false ,'Yes');     
        axe.ivybase__Parent__c = naunce.Id;
        insert axe;
        ivybase__Product_Hierarchy__c subAxe = TestUtility.createTestProductHierarchy('Test8','Sub_Axe', false ,'Yes');     
        subAxe.ivybase__Parent__c = axe.Id;
        insert subAxe;
        ivybase__Product_Hierarchy__c classP = TestUtility.createTestProductHierarchy('Test9','Class', false ,'Yes');     
        classP.ivybase__Parent__c = subAxe.Id;
        insert classP;
        ivybase__Product_Hierarchy__c function1 = TestUtility.createTestProductHierarchy('Test11','Function', false ,'Yes');     
        function1.ivybase__Parent__c = classP.Id;
        insert function1;
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',function1.Id,'Testdesc', false ,'Yes');
        insert p1;
        
        ivybase__Product__c p2 = TestUtility.createTestProduct('Testdsduploadone1',axe.Id,'Testdesc', false ,'Yes');
        insert p2;
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',Market_ISO__c='MY',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                        ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY');
        insert scheme;
        
        Test.startTest();
        JunctionCreatorWrapperClass junction = JunctionRecordCreatorClass.getConfiguration();
        System.debug('junction===='+junction);
        
        Scheme_Product_creator__mdt  schemeProductmdt = junction.config;
        
        JunctionRecordCreatorClass.getParentFieldDetails(schemeProductmdt.Product_Object_API_Name__c, schemeProductmdt.Product_Column_Name__c);        
        
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c(ivydsd__Group_Logic__c='ANY',ivydsd__Group_Type__c='BUY',
                                                                         ivydsd__Scheme__c=scheme.Id,Name='Scheme Group');
        insert schemeGroup;
        
        List<string> productIdList = new List<String>{p1.Id, p2.Id};
        JunctionRecordCreatorClass.insertjunctionrecords(productIdList, schemeGroup.Id, schemeProductmdt.Product_Column_Name__c, schemeProductmdt.Product_Object_API_Name__c);
        
        List<ivybase__Product_Hierarchy__c> phList = JunctionRecordCreatorClass.getProductHierarchyLevel1(schemeProductmdt.Product_Hierarchy_Level_1_Name__c);
        
        List<ivybase__Product_Hierarchy__c> ph1List = JunctionRecordCreatorClass.getProductHierarchyLevel2(Signature.ivybase__Internal_Id__c, 'Function', 'Signature');
        
        JunctionRecordCreatorClass.getSKURecord('Test',schemeProductmdt.Product_Column_Name__c, null, schemeProductmdt.Product_Object_API_Name__c, '', null, true, schemeGroup.Id);
 
        Test.stopTest();
        
        List<ivydsd__Scheme_Group_Product__c> sgp = [SELECT Id FROM ivydsd__Scheme_Group_Product__c WHERE ivydsd__Scheme_Group__c =: schemeGroup.Id];
        System.assertEquals(sgp.size(),2);
    }
}