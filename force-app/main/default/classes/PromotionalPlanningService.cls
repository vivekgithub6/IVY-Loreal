public class PromotionalPlanningService {
            /*****
        * @description This Method will retrieve the promotionplan records.
        * @return List of JourneyPlan records
    ****/
    public static List<Sales_Forecast__c> getpromotionalPlan(){
        String[] promotionalPlanFields = new String[]{'Name','Date__c','Territory__c','Status__c','SuperVisorComments__c','Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c'};
        System.debug('curUserId'+userinfo.getUserId());
        if(SecurityUtility.checkIsAccessible('Sales_Forecast__c', promotionalPlanFields)){
            String month = String.valueOf(System.today().month() + 1);
            List<Sales_Forecast__c> promotionalplanlist = [SELECT Id, Name, Date__c, Target__c, Territory__c, Status__c, SuperVisorComments__c, 
                                                        Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c,
                                                        Total_Achieved_Value__c, Promotion_Achieved_Value__c
                                                      FROM Sales_Forecast__c
                                                      WHERE Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__c =:userinfo.getUserId() 
                                                          AND Date__c = THIS_MONTH];
            System.debug('promotionalplanlist***'+promotionalplanlist);
            return promotionalplanlist;
        }else{
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    //This method is used to sent the next month sales forecasting details
    public static List<Sales_Forecast__c> getApprovedPromotionalPlan(){
        String[] promotionalPlanFields = new String[]{'Name','Date__c','Territory__c','Status__c','SuperVisorComments__c','Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c'};
        if(SecurityUtility.checkIsAccessible('Sales_Forecast__c', promotionalPlanFields)){
            String month = String.valueOf(System.today().month() + 1);
            List<Sales_Forecast__c> promotionalplanlist = [SELECT Id, Name, Date__c, Target__c, Territory__c, Status__c, SuperVisorComments__c, 
                                                        Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c,
                                                        Total_Achieved_Value__c, Promotion_Achieved_Value__c
                                                      FROM Sales_Forecast__c
                                                      WHERE Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__c =:userinfo.getUserId() 
                                                          AND Date__c = THIS_MONTH AND Status__c = 'Approved'];
            return promotionalplanlist;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    //This method is used to sent the approved sales forecasting details
    public static List<Sales_Forecast__c> getNextMonthPromotionalPlan(){
        String[] promotionalPlanFields = new String[]{'Name','Date__c','Territory__c','Status__c','SuperVisorComments__c','Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c'};
        if(SecurityUtility.checkIsAccessible('Sales_Forecast__c', promotionalPlanFields)){
            String month = String.valueOf(System.today().month() + 1);
            List<Sales_Forecast__c> promotionalplanlist = [SELECT Id, Name, Date__c, Target__c, Territory__c, Status__c, SuperVisorComments__c, 
                                                        Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c,
                                                        Total_Achieved_Value__c, Promotion_Achieved_Value__c 
                                                      FROM Sales_Forecast__c
                                                      WHERE Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__c =:userinfo.getUserId() 
                                                          AND Date__c = NEXT_MONTH];
            return promotionalplanlist;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        }
    }
    
    public static List<Sales_Forecast__c> getPromotions_Resource(){
        
        Id resid = ResourceService.getLoginSellerId();
        String[] promotionalPlanFields = new String[]{'Name','Date__c','Month__c','Territory__c','Status__c','SuperVisorComments__c','Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c'};
        System.debug('curUserId'+userinfo.getUserId());
        if(SecurityUtility.checkIsAccessible('Sales_Forecast__c', promotionalPlanFields)){
            System.debug('enetref in If');
            String curerentmnth = String.valueof(date.today().month());
            List<Sales_Forecast__c> promotionalplanlist= [SELECT Id, Name, Date__c, Month__c, Target__c, Territory__c, Status__c, SuperVisorComments__c, 
                                                         Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c,
                                                         Total_Achieved_Value__c
                                                         FROM Sales_Forecast__c WHERE Month__c =:curerentmnth AND 
                                                          Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__c=:userinfo.getUserId()];
            return promotionalplanlist;
        } else {
            throw new SecurityUtility.SFDCAccessControlException(CommonUtility.mobileAppErrorDescMap.get('INSUFFICIENT_PERMISSIONS'),'INSUFFICIENT_PERMISSIONS');
        } 
    }
}