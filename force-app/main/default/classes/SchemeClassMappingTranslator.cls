public class SchemeClassMappingTranslator {
	public static RExAPIResponseDomain.ResponseInfo objectToJson(List<SchemeClassMapping__c> SchemeClasslist,string errorcode){
    RExAPIResponseDomain.ResponseInfo schemeclassResponse = new RExAPIResponseDomain.ResponseInfo();
    schemeclassResponse.Master='SchemeClassMapping';
    schemeclassResponse.Field = new List<String>{'ClassId','Schemeid'};
    schemeclassResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    schemeclassResponse.Next = '0';
        
        List<List<String>> ClassSchemeRecords = new List<List<String>>();
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
        
        if(SchemeClasslist !=Null){
    	for(SchemeClassMapping__c schemeClassRecordList :SchemeClasslist ){
    	List<String> SchemeClassListInfo = new List<String>();
    if(schemeClassRecordList.Class_Frequency__r.name != null){
                     SchemeClassListInfo.add(string.valueOf(statusMapListCode.get(schemeClassRecordList.Class_Frequency__r.name)));
                 }else{
                    SchemeClassListInfo.add(''); 
                 }
            if(schemeClassRecordList.Scheme__r.ivydsd__Internal_Id__c != null){
                     SchemeClassListInfo.add(string.valueOf(schemeClassRecordList.Scheme__r.ivydsd__Internal_Id__c));
                 }else{
                    SchemeClassListInfo.add(''); 
                 }
              
    	 
          ClassSchemeRecords.add(SchemeClassListInfo);                
    	}
    }
    schemeclassResponse.Data=ClassSchemeRecords;
    
    return schemeclassResponse;
    }
}