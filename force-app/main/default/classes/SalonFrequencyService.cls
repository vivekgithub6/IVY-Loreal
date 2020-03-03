/*
 * Block comments with details of changes
 created by pranav on 07-02-2020
 */
public class SalonFrequencyService
{
    public static list<SalonFrequencyDivMapping__c> getSalonFrequencyService()
    {
         //Collecting fields into string array 
        String[] SalonFrequencyFields = new String[]{'Resource__c','Salon__c','Salon_Frequency__c','Division__c'};
		//Performing field accessbility check 
               //Querying records
        List<ivybase__Resource__c> ResourceList=[select ivybase__Location_Hierarchy__c from ivybase__Resource__c where ivybase__Related_User__c=:userinfo.getUserId()];
        ivybase__Resource__c    Resource = ResourceList[0];
        
         if(SecurityUtility.checkIsAccessible('SalonFrequencyDivMapping__c', SalonFrequencyFields)){
    
                list<SalonFrequencyDivMapping__c> SalonFrequencyDivMappingList= [select id,Resource__c,Salon__c,Salon__r.ivybase__Internal_Id__c,Salon_Frequency__c,Division__c,Division__r.name 
                                                                                 from SalonFrequencyDivMapping__c
                                                                                Where Resource__c =: Resource.id ];
		system.debug('SalonFrequencyDivMappingList***'+SalonFrequencyDivMappingList);
		return SalonFrequencyDivMappingList;
		}else{
			  throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
         }
    }
}