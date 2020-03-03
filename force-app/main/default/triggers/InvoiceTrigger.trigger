trigger InvoiceTrigger on ivydsd__Invoice__c (after insert,before insert,after update) {
    Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'InvoiceTrigger'});
    if(triggerLogicMap.get('InvoiceTrigger') == Null || triggerLogicMap.get('InvoiceTrigger') == false){
        if(trigger.isafter && trigger.isinsert) {
            InvoiceTriggerHandler.changeOrderStatus(trigger.new);
        }
        if(trigger.isbefore && trigger.isinsert) {
            InvoiceTriggerHandler.updateresourceInvoice(trigger.new);
        }
        if(trigger.isBefore && trigger.isUpdate) {
            InvoiceTriggerHandler.updateStatus(trigger.new, trigger.oldMap);
        }
    }
}