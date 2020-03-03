trigger PromotionSlabTrigger on ivydsd__Scheme_Slab__c (before delete) {
    set<id> promotionIDset= new set<id>();
    for(ivydsd__Scheme_Slab__c slab:trigger.old){
        if(slab.ivydsd__Scheme__c!=null){
            promotionIDset.add(slab.ivydsd__Scheme__c);
        }
    }
   list<ivydsd__Scheme__c> promolist= [select id,Status__c from ivydsd__Scheme__c where id IN: promotionIDset]; 
    list<ivydsd__Scheme__c> promolistupdate= new list<ivydsd__Scheme__c>();
    if(promolist.size()>0){
        for(ivydsd__Scheme__c schem : promolist){
            schem.Status__c='Draft';
            promolistupdate.add(schem);
        }
    }
    update promolistupdate;
}