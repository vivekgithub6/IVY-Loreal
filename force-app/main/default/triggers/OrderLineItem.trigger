trigger OrderLineItem on ivydsd__Order_Line_Item__c (before insert,before update,after update,after delete,after insert) {
   // Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'OrderLineItem'});
  //  if(triggerLogicMap.get('OrderLineItem') == Null || triggerLogicMap.get('OrderLineItem') == false){
    system.debug(' Query: OrderLineItem trigger');
    
       
    
    
    
    list<ivybase__Resource__c> res=[select id,name,ivybase__Related_User__c,ivybase__Resource_Type__c,ivybase__Resource_Type__r.Name from ivybase__Resource__c where ivybase__Related_User__c =:userinfo.getUserId()];
        system.debug('res'+res);
        String resorcetypename = Label.ResourceType_Name; 
        if(res.size()>0 && res[0].ivybase__Resource_Type__r.Name!=resorcetypename){
     		if((trigger.isupdate && trigger.isbefore) ||(trigger.isinsert && trigger.isbefore) ){
         
        		 OrderLineItemTriggerhandler.getlineitems(Trigger.New);
         
       		 }
        
             if((trigger.isupdate && trigger.isbefore) ||(trigger.isinsert && trigger.isbefore) ){
            	OrderLineItemTriggerhandler.productLineItemValidation(Trigger.New); 
                
                OrderLineItemTriggerhandler.PopulateLineItemNumber(Trigger.New);
                if(trigger.isinsert && trigger.isbefore)
                OrderLineItemTriggerhandler.populatePONumber(Trigger.New); 
        	}
         
        
            if((trigger.isupdate && trigger.isAfter)||(trigger.isinsert && trigger.isAfter) ){
                OrderLineItemTriggerhandler.getdiscount(Trigger.New);
            }
            
            if( trigger.IsDelete && trigger.isAfter){
                OrderLineItemTriggerhandler.getdiscount(Trigger.old);
            }
        }
    else{
        if(/*(trigger.isupdate && trigger.isbefore) ||(*/trigger.isinsert && trigger.isbefore ){
              OrderLineItemTriggerhandler.populatePONumber(Trigger.New);   
         }
        /*if(trigger.isupdate && trigger.isbefore) {
            OrderLineItemTriggerhandler.populatePONumberUpdate(Trigger.New);
        }*/
        /*if((trigger.isupdate && trigger.isbefore) ||(trigger.isinsert && trigger.isbefore) ){
              OrderLineItemTriggerhandler.populatePONumber(Trigger.New);   
         }*/
        
    }
//}
}