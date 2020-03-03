trigger ProductHierarchyTrigger on ivybase__Product_Hierarchy__c (before insert, before update) {
    
    if(trigger.isInsert && trigger.isBefore)
        ProductHierarchyTriggerHandler.populateProductCode(trigger.new);
        
    if(trigger.isUpdate && trigger.isBefore) {
        
        List<ivybase__Product_Hierarchy__c> prodHierarchyList = new List<ivybase__Product_Hierarchy__c>();
        for(ivybase__Product_Hierarchy__c prodHierarchy :trigger.new){
            if((prodHierarchy.ivybase__Code__c != trigger.oldmap.get(prodHierarchy.id).ivybase__Code__c) ||
               (prodHierarchy.ProductHierarchyCode__c != trigger.oldmap.get(prodHierarchy.id).ProductHierarchyCode__c)) {
                prodHierarchyList.add(prodHierarchy);
            }
            
        }
        ProductHierarchyTriggerHandler.updateProductCode(prodHierarchyList, trigger.oldmap);
    }
}