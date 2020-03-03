trigger SchemeProductGroupTrigger on ivydsd__Scheme_Group_Product__c (before insert,before update,before delete) {
 if(trigger.isbefore && trigger.isinsert){
    SchemeProductGroupTriggerHandler.checkSchemeProductGroupProdHirarchy(Trigger.new); 
    SchemeProductGroupTriggerHandler.getPriceForProductInScheme(Trigger.new);
    }
    else if(trigger.isbefore && trigger.isupdate){
    SchemeProductGroupTriggerHandler.checkSchemeProductGroupProdHirarchy(Trigger.new); 
        SchemeProductGroupTriggerHandler.getPriceForProductInScheme(Trigger.new);
    }
    else if(trigger.isbefore && trigger.isdelete){
       SchemeProductGroupTriggerHandler.updatePromotionStatusDraft(trigger.old); 
    }
   
}