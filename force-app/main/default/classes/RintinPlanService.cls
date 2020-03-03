public class RintinPlanService {
    public static Map<Id, Rintin_Plan__c> getRintinPlans(){
        
        String[] rintinPlanFields = new String[]{'Id', 'Name', 'CurrencyIsoCode', 'TId__c', 'Journey_Plan__c', 'Location__c',
            'Date__c', 'StartTime__c', 'EndTime__c', 'InternalId__c', 'Journey_Plan__r.InternalId__c', 
            'Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id', 'Journey_Plan__r.Date__c'};
                system.debug('curUserId'+userinfo.getUserId());
        if(SecurityUtility.checkIsAccessible('Rintin_Plan__c', rintinPlanFields)){
            
            Map<Id, Rintin_Plan__c> rintinPlanMap = new Map<Id, Rintin_Plan__c>([
                SELECT		Id, Name, CurrencyIsoCode, TId__c, Journey_Plan__c, Location__c, Date__c, StartTime__c, EndTime__c,
                InternalId__c, Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id,Product__c ,
                Journey_Plan__r.Date__c, Journey_Plan__r.InternalId__c,Journey_Plan__r.Tid__c, IsAdhoc__c,IsRinten__c,
                SignatureText__c, BrandText__c, SubAxeText__c,Total_Planned_Salons_Agents__c, Org_Salon_Code__c, Serial_Number__c, Org_Salon_Name__c, Org_Salon_Internal_Id__c
                FROM		Rintin_Plan__c 
                WHERE 		Journey_Plan__r.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.Id = :userinfo.getUserId() 
                AND         Date__c >= :SYSTEM.TODAY()
                AND			Date__c >= LAST_N_MONTHS:2
            ]);//  AND 		Date__c <= :SYSTEM.TODAY()
            
            system.debug('rintinPlanMap***'+rintinPlanMap);
            
            return rintinPlanMap;
            
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    } 
    public static Map<Id, Rintin_Plan_Details__c> getRPlanVisitForToday(){
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
    }
}