/*********************************************************************************
Class Name      : ClassFrequencyService
Description     : Used to query records from ClassFrequency. 
Created By      : NagaSai
Created Date    : June-2018
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
public with sharing class ClassFrequencyService { 
	/*****
		* @description This Method will retrieve the ClassFrequency records.
		* @return List of JourneyPlan records
	****/
	public static List<Class_Frequency__c> getClassFrequencies(){
        //Collecting fields into string array 
        String[] ClassFrequencyFields = new String[]{'Id','Frequency__c','Location_Name__c'};
		//Performing field accessbility check 
               //Querying records
        List<ivybase__Resource__c> ResourceList=[select ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:userinfo.getUserId()];
        ivybase__Resource__c    Resource = ResourceList[0];
        system.debug('Resource'+Resource);
         if(SecurityUtility.checkIsAccessible('Class_Frequency__c', ClassFrequencyFields)){
    
                list<Class_Frequency__c> ClassFrequencylist= [select id,Frequency__c,name,Color_Code__c from Class_Frequency__c where FrequencyForLocation__c=:Resource.ivybase__Location_Hierarchy__c];
		system.debug('ClassFrequencylist***'+ClassFrequencylist);
		return ClassFrequencylist;
		}else{
			  throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
         }
	} 
}