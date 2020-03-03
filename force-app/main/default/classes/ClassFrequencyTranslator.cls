/*********************************************************************************
Class Name      : ClassFrequencyTranslator
Description     : Used to convert records data to json format and send to Rest class. 
Created By      : NagaSai
Created Date    : June-2018 
Modification Log:
---------------------------------------------------------------------------------- 
Developer                   Date                   Description
----------------------------------------------------------------------------------            
NagaSai               June-2018            Designed as per client requirements.
*********************************************************************************/
public with sharing class ClassFrequencyTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToJson(List<Class_Frequency__c> ClassFrequencylist,string errorcode){
    RExAPIResponseDomain.ResponseInfo ClassFrequencyResponse = new RExAPIResponseDomain.ResponseInfo();
    ClassFrequencyResponse.Master='ClassFrequency';
    ClassFrequencyResponse.Field = new List<String>{'ClassId','Frequency','Color'};
    ClassFrequencyResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    ClassFrequencyResponse.Next = '0';
		List<List<String>> ClassFrequencyRecords = new List<List<String>>();
         List<ivybase__Standard_List_Master__c> SLMList = new List<ivybase__Standard_List_Master__c>();
          String[] lstMstrFields = new String[]{'ivybase__List_Code__c','ivybase__List_Type__c','ivybase__List_Name__c','Name'};
	   List<String> listTypes = new List<String> {'CHANNEL_HIERARCHY'};
               if(SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', lstMstrFields))
         SLMList  = StandardListMasterservice.getStandardListUsingListType(listTypes);
         system.debug('SLMList---'+SLMList);
        map<string,string> statusMapListCode = new map<string,string>();
		for(ivybase__Standard_List_Master__c stMaster: SLMList){
        		statusMapListCode.put(stMaster.ivybase__List_Name__c,stMaster.Name);
        }
        system.debug('statusMapListCode'+statusMapListCode);
      system.debug('ClassFrequencylist'+ClassFrequencylist);
    if(ClassFrequencylist !=Null){
    	for(Class_Frequency__c ClassFrequencyRecordList :ClassFrequencylist ){
    	List<String> ClassFrequencyListInfo = new List<String>();
    if(ClassFrequencyRecordList.Name != null){
                     ClassFrequencyListInfo.add(string.valueOf(statusMapListCode.get(ClassFrequencyRecordList.Name)));
                 }else{
                    ClassFrequencyListInfo.add(''); 
                 }
            if(ClassFrequencyRecordList.Frequency__c != null){
                     ClassFrequencyListInfo.add(string.valueOf(ClassFrequencyRecordList.Frequency__c));
                 }else{
                    ClassFrequencyListInfo.add(''); 
                 }
              if(ClassFrequencyRecordList.Color_Code__c != null){
                     ClassFrequencyListInfo.add(string.valueOf(ClassFrequencyRecordList.Color_Code__c));
                 }else{
                    ClassFrequencyListInfo.add(''); 
                 }
    	 
          ClassFrequencyRecords.add(ClassFrequencyListInfo);                
    	}
    }
    ClassFrequencyResponse.Data=ClassFrequencyRecords;
    
    return ClassFrequencyResponse;
    }
}