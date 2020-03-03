public class DigitalContentSchemeTranslator {
public static RExAPIResponseDomain.ResponseInfo objectToSchemeinfo(List< ivybase__Digital_Content_Mapping__c> DigitalContentMappingList, String errorCode) {
         RExAPIResponseDomain.ResponseInfo DContentInfo = new RExAPIResponseDomain.ResponseInfo ();
        DContentInfo.Master = 'SchemeDigitalContentMapping';
        DContentInfo.Field = new List<String>{'imgid', 'Schemeid'}; 
        List<List<String>> dContentschemeMapList = new List<List<String>>();
        if (DigitalContentMappingList != null && errorCode == null ) {
            for (ivybase__Digital_Content_Mapping__c digital :DigitalContentMappingList) {
            
                List<String> digitalRec = new List<String>();
             
                digitalRec.add( (digital.ivybase__Digital_Content__c != null) ? digital.ivybase__Digital_Content__r.ivybase__Internal_Id__c :'' );
                digitalRec.add( (digital.Scheme__c != null) ? digital.Scheme__r.ivydsd__Internal_Id__c :'' );            
                dContentschemeMapList.add(digitalRec);
            }
        }
        DContentInfo.Data = dContentschemeMapList;
        DContentInfo.ErrorCode = errorCode == null ? '0' : errorCode;
        DContentInfo.Next = '0';
        return DContentInfo;
    }
}