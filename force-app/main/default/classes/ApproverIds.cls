public class ApproverIds {
 public static Map<String,Id>  getAllLevelApproverIds(Id userId){
        List<String> resourceTypeNameList = new List<String>{'National','Regional','Area','Territory'};
        Map<String,Id> AllLevelApproverIdsMap = new Map<String,Id>();
        system.debug('userIds::::::::'+userId);
        for(ivybase__Location_Hierarchy__c locHier : [SELECT    ivybase__Primary_Resource__c,ivybase__Primary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Secondary_Resource__c,ivybase__Secondary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Current_Resource__c,
                                                                ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Parent__r.ivybase__Primary_Resource__c,
                                                                ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Parent__r.ivybase__Current_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c,
                                                                 ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Current_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Current_Resource__c,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c, 
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__c, 
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c, 
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__c, 
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Current_Resource__c,
                                                                RecordType.DeveloperName,
                                                                ivybase__Parent__r.RecordType.DeveloperName,
                                                                ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName,
                                                                ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName
                                                      FROM      ivybase__Location_Hierarchy__c
                                                      WHERE     ivybase__Primary_Resource__r.ivybase__Related_User__c = :userId]){
                                                          //system.debug('locHier'+locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName );
          system.debug('locHier'+locHier);
                                                            if(locHier.ivybase__Primary_Resource__c != null ){

                if(locHier.ivybase__Primary_Resource__c == (Id)locHier.ivybase__Current_Resource__c){
                    AllLevelApproverIdsMap.put(locHier.RecordType.DeveloperName,
                                    locHier.ivybase__Primary_Resource__r.ivybase__Related_User__c);
                }else{
                    AllLevelApproverIdsMap.put(locHier.RecordType.DeveloperName,
                                    locHier.ivybase__Secondary_Resource__r.ivybase__Related_User__c);
                }
                 
            }
                                                          if(locHier.ivybase__Parent__c != null ){

                if(locHier.ivybase__Parent__r.ivybase__Primary_Resource__c == (Id)locHier.ivybase__Parent__r.ivybase__Current_Resource__c){
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.RecordType.DeveloperName,
                                    locHier.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c);
                }else{
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.RecordType.DeveloperName,
                                    locHier.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c);
                }
                 
            }
            if(locHier.ivybase__Parent__r.ivybase__Parent__c != null ){
            
                if(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__c == (Id)locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Current_Resource__c){
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName ,
                                    locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c);
                }else{
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName,
                                    locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c);
                }
                 
            }
            if(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null ){
            
                if(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__c == (Id)locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Current_Resource__c){
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName,
                                locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c);
                }else{
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.DeveloperName,
                                locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c);
                }
                 
            }
            if(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c != null ){
            
                if(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__c == (Id)locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Current_Resource__c){
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.developerName ,
                                locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Primary_Resource__r.ivybase__Related_User__c);
                }else{
                    AllLevelApproverIdsMap.put(locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.RecordType.developerName ,
                                locHier.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Secondary_Resource__r.ivybase__Related_User__c);
                }
                 
            }
        }
      system.debug('AllLevelApproverIdsMap'+AllLevelApproverIdsMap);
        for(Integer i = 0; i < resourceTypeNameList.size(); i++){
            if(!AllLevelApproverIdsMap.containsKey(resourceTypeNameList[i])){
                if(i == 0){
                    AllLevelApproverIdsMap.put(resourceTypeNameList[i],null);
                }else{
                    AllLevelApproverIdsMap.put(resourceTypeNameList[i],AllLevelApproverIdsMap.get(resourceTypeNameList[i-1]));
                }
            }else if(AllLevelApproverIdsMap.get(resourceTypeNameList[i]) == null){
                if(i != 0){
                    AllLevelApproverIdsMap.put(resourceTypeNameList[i],AllLevelApproverIdsMap.get(resourceTypeNameList[i-1]));
                }
            }
        }
        system.debug('AllLevelApproverIdsMap'+AllLevelApproverIdsMap);
        return AllLevelApproverIdsMap;
    }
}