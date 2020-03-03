public with sharing class UserService {
    public static String getCountryCode()
    {

        User userRec = [select id,name,Market_ISO__c from User where id=:UserInfo.getUserId()];
        String countryCode=userRec.Market_ISO__c;
        return countryCode;
    }
}