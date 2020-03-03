@RestResource(urlMapping='/v1/P4OrderHistory/Masters/*')
global with sharing class RESTOrderManager {
    
    @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getOrderdetails() {
        
        RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
        RExAPIResponseDomain.ResponseInfo OrderInfo;
        RExAPIResponseDomain.ResponseInfo OLIInfo;
        response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        
        try{
           
            map<id,list<ivydsd__Order__c>> accordMap = OrderService.getOrderbyordDate();
            OrderInfo = OrderTranslator.objectToOrderInfo(accordMap,null);
            response.Tables.add(OrderInfo);
            
            Set<Id> orderIdSet = new Set<Id>();
            Map<String,Map<String,String>> intreIdanduomMap = new Map<String,Map<String,String>>();
            Set<Id> ProdId = new Set<Id>();
            if(accordMap!=null){
                for(id accid :accordMap.keyset() ){
                    for(ivydsd__Order__c ord : accordMap.get(accid)){
                        orderIdSet.add(ord.Id);
                    }
                }
            }
            
            List<ivydsd__Order_Line_Item__c> OLIList = OrderLineItemService.getOrderLineItemUsingOrderIdSet(orderIdSet);
            
            for(ivydsd__Order_Line_Item__c oli : OLIList){
                ProdId.add(oli.ivydsd__Product1__c);
            }
            
            for(ivybase__Product_UOM__c pu : ProductUOMService.getProductUOMListByProdIds(ProdId)){
                if(!intreIdanduomMap.containskey(String.valueOf(pu.ivybase__Product__r.ivybase__InternalId__c))){
                    intreIdanduomMap.put(String.valueOf(pu.ivybase__Product__r.ivybase__InternalId__c),new Map<String,String>());
                }
                intreIdanduomMap.get(String.valueOf(pu.ivybase__Product__r.ivybase__InternalId__c)).put(pu.ivybase__UOM_Number__c,pu.ivybase__UOM__c);
            }
           
            OLIInfo = OrderTranslator.objectToOLIInfo(OLIList,intreIdanduomMap,null);
            response.Tables.add(OLIInfo);
            
        }
        catch (SecurityUtility.SFDCAccessControlException ex) {
           
            OrderInfo = OrderTranslator.objectToOrderInfo(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(OrderInfo);
            
            OLIInfo = OrderTranslator.objectToOLIInfo(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            response.Tables.add(OLIInfo);
            
        }
        return response;
    }
}