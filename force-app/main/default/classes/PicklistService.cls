public with sharing class PicklistService{
    
    public static Set<Id> getInvoicesByResourceId(){
        
        Set<Id> invoiceIds = new set<Id>();
        
        List<String> pickdetfields = new List<String>{'ivydsd__Invoice__c','ivydsd__Picklist__c'};
        List<String> pickfields = new List<String>{'ivydsd__Resource__c','ivydsd__Date__c'};
        Id resourceId = ResourceService.getLoginsellerId();
        
        if(SecurityUtility.checkIsAccessible('ivydsd__Picklist_Detail__c', pickdetfields) && SecurityUtility.checkIsAccessible('ivydsd__Picklist__c',pickfields)) {
            
            for(ivydsd__PickList_Detail__c pd : [SELECT Id,Name,ivydsd__Invoice__c FROM ivydsd__Picklist_Detail__c WHERE ivydsd__Picklist__r.ivydsd__Resource__c != null AND ivydsd__Picklist__r.ivydsd__Resource__c = :resourceId AND ivydsd__Picklist__r.ivydsd__Date__c = :System.Today()]){
                
                invoiceIds.add(pd.ivydsd__Invoice__c);
            }
        }
        
        return invoiceIds;
    }
}