@isTest
public class testmainfinal5 {
    public static testmethod void test2()
{
        ivybase__Max_Internal_Id_Value__c cs = new ivybase__Max_Internal_Id_Value__c();
        cs.Name='Contact';
        cs.ivybase__Max_Internal_Id__c=20;
     insert cs;        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);  
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        
        res.ivybase__Location_Hierarchy__c = i1.Id;
        update res;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        Division__c  division = new Division__c (name='matrix', Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id, Market_ISO__c = 'MY');
       insert divLoc;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'ProductCatalogue', ivybase__List_Name__c = 'ProductCatalogue', ivybase__List_Type__c = 'Digital_Content_Folder',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'SalesPresenter', ivybase__List_Name__c = 'SalesPresenter', ivybase__List_Type__c = 'Digital_Content_Folder',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Promotion', ivybase__List_Name__c = 'Promotion', ivybase__List_Type__c = 'Digital_Content_Folder',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
       insert stdMasterList;
   
    Map<String, Schema.RecordTypeInfo> RTDG = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    
    ivybase__Digital_Content__c digital = new ivybase__Digital_Content__c (ivybase__Image_Name__c='dummy',Market_ISO__c = 'MY',ivybase__Image_Url__c='http://s3.amazon.com/folder/file');
    //digital.RecordTypeId = RTDG.get('Promotion').getRecordTypeId();
    insert digital;
    Test.startTest();
    PageReference pref = Page.AWS_Upload;
    Test.setCurrentPage(pref);

    ApexPages.StandardController sc = new ApexPages.StandardController(digital);

    mainfinal5 mc = new mainfinal5(sc);
    mc.save1();
  
}
public static testmethod void test1()
{
        ivybase__Max_Internal_Id_Value__c cs = new ivybase__Max_Internal_Id_Value__c();
        cs.Name='Contact';
        cs.ivybase__Max_Internal_Id__c=20;
        insert cs;        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Sales Rep');
        insert restype;
        
        Id userId = UserInfo.getUserId();
        ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);  
        res.SAP_Id__c = '12345';
        insert res;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
        
        Map<String, Schema.RecordTypeInfo> RT = Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName();
        
        ivybase__Location_Hierarchy__c locHr= TestUtility.createTestLocationHierarchy('Test Location Hierarchy',res.Id); 
        locHr.RecordTypeId = RT.get('Territory').getRecordTypeId();
        locHr.ivybase__Resource_Type__c = restype.id;
        insert locHr;
        Division__c  division = new Division__c (name='matrix',Market_ISO__c = 'MY');
        insert division;
        DivisionLocation__c  divLoc = new DivisionLocation__c(Location_Hierarchy__c=locHr.id,Division__c=division.id,Market_ISO__c = 'MY');
       insert divLoc;
        
        List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
            new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'ProductCatalogue', ivybase__List_Name__c = 'ProductCatalogue', ivybase__List_Type__c = 'Digital_Content_Folder',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'SalesPresenter', ivybase__List_Name__c = 'SalesPresenter', ivybase__List_Type__c = 'Digital_Content_Folder',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'Promotion', ivybase__List_Name__c = 'Promotion', ivybase__List_Type__c = 'Digital_Content_Folder',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
                    insert stdMasterList;
   
    Map<String, Schema.RecordTypeInfo> RTDG = Schema.SObjectType.ivybase__Digital_Content__c.getRecordTypeInfosByDeveloperName();
    
    ivybase__Digital_Content__c digital = new ivybase__Digital_Content__c (ivybase__Image_Name__c='dummy',Market_ISO__c = 'MY',ivybase__Image_Url__c='http://s3.amazon.com/folder/file');
    digital.RecordTypeId = RTDG.get('SalesPresenter').getRecordTypeId();
    insert digital;
    Test.startTest();
    PageReference pref = Page.AWS_Upload;
    Test.setCurrentPage(pref);

    ApexPages.StandardController sc = new ApexPages.StandardController(digital);

    mainfinal5 mc = new mainfinal5(sc);
    mainfinal5.FileName='2323';
    mc.save1();
  
}
}