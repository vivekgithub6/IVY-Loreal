@RestResource(UrlMapping='/v1/order/Master')
global with sharing class RESTOrderDetails {
    @httpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getOrderDetailInfo(){
       RExAPIResponseDomain.MultipleResponseInfo OrderResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        
         OrderResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo OrderDetail = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo OrderLineItemDetail = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo schemeApplyDetailresp = new RExAPIResponseDomain.ResponseInfo();
        RExAPIResponseDomain.ResponseInfo freeProductDetail = new RExAPIResponseDomain.ResponseInfo();
        
        list<ivydsd__Order_Line_Item__c> olitem= new list<ivydsd__Order_Line_Item__c>();
        List<ivydsd__Scheme_Apply_Detail__c> schemeApplyDetail = new List<ivydsd__Scheme_Apply_Detail__c>();
        try{
            List<ivydsd__Order__c> OrderDetList = OrderService.getorderheader();
            system.debug('OrderDetList'+OrderDetList);
            set<Id> ordId = new set<Id>();
            //get all Id
            for(ivydsd__Order__c od:OrderDetList)
            {
                ordId.add(od.id);
            }
            system.debug('OId'+ordId);
            
            OrderDetail=OrderHeaderTranslator.objectToorder(OrderDetList,null);
            //sending orderId to query line item
            olitem=OrderService.getorderlineitem(ordId);
            schemeApplyDetail=OrderService.getschemeApplyDetail(ordId);
            //OrderLineItemDetail=OrderLineitemTranslator.objectToorderlineitem(olitem, null);
            OrderLineItemDetail=OrderLineitemTranslator.objectToorderlineitem(olitem, null);
            schemeApplyDetailresp=OrderLineitemTranslator.objectToSchemeApplyDetail(schemeApplyDetail, null);
            freeProductDetail=OrderLineitemTranslator.objectToSchemeFreeProductDetail(schemeApplyDetail, null);
            OrderResponse.Tables.add(OrderDetail);
            OrderResponse.Tables.add(OrderLineItemDetail);
            OrderResponse.Tables.add(schemeApplyDetailresp);
            OrderResponse.Tables.add(freeProductDetail);
        }Catch(Exception ex){
            
        }
        return OrderResponse;
    }
}