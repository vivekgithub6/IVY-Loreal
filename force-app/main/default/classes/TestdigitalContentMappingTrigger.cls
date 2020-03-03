@isTest
public class TestdigitalContentMappingTrigger {
   
public static testmethod void populateSLMMasterSalesPresenter()
{
     ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
     List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
    
    RT = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    ivybase__Digital_Content__c digitalCOntent = new ivybase__Digital_Content__c();
    digitalCOntent.RecordTypeId=RT.get('SalesPresenter').getRecordTypeId();
    digitalCOntent.Market_ISO__c = 'MY';
    insert digitalCOntent;
    
    ivybase__Digital_Content_Mapping__c digitalMapping = new ivybase__Digital_Content_Mapping__c ();
    digitalMapping.ivybase__Digital_Content__c=digitalCOntent.id;
    digitalMapping.Content_Type__c='NL';
    digitalMapping.ivybase__User__c=userinfo.getUserId();
    insert digitalMapping;
    ivybase__Digital_Content_Mapping__c result = [select id,Standard_List_Master__c from ivybase__Digital_Content_Mapping__c where id=:digitalMapping.id];
    system.debug('digitalMapping'+digitalMapping);
   // system.assertEquals(stdMasterList[1].id, result.Standard_List_Master__c);
    
}
    public static testmethod void populateSLMMasterSalesPresenterForSupervisor()
{
     ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Supervisor');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
     List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
    
    RT = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    ivybase__Digital_Content__c digitalCOntent = new ivybase__Digital_Content__c();
    digitalCOntent.RecordTypeId=RT.get('SalesPresenter').getRecordTypeId();
    digitalCOntent.Market_ISO__c = 'MY';
    insert digitalCOntent;
    
    ivybase__Digital_Content_Mapping__c digitalMapping = new ivybase__Digital_Content_Mapping__c ();
    digitalMapping.ivybase__Digital_Content__c=digitalCOntent.id;
    digitalMapping.Content_Type__c='NL';
    digitalMapping.ivybase__User__c=userinfo.getUserId();
    insert digitalMapping;
    ivybase__Digital_Content_Mapping__c result = [select id,Standard_List_Master__c from ivybase__Digital_Content_Mapping__c where id=:digitalMapping.id];
    system.debug('digitalMapping'+digitalMapping);
 //   system.assertEquals(null, result.Standard_List_Master__c);
    
}
    public static testmethod void populateSLMMasterPromotion()
{
     ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Supervisor');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
     List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
    
    RT = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    ivybase__Digital_Content__c digitalCOntent = new ivybase__Digital_Content__c();
    digitalCOntent.RecordTypeId=RT.get('SalesPresenter').getRecordTypeId();
    digitalCOntent.Market_ISO__c = 'MY';
    insert digitalCOntent;
    
    ivybase__Digital_Content_Mapping__c digitalMapping = new ivybase__Digital_Content_Mapping__c ();
    digitalMapping.Content_Type__c='NL';
    digitalMapping.ivybase__Digital_Content__c=digitalCOntent.id;
    digitalMapping.ivybase__User__c=userinfo.getUserId();
    insert digitalMapping;
    ivybase__Digital_Content_Mapping__c result = [select id,Standard_List_Master__c from ivybase__Digital_Content_Mapping__c where id=:digitalMapping.id];
    system.debug('digitalMapping'+digitalMapping);
 //   system.assertEquals(null, result.Standard_List_Master__c);

    
}
       public static testmethod void populateSLMMasterProductCatalogue()
{
     ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
     List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
    
    RT = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    ivybase__Digital_Content__c digitalCOntent = new ivybase__Digital_Content__c();
    digitalCOntent.RecordTypeId=RT.get('ProductCatalogue').getRecordTypeId();
    digitalCOntent.Market_ISO__c = 'MY';
    insert digitalCOntent;
    
    ivybase__Digital_Content_Mapping__c digitalMapping = new ivybase__Digital_Content_Mapping__c ();
    digitalMapping.Content_Type__c='NL';
    digitalMapping.ivybase__Digital_Content__c=digitalCOntent.id;
    digitalMapping.ivybase__User__c=userinfo.getUserId();
    insert digitalMapping;
    ivybase__Digital_Content_Mapping__c result = [select id,Standard_List_Master__c from ivybase__Digital_Content_Mapping__c where id=:digitalMapping.id];
    system.debug('digitalMapping'+digitalMapping);
 //   system.assertEquals(stdMasterList[6].id, result.Standard_List_Master__c);

}
          
   public static testmethod void populateSLMMasterwithNothing()
{
     ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
     List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
    
    RT = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    ivybase__Digital_Content__c digitalCOntent = new ivybase__Digital_Content__c();
    digitalCOntent.Market_ISO__c = 'MY';
    insert digitalCOntent;
    
    ivybase__Digital_Content_Mapping__c digitalMapping = new ivybase__Digital_Content_Mapping__c ();
    digitalMapping.Content_Type__c='PROMO';
    digitalMapping.ivybase__Digital_Content__c=digitalCOntent.id;
    digitalMapping.ivybase__User__c=userinfo.getUserId();
    insert digitalMapping;
    ivybase__Digital_Content_Mapping__c result = [select id,Standard_List_Master__c from ivybase__Digital_Content_Mapping__c where id=:digitalMapping.id];
    system.debug('digitalMapping'+digitalMapping);
 //   system.assertEquals(stdMasterList[2].id, result.Standard_List_Master__c);

}
     public static testmethod void populateSLMMasterwithnoContentType()
{
     ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
        res.SAP_Id__c='12121212';
        insert res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        system.debug(RT);
        
        Division__c  division = new Division__c ();
        division.name='matrix';
        division.Market_ISO__c = 'MY';
        insert division;
        
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
     List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'DIGITAL_CONTENT_TYPE ',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'PROMO', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'NL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'BSTSELL', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'TOPTWNY', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'PRODUCT_TAGGING',ivybase__Location_Hierarchy__c=locHr.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
    
    RT = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    ivybase__Digital_Content__c digitalCOntent = new ivybase__Digital_Content__c();
    digitalCOntent.RecordTypeId=RT.get('SalesPresenter').getRecordTypeId();
    digitalCOntent.Market_ISO__c = 'MY';
    insert digitalCOntent;
    
    ivybase__Digital_Content_Mapping__c digitalMapping = new ivybase__Digital_Content_Mapping__c ();
    digitalMapping.ivybase__Digital_Content__c=digitalCOntent.id;
    digitalMapping.ivybase__User__c=userinfo.getUserId();
    insert digitalMapping;
    ivybase__Digital_Content_Mapping__c result = [select id,Standard_List_Master__c from ivybase__Digital_Content_Mapping__c where id=:digitalMapping.id];
    system.debug('digitalMapping'+digitalMapping);
  //  system.assertEquals(null, result.Standard_List_Master__c);

    
}
   
    
}