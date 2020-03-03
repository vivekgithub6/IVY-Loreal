public with sharing class  SaloonCatagoryService {
	public static List<Salon_Catagory__c> get_All_Saloon_Catagory_records()
    {
        List<Salon_Catagory__c> saloonRecords = new List<Salon_Catagory__c>();
        String[] saloonFields = new String[] {'Criteria1__r.Range__c', 'Criteria2__r.Range__c', 'Salon_Catagoty__c'}; 
            if (SecurityUtility.checkIsAccessible('Salon_Catagory__c', saloonFields)) {
            	saloonRecords=[select Criteria1__r.Range__c,Criteria2__r.Range__c,Salon_Catagoty__c from Salon_Catagory__c];
            	return saloonRecords;
            }
        else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
            
    }
}