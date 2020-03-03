trigger RetailerProductAllocation on RetailerProductAllocation__c (before insert,before update) {
    
   /* Map<String, Boolean> triggerLogicMap = TriggerLogicService.getDuplicationCheck(new Set<String>{'Retailer_Product_Allocation_Duplicate_Check'});
    if(triggerLogicMap.get('Retailer_Product_Allocation_Duplicate_Check') == Null 
       || triggerLogicMap.get('Retailer_Product_Allocation_Duplicate_Check') == false) {      
           List<Id> AccountId  = new List<Id>();
           List<Id> ProductId  = new List<Id>();
           List<Date> FromDate  = new List<Date>();
           List<Date> ToDate  = new List<Date>();
           Map<String,RetailerProductAllocation__c> newRecordMap = new Map<String,RetailerProductAllocation__c>();
           Map<String,RetailerProductAllocation__c> OldRecordMap = new Map<String,RetailerProductAllocation__c>();
           for(RetailerProductAllocation__c r:trigger.new)
           {
               String s = ''+r.Account__c+'-'+r.Product_Master__c+'-'+r.From__c+'-'+r.To__c;
               if(newRecordMap.containsKey(s))
               {
                   r.addError('Duplicate Combination');
               }else
               {
                   newRecordMap.put(s,r);
               }
               AccountId.add(r.Account__c);
               ProductId.add(r.Product_Master__c );
               FromDate.add(r.From__c);
               ToDate.add(r.To__c);
           }
           FromDate.sort();
           ToDate.sort();
           if(FromDate.size()>0 && ToDate.size()>0){
               Date startingDate = FromDate[0];
               Date EndingDate = ToDate[ToDate.size()-1] ;
               List<RetailerProductAllocation__c> rpa = [select id,name,Account__c,Product_Master__c,From__c,To__c from RetailerProductAllocation__c where Account__c=:AccountId and Product_Master__c=:ProductId and From__c=:startingDate and To__c=:EndingDate];
               for(RetailerProductAllocation__c r:rpa)
               {
                   String s = ''+r.Account__c+'-'+r.Product_Master__c+'-'+r.From__c+'-'+r.To__c;
                   OldRecordMap.put(s,r);   
               }
               
               for(RetailerProductAllocation__c r:trigger.new)
               {
                   String s = ''+r.Account__c+'-'+r.Product_Master__c+'-'+r.From__c+'-'+r.To__c;
                   if(OldRecordMap.containsKey(s))
                   {
                       r.addError('Combination Already Exists');
                   }
                   
               }
               
               
               
           }
       }*/
}