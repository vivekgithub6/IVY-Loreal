public class RintinPlanDetailService {
    public static Map<Id, Rintin_Plan_Details__c> getRintinDokoSalonDetails(Set<Id> rintinPlanId){
        
        String[] rintinPlanDetailFields = new String[]{'Id', 'Name', 'CurrencyIsoCode', 'Retailer_Id__c', 'isActive__c',
            'IsDoko__c', 'Hair_Dresser__c', 'Rintin_Plan__c', 'Agent__c',
            'Retailer_Id__r.ivybase__Internal_Id__c', 'Rintin_Plan__r.TId__c',
            'Rintin_Plan__r.InternalId__c'};
                
                if(SecurityUtility.checkIsAccessible('Rintin_Plan_Details__c', rintinPlanDetailFields)){ 
                    Map<Id, Rintin_Plan_Details__c> rintinPlanDetailMap = new Map<Id, Rintin_Plan_Details__c>([
                        SELECT Id, Name, CurrencyIsoCode, Retailer_Id__c, isActive__c,
                        IsDoko__c, Hair_Dresser__c, Rintin_Plan__c, Agent__c,
                        Retailer_Id__r.ivybase__Internal_Id__c, Rintin_Plan__r.TId__c,
                        Rintin_Plan__r.InternalId__c
                        FROM Rintin_Plan_Details__c 
                        WHERE  Rintin_Plan__c = :rintinPlanId 
                        AND Retailer_Id__c != NULL And Hair_Dresser__c=null AND Agent__c=null
                    ]);//AND Agent__c=null
                    System.debug('rintinPlanDetailMap::'+rintinPlanDetailMap);
                    return rintinPlanDetailMap;      
                }
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static Map<Id, Rintin_Plan_Details__c> getRintinDokoHairdresserAndAgentDetails(Set<Id> rintinPlanId){
        
        String[] rintinPlanDetailFields = new String[]{'Id', 'Name', 'CurrencyIsoCode', 'Retailer_Id__c', 'isActive__c',
            'IsDoko__c', 'Hair_Dresser__c', 'Rintin_Plan__c', 'Agent__c',
            'Retailer_Id__r.ivybase__Internal_Id__c', 'Rintin_Plan__r.TId__c',
            'Rintin_Plan__r.InternalId__c', 'Hair_Dresser__r.Internal_Id__c',
            'Agent__r.ivybase__Internal_Id__c'};
                
                if(SecurityUtility.checkIsAccessible('Rintin_Plan_Details__c', rintinPlanDetailFields)){
                    Map<Id, Rintin_Plan_Details__c> rintinPlanDetailMap = new Map<Id, Rintin_Plan_Details__c>([
                        SELECT Id, Name, CurrencyIsoCode, Retailer_Id__c, isActive__c, IsDoko__c, Hair_Dresser__c,
                        Rintin_Plan__c, Agent__c, Retailer_Id__r.ivybase__Internal_Id__c, Rintin_Plan__r.TId__c, 
                        Rintin_Plan__r.InternalId__c, Hair_Dresser__r.Internal_Id__c, Agent__r.ivybase__Internal_Id__c
                        FROM Rintin_Plan_Details__c 
                        WHERE  Rintin_Plan__c = :rintinPlanId 
                        AND Retailer_Id__c != NULL 
                        AND (Hair_Dresser__c != NULL OR Agent__c!=null)
                    ]);
                    System.debug('rintinPlanDetailMap::'+rintinPlanDetailMap);
                    return rintinPlanDetailMap;      
                }
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    /*public static Map<Id, Rintin_Plan_Details__c> getRPlanVisitForToday(){
String[] rintinPlanDetailFields = new String[]{'Id', 'Name', 'CurrencyIsoCode', 'Retailer_Id__c', 'isActive__c',
'IsDoko__c', 'Hair_Dresser__c', 'Rintin_Plan__c', 'Agent__c',
'Retailer_Id__r.ivybase__Internal_Id__c', 'Rintin_Plan__r.Date__c',
'Rintin_Plan__r.Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id',
'Rintin_Plan__r.InternalId__c', 'Agent__r.ivybase__Internal_Id__c'};

if(SecurityUtility.checkIsAccessible('Rintin_Plan_Details__c', rintinPlanDetailFields)){
Map<Id, Rintin_Plan_Details__c> rintinPlanDetailMap = new Map<Id, Rintin_Plan_Details__c>([
SELECT Id, Name, CurrencyIsoCode, Retailer_Id__c, isActive__c, IsDoko__c, Hair_Dresser__c,
Rintin_Plan__c, Agent__c, Retailer_Id__r.ivybase__Internal_Id__c, Rintin_Plan__r.Date__c,
Rintin_Plan__r.InternalId__c,Rintin_Plan__r.TId__c, Agent__r.ivybase__Internal_Id__c
FROM Rintin_Plan_Details__c 
WHERE  Rintin_Plan__r.Date__c = :system.today()
AND Rintin_Plan__r.Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id = :userinfo.getUserId() 
AND Retailer_Id__c != NULL And Hair_Dresser__c=null AND Agent__c=null
]);
System.debug('rintinPlanDetailMap::'+rintinPlanDetailMap);
return rintinPlanDetailMap;      
}
else{
throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
}
}*/
    
    public static Map<Id, Rintin_Plan__c> getRPlanVisitForToday(){
        String[] rintinPlanDetailFields = new String[]{'Id', 'Name', 'CurrencyIsoCode', 'Retailer_Id__c', 'isActive__c',
            'IsDoko__c', 'Hair_Dresser__c', 'Rintin_Plan__c', 'Agent__c',
            'Retailer_Id__r.ivybase__Internal_Id__c', 'Rintin_Plan__r.Date__c',
            'Rintin_Plan__r.Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id',
            'Rintin_Plan__r.InternalId__c', 'Agent__r.ivybase__Internal_Id__c'};
                
                if(SecurityUtility.checkIsAccessible('Rintin_Plan_Details__c', rintinPlanDetailFields)){
                    Map<Id, Rintin_Plan__c> rintinPlanDetailMap = new Map<Id, Rintin_Plan__c>([
                        SELECT		TId__c, Journey_Plan__c, Location__c, Date__c, StartTime__c, EndTime__c, InternalId__c,
                        Planned_Salons__c, Actual_Saloons_count__c, Sales_Rep_Name__c, Sales_Rep_Code__c, Signature__c, 
                        Brand__c, SubAxe__c, Product_Master__c, IsAdhoc__c, IsRinten__c, Product__c, SignatureText__c, 
                        BrandText__c, SubAxeText__c, Journey_Plan__r.Status__c,
                        (SELECT 	Name, Retailer_Id__c, isActive__c, IsDoko__c, Hair_Dresser__c,
                         Rintin_Plan__c, Agent__c, Retailer_Id__r.ivybase__Internal_Id__c, Rintin_Plan__r.Date__c,
                         Rintin_Plan__r.InternalId__c, Rintin_Plan__r.TId__c, Agent__r.ivybase__Internal_Id__c 
                         FROM 		Rintin_Plan_Details__r
                         WHERE 		Retailer_Id__c != NULL And Hair_Dresser__c=null AND Agent__c=null)
                        FROM 		Rintin_Plan__c
                        WHERE  		Date__c = :system.today()
                        AND Journey_Plan__r.Status__c='Approved'
                        AND 		Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id = :userinfo.getUserId()]);
                    System.debug('rintinPlanDetailMap::'+rintinPlanDetailMap);
                    return rintinPlanDetailMap;      
                }
        else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
}