@isTest
public class Test_PromotionDeltionTriggers {
    private static testMethod void testSchemeApplyDetail(){
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
        insert divLoc;
    
        
        
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
        
        
        ivydsd__Scheme__c scheme = new ivydsd__Scheme__c(ivydsd__Active__c='Yes',ivydsd__Code__c='TEST',ivydsd__Description__c='test',
                                                         ivydsd__Scheme_Buy_Logic__c='ANY',ivydsd__From__c=Date.today(),
                                                         ivydsd__To__c=Date.today().addDays(5),Name='TEST',ivydsd__Scheme_Type__c='QTY',Market_ISO__c='MY');
        insert scheme;
        
        ivydsd__Scheme_Slab__c schemeSlab = new ivydsd__Scheme_Slab__c(Name='Test Slab',ivydsd__Scheme__c=scheme.Id);
        insert schemeSlab;
        
        
     
        
        ivydsd__Scheme_Group__c schemeGroup = new ivydsd__Scheme_Group__c(ivydsd__Group_Logic__c='ANY',ivydsd__Group_Type__c='BUY',
                                                                          ivydsd__Scheme__c=scheme.Id,Name='Scheme Group');
        insert schemeGroup;
        
           ivydsd__Scheme_Slab_Target__c slbtarget = new ivydsd__Scheme_Slab_Target__c(Name='slab target',ivydsd__Scheme_Slab__c=schemeSlab.id,
                                                                                       ivydsd__Minimum_Value__c=100,Type__c='QTY',ivydsd__Scheme_Group__c=schemeGroup.id);
       
        insert slbtarget;
            
            ivydsd__Scheme_Free_Detail__c sfdetail = new ivydsd__Scheme_Free_Detail__c(ivydsd__Scheme_Slab__c=schemeSlab.id,
                                                                                       ivydsd__Free_Quantity_UOM__c='piece',Scheme_Type__c='QTY');
        insert sfdetail;
        delete slbtarget;
        delete sfdetail;
        delete schemeSlab;
        
        Promotion_Package_Capping__c pkm= new Promotion_Package_Capping__c(Promotion__c=scheme.Id,name='caping',Division__c=division.id);
        insert pkm;
        delete pkm;
        Test.startTest();
 
        
        ivydsd__Scheme_Group_Product__c schemeGrpProduct = new ivydsd__Scheme_Group_Product__c(ivydsd__Product1__c=p1.Id,ivydsd__Scheme_Group__c=schemeGroup.Id);
        insert schemeGrpProduct;
        update schemeGrpProduct;
        delete schemeGrpProduct;
        
        delete schemeGroup;
        Test.stopTest();        
        
    }
}