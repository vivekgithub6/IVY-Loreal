/*
* Test Class Name: TestAcccountTriggerHandler
*
*/
trigger AccountTrigger on Account (after insert, before update, after update, before insert) {
    Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'AccountTrigger'});
    if(triggerLogicMap.get('AccountTrigger') == Null || triggerLogicMap.get('AccountTrigger') == false){
        if(Trigger.isInsert && Trigger.isAfter){
            AccountTriggerHandler.reDocumentData(trigger.new);
            //  AccountTriggerHandler.createPartner(trigger.new);
            AccountTriggerHandler.insertHairDresser(trigger.new);
            
        }
        if(Trigger.isUpdate && Trigger.isBefore){
            for(Account acc : Trigger.new){
                if(acc.Is_Conquest__c == true){
                    if(trigger.oldmap.get(acc.id).Converted_to_Normal_Saloon__c!=true && acc.Converted_to_Normal_Saloon__c==true){
                        AccountTriggerHandler.updateNormalSalon(Trigger.new);
                    }
                }
            }
            
            
        }
        if(Trigger.isAfter && Trigger.isUpdate){
            AccountTriggerHandler.updateOutstandingAmountinSoldtoParty(Trigger.new);
        }
        if((Trigger.isInsert || Trigger.isUpdate) && Trigger.isBefore)
        {
            //for mag
            //for(Account acc : Trigger.new){
                
                    //if(acc.No_of_Stylist__c!=null && acc.Color_Price__c!=null)
                        AccountTriggerHandler.updateMag(Trigger.new);                
            //}
        }
    }
}