@isTest
public class TESTProductGroupTranslator {
    private static testMethod void testProGrpTranslator(){
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c = '12345';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        ivybase__Location_Hierarchy__c locNational= TestUtility.createTestLocationHierarchy('Test Location National',res.Id); 
        locNational.RecordTypeId = RT.get('National').getRecordTypeId();
        locNational.ivybase__Resource_Type__c = restype.id;
        insert locNational;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        
        Division__c  division = new Division__c (name='matrix');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id);
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
        List<ivybase__Product_Group__c> proList = new List<ivybase__Product_Group__c>();
        proList.add(pg1);
        
        ivybase__Product_Hierarchy__c ph = TestUtility.createTestProductHierarchy('Test','Function', true ,'Yes'); 
        insert ph;
        System.debug('ph::'+ph);
        ivybase__Product_Hierarchy__c brandh = TestUtility.createTestProductHierarchy('Test','Brand', true ,'Yes'); 
        insert brandh;
        System.debug('brand::'+brandh);
        
        ivybase__Product__c p1 = TestUtility.createTestProduct('Testdsduploadone',ph.Id,'Testdesc', false ,'Yes');
        p1.ivybase__Barcode__c = 1234;
        insert p1;
        
        
        
        ivybase__Standard_List_Master__c signature = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Signature',ivybase__List_Code__c='Signature',ivybase__List_Type__c = 'PRODUCT_HIERARCHY', ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert signature;
        ivybase__Standard_List_Master__c Brand = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Brand',ivybase__List_Code__c='Brand',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= signature.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert Brand;
        ivybase__Standard_List_Master__c SubBrand = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Sub Brand',ivybase__List_Code__c='Sub Brand',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= Brand.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert SubBrand;
        ivybase__Standard_List_Master__c Reference = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Reference',ivybase__List_Code__c='Reference',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= SubBrand.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert Reference;
        ivybase__Standard_List_Master__c Nuance = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Nuance',ivybase__List_Code__c='Nuance',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= Reference.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert Nuance;
        ivybase__Standard_List_Master__c Axe = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Axe',ivybase__List_Code__c='Axe',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= Nuance.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert Axe;
        ivybase__Standard_List_Master__c SubAxe = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Sub Axe',ivybase__List_Code__c='Sub Axe',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= Axe.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert SubAxe;
        ivybase__Standard_List_Master__c Classs = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Class',ivybase__List_Code__c='Class',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= SubAxe.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert Classs;
        ivybase__Standard_List_Master__c Function = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Function',ivybase__List_Code__c='Function',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= Classs.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert Function;
        ivybase__Standard_List_Master__c ProductSKU = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Product SKU',ivybase__List_Code__c='Product SKU',ivybase__List_Type__c = 'PRODUCT_HIERARCHY',ivybase__Parent_Id__c= Function.Id, ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert ProductSKU;
        
        ivybase__Standard_List_Master__c top20 = new ivybase__Standard_List_Master__c(ivybase__List_Name__c = 'Top20sku',ivybase__List_Code__c='TOPTWNY',ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c = locNational.Id, ivybase__Resource_Type__c = restype.Id);
        insert top20;
        
        List<ivybase__Standard_List_Master__c> SLMList = new List<ivybase__Standard_List_Master__c>();
        SLMList.add(signature); SLMList.add(Brand); SLMList.add(SubBrand); SLMList.add(Reference); SLMList.add(Nuance);
        SLMList.add(Axe);SLMList.add(SubAxe); SLMList.add(Classs); SLMList.add(Function); SLMList.add(ProductSKU); SLMList.add(top20);
        
        List<ivybase__Product_Group_Detail__c> proDetailList = new List<ivybase__Product_Group_Detail__c>{
           new ivybase__Product_Group_Detail__c(ivybase__Product_Group__c=pg1.Id,Product_Hierarchy__c=brandh.Id,ivybase__Product__c=p1.Id,ivybase__Standard_List_Master__c=top20.Id) 
        };
        insert proDetailList;
        
        List<ivybase__Product_Group_Mapping__c> proMapList = new List<ivybase__Product_Group_Mapping__c>{
            new ivybase__Product_Group_Mapping__c(ivybase__Location_Hierarchy__c=locNational.Id,ivybase__Product_Group__c=pg1.Id,ivybase__Distributor__c=acc.Id)
        };
            insert proMapList;
        
        
        ProductGroupTranslator.objectToProductTaggingInfo(proList,SLMList,null);
        ProductGroupTranslator.objectToProductGroupDetailInfo(proDetailList,null);    
        ProductGroupTranslator.objectToProductGroupMappingInfo(proMapList,null);
        
                
       
    }

}