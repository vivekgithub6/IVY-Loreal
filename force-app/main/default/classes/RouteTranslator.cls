public with sharing class RouteTranslator {

    public static RExAPIResponseDomain.ResponseInfo objectToBeatMaster(List<ivybase__Route__c> routeList, String errorCode) {
        
        RExAPIResponseDomain.ResponseInfo beatMaster = new RExAPIResponseDomain.ResponseInfo();
        beatMaster.Master = 'BeatMaster';
        beatMaster.Field = new List<String> {'BeatId','BeatDescription','Today'};        
        beatMaster.ErrorCode = errorCode == null ? '0' : errorCode;
        beatMaster.Next = '0';
        List<List<String>> beatList = new List<List<String>>();
        if (routeList != null && errorCode == null) {            
            for (ivybase__Route__c route1:routeList) {
                List<String> routeInfo = new List<String>();
                routeInfo.add(route1.Name);
                if (route1.ivybase__Description__c != null) {
                    routeInfo.add(route1.ivybase__Description__c);            
                    routeInfo.add(getTodayField(route1.ivybase__Description__c));
                } else {
                    routeInfo.add('');
                    routeInfo.add('0');
                }
                beatList.add(routeInfo);
            }                      
        }
        beatMaster.Data = beatList;  
        return beatMaster;
    }    
    
    public static String getTodayField(String description) {
        Date surveyProcessDate = CommonUtility.surveyProcessDate(UserInfo.getUserId());
        if(description == DateTime.newInstance(surveyProcessDate, Time.newInstance(0, 0, 0, 0)).format('EEEE')) {
            return '1';
        }
        return '0';
    }
}