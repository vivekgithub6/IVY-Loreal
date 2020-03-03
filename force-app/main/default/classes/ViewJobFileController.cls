global with sharing class ViewJobFileController  {
    public Interface_Run__c currentrecord{get;set;}    
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
    public ViewJobFileController (ApexPages.StandardController controller){
        try{
            currentRecord = (Interface_Run__c)controller.getRecord();
            recordid=(String)currentRecord.Id;
            rootFolder=[select File_Path__c from Interface_Run__c where id=:recordid].File_Path__c;
            imageName=rootFolder.substringAfterLast('/');
            string[] amazonListString=new string[]{};
            amazonListString.add('Amazon_Configuration');
            List<ivybase__Standard_List_Master__c> amazonList = StandardListMasterservice.getStandardListUsingListType(amazonListString);
            system.debug('amazonList'+amazonList);
            system.debug('rootFolder'+rootFolder);
            
            
            for(ivybase__Standard_List_Master__c aw :amazonList)
            { 
                //if(!Test.isRunningTest())
                 //to check if encrypted name is there use that name instead of list name(Used For AMazon Configuration)
           if( aw.ivybase__Encrypted_List_Name__c!=null && string.isEmpty(aw.ivybase__Encrypted_List_Name__c)==false)
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
                if(aw.ivybase__List_Code__c=='AS_ROOT_DIR')
                {
                    //  rootFolder=aw.ivybase__List_Name__c;
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