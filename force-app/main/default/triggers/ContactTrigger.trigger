trigger ContactTrigger on Contact (before insert,after insert) {
    
    //Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'ContactTrigger'});
   if(trigger.isInsert && trigger.isBefore){
        //if(triggerLogicMap.get('ContactTrigger') == Null || triggerLogicMap.get('ContactTrigger') == false){
        ContactTriggerHandler.FillInternalId(trigger.new);
        //}
    }
    if(trigger.isInsert && trigger.isAfter){
        List<Id> contactId = new List<Id>();
        List<String> imageUrlSet = new List<String>();
        
        for(contact c:trigger.new){
            string ImageURL=c.Signature__c;
            if(ImageURL!=null && c.Signature_Link__c==null){
                imageUrlSet.add(ImageURL);
                contactId.add(c.id);
            }
            
            // S3ImageDownload.listContents(ImageURL,c.id,null);
        }
         
    }
    /*if(trigger.isUpdate && trigger.isAfter)
    {
        List<Id> contactId = new List<Id>();
        List<String> imageUrlSet = new List<String>();
        for(contact c:trigger.new){
            if(c.Signature__c!=trigger.oldmap.get(c.id).Signature__c){
                imageUrlSet.add(c.Signature__c);
                contactId.add(c.id);
                //if(ImageURL!=Null)
                //S3ImageDownload.listContents(ImageURL,c.id,null);
            }
        }
        system.debug('imageUrlSet'+imageUrlSet);
        system.debug('contactId'+contactId);
        
    }*/
}