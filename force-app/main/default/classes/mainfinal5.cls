global with sharing class mainfinal5  {
 public ivybase__Digital_Content__c currentrecord{get;set;}    
    public void save1() {
        System.debug(imageName);
         System.debug(imageURL);
 
    System.debug('digitalContent'+recordid);
 		digitalContent=[select id,name,ivybase__Image_Name__c,ivybase__Image_Url__c from ivybase__Digital_Content__c where id=:recordid];
        digitalContent.ivybase__Image_Name__c=imageName;
        digitalContent.ivybase__Image_Path__c=imageURL;
        digitalContent.ivybase__Image_Url__c=((FolderStructure!=null)?FolderStructure:'')+''+((imageName!=null)?imageName:'');
        update digitalContent;
    }
    
    public static ivybase__Digital_Content__c digitalContent{get;set;}
	public static string imageURL{get;set;}
    public static string imageName{get;set;}
    public static string recordid{get;set;}
    public static string AccessKeyID{get;set;}
    public static string secretAccessKey{get;set;}
	public static string region{get;set;}
    public static string BucketName{get;set;}
    public static string rootFolder{get;set;}
    public static string FolderStructure{get;set;}
    public static string FileName{get;set;}    
    
	
public mainfinal5 (ApexPages.StandardController controller){
    
    currentRecord = (ivybase__Digital_Content__c)controller.getRecord();
	recordid=(String)currentRecord.Id;
    List<RecordType> folderList = [SELECT id,name,DeveloperName from RecordType where id=:currentRecord.RecordTypeId];
	List<ivybase__Standard_List_Master__c> stdList = StandardListMasterService.getStandardListUsingListType(new List<String>{'Digital_Content_Folder'});
    system.debug('stdList'+stdList);
    Map<String,String> slmMap = new Map<String,String>();
    for(ivybase__Standard_List_Master__c s:stdList)
    {
        slmMap.put(s.ivybase__List_Name__c,s.ivybase__List_Code__c);
    }
    String folderName='';
    if(folderList.size()>0)
        {
            for(RecordType f:folderList)
            {
                if(slmMap.containsKey(f.DeveloperName))
                {
				    folderName=slmMap.get(f.DeveloperName);                    
                }
            }
        }
    else
    {
     List<RecordType> DigitalCOntent= [select id,name,DeveloperName,SObjectType from RecordType where SObjectType='ivybase__Digital_Content__c'];   
    	for(RecordType f:DigitalCOntent)
            {
                folderName=f.DeveloperName;
            }
    }
    
    FolderStructure=folderName;
    system.debug('FolderStructure'+FolderStructure);
    List<String> amazonListString = new List<String>();
    amazonListString.add('Amazon_Configuration');
    List<ivybase__Standard_List_Master__c> amazonList = StandardListMasterservice.getStandardListUsingListType(amazonListString);
    system.debug('amazonList'+amazonList);

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
        if(aw.ivybase__List_Code__c=='AS_ROOT_DIR')
        {
            rootFolder=aw.ivybase__List_Name__c;
        }
        if(aw.ivybase__List_Code__c=='AS_REGION_CODE')
        {
          region=aw.ivybase__List_Name__c;  
        }

        
    }
    
    
}


}