global class RetailerDocumentService {
    public static List<Document__c> getAllDocuments(Set<id> accountIds){
        
        List<Document__c> documents = [Select Id, Name,Available__c,Document_Code__c, Retailer__c from Document__c where Retailer__c IN : accountIds];
        
        return documents;
    }

}