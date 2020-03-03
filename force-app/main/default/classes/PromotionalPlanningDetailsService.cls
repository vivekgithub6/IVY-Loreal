public class PromotionalPlanningDetailsService {
    public static List<Sales_Forecast_Detail__c> getPromotionalPlanningDetails(set<id> ppid ){
     String[] salesforeCastDetailFields = new String[]{'Name','Date__c','Sales_Forecast__c','Store__c','Total_Normal_Target__c','Total_Scheme_Target__c','Target__c'};
	 	system.debug('curUserId'+userinfo.getUserId());
		if(SecurityUtility.checkIsAccessible('Sales_Forecast_Detail__c', salesforeCastDetailFields)){
            system.debug('enetref in If');
		list<Sales_Forecast_Detail__c> salesforeCastDetaillist= [select id,Name,Sales_Forecast__c,Sales_Forecast__r.Name,Store__c,Store__r.ivybase__Internal_Id__c,Scheme__c,Scheme__r.ivydsd__Internal_Id__c,Quantity__c,Standard_List_Master__r.name,Product_Hierarchy__r.ivybase__Internal_Id__c,Target__c
                                                      from Sales_Forecast_Detail__c 
                                                      Where Sales_Forecast__c IN:ppid];
		system.debug('promotionalplanlist***'+salesforeCastDetaillist);
		return salesforeCastDetaillist;
		}else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
	} 
       
    public static List<Sales_Forecast_Detail__c> getPromotionalPlanningDetailsbyPromo(set<id> ppid ){
     String[] salesforeCastDetailFields = new String[]{'Name','Date__c','Sales_Forecast__c','Store__c','Scheme_Achievement__c','Total_Normal_Target__c','Total_Scheme_Target__c','Target__c'};
	 	system.debug('curUserId'+userinfo.getUserId());
		if(SecurityUtility.checkIsAccessible('Sales_Forecast_Detail__c', salesforeCastDetailFields)){
            system.debug('enetref in If');
		list<Sales_Forecast_Detail__c> salesforeCastDetaillist= [select id,Name,Sales_Forecast__c,Scheme_Achievement__c,Sales_Forecast__r.Name,Store__c,Store__r.ivybase__Internal_Id__c,Scheme__c,Standard_List_Master__r.name,Scheme__r.ivydsd__Internal_Id__c,Quantity__c,Product_Hierarchy__r.ivybase__Internal_Id__c,Target__c
                                                      from Sales_Forecast_Detail__c 
                                                      Where Sales_Forecast__c IN:ppid];
		system.debug('promotionalplanlist***'+salesforeCastDetaillist);
		return salesforeCastDetaillist;
		}else{
			
			
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
            
        }
	}
    }