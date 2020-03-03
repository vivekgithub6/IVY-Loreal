Public class CommonUtility {
    public static Date surveyProcessDate(Id userId) {
        ivybase__Day_Close__c dc = ivybase__Day_Close__c.getInstance(userId);
        Date surveyProcessDate = system.today();
        if (dc != null && dc.ivybase__MobileDate__c != null ) {
            Date mobileDate = Date.newInstance(dc.ivybase__MobileDate__c.year(),dc.ivybase__MobileDate__c.month(),dc.ivybase__MobileDate__c.day());
            system.debug(mobileDate == system.today());
            if (mobileDate == system.today()) {
                surveyProcessDate  = Date.valueOf(dc.ivybase__MobileDate__c.addDays(1));
            }
        }
        return surveyProcessDate;
    }
    public static string convertTwodigit(Decimal dateVal) {
        if (dateVal < 10) {
            return '0'+dateVal;
        } 
        return ''+dateVal;
    }

    public static String priceListMappingDuplicateErrorMessage = 'A custom Price List is already available for this Store Hierarchy.';
    
    public static Map<String, String> mobileAppErrorCodesMap = new Map<String, String> { 
                    'INSUFFICIENT_PERMISSIONS'=>'E100'
                };
    public static Map<String, String> mobileAppErrorDescMap = new Map<String, String> { 
                    'INSUFFICIENT_PERMISSIONS'=>'Insufficient permissions on the object/fields',
                    'VISIT_NOT_FOUND'=>'OutletTimeStamp not found'
                };
    
    public static DateTime convertStringToLocalDT(String datetimestr){
        
        Datetime DTime;
                
        if(String.isNotBlank(datetimestr)) {
        
            List<String> dateAndTimeList = datetimestr.split(' ');
            
            if (dateAndTimeList != null && dateAndTimeList.size() == 2) {
            
                List<String> dateList = dateAndTimeList[0].split('/');
                List<String> timeList = dateAndTimeList[1].split(':');
                
                if(dateList != null && dateList.size() == 3 && timeList != null && timeList.size() == 3) {
                    DTime = DateTime.newInstance(Integer.valueOf(dateList[0]),Integer.valueOf(dateList[1]),Integer.valueOf(dateList[2]),
                                                 Integer.valueOf(timeList[0]),Integer.valueOf(timeList[1]),Integer.valueOf(timeList[2]));
                }
            }
            
        }
        return DTime;
    }
}