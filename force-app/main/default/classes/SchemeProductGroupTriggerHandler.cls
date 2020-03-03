/*
 * Block comments with details of changes
 * s
 */
public class SchemeProductGroupTriggerHandler
{
    public static void checkSchemeProductGroupProdHirarchy(list<ivydsd__Scheme_Group_Product__c> promoGrpProdList)
    {
        set<id> promoGrpId= new set<id>();
        for(ivydsd__Scheme_Group_Product__c SGP:promoGrpProdList){
        promoGrpId.add(SGP.ivydsd__Scheme_Group__c);
        }
        
        list<ivydsd__Scheme_Group__c> ScehmeGroup=[select Id,Name,Product_Hierarchy__c
                                                   from ivydsd__Scheme_Group__c where ID IN:promoGrpId];
        Map<id,id> PromogrpProdHirIdMap= new Map<id,id>();
        for(ivydsd__Scheme_Group__c sg:ScehmeGroup){
            PromogrpProdHirIdMap.put(sg.id,sg.Product_Hierarchy__c);
        }  
        
        for(ivydsd__Scheme_Group_Product__c sgrprod:promoGrpProdList){
            if(PromogrpProdHirIdMap!=null && PromogrpProdHirIdMap.containsKey(sgrprod.ivydsd__Scheme_Group__c) && PromogrpProdHirIdMap.get(sgrprod.ivydsd__Scheme_Group__c)!=null){
            sgrprod.adderror('You Can create a promotion product Group record when Product Hirarchy is tagged at Promotion Group ');
            }
        }
    }
    public static void getPriceForProductInScheme(list<ivydsd__Scheme_Group_Product__c> promoGrpProdList){
        set<id> prdid= new set<id>();
        for(ivydsd__Scheme_Group_Product__c sgp:promoGrpProdList){
            if(sgp.ivydsd__Product1__c != NULL)
            prdid.add(sgp.ivydsd__Product1__c);
        }
        system.debug('size ->'+prdid);
        
        
        if(!prdid.IsEMpty()){
            Map<id,Decimal> productPriceMap= new map<id,Decimal>();
            
            list<ivybase__Price_List_Entrie__c> Priceentrylist= [select id,ivybase__Price_List__c,ivybase__UOM_1_Price__c,ivybase__Product__c 
                                                                 from ivybase__Price_List_Entrie__c where ivybase__Product__c IN:prdid AND ivybase__Price_List__r.ivybase__Is_Standard__c=True];
            /*Map<id,Decimal> productPriceMap= new map<id,Decimal>();*/
            if(Priceentrylist.size()>0){
                for(ivybase__Price_List_Entrie__c ple:Priceentrylist){
                    productPriceMap.put(ple.ivybase__Product__c,ple.ivybase__UOM_1_Price__c);
                }
            }
             
            system.debug('productPriceMap'+productPriceMap);
            for(ivydsd__Scheme_Group_Product__c sgpprice:promoGrpProdList){
                if(productPriceMap!=null && productPriceMap.containskey(sgpprice.ivydsd__Product1__c) && productPriceMap.get(sgpprice.ivydsd__Product1__c)!=null){
                    system.debug('Inside IF');
                    sgpprice.Product_Value_Worth__c=productPriceMap.get(sgpprice.ivydsd__Product1__c);
                    
                }else{
                    system.debug('inside else');
                    sgpprice.Product_Value_Worth__c=0;
                }
            }
            
        }
        
    }
    public static void updatePromotionStatusDraft(list<ivydsd__Scheme_Group_Product__c> oldpromoGrpProdList){
         set<id> promotionGrpIDset= new set<id>();
    for(ivydsd__Scheme_Group_Product__c SCG : oldpromoGrpProdList){
        if(SCG.ivydsd__Scheme_Group__c !=null){
            promotionGrpIDset.add(SCG.ivydsd__Scheme_Group__c);
        }
    }
    set<id> promotionIDset = new set<id>();
    list<ivydsd__Scheme_Group__c> SCGrp =[select id,ivydsd__Scheme__c from ivydsd__Scheme_Group__c where id IN:promotionGrpIDset ];
    if(SCGrp.size()>0){
        for(ivydsd__Scheme_Group__c SCGrop:SCGrp){
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
}