public class RetailerProductAllocation_update {
    public static void Update_product_Allocation(Map<id,map<id,decimal>> accountidprodQtyMap){
        system.debug('accountidprodQtyMap'+accountidprodQtyMap);
        set<id> accidset = new set<id>();
        set<id> prdidset= new set<id>();
        if(accountidprodQtyMap!=null){
            for(id accid:accountidprodQtyMap.keyset()){
                if(accountidprodQtyMap.containskey(accid)){
                    accidset.add(accid);
                    for(id prdid :accountidprodQtyMap.get(accid).keyset()){
                        prdidset.add(prdid); 
                    }
                }
            }
        }
        List<RetailerProductAllocation__c> product = [select id,
                                                      name,
                                                      To__c,
                                                      Quantity__c,
                                                      Product_Master__c,
                                                      From__c,
                                                      Account__r.ivybase__Internal_Id__c,
                                                      Product_Master__r.ivybase__InternalId__c,
                                                      Account__c from RetailerProductAllocation__c
                                                      where Account__c IN:accidset AND Product_Master__c IN: prdidset
                                                      and ( (From__c<=:date.today() AND To__c>=:date.today()) OR ((From__c=Null OR From__c<=:date.today()) AND (To__c=Null OR To__c>=:date.today())) )
                                                     ];
        system.debug('retailerproductallocation'+product);
        list<RetailerProductAllocation__c> updateReatilerproductlist= new list<RetailerProductAllocation__c>();   
        if(product.size()>0 && product!=null){ 
            for(RetailerProductAllocation__c RPA:product){
                if(accountidprodQtyMap.containskey(RPA.Account__c) && accountidprodQtyMap.get(RPA.Account__c).containskey(RPA.Product_Master__c) ){
                    if(RPA.Quantity__c!=0 && (RPA.Quantity__c>=accountidprodQtyMap.get(RPA.Account__c).get(RPA.Product_Master__c)) ){
                        RPA.Quantity__c= RPA.Quantity__c-accountidprodQtyMap.get(RPA.Account__c).get(RPA.Product_Master__c); 
                    }
                    
                    updateReatilerproductlist.add(RPA);
                }
            } 
        }
        if(updateReatilerproductlist.size()>0){
            update updateReatilerproductlist;
        }
    }
}