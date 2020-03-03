/*********************************************************************************
Class Name      : HolidayService
Description     : This class is used to convert the journeyplan records into JSON format and send to Rest class.
Created By      : NagaSai
Created Date    : June-2018
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
public with sharing class HolidayTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToHoliday(List<ivybase__Holiday__c> Holidaylist,string errorcode){
    RExAPIResponseDomain.ResponseInfo HolidayMasterResponse = new RExAPIResponseDomain.ResponseInfo();
    HolidayMasterResponse.Master='HolidayMaster';
    HolidayMasterResponse.Field = new List<String>{'Date','Description'};
    HolidayMasterResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    HolidayMasterResponse.Next = '0';
List<List<String>> HolidayRecords = new List<List<String>>();
    system.debug('Holidaylist'+Holidaylist);
    if(Holidaylist !=Null){
    	for(ivybase__Holiday__c HolidayRecordList :Holidaylist ){
    	List<String> HolidayListInfo = new List<String>();
    	  if(HolidayRecordList.ivybase__Start__c != null){
                     HolidayListInfo.add((HolidayRecordList.ivybase__Start__c).format('yyyy/MM/dd'));
                 }else{
                    HolidayListInfo.add(''); 
                 }
           
    	 if(HolidayRecordList.ivybase__Description__c != null){
                     HolidayListInfo.add(HolidayRecordList.ivybase__Description__c);
                 }else{
                    HolidayListInfo.add(''); 
                 }
          HolidayRecords.add(HolidayListInfo);                
    	}
    }
    
    HolidayMasterResponse.Data=HolidayRecords;
    
    return HolidayMasterResponse;
    }
}