public with sharing class SurveyImageTriggerHandler {
   
    public static void Aws(List<ivybase__Survey_Image__c> surList, Map<Id, ivybase__Survey_Image__c> surOldmap) {
        Map<String,String> listTypeStdMasterMap = new Map<String,String>();
        list<string> typename= new list<string>();
        typename.add('Amazon_Configuration');
        for(ivybase__Standard_List_Master__c stdMtr: StandardListMasterservice.getStandardListUsingListType(typename)){
            listTypeStdMasterMap.put(stdMtr.ivybase__List_Code__c,stdMtr.ivybase__List_Name__c);
        }
        
        Datetime timestamp = Datetime.now().AddDays(365);
        Long Lexpires = timestamp.getTime()/1000;
        String bucket = listTypeStdMasterMap.get('AS_BUCKET_NAME');
        String key = listTypeStdMasterMap.get('AS_ACCESS_KEY');
        String method = 'GET';
        String secret = listTypeStdMasterMap.get('AS_SECURITY_KEY');
        String rootDir = listTypeStdMasterMap.get('AS_ROOT_DIR');
        String host = listTypeStdMasterMap.get('AS_HOST');
        
        Set<String> urlSet = new Set<String>{'AS_BUCKET_NAME','AS_ACCESS_KEY','AS_SECURITY_KEY','AS_ROOT_DIR','AS_HOST'};
        //String encodedStringToSign = EncodingUtil.urlEncode(stringToSign,'UTF-8');    
        if(listTypeStdMasterMap.keySet().containsAll(urlSet)){
            for(ivybase__Survey_Image__c survey : surList) {
                if(survey.ivybase__Image_Name__c != null) {
                   String stringToSign = 'GET\n\n\n'+Lexpires+'\n/'+bucket+'/'+rootDir  +  survey.ivybase__Image_Name__c;
                   system.debug('stringToSign' + stringToSign );
                   Blob bsig = Crypto.generateMac('HMacSHA1',Blob.valueOf(stringToSign),Blob.valueof(secret));
                    String Signature = EncodingUtil.base64Encode(bsig);
                    Signature = Signature.replace('+', '%2B');
                    system.debug('Signature' + Signature );
                    
                    if(surOldmap == NULL) {
                        survey.ivybase__URL__c = host + rootDir +  survey.ivybase__Image_Name__c+'?AWSAccessKeyId='+ key+
                                      '&Expires='+Lexpires +'&Signature='+Signature ;
                    }
                    else
                    {
                       survey.ivybase__URL__c = host + rootDir + survey.ivybase__Image_Name__c+'?AWSAccessKeyId='+ key+
                                      '&Expires='+Lexpires +'&Signature='+Signature ;
                       
                    } 
                     system.debug('survey' + survey);
                }
            }
        }
  
    }
}