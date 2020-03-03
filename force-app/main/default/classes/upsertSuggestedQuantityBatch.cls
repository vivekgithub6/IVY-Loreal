global class upsertSuggestedQuantityBatch implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT Id FROM Account WHERE RecordType.Name=\'Retail Account\' AND ivybase__Active__c=\'Yes\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> accts) {
        
        System.debug(':::accts:::' + accts);
        
        if(accts != NULL && accts.size() > 0) {
            
            List<ivydsd__Suggested_Quantity__c> upsertSuggQtyList = new List<ivydsd__Suggested_Quantity__c>();
            Set<Id> productIds = new Set<Id>();
            Set<Id> storeIds = new Set<Id>();
            Set<Id> suggQuantityIds = new Set<Id>();
            Map<String, ivydsd__Suggested_Quantity__c> suggQuantityMap = new Map<String, ivydsd__Suggested_Quantity__c>();
            
            Map<String, Integer> orderCount = new Map<String, Integer>();
            Map<String, Decimal> totalOrderQtyCnt = new Map<String, Decimal>();
            
            
            //Begin RtrWiseP4OrderHistory Code
            Map<Id,String> invoiceIdandStoreMap = new Map<Id,String>();
            Set<Id> retailerIds = new Set<Id>();
            Map<Id,Map<Integer,Id>> retailerLast4Invoice = new Map<Id,Map<Integer,Id>>();
            List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
            Set<String> chkdup = new Set<String>();
            List<ivydsd__Invoice_Line_Item__c > invoiceLineItemList = new List<ivydsd__Invoice_Line_Item__c >();
            Map<Id,Set<Id>> RetailerproductWithPastQuantity = new Map<Id,Set<Id>>();
            Map<Id,Map<Id,Decimal>> invIdprodqtyMap = new Map<Id,Map<Id,Decimal>>();
            
            for(Account a:accts)
            {
                retailerIds.add(a.id);
            }
            //we will get only the last 4 invoice for the retailer , no filter on invoice status
            invoiceList = InvoiceService.getLast4invoiceByRetailerIds(retailerIds);
            system.debug('****invoiceList'+invoiceList);
            for(ivydsd__Invoice__c inv:invoiceList)
            {
                retailerLast4Invoice.put(inv.ivydsd__Store__c,new Map<Integer,Id>());
            }
            system.debug('retailerLast4Invoice'+retailerLast4Invoice);
            for(ivydsd__Invoice__c inv:invoiceList)
            {
                if(retailerLast4Invoice.containsKey(inv.ivydsd__Store__c) && retailerLast4Invoice.get(inv.ivydsd__Store__c).keyset().size()<4)
                {
                    Integer count = retailerLast4Invoice.get(inv.ivydsd__Store__c).keyset().size();
                    if(retailerLast4Invoice.get(inv.ivydsd__Store__c).keyset().size() == 0){
                        retailerLast4Invoice.get(inv.ivydsd__Store__c).put(1,inv.Id);
                    }else{
                        retailerLast4Invoice.get(inv.ivydsd__Store__c).put(count+1,inv.Id); 
                    }    
                }
                
            }
            for(ivydsd__Invoice__c inv :invoiceList)
            {
                invoiceIdandStoreMap.put(inv.id,String.valueOf(inv.ivydsd__Store__r.ivybase__Internal_Id__c));
            }
            
            invoiceLineItemList=InvoiceLineItemService.getILIUsinginvoiceIdSet(invoiceIdandStoreMap.keyset());
            
            //End RtrWiseP4OrderHistory
            
            if(invoiceLineItemList.size() > 0) {
                
                for(ivydsd__Invoice_Line_Item__c line : invoiceLineItemList) {
                    
                    productIds.add(line.ivydsd__Product_Master1__c);
                    storeIds.add(line.ivydsd__Invoice__r.ivydsd__Store__c);
                }
                
                if(productIds.size() > 0) {
                    for(ivydsd__Suggested_Quantity__c sq : [SELECT Id,ivydsd__Product__c,ivydsd__Retailer__c,ivydsd__Quantity__c FROM ivydsd__Suggested_Quantity__c WHERE ivydsd__Product__c IN :productIds AND ivydsd__Retailer__c IN :storeIds]) {
                        
                        suggQuantityMap.put(String.valueOf(sq.ivydsd__Product__c) + String.valueOf(sq.ivydsd__Retailer__c), sq);
                        suggQuantityIds.add(sq.Id);
                    }
                    
                    
                    for(ivydsd__Invoice_Line_Item__c invli : invoiceLineItemList){
                        if(invli.ivydsd__UOM_1_Quantity__c !=null){
                            if(invli.ivydsd__UOM_1_Quantity__c>0){
                                // productWithPastQuantity.add(invli.ivydsd__Product_Master1__c);
                                if(RetailerproductWithPastQuantity.containsKey(invli.ivydsd__Invoice__r.ivydsd__Store__c))
                                {
                                    RetailerproductWithPastQuantity.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).add(invli.ivydsd__Product_Master1__c);
                                }else
                                {
                                    Set<Id> productId = new Set<Id>();
                                    productId.add(invli.ivydsd__Product_Master1__c);
                                    RetailerproductWithPastQuantity.put(invli.ivydsd__Invoice__r.ivydsd__Store__c,productId); 
                                }
                            }
                            if(invIdprodqtyMap.containsKey(invli.ivydsd__Invoice__c))
                            {
                                if(invIdprodqtyMap.get(invli.ivydsd__Invoice__c).containsKey(invli.ivydsd__Product_Master1__c))
                                {
                                    Decimal exisitngQty = invIdprodqtyMap.get(invli.ivydsd__Invoice__c).get(invli.ivydsd__Product_Master1__c);
                                    invIdprodqtyMap.get(invli.ivydsd__Invoice__c).put(invli.ivydsd__Product_Master1__c,exisitngQty+invli.ivydsd__UOM_1_Quantity__c);
                                }else
                                {
                                    invIdprodqtyMap.get(invli.ivydsd__Invoice__c).put(invli.ivydsd__Product_Master1__c,invli.ivydsd__UOM_1_Quantity__c);       
                                }
                                
                            }else
                            {   Map<Id,Decimal> prodQty = new Map<Id,Decimal>();
                             prodQty.put(invli.ivydsd__Product_Master1__c,invli.ivydsd__UOM_1_Quantity__c);
                             invIdprodqtyMap.put(invli.ivydsd__Invoice__c,prodQty);
                            }
                        } 
                    } 
                    for(ivydsd__Invoice_Line_Item__c invli : invoiceLineItemList){
                        String key = String.valueOf(invli.ivydsd__Product_Master1__c) + String.valueOf(invli.ivydsd__Invoice__r.ivydsd__Store__c);
                        if(orderCount.get(key) == NULL) 
                        {
                            orderCount.put(key, 0);
                        }
                        if(totalOrderQtyCnt.get(key) == NULL)
                        {
                            totalOrderQtyCnt.put(key, 0);
                        }
                        if(!chkdup.contains(String.Valueof(invli.ivydsd__Invoice__r.ivydsd__Store__c)+String.Valueof(invli.ivydsd__Product_Master1__c))){
                            if(RetailerproductWithPastQuantity.containskey(invli.ivydsd__Invoice__r.ivydsd__Store__c)==true && RetailerproductWithPastQuantity.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).contains(invli.ivydsd__Product_Master1__c)){                    
                                String quantity ='';
                                if(retailerLast4Invoice.containskey(invli.ivydsd__Invoice__r.ivydsd__Store__c)){
                                    
                                    List<Integer> tempcountlist = new List<Integer>{1,2,3,4};
                                        
                                        for(Integer int1 : tempcountlist){
                                            
                                            if(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).containskey(int1) && invIdprodqtyMap.Containskey(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).get(int1)) &&
                                               
                                               invIdprodqtyMap.get(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).get(int1)).get(invli.ivydsd__Product_Master1__c) != null){
                                                   
                                                   
                                                   Decimal tempqty = invIdprodqtyMap.get(retailerLast4Invoice.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).get(int1)).get(invli.ivydsd__Product_Master1__c);
                                                   
                                                   quantity += String.ValueOf(tempqty);
                                               } else {
                                                   quantity += '0';
                                               }
                                            
                                            if(int1 != tempcountlist.size()){
                                                quantity += ',';
                                            }
                                        }
                                    
                                    chkdup.add(String.Valueof(invli.ivydsd__Invoice__r.ivydsd__Store__c)+String.Valueof(invli.ivydsd__Product_Master1__c));
                                    if(quantity!=null && String.isEmpty(quantity)==false)
                                    {
                                        system.debug('****quantity'+quantity);
                                        List<String> eachQuantity = quantity.split(',');
                                        for(String s:eachQuantity)
                                        {
                                            Decimal value=ConversionUtility.StringToDecimal(s);
                                            if(value!=null && value>0)
                                            {
                                                totalOrderQtyCnt.put(key, totalOrderQtyCnt.get(key) + value);
                                                orderCount.put(key, orderCount.get(key) + 1);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    
                    system.debug('****orderCount'+orderCount);
                    system.debug('****totalOrderQtyCnt'+totalOrderQtyCnt);
                    
                    for(ivydsd__Invoice_Line_Item__c invli : invoiceLineItemList){
                        if(invli.ivydsd__Product_Master1__c!=null && invli.ivydsd__Invoice__r.ivydsd__Store__c!=null){
                            if(RetailerproductWithPastQuantity.containskey(invli.ivydsd__Invoice__r.ivydsd__Store__c)==true && RetailerproductWithPastQuantity.get(invli.ivydsd__Invoice__r.ivydsd__Store__c).contains(invli.ivydsd__Product_Master1__c)){                    
                                String key = String.valueOf(invli.ivydsd__Product_Master1__c) + String.valueOf(invli.ivydsd__Invoice__r.ivydsd__Store__c);
                                ivydsd__Suggested_Quantity__c suggQuantity = suggQuantityMap.get(key) != NULL ? suggQuantityMap.get(key) : new ivydsd__Suggested_Quantity__c();
                                
                                if(suggQuantityMap.get(key) == NULL) {
                                    suggQuantity.ivydsd__Product__c = invli.ivydsd__Product_Master1__c;
                                    suggQuantity.ivydsd__Retailer__c = invli.ivydsd__Invoice__r.ivydsd__Store__c;
                                }
                                suggQuantity.ivydsd__Quantity__c = (totalOrderQtyCnt.get(key) != NULL && orderCount.get(key) != NULL && totalOrderQtyCnt.get(key) > 0 && orderCount.get(key) > 0) ? totalOrderQtyCnt.get(key)/orderCount.get(key) : 0;
                                suggQuantity.ivydsd__Quantity__c=Math.ceil(suggQuantity.ivydsd__Quantity__c);
                                if(!upsertSuggQtyList.contains(suggQuantity)){
                                    //system.debug('suggQuantity id'+suggQuantity+' is already in the list');
                                    upsertSuggQtyList.add(suggQuantity);
                                }
                                //upsertSuggQtyList.add(suggQuantity);
                            }
                        }
                    }
                }
            }
            
            
            
            
            List<ivydsd__Suggested_Quantity__c> deleteSOs = [SELECT Id FROM ivydsd__Suggested_Quantity__c WHERE ivydsd__Retailer__c IN :accts AND Id NOT IN :suggQuantityIds];
            
            System.debug(':::deleteSOs:::' + deleteSOs);
            System.debug(':::upsertSuggQtyList:::' + upsertSuggQtyList);
            
            if(deleteSOs.size() > 0) delete deleteSOs;
            if(upsertSuggQtyList.size() > 0) upsert upsertSuggQtyList;
            
            
        }
    }
    global void finish(Database.BatchableContext BC) {
        TurnOver_Batch tb= new TurnOver_Batch();
        database.executebatch(tb,1);
        
    }
}