/*********************************************************************************
Class Name      : ClassFrequencyTranslator
Description     : Used to return data to external sources. 
Created By      : NagaSai
Created Date    : June-2018
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
@RestResource(UrlMapping='/v1/ClassFrequency/Masters/')
global with sharing class RestClassFrequencyMaster{
   @httpGet
    global static RExAPIResponseDomain.ResponseInfo getClassFrequencyMasterInfo(){
          RExAPIResponseDomain.ResponseInfo ClassFrequency = new RExAPIResponseDomain.ResponseInfo();
           try{
            List<Class_Frequency__c> ClassFrequencyList = ClassFrequencyService.getClassFrequencies();
            ClassFrequency=ClassFrequencyTranslator.objectToJson(ClassFrequencyList,null);
                  }Catch(Exception ex){
            system.debug('exception'+ex.getMessage()+ex.getStackTraceString());
           ClassFrequency=ClassFrequencyTranslator.objectToJson(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
             }
        return ClassFrequency;
    }
}