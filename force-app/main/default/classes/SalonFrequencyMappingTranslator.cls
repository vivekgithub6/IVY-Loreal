/*
 * Block comments with details of changes
 */
public class SalonFrequencyMappingTranslator
{
    public static RExAPIResponseDomain.ResponseInfo objectToJson(List<SalonFrequencyDivMapping__c> SalonFrequencylist,string errorcode){
        RExAPIResponseDomain.ResponseInfo SalonFrequencyResponse = new RExAPIResponseDomain.ResponseInfo();
        SalonFrequencyResponse.Master='RetailerFrequency';
        SalonFrequencyResponse.Field = new List<String>{'Rid','DivisionId','Frequency'};
        SalonFrequencyResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        SalonFrequencyResponse.Next = '0';
        List<List<String>> SalonFrequencyRecords = new List<List<String>>();
        List<ivybase__Standard_List_Master__c> SLMList = new List<ivybase__Standard_List_Master__c>();
        String[] lstMstrFields = new String[]{'ivybase__List_Code__c','ivybase__List_Type__c','ivybase__List_Name__c','Name'};
        List<String> listTypes = new List<String> {'DIVISION_TYPE'};
        if(SecurityUtility.checkIsAccessible('ivybase__Standard_List_Master__c', lstMstrFields))
            SLMList  = StandardListMasterservice.getStandardListUsingListType(listTypes);
        system.debug('SLMList---'+SLMList);
        map<string,string> statusMapListCode = new map<string,string>();
        for(ivybase__Standard_List_Master__c stMaster: SLMList){
            statusMapListCode.put(stMaster.ivybase__List_Code__c,stMaster.Name);
        }

        if(SalonFrequencylist !=Null){
            for(SalonFrequencyDivMapping__c SalonFrequencyDivMappingRecordList :SalonFrequencylist ){
                List<String> SalonFrequencyListInfo = new List<String>();
                if(SalonFrequencyDivMappingRecordList.Salon__c != null){
                    SalonFrequencyListInfo.add(string.valueOf(SalonFrequencyDivMappingRecordList.Salon__r.ivybase__Internal_Id__c));
                }else{
                    SalonFrequencyListInfo.add(''); 
                }
                if(SalonFrequencyDivMappingRecordList.Division__c != null && statusMapListCode.containskey(SalonFrequencyDivMappingRecordList.Division__r.name) && statusMapListCode.get(SalonFrequencyDivMappingRecordList.Division__r.name)!=null){
                    SalonFrequencyListInfo.add(statusMapListCode.get(SalonFrequencyDivMappingRecordList.Division__r.name));
                }else{
                    SalonFrequencyListInfo.add(''); 
                }//divsion ID
                if(SalonFrequencyDivMappingRecordList.Salon_Frequency__c != null){
                    SalonFrequencyListInfo.add(string.valueOf(SalonFrequencyDivMappingRecordList.Salon_Frequency__c));
                }else{
                    SalonFrequencyListInfo.add(''); 
                }//Salon Frequency

                SalonFrequencyRecords.add(SalonFrequencyListInfo);                
            }
        }
        SalonFrequencyResponse.Data=SalonFrequencyRecords;

        return SalonFrequencyResponse;
    }
}