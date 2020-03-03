public with sharing class S3ImageDownloadSync {
    
    public static String accessKeyId;
    public static String secretKey;
    public static String service='s3';
    public static String region;
    public static string bucketname;
    public static string rootFolder;
    
    public static List<Contact> copyHairdresserSign(List<Contact> conList){
        //This will set Amazon config values from SLM in the Static variables
        S3ImageDownloadSync.setAmazonConfigVars();
        //debug lines to check the set config
        system.debug('AccessKeyID'+AccessKeyID);
        system.debug('BucketName'+BucketName);                  
        system.debug('secretKey'+secretKey);
        system.debug('region'+region);
        system.debug('rootFolder'+rootFolder);
        
        List<Folder> fold = [select id,name,accessType from Folder where accessType='Public' and name like '%loreal Upload%'];
        Id folderId =null;
        for(Folder f:fold)
        {
            system.debug('FOlder Name'+f.name);
            folderId=f.id;  
        }
        Map<String,Document> DocumentMap = new Map<String,Document>();
        for(Contact con:conList){
            if(con.Signature__c!=null && String.isEmpty(con.Signature__c)==false)
            {
                PageReference pr = new PageReference(String.valueOf(con.Signature__c));
                system.debug('S3-:Image PR'+pr);
                //get endpoint URL 
                Url endpoint = new Url(pr.getUrl());
                //calling the hhtp req generating method from the other class
                HttpRequest request = S3ImageDownload.signedRequest('GET', endpoint, null, null, null,accessKeyId,secretKey,service,region,bucketname,rootFolder);    
                request.setTimeout(60000);
                HttpResponse response = new Http().send(request);
                system.debug('response'+response);
                //save the document in the response as a Document
                Document d;
                if(folderId!=null){
                    String imageURL=con.Signature__c;
                    d=new document(name=imageURL.substringAfterLast('/'),Body=response.getBodyAsBlob(),FolderId=folderId,IsPublic=True);
                        DocumentMap.put(imageURL,d);
                }
            }
            
        }
        if(DocumentMap.keyset().size()>0)
        {
            insert DocumentMap.values();
        }
        for(Contact con:conList){
            if(DocumentMap.containsKey(con.Signature__c) && DocumentMap.get(con.Signature__c)!=null)
            {
                con.Signature_Link__c=Label.Org_URL+'/servlet/servlet.ImageServer?id='+DocumentMap.get(con.Signature__c).id+'&oid='+UserInfo.getOrganizationId();
            }
            else
            {
                con.Signature_Link__c=' ';
            }
        }
        return conList; 
    }
    
    public static List<ivydsd__Order__c> copyOrderSign(List<ivydsd__Order__c> orderList){
        //This will set Amazon config values from SLM in the Static variables
        S3ImageDownloadSync.setAmazonConfigVars();
        //debug lines to check the set config
        system.debug('AccessKeyID'+AccessKeyID);
        system.debug('BucketName'+BucketName);                  
        system.debug('secretKey'+secretKey);
        system.debug('region'+region);
        system.debug('rootFolder'+rootFolder);
        
        List<Folder> fold = [select id,name,accessType from Folder where accessType='Public' and name like '%loreal Upload%'];
        Id folderId =null;
        for(Folder f:fold)
        {
            system.debug('FOlder Name'+f.name);
            folderId=f.id;  
        }
        Map<String,Document> DocumentMap = new Map<String,Document>();
        for(ivydsd__Order__c ord:orderList){
            if(ord.Signature_Image_Path__c!=null && ord.Signature_Image_Path__c!='(null)' && String.isEmpty(ord.Signature_Image_Path__c)==false)
            {
                PageReference pr = new PageReference(String.valueOf(ord.Signature_Image_Path__c));
                system.debug('S3-:Image PR'+pr);
                //get endpoint URL 
                Url endpoint = new Url(pr.getUrl());
                //calling the hhtp req generating method from the other class
                HttpRequest request = S3ImageDownload.signedRequest('GET', endpoint, null, null, null,accessKeyId,secretKey,service,region,bucketname,rootFolder);    
                request.setTimeout(60000);
                HttpResponse response = new Http().send(request);
                system.debug('response'+response);
                //save the document in the response as a Document
                Document d;
                if(folderId!=null){
                    String imageURL=ord.Signature_Image_Path__c;
                    d=new document(name=imageURL.substringAfterLast('/'),Body=response.getBodyAsBlob(),FolderId=folderId,IsPublic=True);
                        DocumentMap.put(imageURL,d);
                    
                }
            }
            
        }
        if(DocumentMap.keyset().size()>0)
        {
            insert DocumentMap.values();
        }
        for(ivydsd__Order__c ord:orderList){
            ord.Email_Sent__c=true;
            if(DocumentMap.containsKey(ord.Signature_Image_Path__c) && DocumentMap.get(ord.Signature_Image_Path__c)!=null)
            {
                ord.Signature_Link1__c=Label.Org_URL+'/servlet/servlet.ImageServer?id='+DocumentMap.get(ord.Signature_Image_Path__c).id+'&oid='+UserInfo.getOrganizationId();
            }
            else
            {
                ord.Signature_Link1__c=' ';
            }
        }
        return orderList; 
    }
    
    public static void setAmazonConfigVars(){
        
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
                secretKey=aw.ivybase__List_Name__c;
                
            }
            if(aw.ivybase__List_Code__c=='AS_ROOT_DIR')
            {
                if(aw.ivybase__List_Name__c!=Null)
                    rootFolder=aw.ivybase__List_Name__c+'/';
            }
            if(aw.ivybase__List_Code__c=='AS_REGION_CODE')
            {
                region=aw.ivybase__List_Name__c;  
                
            }
            
        }
        
    }
}