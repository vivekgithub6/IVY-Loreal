public class InvoiceTriggerHandler {
    public static void changeOrderStatus(list<ivydsd__Invoice__c> invlist){
        set<id> ordid= new set<id>();
        for(ivydsd__Invoice__c inv:invlist){
            if(inv.ivydsd__Order__c!=null){
                ordid.add(inv.ivydsd__Order__c);
            }
        }
        list<ivydsd__Order__c> updateorderlist= new list<ivydsd__Order__c>();
        list<ivydsd__Order__c> orderList = [select id,name,ivydsd__Order_Status__c from ivydsd__Order__c where Id IN:ordid];
        for(ivydsd__Order__c ord:orderList){
            ord.ivydsd__Order_Status__c='Invoiced';
            updateorderlist.add(ord);
        }
        if(updateorderlist.size()>0){
            update updateorderlist;
        }
    } 
    // to update invoice resource and salon with order resource and salon 
    public static void updateresourceInvoice(list<ivydsd__Invoice__c> invlist){
        set<id> orderid= new set<id>();
        for(ivydsd__Invoice__c inv:invlist){
            if(inv.ivydsd__Order__c!=null){
               orderid.add(inv.ivydsd__Order__c); 
            }  
        }
       list<ivydsd__Order__c> orderlist=[select id,ivydsd__Resource__c,ivydsd__Store__c from ivydsd__Order__c where id IN:orderid ];
        map<id,id> OrderResourceMap =new map<id,id>();
        Map<Id,Id> orderSalonMap = new Map<id,id>();
        for(ivydsd__Order__c ord:orderlist ){
          OrderResourceMap.put(ord.id,ord.ivydsd__Resource__c);  
            orderSalonMap.put(ord.id, ord.ivydsd__Store__c);
        }
        
        for(ivydsd__Invoice__c inv:invlist){
            if(OrderResourceMap!=null && OrderResourceMap.containskey(inv.ivydsd__Order__c) && OrderResourceMap.get(inv.ivydsd__Order__c)!=null){
            inv.ivydsd__Resource__c=OrderResourceMap.get(inv.ivydsd__Order__c);
                }
            if(orderSalonMap!=null && orderSalonMap.containskey(inv.ivydsd__Order__c) && orderSalonMap.get(inv.ivydsd__Order__c)!=null){
                inv.ivydsd__Store__c=orderSalonMap.get(inv.ivydsd__Order__c);
            }
        }
    }
    public static void createSkuSaloon(list<ivydsd__Invoice__c> invlist){
        set<id> invoiceid = new set<id>();
        for(ivydsd__Invoice__c inv:invlist){
            //if(inv.ivydsd__Invoice_Status__c=='Collected'){
                invoiceid.add(inv.id);
            //}
        }
        Set<Id> top20SkuProductIdSet = ProductGroupService.getAllProductBasedOnGroupRecordType('Top20sku');
        list<ivydsd__Invoice_Line_Item__c> InvLitem=new list<ivydsd__Invoice_Line_Item__c>();
        InvLitem=[select id,ivydsd__Product_Master1__c,ivydsd__Invoice__r.Market_ISO__c,ivydsd__Invoice__r.ivydsd__Resource__c,ivydsd__Product_Master1__r.ivybase__InternalId__c,ivydsd__Total_Amount__c,ivydsd__Invoice__c,ivydsd__Invoice__r.ivydsd__Invoice_Date__c,ivydsd__Invoice__r.ivydsd__Store__c,ivydsd__Invoice__r.ivydsd__Store__r.ivybase__Internal_Id__c
                  from ivydsd__Invoice_Line_Item__c 
                  where  ivydsd__Invoice__c IN:invoiceid ];
        
        system.debug('InvLitem'+InvLitem);
        list<SKU_SaloonSale__c> sksList= new list<SKU_SaloonSale__c>();
        for(ivydsd__Invoice_Line_Item__c IL:InvLitem){
                //creating a SKUSaloon Record
            SKU_SaloonSale__c sks= new SKU_SaloonSale__c();
            sks.Account__c=IL.ivydsd__Invoice__r.ivydsd__Store__c;
            sks.InvoiceDate__c=IL.ivydsd__Invoice__r.ivydsd__Invoice_Date__c;
            sks.SaleAmount__c=IL.ivydsd__Total_Amount__c;
            sks.Product_Master__c=IL.ivydsd__Product_Master1__c;
            sks.Product_Internal_Id__c=String.valueOf(IL.ivydsd__Product_Master1__r.ivybase__InternalId__c);
            sks.Account_Internal_Id__c=String.valueOf(IL.ivydsd__Invoice__r.ivydsd__Store__r.ivybase__Internal_Id__c);
            sks.Resource__c=String.valueOf(IL.ivydsd__Invoice__r.ivydsd__Resource__c);
            sks.Invoice_Line_Item__c=IL.id;
            sks.Market_ISO__c = IL.ivydsd__Invoice__r.Market_ISO__c;
            if(top20SkuProductIdSet.contains(IL.ivydsd__Product_Master1__c))
            {
              sks.IsTop20__c=true;  
            }
            sksList.add(sks);
            
        }
        if(sksList.size()>0){
           insert sksList; 
        }
    }
    //This method is used to handle the Status value become empty during the update
    public static void updateStatus(List<ivydsd__Invoice__c> invoiceList, Map<Id, ivydsd__Invoice__c> invoiceMap) {
        for(ivydsd__Invoice__c inv : invoiceList) {
            ivydsd__Invoice__c oldinv = invoiceMap != null && invoiceMap.containsKey(inv.Id) ? invoiceMap.get(inv.Id) : null;
            if(oldinv != null && oldinv.ivydsd__Invoice_Status__c != inv.ivydsd__Invoice_Status__c && String.isBlank(inv.ivydsd__Invoice_Status__c) == true) {
                inv.ivydsd__Invoice_Status__c = oldinv.ivydsd__Invoice_Status__c;
            }
        }
    }
}