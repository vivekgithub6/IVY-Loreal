global with sharing class AccountDomain {

    global class RetailerInfo {}
    global class RetailerMaster {}
    public class accountIdandNameInfo {
        public Map<String, Id> internalIdAndSFIdMap;
        public Map<String, String> internalIdAndNameMap;
        public Map<String, Id> internalIdwithSFLocationIdMap;
    } 
}