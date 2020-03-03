@isTest
public class TestViewJobFileController {
    private static testMethod void InvokeVfPage(){
     string AccessKeyID = 'test';
     string BucketName  = 'test1';
     string secretAccessKey ='ss3';
     string region ='ss33';
        Interface_Run__c i=new Interface_Run__c();
        i.Processed_Rows__c=10;
        i.Name='Context';
        i.Error_Rows__c=20;
        i.Rejected_Rows__c=30;
        i.File_Path__c='Archive/Logs_2018-09-17_13-09.zip';
        i.Market_ISO__c = 'MY';
        insert i; 
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
            insert restype;
            
            Id userId = UserInfo.getUserId();
            ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
            insert res;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd',Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        insert i1;
          res.ivybase__Location_Hierarchy__c = i1.Id;
        update res;
        
         List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id,ivybase__Encrypted_List_Name__c='encrypted dummy'),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
      insert stdMasterList;
    Test.startTest();
    PageReference pref = Page.ViewJobFile;
    Test.setCurrentPage(pref);
    // ApexPages.StandardController sc1 = new ApexPages.StandardController();
     // ViewJobFileController mc1 = new ViewJobFileController(stdMasterList);
     ApexPages.StandardController sc = new ApexPages.StandardController(i);

    ViewJobFileController mc = new ViewJobFileController(sc);
    ViewJobFileController.imageURL='url';
    ViewJobFileController.FolderStructure='folder'; 
    ViewJobFileController.imageName='ss1';
    ViewJobFileController.recordid='ss2';
    ViewJobFileController.AccessKeyID='ss3';
    ViewJobFileController.secretAccessKey='ss4';  
    ViewJobFileController.region='ss4';
    ViewJobFileController.BucketName='u2';
    ViewJobFileController.rootFolder='folder1'; 
    
    
     List<ivybase__Standard_List_Master__c> stdMasterList1 = new List<ivybase__Standard_List_Master__c> ();
      for(Integer j=0;j<6;j++){
      
      ivybase__Standard_List_Master__c ivl = new ivybase__Standard_List_Master__c ();
      ivl.ivybase__Encrypted_List_Name__c = 'test';
      ivl.ivybase__List_Code__c = 'AS_ACCESS_KEY';
      if(j==0){
      ivl.ivybase__List_Code__c = 'AS_ACCESS_KEY';
      }Else if(j==1){ivl.ivybase__List_Code__c = 'AS_BUCKET_NAME';}
      else if(j==2){ivl.ivybase__List_Code__c = 'AS_ROOT_DIR';}
      else if(j==3){ivl.ivybase__List_Code__c = 'AS_SECURITY_KEY';}
      stdMasterList1.add(ivl) ;
      
      }
      insert stdMasterList1 ;
    
    
    }
}