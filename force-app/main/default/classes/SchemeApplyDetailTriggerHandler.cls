public class SchemeApplyDetailTriggerHandler {
    public static voId getschemeappliedvalue(List<ivydsd__Scheme_Apply_Detail__c> SchemeApplyList){
        //scheme apply detail get ->scheme slab-> scheme to Set-->
        Set<Id> orderId = new Set<Id>();
        Set<Id> olId = new Set<Id>();
        Set<Id> schemeIdRelatedSchemeApply = new Set<Id>();
        Set<Id> schemeapplyId = new Set<Id>();
        for(ivydsd__Scheme_Apply_Detail__c SAD : SchemeApplyList){
            schemeapplyId.add(SAD.Id);
            if(SAD.ivydsd__Order__c != null){
                orderId.add(SAD.ivydsd__Order__c); 
            }if(SAD.ivydsd__Order_Line_Item__c != null){
                olId.add(SAD.ivydsd__Order_Line_Item__c);
            }if(SAD.ivydsd__Scheme__c != null){
                schemeIdRelatedSchemeApply.add(SAD.ivydsd__Scheme__r.ivydsd__Scheme__c);
                
            }
        }
        //Qurying Scheme Apply details based on Order
        List<ivydsd__Scheme_Apply_Detail__c> OrderSchemeDetails=[SELECT Id, ivydsd__Order__c,ivydsd__Order_Line_Item__c,ivydsd__Scheme__c,ivydsd__Scheme__r.ivydsd__Scheme__c FROM ivydsd__Scheme_Apply_Detail__c WHERE ivydsd__Order__c IN:orderId AND Id IN: schemeapplyId];
        Map<Id,Set<Id>> orderschemeMap = new Map<Id,Set<Id>>(); //useed to hold the order Id and applied schemeIds
        Set<Id> schemeId = new Set<Id>();//holding the all the scheme Ids related to the order
        for(ivydsd__Scheme_Apply_Detail__c sc:OrderSchemeDetails){
            if(sc.ivydsd__Scheme__c!=null){
                schemeId.add(sc.ivydsd__Scheme__r.ivydsd__Scheme__c);  
            }
            if(orderschemeMap.containskey(sc.ivydsd__Order__c)){
                orderschemeMap.get(sc.ivydsd__Order__c).add(sc.ivydsd__Scheme__r.ivydsd__Scheme__c);
            }else{
                Set<Id> schemId = new Set<Id>();
                schemId.add(sc.ivydsd__Scheme__r.ivydsd__Scheme__c);
                orderschemeMap.put(sc.ivydsd__Order__c,schemId);
            }
        }
        System.debug('orderschemeMap'+orderschemeMap);
        //Querying Scheme Group and scheme Group Product related to the Scheme applied to Order
        List<ivydsd__Scheme_Group__c> schgrpList = [SELECT Id,Name,ivydsd__Group_Type__c,ivydsd__Scheme__c,(SELECT Id,ivydsd__Product1__c,Product_Hierarchy__c FROM ivydsd__Scheme_Group_Details__r) FROM ivydsd__Scheme_Group__c WHERE ivydsd__Group_Type__c='BUY' AND ivydsd__Scheme__c IN:schemeId];
        System.debug('schgrpList'+schgrpList);
        Map<Id,Set<Id>> schemProdIDMap= new  Map<Id,Set<Id>>(); 
        Map<Id,Set<Id>> schemProdHirIDMap= new  Map<Id,Set<Id>>();
        for(ivydsd__Scheme_Group__c schgrp:schgrpList){
            for(ivydsd__Scheme_Group_Product__c Sgp:schgrp.ivydsd__Scheme_Group_Details__r){
                if(Sgp.ivydsd__Product1__c!=null && schemProdIDMap.containskey(schgrp.ivydsd__Scheme__c)){
                    schemProdIDMap.get(schgrp.ivydsd__Scheme__c).add(Sgp.ivydsd__Product1__c);  
                }else{
                    Set<Id> prdId= new Set<Id>();
                    prdId.add(Sgp.ivydsd__Product1__c);
                    schemProdIDMap.put(schgrp.ivydsd__Scheme__c,prdId);  
                }
                //forming scheme and prdhirchy Id Map
                
                if(Sgp.Product_Hierarchy__c!=null && schemProdHirIDMap.containskey(schgrp.ivydsd__Scheme__c)){
                    schemProdHirIDMap.get(schgrp.ivydsd__Scheme__c).add(Sgp.Product_Hierarchy__c);  
                }else{
                    Set<Id> prdhrId= new Set<Id>();
                    prdhrId.add(Sgp.Product_Hierarchy__c);
                    schemProdHirIDMap.put(schgrp.ivydsd__Scheme__c,prdhrId);  
                }
            }
        }
        System.debug('schemProdIDMap'+schemProdIDMap);
        //----
        List<ivydsd__Order_Line_Item__c> oli_List=[SELECT Id, ivydsd__UOM_1_Quantity__c,ivydsd__Product1__c,ivydsd__UOM_1_Rate__c,ivydsd__Total_Amount__c,ivydsd__Order__c,ivydsd__Order__r.ivydsd__Store__c
                                                   From ivydsd__Order_Line_Item__c Where ivydsd__Order__c IN:orderschemeMap.keySet()];
        
        Map<Id,ivydsd__Order_Line_Item__c> prodlineMap= new Map<Id,ivydsd__Order_Line_Item__c>();
        Set<Id> checkprdctId= new Set<Id>();
        for(ivydsd__Order_Line_Item__c oli:oli_List ){
            checkprdctId.add(oli.ivydsd__Product1__c);
            prodlineMap.put(oli.ivydsd__Product1__c,oli);
        }
        System.debug('prodlineMap'+prodlineMap);
        Map<ID,Set<ID>> getprodvsprodhrchyMap = ProductService.getprodvsprodhrchyMap(checkprdctId);
        //holding the order Id,scheme Id and Price which is coming FROM Orderlineitem
        Map<Id, Map<Id,Decimal>> orderSchemepriceMap= new Map<Id, Map<Id,Decimal>>();
        
        for(ID ordId:orderschemeMap.keySet()){
            for(ID schId:orderschemeMap.get(ordId)){
                if(schemProdIDMap.containskey(schId)){
                    for(Id prdId:schemProdIDMap.get(schId)){
                        if(prodlineMap.containskey(prdId)&& prodlineMap.get(prdId).ivydsd__Order__c==ordId ){
                            if(orderSchemepriceMap.containskey(ordId)){
                                decimal prevprice=orderSchemepriceMap.get(ordId).get(schId);
                                if(prevprice==null){
                                    prevprice=0;
                                }
                                System.debug('**prevprice'+prevprice);
                                System.debug('**orderSchemepriceMap'+orderSchemepriceMap);
                                System.debug('**prodlineMap'+prodlineMap);
                                orderSchemepriceMap.get(ordId).put(schId,((prodlineMap.get(prdId).ivydsd__Total_Amount__c==null?0:prodlineMap.get(prdId).ivydsd__Total_Amount__c)+prevprice));  
                                
                            }else{
                                Map<Id,decimal> schemprice= new Map<Id,decimal> ();
                                schemprice.put(schId,((prodlineMap.get(prdId).ivydsd__Total_Amount__c==null)?0:prodlineMap.get(prdId).ivydsd__Total_Amount__c));
                                orderSchemepriceMap.put(ordId,schemprice);
                            }
                        }
                    }
                    //prod hierarchy
                    for(Id prdhrId:schemProdHirIDMap.get(schId)){
                        for(Id prdId:prodlineMap.keySet()){
                            if(prodlineMap.get(prdId).ivydsd__Order__c==ordId && getprodvsprodhrchyMap!=null && getprodvsprodhrchyMap.containskey(prdId) 
                               && getprodvsprodhrchyMap.get(prdId)!=null && getprodvsprodhrchyMap.get(prdId).contains(prdhrId)){
                                   
                                   if(orderSchemepriceMap.containskey(ordId)){
                                       decimal prevprice=orderSchemepriceMap.get(ordId).get(schId);
                                       if(prevprice==null){
                                           prevprice=0;
                                       }
                                       orderSchemepriceMap.get(ordId).put(schId,((prodlineMap.get(prdId).ivydsd__Total_Amount__c==null?0:prodlineMap.get(prdId).ivydsd__Total_Amount__c)+prevprice));  
                                   } else {
                                       Map<Id,decimal> schemprice= new Map<Id,decimal> ();
                                       schemprice.put(schId,((prodlineMap.get(prdId).ivydsd__Total_Amount__c==null)?0:prodlineMap.get(prdId).ivydsd__Total_Amount__c));
                                       orderSchemepriceMap.put(ordId,schemprice);
                                   }
                               }
                        }
                    }
                    //end of prod hirchy loop
                }
            }
        }
        System.debug('orderSchemepriceMap'+orderSchemepriceMap);
        List<ivydsd__Order__c> orderList=[SELECT Id,ivydsd__Store__c FROM ivydsd__Order__c WHERE  Id IN:orderSchemepriceMap.keySet()];
        
        
        List<Sales_Forecast__c> Sfcast=  PromotionalPlanningService.getApprovedPromotionalPlan();
        Set<Id> sfId = new Set<Id>();
        for(Sales_Forecast__c sfc:Sfcast){
            sfId.add(sfc.Id);
        }
        List<Sales_Forecast_Detail__c> sfdetailList=PromotionalPlanningDetailsService.getPromotionalPlanningDetailsbyPromo(sfId);
        List<Sales_Forecast_Detail__c> updateSfDetail= new List<Sales_Forecast_Detail__c>();
        if(sfdetailList!=null){
            
            for(Sales_Forecast_Detail__c sfd:sfdetailList){
                for(ivydsd__Order__c ords:orderList){
                    if(sfd.Scheme__c!=null && sfd.Store__c!=null &&(sfd.Store__c==ords.ivydsd__Store__c)){
                        if(orderSchemepriceMap.containskey(ords.Id) && orderSchemepriceMap.get(ords.Id).containskey(sfd.Scheme__c) ){
                            sfd.Scheme_Achievement__c=+ orderSchemepriceMap.get(ords.Id).get(sfd.Scheme__c);
                        }
                        
                    }
                }
                updateSfDetail.add(sfd);
                system.debug('updateSfDetail'+updateSfDetail);
                
            }
            update updateSfDetail;
        }
    }
}