public with sharing class JourneyPlanService {
	/*****
		* @description This Method will retrieve the JourneyPlan records.
		* @return List of JourneyPlan records
	****/
	public static List<JourneyPlan__c> getJourneyPlan(){
		String[] journeyPlanFields = new String[]{'Id','Tid__c','Name','Date__c','Month__c','UserId__c','SupervisorComments__c','Status__c','Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c'};
	 	system.debug('curUserId'+userinfo.getUserId());
		if(SecurityUtility.checkIsAccessible('JourneyPlan__c', journeyPlanFields)){
            system.debug('enetref in If');
		list<JourneyPlan__c> journeyplanlist= [select id,Tid__c,Name,Date__c,Month__c,Year__c,UserId__c,InternalId__c,
												SupervisorComments__c,Status__c,Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c 
                                               	from 
                                               	JourneyPlan__c 
                                               	where 
                                               Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.id=:userinfo.getUserId() 
                                               AND Date__c >=LAST_N_MONTHS:2 ];
		system.debug('journeyplanlist***'+journeyplanlist);
		return journeyplanlist;
		}else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
	} 
}