@RestResource(UrlMapping='/v1/InvoiceMaster/Masters/*')
global with sharing class RESTInvoiceMaster{

    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getInvoiceMaster() {
        
        RExAPIResponseDomain.ResponseInfo Invoiceresponse = new RExAPIResponseDomain.ResponseInfo();
        
        try{
             
             Set<Id> retailIds = new Set<Id>();
             List<Account> Retailerlist = AccountService.getAllRetailerMaster_List_for_Resource();
             
             for(Account a : Retailerlist){
                 retailIds.add(a.Id);
             }
             
             Set<Id> invoiceids =  PicklistService.getInvoicesByResourceId();
            
             List<ivydsd__Invoice__c> Invoicelist = InvoiceService.getinvoiceByRetailerIds(retailIds,invoiceids);
             Invoiceresponse = InvoiceTranslator.objectToINVInfo(Invoicelist,null);
        
         } catch(SecurityUtility.SFDCAccessControlException ex) {
    
            Invoiceresponse = InvoiceTranslator.objectToINVInfo(null, CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));
            
        }
        return Invoiceresponse;
    }
}