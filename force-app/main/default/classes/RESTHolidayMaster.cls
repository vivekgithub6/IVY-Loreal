@RestResource(UrlMapping='/v1/Holidays/Masters/')
global with sharing class RESTHolidayMaster{
       @httpGet
    global static RExAPIResponseDomain.ResponseInfo getHolidayMasterInfo(){
          RExAPIResponseDomain.ResponseInfo Holidayplan = new RExAPIResponseDomain.ResponseInfo();
         try{
            List<ivybase__Holiday__c> HolidayList = HolidayService.getHolidays();
           
            Holidayplan=HolidayTranslator.objectToHoliday(HolidayList,null);
                      }Catch(Exception ex){
            system.debug('exception'+ex.getMessage());
           Holidayplan=HolidayTranslator.objectToHoliday(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
           }
        return Holidayplan;
    }
}