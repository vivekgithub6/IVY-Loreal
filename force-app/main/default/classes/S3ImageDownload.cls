public class S3ImageDownload implements Queueable,Database.AllowsCallouts {
    
    public void execute(QueueableContext qc) {  
        //if we send order id , contact will be null
        if(orderList !=null && orderList.size()>0 && imageURL!=null && imageURL.size()>0)
        {
            S3ImageDownload.listContents(imageURL,null,orderList,orderList.size()); 
        }
        //if we send contact id , order will be null
        if(ContactId!=null && ContactId.size()>0 && imageURL!=null && imageURL.size()>0)
        {
            S3ImageDownload.listContents(imageURL,ContactId,null,ContactId.size()); 
        }
        // System.debug('Test');
        
    }
    //List of imagename 
    //if its hairdresser send contact id list and order as null
    //if its order signature send order id and contact as null
    //send the size of the list
    public S3ImageDownload(List<String> imageName,List<Id> contactId,List<Id> orderIds,Integer n)
    {
        this.ContactId=contactId;
        this.orderList=orderIds;
        this.imageURL=imageName;
        this.n=n;
    }
    public integer n;
    public List<Id> orderList;
    public List<Id> ContactId;
    public List<String> imageURL;
    public static String accessKeyId;
    public static String secretKey;
    public static String service='s3';
    public static String region;
    public static string bucketname;
    public static string rootFolder;
    
    static Datetime now = Datetime.now();
    //send the list of image name and (contact id or order id)and the size of the list
    public static void listContents(List<String> imagename,List<Id> contactid,List<Id>orderid,Integer n) {
        system.debug('contactid'+contactid);
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
                system.debug('AccessKeyID'+AccessKeyID);
            }
            if(aw.ivybase__List_Code__c=='AS_BUCKET_NAME')
            {
                BucketName=aw.ivybase__List_Name__c;
                system.debug('BucketName'+BucketName);
            }
            if(aw.ivybase__List_Code__c=='AS_SECURITY_KEY')
            {
                secretKey=aw.ivybase__List_Name__c;
                system.debug('secretKey'+secretKey);
            }
            if(aw.ivybase__List_Code__c=='AS_ROOT_DIR')
            {
                if(aw.ivybase__List_Name__c!=Null)
                    rootFolder=aw.ivybase__List_Name__c+'/';
            }
            if(aw.ivybase__List_Code__c=='AS_REGION_CODE')
            {
                region=aw.ivybase__List_Name__c;  
                system.debug('region'+region);
            }
            
            
        }
        for(integer indexVar=0;indexVar<n;indexVar++)
        {
            DownloadAndUpdateRecords(imagename,contactid,orderid,indexVar,AccessKeyID,secretKey,service,region,BucketName,rootFolder); 
        }
        
    }
    //send all image url , (contact id or order id),index value , amazon credentials
    @future (callout=true) public static void DownloadAndUpdateRecords(List<String> imagename,List<Id> contactid,List<Id>orderid,Integer indexVar,String accessKeyId,String secretKey,String service,String region,String bucketname,String rootFolder)
    {
        system.debug('S3-:Image Name'+imagename[indexVar]);
        PageReference pr = new PageReference(imagename[indexVar]);
        system.debug('S3-:Image PR'+pr);
        //get endpoint URL 
        Url endpoint = new Url(pr.getUrl());
        system.debug('S3-:Image endpoint'+endpoint);
        system.debug('accessKeyId'+accessKeyId);
        system.debug('secretKey'+secretKey);
        system.debug('service'+service);
        system.debug('region'+region);
        system.debug('bucketname'+bucketname);
        system.debug('rootFolder'+rootFolder);
        //create a signed signature
        HttpRequest request = signedRequest('GET', endpoint, null, null, null,accessKeyId,secretKey,service,region,bucketname,rootFolder);
        system.debug('request'+request);
        request.setTimeout(60000);
        //send request and get response
        HttpResponse response = new Http().send(request);
        system.debug('hi');
        system.debug('responce'+response.getBody());
        system.debug('response'+response.getBodyAsBlob());
        List<Folder> fold = [select id,name,accessType from Folder where accessType='Public' and name like '%loreal Upload%'];
        Id folderId =null;
        for(Folder f:fold)
        {
            system.debug('FOlder Name'+f.name);
            folderId=f.id;  
        }
        system.debug('folder id::'+folderId);
        system.debug('imagename ::'+imagename);
        Document d;
        //insert image in document
        if(folderId!=null && imagename!=null){
            d=new document(name=imagename[indexVar].substringAfterLast('/'),Body=response.getBodyAsBlob(),FolderId=folderId,IsPublic=True);
            insert d;
        }
        
        //if its contact update the records and send email
      if(contactid!=Null){
            contact contactrecord=[select Signature_Link__c,email from contact where id=:contactid[indexVar]];
            if(Label.Org_URL!=null && String.isEmpty(Label.Org_URL)==false){
                if(d!=null){
                    contactrecord.Signature_Link__c=Label.Org_URL+'/servlet/servlet.ImageServer?id='+d.id+'&oid='+UserInfo.getOrganizationId();
                    update contactrecord;  
                }
            }
            
            
            // if (response.getStatusCode() != 200) throw new ClientException(response.getBody());
            //  string signaturelink='https://lorealapacdev-dev-ed--c.na59.content.force.com/servlet/servlet.ImageServer?id='+d.id+'&oid=00Df4000004HP0G';
            
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();  
            msg.setTemplateId( [select id,Name from EmailTemplate WHERE Name ='HairDresser Status Info Mail' LIMIT 1].id );
            // msg.setWhatId(contactrecord);
            msg.setTargetObjectId(contactrecord.Id);
            msg.setSaveAsActivity(false); 
            msg.toAddresses= new String[] {contactrecord.Email};
                
                Messaging.SingleEmailMessage[] messages =
                new List<Messaging.SingleEmailMessage> {msg};
                    
                    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        }
        //if its order update order with image link 
        if(orderid!=Null){
            system.debug('enetring');
            ivydsd__Order__c Order=[select Signature_Link1__c,Saloon_Email__c from ivydsd__Order__c where id=:orderid[indexVar]];
            if(Label.Org_URL!=null && String.isEmpty(Label.Org_URL)==false){
                if(d!=null){
                    Order.Signature_Link1__c=Label.Org_URL+'/servlet/servlet.ImageServer?id='+d.id+'&oid='+UserInfo.getOrganizationId();
                    update Order;   
                }
            }
            // if (response.getStatusCode() != 200) throw new ClientException(response.getBody());
            //  string signaturelink='https://lorealapacdev-dev-ed--c.na59.content.force.com/servlet/servlet.ImageServer?id='+d.id+'&oid=00Df4000004HP0G';
            
        }
         
    }
    /**
* Signature Version 4 Signing Process
* Requests to AWS must be signed—that is, they must include information that AWS can use to authenticate the
* requestor. Requests are signed using the access key ID and secret access key of an account or of an IAM user.
* https://docs.aws.amazon.com/general/latest/gr/signing_aws_api_requests.html
*/
    public static HttpRequest signedRequest(String method, Url endpoint, Map<String,String> headers, Blob payload, Boolean presign,String accessKeyId,String secretKey,String service,String region,String bucketname,String rootFolder) {
        
        //defaults
        if (headers == null) headers = new Map<String,String>();
        if (payload == null) payload = Blob.valueOf('');
        if (presign == null) presign = false;
        
        //assemble
        
        String termination = 'aws4_request';
        String iso8601date = now.formatGmt('YYYYMMdd');
        String iso8601time = now.formatGmt('YYYYMMdd\'T\'HHmmss\'Z\'');
        String credentialScope = iso8601date + '/' + region + '/' + service + '/' + termination;
        
        //prepare headers
        headers.put('Host', endpoint.getHost());
        String signedHeaders = signedHeadersFor(headers);
        
        //handle spaces and special characters in paths
        String spec = '';
        spec += endpoint.getProtocol() + '://';
        spec += endpoint.getHost();
        spec += rfc3986For(endpoint.getPath(), false);
        if (endpoint.getQuery() != null) spec += '?' + endpoint.getQuery();
        
        //prepare parameters
        PageReference pr = new PageReference(spec);
        Map<String,String> parameters = pr.getParameters();
        parameters.put('X-Amz-Algorithm', 'AWS4-HMAC-SHA256');
        parameters.put('X-Amz-Credential', accessKeyId + '/' + credentialScope);
        parameters.put('X-Amz-Date', iso8601time);
        parameters.put('X-Amz-Expires', '86400');
        parameters.put('X-Amz-SignedHeaders', signedHeaders);
        
        //Task 1: Create a Canonical Request for Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
        String canonicalRequest = canonicalMethodFor(method)
            + '\n' + canonicalUriFor(endpoint.toExternalForm())
            + '\n' + canonicalQueryStringFor(parameters)
            + '\n' + canonicalHeadersFor(headers)
            + '\n' + signedHeadersFor(headers)
            + '\n' + (presign ? 'UNSIGNED-PAYLOAD' : hexEncodedHashFor(payload))
            ;
        
        //Task 2: Create a String to Sign for Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-create-string-to-sign.html
        String algorithm = 'AWS4-HMAC-SHA256';
        String canonicalRequestHash = hexEncodedHashFor(Blob.valueOf(canonicalRequest));
        String stringToSign = algorithm + '\n' + iso8601time + '\n' + credentialScope + '\n' + canonicalRequestHash;
        
        //Task 3: Calculate the AWS Signature Version 4
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-calculate-signature.html
        Blob keySecret = Blob.valueOf('AWS4' + secretKey);
        Blob keyDate = Crypto.generateMac('hmacSHA256', Blob.valueOf(iso8601date), keySecret);
        Blob keyRegion = Crypto.generateMac('hmacSHA256', Blob.valueOf(region), keyDate);
        Blob keyService = Crypto.generateMac('hmacSHA256', Blob.valueOf(service), keyRegion);
        Blob keySigning = Crypto.generateMac('hmacSHA256', Blob.valueOf('aws4_request'), keyService);
        Blob blobToSign = Blob.valueOf(stringToSign);
        Blob hmac = Crypto.generateMac('hmacSHA256', blobToSign, keySigning);
        
        //Task 4: Add the Signing Information to the Request
        //https://docs.aws.amazon.com/general/latest/gr/sigv4-add-signature-to-request.html
        if (!presign) headers.put('X-Amz-Content-Sha256', hexEncodedHashFor(payload));
        String signature = EncodingUtil.convertToHex(hmac);
        parameters.put('X-Amz-Signature', signature);
        
        //prepare request
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndpoint(pr.getUrl());
        if (payload != Blob.valueOf('')) request.setBodyAsBlob(payload); //affects http method
        for (String header : headers.keySet()) request.setHeader(header, headers.get(header));
        
        return request;
    }
    
    /**
* Build the signed headers list by iterating through the collection of header names, sorted by lowercase character
* code. For each header name except the last, append a semicolon (';') to the header name to separate it from the
* following header name.
* https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
*/
    @TestVisible static String signedHeadersFor(Map<String,String> headers) {
        
        //lowercase header keys
        List<String> keys = new List<String>(headers.keySet());
        for (Integer i = 0; i < keys.size(); i++) keys.set(i, keys[i].toLowerCase());
        
        //sort ascii
        keys.sort();
        
        //prepare values
        List<String> signedHeaders = new List<String>();
        for (String key : keys) signedHeaders.add(key);
        
        return String.join(signedHeaders, ';');
    }
    /**
* Caution: The standard UriEncode functions provided by your development platform may not work because of
* differences in implementation and related ambiguity in the underlying RFCs. We recommend that you write your own
* custom UriEncode function to ensure that your encoding will work.
* https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-query-string-auth.html
*/
    @TestVisible static String rfc3986For(String characters, Boolean encodeSlash) {
        String result = '';
        for (Integer i = 0; i < characters.length(); i++) {
            String character = characters.substring(i, i + 1);
            
            if (
                (character >= 'A' && character <= 'Z') || 
                (character >= 'a' && character <= 'z') || 
                (character >= '0' && character <= '9') || 
                character == '_' || 
                character == '-' || 
                character == '~' || 
                character == '.'
            ) {
                result += character;
            } else if (character == '/') {
                result += encodeSlash ? '%2F' : character;
            } else {
                result += '%' + EncodingUtil.convertToHex(Blob.valueOf(character)).toUpperCase();
            }
        }
        
        return result;
    }
    
    /**
* Start with the HTTP request method (GET, PUT, POST, etc.), followed by a newline character.
* https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
*/
    @TestVisible static String canonicalMethodFor(String method) {
        return method.toUpperCase();
    }
    
    /**
* The canonical URI is the URI-encoded version of the absolute path component of the URI, which is everything in
* the URI from the HTTP host to the question mark character
* http://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
*/
    @TestVisible static String canonicalUriFor(String endpoint) {
        Url uri = new Url(endpoint);
        return rfc3986For(uri.getPath(), false);
    }
    
    /**
* To construct the canonical query string, complete the following steps:
* a. URI-encode each parameter name and value.
* b. Sort the encoded parameter names by character code in ascending order (ASCII order).
* c. Build the canonical query string by starting with the first parameter name in the sorted list.
* d. For each parameter, append the URI-encoded parameter name, followed by '=' followed by the URI-encoded value
* e. Append the character '&' (ASCII code 38) after each parameter value, except for the last value in the list.
* https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
*/
    @TestVisible static String canonicalQueryStringFor(Map<String,String> parameters) {
        
        //sort keys by ascii code
        List<String> sortedKeys = new List<String>(parameters.keySet());
        sortedKeys.sort();
        
        //prepare values
        List<String> canonicalParameters = new List<String>();
        for (String sortedKey : sortedKeys) canonicalParameters.add(
            sortedKey + 
            '=' + 
            rfc3986For(parameters.get(sortedKey), true)
        );
        
        return String.join(canonicalParameters, '&');
    }
    
    /**
* To create the canonical headers list, convert all header names to lowercase and remove leading spaces and
* trailing spaces. Convert sequential spaces in the header value to a single space.
* https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
*/
    @TestVisible static String canonicalHeadersFor(Map<String,String> key2value) {
        
        //lowercase header keys
        Map<String,String> lower2value = new Map<String,String>();
        for (String key : key2value.keySet()) lower2value.put(key.toLowerCase(), key2value.get(key).trim().replaceAll('\\s+', ' '));
        
        //sort canonical keys by ascii code
        List<String> sortedKeys = new List<String>(lower2value.keySet());
        sortedKeys.sort();
        
        //prepare values
        List<String> canonicalHeaders = new List<String>();
        for (String sortedKey : sortedKeys) canonicalHeaders.add(sortedKey + ':' + lower2value.get(sortedKey) + '\n');
        
        return String.join(canonicalHeaders, '');
    }
    /**
* The hashed canonical request must be represented as a string of lowercase hexademical characters.
* https://docs.aws.amazon.com/general/latest/gr/sigv4-create-canonical-request.html
*/
    @TestVisible static String hexEncodedHashFor(Blob data) {
        Blob hash = Crypto.generateDigest('SHA256', data);
        return EncodingUtil.convertToHex(hash);
    }
    
    
}