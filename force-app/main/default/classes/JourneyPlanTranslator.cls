/*****
Description: This class is used to convert the journeyplan records into JSON format and send to Rest class

*******/
public with sharing class JourneyPlanTranslator {
    /**************************************************************************
* @description This Method will send the JourneyPlan records to Restclass
* @param  List of JourneyPlan records which are coming from service class,
Map of StandardListMaster ListName(Key) and Name(Value),Error code    

****************************************************************************/
    public static RExAPIResponseDomain.ResponseInfo objectToJourneyPlan(List<JourneyPlan__c> journeyplanlist,map<string,string> statusMapListCode,string errorcode){
        RExAPIResponseDomain.ResponseInfo journeyPlanMasterResponse = new RExAPIResponseDomain.ResponseInfo();
        journeyPlanMasterResponse.Master='JourneyPlanHeader';
        
        // To send data only for japan
        ivybase__Resource__c loggedInResource =  ResourceService.getSellerId(UserInfo.getUserId());
        
        if(loggedInResource.Market_ISO__c == 'JPN') {
            journeyPlanMasterResponse.Field = new List<String>{'TId','Date','UserId','Month','Year','SupervisorComments','Status','RefId'};
                } else {
                    journeyPlanMasterResponse.Field = new List<String>{'TId','Date','UserId','Month','Year','SupervisorComments','Status'};
                        
                        }    
        
        journeyPlanMasterResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        journeyPlanMasterResponse.Next = '0';
        
        //used to holding the list of Journey plan records.
        List<List<String>> jourplanRecords = new List<List<String>>();
        system.debug('journeyplanlist'+journeyplanlist);
        if(journeyplanlist !=Null){
            //iterating the list of records which are passing from service class
            for(JourneyPlan__c journyPlanrecordList :journeyplanlist ){
                List<String> jplanListInfo = new List<String>();
                
                
                if(journyPlanrecordList.Tid__c != null){
                    jplanListInfo.add(journyPlanrecordList.Tid__c);
                }
                else if(journyPlanrecordList.InternalId__c != null) {
                    jplanListInfo.add(journyPlanrecordList.InternalId__c);
                }else{
                    jplanListInfo.add(''); 
                }
                if(journyPlanrecordList.Date__c != null){
                    // Date d = journyPlanrecordList.Date__c;
                    integer d=journyPlanrecordList.Date__c.day();
                    integer mo=journyPlanrecordList.Date__c.month();
                    integer yr=journyPlanrecordList.Date__c.year();
                    DateTime DT = DateTime.newInstance(yr, mo, d);
                    
                    jplanListInfo.add(dt.format('yyyy/MM/dd'));
                }else{
                    jplanListInfo.add(''); 
                }
                if(journyPlanrecordList.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c != null){
                    jplanListInfo.add((journyPlanrecordList.Territory__r.ivybase__Primary_Resource__r.ivybase__Related_User__r.ivybase__Internal_Id__c).format());
                }else{
                    jplanListInfo.add(''); 
                }
                if(journyPlanrecordList.Month__c != null){
                    string monthString=String.valueOf(journyPlanrecordList.Month__c);
                    system.debug('monthString'+monthString);
                    if(monthString.length()==1){
                        jplanListInfo.add('0'+monthString);
                    }
                    else{
                        jplanListInfo.add(monthString);
                    }
                    
                }else{
                    jplanListInfo.add(''); 
                }
                if(journyPlanrecordList.Year__c != null){
                    string datestring=String.valueOf(journyPlanrecordList.Year__c);
                    jplanListInfo.add(datestring);
                }else{
                    jplanListInfo.add(''); 
                }
                if(journyPlanrecordList.SupervisorComments__c != null){
                    jplanListInfo.add(journyPlanrecordList.SupervisorComments__c);
                }else{
                    jplanListInfo.add(''); 
                }
                if(journyPlanrecordList.Status__c != null){
                    //jplanListInfo.add(journyPlanrecordList.Status__c);
                    jplanListInfo.add(statusMapListCode.get(journyPlanrecordList.Status__c));
                }else{
                    jplanListInfo.add(''); 
                } 
                if(loggedInResource.Market_ISO__c == 'JPN'){
                    jplanListInfo.add('');
                }
                
                
                jourplanRecords.add(jplanListInfo);                
            }
        }
        
        journeyPlanMasterResponse.Data=jourplanRecords;
        
        return journeyPlanMasterResponse;
    }
}