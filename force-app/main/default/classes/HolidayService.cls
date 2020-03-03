/*********************************************************************************
Class Name      : HolidayService
Description     : Used to query records from Holiday. 
Created By      : NagaSai
Created Date    : June-2018
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
public with sharing class HolidayService {
	/*****
		* @description This Method will retrieve the Holiday records.
		* @return List of Holiday records
	****/
	public static List<ivybase__Holiday__c> getHolidays(){
        //Collecting fields into string array 
        String[] HolidayFields = new String[]{'Id','ivybase__End__c','ivybase__Start__c','ivybase__Description__c'};
		//Performing field accessbility check 
            if(SecurityUtility.checkIsAccessible('ivybase__Holiday__c', HolidayFields)){
        //Querying records
                ivybase__Resource__c Resource=[select ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:userinfo.getUserId()];
       list<ivybase__Holiday__c> Holidaylist= [select id,ivybase__End__c,ivybase__Start__c,ivybase__Description__c from ivybase__Holiday__c where Location_Hierarchy__c=:Resource.ivybase__Location_Hierarchy__c];
		system.debug('Holidaylist***'+Holidaylist);
		return Holidaylist;
		}else{
			  throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
         }
	} 
}