public class SchemeTargetService {
 public static List<Scheme_Target__c> getSchemeTargetDetails(set<id> saFoDetid ){
     String[] schemetargetFields = new String[]{'Name','Scheme__c','Quantity__c','Sales_Forecast_Detail__c','Target__c'};
	 	system.debug('curUserId'+userinfo.getUserId());
		if(SecurityUtility.checkIsAccessible('Scheme_Target__c', schemetargetFields)){
            system.debug('enetref in If');
		list<Scheme_Target__c> SchemeTargeDetaillist= [select id,Name,Scheme__c,Scheme__r.ivydsd__Internal_Id__c,Quantity__c,Sales_Forecast_Detail__c,Target__c
                                                      from Scheme_Target__c 
                                                      Where Sales_Forecast_Detail__c IN:saFoDetid];
		system.debug('SchemeTargeDetaillist***'+SchemeTargeDetaillist);
		return SchemeTargeDetaillist;
		}else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
	} 
}