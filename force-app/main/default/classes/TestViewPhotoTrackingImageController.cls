@isTest
public class TestViewPhotoTrackingImageController {
   private static testMethod void InvokeVfPage(){
        ivype__Photo_Capture_Tracking__c i=new ivype__Photo_Capture_Tracking__c();
       
        i.Image_Path__c='https://ivycpgsfdc-lorealapac-uat.s3.ap-southeast-1.amazonaws.com/IvyCPG_LorealPPD/CompetitorTrackImages/20181206/10/new brands-15441080621.png';
       
        insert i; 
        
        ivybase__Resource_Type__c restype = TestUtility.createTestResourceType('Merchandiser');
            insert restype;
            
            Id userId = UserInfo.getUserId();
            ivybase__Resource__c res = TestUtility.createTestResource('Resource',userId,restype.id);
            insert res;
        
        ivybase__Location_Hierarchy__c i1=new ivybase__Location_Hierarchy__c(name = 'ddd', Market_ISO__c = 'MY', ivybase__Active__c = 'yes',ivybase__Primary_Resource__c=res.Id,RecordTypeId=Schema.SObjectType.ivybase__Location_Hierarchy__c.getRecordTypeInfosByDeveloperName().get('National').getRecordTypeId());
        
        insert i1;
         res.ivybase__Location_Hierarchy__c = i1.Id;
        update res;
        
         List<ivybase__Standard_List_Master__c> stdMasterList = new List<ivybase__Standard_List_Master__c> { 
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_REGION_CODE', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ACCESS_KEY', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_SECURITY_KEY', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_BUCKET_NAME', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_END_POINT', ivybase__List_Name__c = 'dummmy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_HOST', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_ROOT_DIR', ivybase__List_Name__c = 'dummy', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id),
                new ivybase__Standard_List_Master__c(ivybase__List_Code__c = 'AS_TYPE', ivybase__List_Name__c = 'AWS', ivybase__List_Type__c = 'Amazon_Configuration',ivybase__Location_Hierarchy__c=i1.Id,ivybase__Resource_Type__c=restype.Id)
                }; 
      insert stdMasterList;
        ApexPages.StandardController sc = new ApexPages.StandardController(i);
        ViewPhotoTrackingImageController v=new ViewPhotoTrackingImageController(sc);
        ViewPhotoTrackingImageController.imageName ='uh';
        ViewPhotoTrackingImageController.recordid ='test';
        ViewPhotoTrackingImageController.AccessKeyID = 's';
        ViewPhotoTrackingImageController.region = 'fd';
        ViewPhotoTrackingImageController.BucketName= 'd';
        ViewPhotoTrackingImageController.rootFolder= 's';
        ViewPhotoTrackingImageController.secretAccessKey= 's1';
    }

}