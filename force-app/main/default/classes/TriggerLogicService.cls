public with sharing class TriggerLogicService {

    public static Map<String, Boolean> resultMap;
    static{
        resultMap = new Map<String, Boolean>();
        for(Trigger_Logic_Configuration__c tl : [select Name, Deactive_Logic__c,Trigger_Name__c from Trigger_Logic_Configuration__c ] ){
                resultMap.put(tl.Name, tl.Deactive_Logic__c);
        }
    }    
    public static Map<String, Boolean> getDuplicationCheck(Set<String> developerNameSet) {
     /*   
        List<String> tempList = new List<String>();
        
        if(resultMap == NULL) {
            resultMap = new Map<String, Boolean>();
            tempList.addAll(developerNameSet);
        } else {

            for(String s : developerNameSet) {
                if(resultMap.containsKey(s) == FALSE) {
                    tempList.add(s);
                }
            }
        }
        
        if(tempList.isEmpty() == FALSE) {
            for(Trigger_Logic_Configuration__c tl : [select Name, Deactive_Logic__c,Trigger_Name__c from Trigger_Logic_Configuration__c 
                                          WHERE Name IN :developerNameSet] ){
                resultMap.put(tl.Name, tl.Deactive_Logic__c);
            }
        }
       */ 
        return resultMap;
    }//End Method
    
    /* 
     * Added method for Surveys method

	*/
     public static Map<String, Boolean> getDuplicationCheck2(Set<String> developerNameSet) {
        
        List<String> tempList = new List<String>();
        
        if(resultMap == NULL) {
            resultMap = new Map<String, Boolean>();
            tempList.addAll(developerNameSet);
        } else {

            for(String s : developerNameSet) {
                if(resultMap.containsKey(s) == FALSE) {
                    tempList.add(s);
                }
            }
        }
        
        if(tempList.isEmpty() == FALSE) {
            for(ivybase__Trigger_Logic_Configuration__mdt tl : [SELECT Id, ivybase__Deactive_Logic__c,DeveloperName FROM ivybase__Trigger_Logic_Configuration__mdt 
                                          WHERE DeveloperName IN :developerNameSet] ){
                resultMap.put(tl.DeveloperName, tl.ivybase__Deactive_Logic__c);
            }
        }
        
        return resultMap;
    }
    
    
}