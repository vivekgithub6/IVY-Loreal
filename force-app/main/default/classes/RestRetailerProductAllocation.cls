@RestResource(UrlMapping='/v1/RetailerProductAllocation/Masters/')
global with sharing class RestRetailerProductAllocation {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo RetailerProductAllocationMasterInfo(){
        RExAPIResponseDomain.ResponseInfo RetailerProductResponse = new RExAPIResponseDomain.ResponseInfo();
        Set<Id> retailerId = new Set<Id>();
        List<Account> allAccountForThisResource = AccountService.getAllRetailerMaster_List_for_Resource();
        
        for(Account a:allAccountForThisResource)
        {
            retailerId.add(a.id);
            system.debug('internal'+a.ivybase__Internal_Id__c);
        }
        system.debug('retailerId'+retailerId);
        
        List<RetailerProductAllocation__c> retailerProduct = RetailerProductAllocationService.get_product_Allocation(retailerId);
        System.debug('++++' + retailerProduct.size());
        
        RetailerProductResponse=RetailerProductAllocationTranslator.objectToRetailerProductAllocation(retailerProduct,null);

        return RetailerProductResponse;
    }
}