public class CustomSettingService {
	    public static Boolean getTriggeroffValue() {
       
        Boolean hasPermission = false;
        
        ivybase__Bypass_Business_Rules__c bbr = ivybase__Bypass_Business_Rules__c.getInstance();
        
        System.debug('bbr:::::'+bbr);
        if(bbr != null) {
            hasPermission = bbr.ivybase__Deactivate_All_Rules__c;
        }
        
        return hasPermission;
    }
}