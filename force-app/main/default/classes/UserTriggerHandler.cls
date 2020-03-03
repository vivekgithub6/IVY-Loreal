public with sharing class UserTriggerHandler {
    @future
    public static void updateCustomSetting_UserwiseCountryValues(Map<Id,String> userCountryMap,Map<Id,String> userCurrencyMap)
    {
        List<UserwiseCountryValues__c> allcustomSetting = new List<UserwiseCountryValues__c>();
        List<UserwiseCountryValues__c> allcustomSettingUpdate = new List<UserwiseCountryValues__c>();
        Set<Id> userId = new Set<Id>();
        userId.addAll(userCountryMap.keySet());
        userId.addAll(userCurrencyMap.keySet());
        for(Id u:userId){
        UserwiseCountryValues__c  mc = UserwiseCountryValues__c.getInstance(u);
        system.debug('mc inside'+mc);
        if(mc!=null && mc.id!=null)
        {
            if(userCountryMap.containsKey(u))
            {
             mc.Market_ISO__c = userCountryMap.get(u);
            }
            /*if(userCurrencyMap.containsKey(u))
            {
             mc.Currency__c=userCurrencyMap.get(u);
            }*/
            allcustomSettingUpdate.add(mc);
        }
        else
        {
            
            UserwiseCountryValues__c newRec = new UserwiseCountryValues__c(SetupOwnerId = u);
             if(userCountryMap.containsKey(u))
            {
             newRec.Market_ISO__c = userCountryMap.get(u);
            }
            /*if(userCurrencyMap.containsKey(u))
            {
             newRec.Currency__c=userCurrencyMap.get(u);
            }*/
            allcustomSetting.add(newRec);
            system.debug('no record found');
        }
        }
        if(allcustomSetting.size()>0)
        {
            insert allcustomSetting;
        }
        if(allcustomSettingUpdate.size()>0)
        {
            update allcustomSettingUpdate;
        }
        
    }
    
}