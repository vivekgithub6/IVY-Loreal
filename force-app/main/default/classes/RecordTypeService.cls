public with sharing class RecordTypeService {
    public static List<RecordType> getObjectBasedRecordTypesCustomOne(String sobjectName) {
        List<RecordType> recordTypeList = new List<RecordType>();
        if (sobjectName != null && sobjectName != '') {
            recordTypeList = [ SELECT ID, 
                                   Name,
                                   SObjectType, 
                                   DeveloperName 
                               FROM
                                   RecordType
                               WHERE 
                                   SObjectType =:sobjectName];                                   
            return recordTypeList;
        }
        return null;
    }
    public static List<RecordType> getObjectBasedRecordTypes(String sobjectName) {
      
        List<RecordType> recordTypeList = new List<RecordType>();
        if (sobjectName != null && !sobjectName.startsWithIgnoreCase('ivybase__') && sobjectName.endsWithIgnoreCase('__c')) {
            sobjectName = 'ivybase__'+sobjectName;
        }
        if (sobjectName != null && sobjectName != '') {
            recordTypeList = [ SELECT ID, 
                                   Name,
                                   SObjectType, 
                                   DeveloperName 
                               FROM
                                   RecordType
                               WHERE 
                                   SObjectType =:sobjectName];                                   
            return recordTypeList;
        }
        return null;
    }
    
    /* public static Id getRecordtypeIdByName(String recordTypeName,String sobjectName) {
     
         Id recordType;
         if (sobjectName != null && !sobjectName.startsWithIgnoreCase('ivybase__') && sobjectName.endsWithIgnoreCase('__c')) {
            sobjectName = 'ivybase__'+sobjectName;
        }
         if(recordTypeName != null && recordTypeName != ''){
             recordType = [SELECT Id 
                             FROM 
                             RecordType 
                             WHERE SObjectType = :sobjectName AND 
                             Name = :recordTypeName][0].Id;
         }
         return recordType;
     }*/
}