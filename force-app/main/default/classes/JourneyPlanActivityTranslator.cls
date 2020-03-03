/************************************************************
* @description This is an Translator class for JourneyPlanActivityManager.
  It will convert the  JourneyPlanActivity records into JSON format 
  and Send to the master class.
************************************************************/
public with sharing class JourneyPlanActivityTranslator {
     /**************************************************************************
        * @description This Method will send the GeographicalHierarchy records to manager
        * @param  List of GeographicalHierarchy records which are coming from service class,
             Map of StandardListMaster ListName(Key) and Name(Value),Error code    
        
        ****************************************************************************/ 
     public static RExAPIResponseDomain.ResponseInfo objectToJourneyPlanActivity(List<JourneyPlanActivity__c> JourneyPlanActivityList,String errorCode){
         RExAPIResponseDomain.ResponseInfo JourneyplanActivityMasterResponce = new RExAPIResponseDomain.ResponseInfo();
         JourneyplanActivityMasterResponce.Master = 'JourneyPlanDetail';
         
         // To send data only for japan
        ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
         
         if(loggedInResource.Market_ISO__c == 'JPN') {
            JourneyplanActivityMasterResponce.Field = new List<String>{'TId','Date','TypeId','WorkWithUserId','Comments','StartTime','EndTime','PlanName'};  
         } else {
            JourneyplanActivityMasterResponce.Field = new List<String>{'TId','Date','TypeId','WorkWithUserId','Comments'}; 
         }
         
       
        
      JourneyplanActivityMasterResponce.ErrorCode  = errorCode == null ? '0' : errorCode;
        JourneyplanActivityMasterResponce.Next = '0';
         
         List<List<String>> JourneyActivityRecords = new List<List<String>>();
         system.debug('JourneyPlanActivityList'+JourneyPlanActivityList);
         if(JourneyPlanActivityList != null && errorCode == null){
             for(JourneyPlanActivity__c ActivityList : JourneyPlanActivityList){
                  List<String> ActivityListInfo = new List<String>();
                //TId
                 if(ActivityList.JourneyPlan__r.Tid__c != null){
                     ActivityListInfo.add(ActivityList.JourneyPlan__r.Tid__c);
                 }else if(ActivityList.JourneyPlan__r.InternalId__c != null)
                 {
                     ActivityListInfo.add(ActivityList.JourneyPlan__r.InternalId__c);
                 }
                 else{
                    ActivityListInfo.add(''); 
                 }
                 //date
                 if(ActivityList.Date__c != null){
                     integer d=ActivityList.Date__c.day();
                      integer mo=ActivityList.Date__c.month();
                     integer yr=ActivityList.Date__c.year();
                 	DateTime DT = DateTime.newInstance(yr, mo, d);
                     ActivityListInfo.add(DT.format('yyyy/MM/dd'));
                 }else{
                    ActivityListInfo.add(''); 
                 }
                 //typeid
                  if(ActivityList.TypeId__r.Name != null){
                     ActivityListInfo.add(ActivityList.TypeId__r.Name);
                 }else{
                    ActivityListInfo.add(''); 
                 }
                 //WorkWithUserId__c
                  if(ActivityList.WorkWithUserId__c != null){
                     ActivityListInfo.add(ActivityList.WorkWithUserId__c);
                 }else{
                    ActivityListInfo.add(''); 
                 }
                 //comments
                 if(ActivityList.Comments__c != null){
                     ActivityListInfo.add(ActivityList.Comments__c);
                 }else{
                    ActivityListInfo.add(''); 
                 }
                 
                 if(loggedInResource.Market_ISO__c == 'JPN') {
                     // To send start time (Added newly for ANZ)
                     ActivityListInfo.add(ActivityList.Start_Time__c != NULL ? ActivityList.Start_Time__c:'');
                     ActivityListInfo.add(ActivityList.End_Time__c != NULL ? ActivityList.End_Time__c:'');
                     // Untril here (Added newly for ANZ)
                     ActivityListInfo.add('');
                 }
         
                 
             JourneyActivityRecords.add(ActivityListInfo);
             }//git
         }

         JourneyplanActivityMasterResponce.Data = JourneyActivityRecords;
       return JourneyplanActivityMasterResponce;
     } 
}