public class SchemeClassMappingService {
    public static List<SchemeClassMapping__c> getSchemeClassMapping(){
        String[] SchemeClassMappingFields = new String[]{'Id','Scheme__c','Class_Frequency__c'};
	 	system.debug('curUserId'+userinfo.getUserId());
		if(SecurityUtility.checkIsAccessible('SchemeClassMapping__c', SchemeClassMappingFields)){
            system.debug('enetref in If');
		list<SchemeClassMapping__c> SchemeClassMappinglist= [select id,Scheme__c,Class_Frequency__c,Scheme__r.ivydsd__Internal_Id__c,Class_Frequency__r.name
                                               	from 
                                               	SchemeClassMapping__c];
		system.debug('SchemeClassMappinglist***'+SchemeClassMappinglist);
		return SchemeClassMappinglist;
		}else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
      
    }
}