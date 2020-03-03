@RestResource(UrlMapping='/v1/RtwWiseP4OrderAndStockMaster/Masters/')
global with sharing class RESTRtwWiseP4OrderAndStockMaster{

    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getRtrWiseP4OrderAndStockMasterInfo(){
        
        RExAPIResponseDomain.ResponseInfo Response = new RExAPIResponseDomain.ResponseInfo();
        
        try{
            
            
            Map<Id,String> invoiceIdandStoreMap = new Map<Id,String>();
            Set<Id> retailerIds = new Set<Id>();
            Map<Id,Map<Integer,Id>> retailerLast4Invoice = new Map<Id,Map<Integer,Id>>();
            List<ivydsd__Invoice__c> invoiceList = new List<ivydsd__Invoice__c>();
            List<ivydsd__Invoice_Line_Item__c > invoiceLineItemList = new List<ivydsd__Invoice_Line_Item__c >();
            List<Account> Retailerlist = AccountService.getAllRetailerMaster_List_for_Resource();
            System.debug('Retailerlist::'+Retailerlist);
            Set<Id> visitIds = new Set<Id>();
            for(Account acc : Retailerlist){
                retailerIds.add(acc.Id);
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
            system.debug('****retailerLast4Invoice'+retailerLast4Invoice);
            Response = invoiceTranslator.objectToInvoiceLineItemPast4Invoice(retailerLast4Invoice,invoiceLineItemList,null); 
            
        }catch (SecurityUtility.SFDCAccessControlException ex) {
    
            Response = invoiceTranslator.objectToInvoiceLineItemPast4Invoice(null,null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
       }  
       return Response;
   }
}