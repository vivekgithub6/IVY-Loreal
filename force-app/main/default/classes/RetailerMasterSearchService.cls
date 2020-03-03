public class RetailerMasterSearchService {
    
    public static LIST<Account> getAccounts(String searchString, list<String> SearchTypeList) {
        
        LIST<Id> salonId = new LIST<Id>();
        LIST<Account> accLIST = new LIST<Account>();
        String nameString;
        if(SearchTypeList.contains('NODE2')) {
            nameString = '%'+searchString+'%';
            for(StoreDivisionMapping__c sdm: [select id, Store_Hierarchy__r.name,Account__c, Store_Hierarchy__r.RecordType.Name  
                                              from StoreDivisionMapping__c 
                                              where  Store_Hierarchy__r.RecordType.Name  = 'Node4' AND Store_Hierarchy__r.name LIKE: nameString ])
            {
                salonId.add(sdm.Account__c);
            }
            
        }
        
        if(SearchTypeList.contains('NAME')) {
            nameString = '%'+searchString+'%';
            
        }
        system.debug('nameString'+ nameString);
        
        accLIST  = [SELECT ID, NAME, Sold_To_Party_Number__c,Store_Address__c,ivybase__Internal_Id__c  
                    FROM ACCOUNT 
                    WHERE NAME LIKE: nameString OR Sold_To_Party_Number__c =: searchString  OR Id IN:salonId];
        system.debug('**** '+accLIST.size());
        return accLIST;
    }
}