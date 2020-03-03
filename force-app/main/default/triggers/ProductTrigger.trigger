/**
 * Created By : Ivy Mobility
 * Purpose : Used to assign the Value for the Product Code and Customer Material Codes
 * Test Class Covered : TestProductTrigger
*/
trigger ProductTrigger on ivybase__Product__c (before insert, before update, after insert, after update) {
    Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'ProductTrigger'});
    if(triggerLogicMap.get('ProductTrigger') == Null || triggerLogicMap.get('ProductTrigger') == false){
        Map<String, String> countryCodeMap = ProductHierarchyTriggerHandler.generateCCMap();
        if(trigger.isInsert && trigger.isAfter)
            ProductTriggerHandler.createUOMProduct(trigger.new);
        
        if(trigger.isUpdate  && trigger.isAfter){
            Set<Id> prodIds = new Set<Id>();
            for(ivybase__Product__c product : trigger.new){
                if(product.ivybase__Barcode__c != trigger.oldmap.get(product.id).ivybase__Barcode__c)
                    prodIds.add(product.Id);
            }
            ProductTriggerHandler.updateUOMProduct(prodIds);
        }
        
        if(trigger.isInsert && trigger.isBefore)
            ProductTriggerHandler.populateProductCode(trigger.new);
        
        if(trigger.isUpdate && trigger.isBefore) {
            
            List<ivybase__Product__c> prodList = new List<ivybase__Product__c >();
            for(ivybase__Product__c product:trigger.new){
                product.Customer_Material_Code__c = String.isNotBlank(product.Customer_Material__c) == true && 
                    product.Customer_Material__c.endsWith(countryCodeMap.get(product.Market_ISO__c)) == true ? 
                    product.Customer_Material__c.removeEnd(countryCodeMap.get(product.Market_ISO__c)) : product.Customer_Material__c;
                if((product.ivybase__Code__c != trigger.oldmap.get(product.id).ivybase__Code__c)
                   || (product.Product_Code__c != trigger.oldmap.get(product.id).Product_Code__c)) {
                   
                    prodList.add(product);
                }
                
            }
            ProductTriggerHandler.updateProductCode(prodList, trigger.oldmap);
        }
    }
}