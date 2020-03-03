@RestResource(urlMapping='/v1/P4invoiceHistory/Masters/')
global with sharing class RESTP4InvoiceMaster {
 @HttpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getOrderdetails() {
     RExAPIResponseDomain.MultipleResponseInfo response = new RExAPIResponseDomain.MultipleResponseInfo();
    response.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
   RExAPIResponseDomain.ResponseInfo invinfo = new RExAPIResponseDomain.ResponseInfo();
         RExAPIResponseDomain.ResponseInfo invdetail = new RExAPIResponseDomain.ResponseInfo();
        try{
            Map<id,List<ivydsd__Invoice__c>> invaccmap = InvoiceService.getinvoicebyinvDate();
            System.debug('invaccmap:: '+invaccmap);
            invinfo = invoiceTranslator.objectToinvoiceInfo(invaccmap,null);
            response.Tables.add(invinfo);
            //Adding invoice id to set for retrieving line item data
             Set<Id> invoiceIdSet = new Set<Id>();
            for(id acid : invaccmap.keyset()){
                if(invaccmap.get(acid)!=null){
                    for(ivydsd__Invoice__c inv:invaccmap.get(acid)){
                        invoiceIdSet.add(inv.Id);   
                    }
                }   
            }
            List<ivydsd__Invoice_Line_Item__c> invlitem=InvoiceLineItemService.getILIUsinginvoiceIdSet(invoiceIdSet);
           invdetail=invoiceTranslator.objectToInvoiceLineInfo(invlitem,null);
           response.Tables.add(invdetail); 
        }//try end
        catch(Exception ex){
            system.debug('exception'+ex.getMessage());
        }
        
    return response;
    }
}