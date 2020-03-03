/*
* This class is used for Surveys

*/
public class SyncProcessConfigurationService {

    public static Map<String, Boolean> getsyncprocesses() {
    
       Map<String, Boolean> resultMap = new Map<String, Boolean>();
       
          for(ivybase__Sync_Process_Configuration__mdt spc : [SELECT Id, ivybase__Deactivate__c,DeveloperName 
                                                              FROM 
                                                                  ivybase__Sync_Process_Configuration__mdt 
                                                              LIMIT 10000
                                                              ] ){
                resultMap.put(spc.DeveloperName, spc.ivybase__Deactivate__c);
          }
          
      return resultMap;
    }
}