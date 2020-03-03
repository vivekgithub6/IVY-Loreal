trigger InvoiceLineItemTrigger on ivydsd__Invoice_Line_Item__c (after insert, after update) {
    system.debug('invoice trigger');
     Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'InvoiceLineItemTrigger'});
    if(triggerLogicMap.get('InvoiceLineItemTrigger') == Null || triggerLogicMap.get('InvoiceLineItemTrigger') == false){
        
         if(trigger.isInsert && trigger.isAfter) {
             InvoiceLineItemTriggerHandler.createskusaloon(Trigger.new);
         }
         if(trigger.isUpdate && trigger.isAfter) {
             
             List<ivydsd__Invoice_Line_Item__c> invoiceLineitemList = new List<ivydsd__Invoice_Line_Item__c>();
             for(ivydsd__Invoice_Line_Item__c invoiceLineitem :trigger.new){
                if(invoiceLineitem.ivydsd__Total_Amount__c !=trigger.oldmap.get(invoiceLineitem.id).ivydsd__Total_Amount__c)
                    
                    invoiceLineitemList.add(invoiceLineitem);
            }
            if(invoiceLineitemList.size()>0) {
                InvoiceLineItemTriggerHandler.updateSkuSaloon(invoiceLineitemList);
            }
         }
    }
    
}