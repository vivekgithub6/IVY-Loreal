/************************************************************
* @description This is an Service class for JourneyPlanActivityServiceManager
It will retrieve the JourneyPlanActivityService and send it to the master class.
************************************************************/
public with sharing class JourneyPlanActivityService {
    /**************************************************************************
* @description This Method will retrieve the JourneyPlanActivityService records
* @param  No parameter
* @return List of JourneyPlanActivityService records
************s****************************************************************/ 
    public static List<JourneyPlanActivity__c> getJourneyPlanActivity(List<id> JourneyPlanId){
    	
    	String[] journeyPlanActivityFields = new String[]{'Id','Comments__c','Date__c','JourneyPlan__r.Name','Name','TypeId__r.Name','WorkWithUserId__c','Store__c','Store__r.ivybase__Internal_Id__c','Start_Time__c','End_Time__c'};
		
		if(SecurityUtility.checkIsAccessible('JourneyPlanActivity__c', journeyPlanActivityFields)){
        System.debug('enterd into if');
        List<JourneyPlanActivity__c> JourneyPlanActivities = [Select Id, 
                                                              Comments__c,
                                                              Date__c,
                                                              JourneyPlan__r.InternalId__c,
                                                              JourneyPlan__r.Tid__c,
                                                              Name,Store__r.ivybase__Internal_Id__c,
                                                              TypeId__r.Name,
                                                              WorkWithUserId__c,
                                                              Start_Time__c,
                                                              End_Time__c
                                                              from JourneyPlanActivity__c 
                                                              where JourneyPlan__c=:JourneyPlanId AND TypeId__c != null and Store__c=null 
                                                             ];
            system.debug('JourneyPlanActivities'+JourneyPlanActivities);
        return JourneyPlanActivities;      
	}else{
			system.debug('in lese');
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            }
    }     
}