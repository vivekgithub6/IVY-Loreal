trigger promotionslabtarget on ivydsd__Scheme_Slab_Target__c (before delete) {
   set<id> promotionslabIDset= new set<id>();
    for(ivydsd__Scheme_Slab_Target__c SCG : trigger.old){
        if(SCG.ivydsd__Scheme_Slab__c !=null){
            promotionslabIDset.add(SCG.ivydsd__Scheme_Slab__c);
        }
    }
    set<id> promotionIDset = new set<id>();
    list<ivydsd__Scheme_Slab__c> SCGrp =[select id,ivydsd__Scheme__c from ivydsd__Scheme_Slab__c where id IN:promotionslabIDset ];
    if(SCGrp.size()>0){
        for(ivydsd__Scheme_Slab__c SCGrop:SCGrp){
            if(SCGrop.ivydsd__Scheme__c!=null){
                promotionIDset.add(SCGrop.ivydsd__Scheme__c);
            }
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