global with sharing class ViewDigitalContentController  {
    public ivybase__Digital_Content__c currentrecord{get;set;}    
    //public static Interface_Run__c digitalContent{get;set;}
    public static string imageURL{get;set;}
    public static string imageName{get;set;}
    public static string recordid{get;set;}
    public static string AccessKeyID{get;set;}
    public static string secretAccessKey{get;set;}
    public static string region{get;set;}
    public static string BucketName{get;set;}
    public static string rootFolder{get;set;}
    public static string FolderStructure{get;set;}
    //public static string FileName{get;set;}    
    public ViewDigitalContentController (ApexPages.StandardController controller){
        try{
            currentRecord = (ivybase__Digital_Content__c)controller.getRecord();
            recordid=(String)currentRecord.Id;
            imageName=[select ivybase__Image_Url__c from ivybase__Digital_Content__c where id=:recordid].ivybase__Image_Url__c;
            
            
            string[] amazonListString=new string[]{};
            amazonListString.add('Amazon_Configuration');
            List<ivybase__Standard_List_Master__c> amazonList = StandardListMasterservice.getStandardListUsingListType(amazonListString);
            system.debug('amazonList'+amazonList);
            system.debug('rootFolder'+rootFolder);
            for(ivybase__Standard_List_Master__c aw :amazonList)
            {
            //to check if encrypted name is there use that name instead of list name(Used For AMazon Configuration)
            if(aw.ivybase__Encrypted_List_Name__c!=null && string.isEmpty(aw.ivybase__Encrypted_List_Name__c)==false)
            {
                aw.ivybase__List_Name__c=aw.ivybase__Encrypted_List_Name__c;
            }
                if(aw.ivybase__List_Code__c=='AS_ACCESS_KEY')
                {
                    AccessKeyID=aw.ivybase__List_Name__c;
                }
                if(aw.ivybase__List_Code__c=='AS_BUCKET_NAME')
                {
                    BucketName=aw.ivybase__List_Name__c;
                }
                if(aw.ivybase__List_Code__c=='AS_SECURITY_KEY')
                {
                    secretAccessKey=aw.ivybase__List_Name__c;
                }
                if(aw.ivybase__List_Code__c=='AS_ROOT_DIR' && string.isnotblank(imageName))
                {
                     rootFolder=aw.ivybase__List_Name__c+'/'+imageName;
                }
                if(aw.ivybase__List_Code__c=='AS_REGION_CODE')
                {
                    region=aw.ivybase__List_Name__c;  
                }
                
                
            }
            
        }
        Catch(Exception e){
            system.debug('error'+e.getMessage());
        }
    }
    
    
}