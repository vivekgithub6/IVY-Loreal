public class InvoiceLineItemTriggerHandler {
    public static void createskusaloon(list<ivydsd__Invoice_Line_Item__c> ILitemsList){
        Set<Id> invoice_line_item_id = new Set<Id>();
        if(ILitemsList.size()>0){
            for(ivydsd__Invoice_Line_Item__c iL:ILitemsList){
                invoice_line_item_id.add(iL.id);
            }
        }
        Set<Id> top20SkuProductIdSet = ProductGroupService.getAllProductBasedOnGroupRecordType('Top20sku');
        
       list<ivydsd__Invoice_Line_Item__c> InvLitem=new list<ivydsd__Invoice_Line_Item__c>();
        InvLitem=[select id,ivydsd__Product_Master1__c,ivydsd__Product_Master1__r.Division__c,ivydsd__Product_Master1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c,ivydsd__UOM_1_Quantity__c,ivydsd__Invoice__r.Market_ISO__c,ivydsd__Invoice__r.ivydsd__Resource__c,ivydsd__Product_Master1__r.ivybase__InternalId__c,ivydsd__Total_Amount__c,ivydsd__Invoice__c,ivydsd__Invoice__r.ivydsd__Invoice_Date__c,ivydsd__Invoice__r.ivydsd__Store__c,ivydsd__Invoice__r.ivydsd__Store__r.ivybase__Internal_Id__c
                  from ivydsd__Invoice_Line_Item__c 
                  where id IN: invoice_line_item_id];
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
            sks.Quantity__c=IL.ivydsd__UOM_1_Quantity__c;
            sks.Market_ISO__c = IL.ivydsd__Invoice__r.Market_ISO__c;
            sks.division__c=IL.ivydsd__Product_Master1__r.Division__c;
          if(IL.ivydsd__Product_Master1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c!=null)
            sks.Product_Hierarchy__c=IL.ivydsd__Product_Master1__r.ivybase__Parent__r.ivybase__Parent__r.ivybase__Parent__c;
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
    
    public static void updateSkuSaloon(list<ivydsd__Invoice_Line_Item__c> ILitemsList){
    
        Set<Id> invoiceLineItemIdSet = new Set<Id>();
        Map<Id,Decimal> invoiceLineItemIdAmtMap = new Map<Id,Decimal>();
        Map<Id,Decimal> invoiceLineItemIdQtyMap = new Map<Id,Decimal>();
        
        if(ILitemsList.size()>0){
        
            for(ivydsd__Invoice_Line_Item__c iL:ILitemsList){
            
                invoiceLineItemIdSet.add(iL.id);
                invoiceLineItemIdAmtMap.put(iL.id, iL.ivydsd__Total_Amount__c);
                invoiceLineItemIdQtyMap.put(iL.id, iL.ivydsd__UOM_1_Quantity__c);
            }
        }
        
        list<SKU_SaloonSale__c> saloonsaleList= [SELECT Id,Invoice_Line_Item__c,SaleAmount__c 
                                          FROM SKU_SaloonSale__c 
                                          WHERE Invoice_Line_Item__c IN : invoiceLineItemIdSet];
        
        if(saloonsaleList.size()>0) {      
                                    
            for(SKU_SaloonSale__c saloonsale : saloonsaleList){
                
                if(invoiceLineItemIdAmtMap != null && invoiceLineItemIdAmtMap.isEmpty() == False 
                   && invoiceLineItemIdAmtMap.containsKey(saloonsale.Invoice_Line_Item__c)) {
                   
                    saloonsale.SaleAmount__c = invoiceLineItemIdAmtMap.get(saloonsale.Invoice_Line_Item__c);
                }
                if(invoiceLineItemIdQtyMap != null && invoiceLineItemIdQtyMap.isEmpty() == False 
                   && invoiceLineItemIdQtyMap.containsKey(saloonsale.Invoice_Line_Item__c)) {
                   
                    saloonsale.Quantity__c = invoiceLineItemIdQtyMap.get(saloonsale.Invoice_Line_Item__c);
                }
            }
            update saloonsaleList;
        }
    }
}