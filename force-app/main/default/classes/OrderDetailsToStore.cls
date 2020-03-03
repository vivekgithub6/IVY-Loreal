public class OrderDetailsToStore {
    public string OrderId{get;set;}
    public list<ivydsd__Order__c> OrderDetail=new list<ivydsd__Order__c>();
    public Decimal FinalOrdervalue{get;set;}
    public Decimal TotalQuantity{get;set;}
    public String CurrencyCode{get;set;}
    
    public list<ivydsd__Order_Line_Item__c> OrderLineitemDetail=new list<ivydsd__Order_Line_Item__c>();
    public  list<ivydsd__Order__c> getOrderDetails(){
            OrderDetail=[select ivydsd__Order_Date__c,Division__r.name,order_value_without_tax__c,CurrencyIsoCode ,ivydsd__Mobile_Order_Number__c,Salon_Code__c,Signature_Image_Path__c,Signature_Link1__c,ivydsd__Remarks__c,ivydsd__Final_Order_Value__c,ivydsd__Store__r.ivybase__StoreCode__c,ivydsd__Store__r.Name,Bill_To__r.Store_Address__c,Ship_To__r.Store_Address__c,(select Product_Name__c,ivydsd__UOM_1_Quantity__c,CurrencyIsoCode,ivydsd__Total_Amount__c,Product_Code__c from ivydsd__Order_Line_Items__r) from ivydsd__Order__c where id=:OrderId];
        FinalOrdervalue=0;
        if(OrderDetail.size()>0){
            CurrencyCode=OrderDetail[0].CurrencyIsoCode;
            FinalOrdervalue=OrderDetail[0].order_value_without_tax__c;
            if(FinalOrdervalue!=null){
            FinalOrdervalue=FinalOrdervalue.setScale(2);
            }
             }
        system.debug('OrderDetail'+OrderDetail);
        return OrderDetail;
    }
    public  list<ivydsd__Order_Line_Item__c> getOrderLineItemDetails(){
       for(ivydsd__Order__c order:OrderDetail)
            OrderLineitemDetail=order.ivydsd__Order_Line_Items__r;
        TotalQuantity=0;
        for(ivydsd__Order_Line_Item__c orderlineiem:OrderLineitemDetail){
            if(orderlineiem.ivydsd__UOM_1_Quantity__c!=null){
            TotalQuantity+=orderlineiem.ivydsd__UOM_1_Quantity__c;
            }
        }
        return OrderLineitemDetail;
    }
}