/*
* Class Name	: CustomLookupController
* Pirpose		: Used to send selected records to lightning component.
*
*/


public class CustomLookupController {
    
    
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(String searchKeyWord, String ObjectName, String resourceType, String managerId) {
        system.debug('ObjectName-->' + ObjectName);
        String searchKey = searchKeyWord + '%';
        
        List < sObject > returnList = new List < sObject > ();
        
        system.debug('searchKeyWord '+ searchKeyWord);
        system.debug('resourceType '+ resourceType);
        system.debug('managerId '+ managerId);
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, ivybase__Related_User__c, Name from ' +ObjectName + ' where Name LIKE: searchKey AND ivybase__Resource_Type__r.Name =: resourceType ';
       
        if(managerId != NULL && managerId != '') {
            sQuery = sQuery + ' and ivybase__Reports_To__c = : managerId ';
        }
        sQuery = sQuery + 'order by createdDate DESC';
        system.debug('query ->'+ sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        system.debug('lstOfRecords'+ lstOfRecords);
        
        return lstOfRecords;
        /*for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;*/
    }
}