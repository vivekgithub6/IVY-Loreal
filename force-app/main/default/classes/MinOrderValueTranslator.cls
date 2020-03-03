public class MinOrderValueTranslator {
	 public static RExAPIResponseDomain.ResponseInfo objectToMinOrderValue(List<Minimum_Order_Amount__c> MinorderList,string errorcode){
    RExAPIResponseDomain.ResponseInfo MinOrderMasterResponse = new RExAPIResponseDomain.ResponseInfo();
    MinOrderMasterResponse.Master='MinOrderValueMaster';
    MinOrderMasterResponse.Field = new List<String>{'DivisionId','SignatureId','Value'};
    MinOrderMasterResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
    MinOrderMasterResponse.Next = '0';
    Map<String,String> internalIdAndSMasterMap = new Map<String,string>();
    for(ivybase__Standard_List_Master__c stdMaster:  StandardListMasterService.getAllStandard_List()){
        internalIdAndSMasterMap.put(stdMaster.ivybase__List_Name__c,stdMaster.Name);
    }
        //used to holding the list of MinOrderValue records.
    List<List<String>> MinOrderValueRecords = new List<List<String>>();
    system.debug('MinorderList'+MinorderList);
    if(MinorderList !=Null){
        //iterating the list of records which are passing from service class
    	for(Minimum_Order_Amount__c MinOrderValuerecordList :MinorderList ){
    	List<String> MordervalListInfo = new List<String>();
    	
           
    	if(MinOrderValuerecordList.Division__c != null && internalIdAndSMasterMap!=null && internalIdAndSMasterMap.containskey(MinOrderValuerecordList.Division__r.name) && internalIdAndSMasterMap.get(MinOrderValuerecordList.Division__r.name)!=null){
                     MordervalListInfo.add(internalIdAndSMasterMap.get(MinOrderValuerecordList.Division__r.name));
                 }else{
                    MordervalListInfo.add(''); 
                 }
         if(MinOrderValuerecordList.Product_Hierarchy__c != null){
                     MordervalListInfo.add(MinOrderValuerecordList.Product_Hierarchy__r.ivybase__Internal_Id__c);
                 }else{
                    MordervalListInfo.add(''); 
                 }
            if(MinOrderValuerecordList.Value__c != null){
                     MordervalListInfo.add(string.valueof(MinOrderValuerecordList.Value__c));
                 }else{
                    MordervalListInfo.add(''); 
                 }
            
          
          MinOrderValueRecords.add(MordervalListInfo);                
    	}
    }
    
    MinOrderMasterResponse.Data=MinOrderValueRecords;
    
    return MinOrderMasterResponse;
    }
}