global class InvoiceOrderDataCorrectionDONOTSCHEDULE implements Database.Batchable<sObject>{
    /*
InvoiceOrderDataCorrectionDONOTSCHEDULE sfa= new InvoiceOrderDataCorrectionDONOTSCHEDULE();
database.executeBatch(sfa);
     */
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query='select id,ivydsd__Resource__c,ivydsd__Store__c  from ivydsd__Order__c where ivydsd__Resource__c=\'a0Yp0000001qpltEAA\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<ivydsd__Order__c> ordList){
        /*List<ivydsd__invoice__c> updInvList = new List<ivydsd__invoice__c>();
        Map<Id,ivydsd__invoice__c> invMap = new Map<Id,ivydsd__invoice__c>();
        for(ivydsd__invoice__c inv :invList){
            invMap.put(inv.id, inv);
        }
        Set<Id> InvIdSet = new Set<Id>();
        for(ivydsd__Invoice_Line_Item__c rec : [select id, ivydsd__Product_Master1__r.Division__c, ivydsd__invoice__c from ivydsd__Invoice_Line_Item__c where ivydsd__invoice__c in :invList]){
            if(rec.ivydsd__Product_Master1__r.Division__c != 'a2Ip00000006y0MEAQ'){
                
                InvIdSet.add(rec.ivydsd__invoice__c);
            }            
        }
        
        for(Id InvId : InvIdSet){
            ivydsd__invoice__c inv = invMap.get(Invid);
            inv.ivydsd__Resource__c = '';
                inv.ivydsd__Store__c = '';
                updInvList.add(inv);
        }
        
        Map<Id,ivydsd__Order__c> ordMap = new Map<Id,ivydsd__Order__c>();
        Set<Id> OrdIdSet = new Set<Id>();
        for(ivydsd__invoice__c updInv : updinvlist){
            OrdIdSet.add(updInv.ivydsd__Order__c);
        }
        
        List<ivydsd__Order__c> updOrdList =  new List<ivydsd__Order__c>();
        for(ivydsd__Order__c  ord : [select id from ivydsd__Order__c  where ivydsd__Resource__c = 'a0Yp0000001qpltEAA']){
            ord.ivydsd__Resource__c = '';
            ord.ivydsd__Store__c = '';
            updOrdList.add(ord);
            
        }
        
        update updOrdList;
        update updInvList;*/
        Set<Id> OrdIdSet = new Set<Id>();
        for(ivydsd__Order_Line_Item__c rec : [select id, ivydsd__Product1__r.Division__c, ivydsd__Order__c from ivydsd__Order_Line_Item__c where ivydsd__Order__r.id in :ordList]){
            if(rec.ivydsd__Product1__r.Division__c != 'a2Ip00000006y0MEAQ'){
                
                OrdIdSet.add(rec.ivydsd__Order__c);
            }            
        }
        List<ivydsd__Order__c> updOrdList =  new List<ivydsd__Order__c>();
        for(ivydsd__Order__c  ord : [select id,ivydsd__Resource__c,ivydsd__Store__c from ivydsd__Order__c  where id = :OrdIdSet]){
            ord.ivydsd__Resource__c = null;
            ord.ivydsd__Store__c = null;
            updOrdList.add(ord);
            
        }
        
        update updOrdList;
    }
    
    global void finish(Database.BatchableContext bc){
        
    }
}