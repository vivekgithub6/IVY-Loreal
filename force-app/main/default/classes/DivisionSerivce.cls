public with sharing class DivisionSerivce {
	public static Set<Id> getDivisionForUserTerritory(Set<Id> userTerritoryId)
    {
    	Set<Id> divId = new Set<Id>();
        String[] divFields = new String[] {'Division__c', 'Name', 'Location_Hierarchy__c'};
        if (SecurityUtility.checkIsAccessible('DivisionLocation__c', divFields )) {     
    		List<DivisionLocation__c> divisionList = [select id,name,Division__c, Location_Hierarchy__c from DivisionLocation__c where Location_Hierarchy__c=:userTerritoryId];    
        	for(DivisionLocation__c d:divisionList)
            {
               divId.add(d.Division__c); 
            }
            return divId;
    	}
        else
        {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
}