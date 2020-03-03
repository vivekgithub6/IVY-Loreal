/**
* Created By : Ivy Mobility
* Created Date : 2019-April-27
* Purpose : To avoid the duplicate records
*/
trigger PromotionPackageCappingTrigger on Promotion_Package_Capping__c (before insert, before update,before delete) {
    if(trigger.isbefore && (trigger.isinsert || trigger.isupdate)){
        List<String> uniqueFormulaList = new List<String>();
        for(Promotion_Package_Capping__c ppc : trigger.new) {
            uniqueFormulaList.add(ppc.Unique_Formula__c);
        }
        List<Promotion_Package_Capping__c> ppcList = [SELECT Id FROM Promotion_Package_Capping__c WHERE Unique_Formula__c IN :uniqueFormulaList];
        if(ppcList != null && ppcList.isEmpty() == false) {
            trigger.new[0].Unique_Formula__c.addError('The same combination already exist');
        }
    }
    
    if(trigger.isbefore && trigger.isdelete){
        set<id> promotionIDset= new set<id>();
        for(Promotion_Package_Capping__c SCG : trigger.old){
            if(SCG.Promotion__c !=null){
                promotionIDset.add(SCG.Promotion__c);
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
}