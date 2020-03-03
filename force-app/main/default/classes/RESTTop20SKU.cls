@RestResource(UrlMapping='/v1/Top20SKU/Masters/')
global  class RESTTop20SKU {//with sharing
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getTop20skuMasterInfo(){
        RExAPIResponseDomain.ResponseInfo Top20Response = new RExAPIResponseDomain.ResponseInfo();
        Set<Id> retailerId = new Set<Id>();
        List<Account> allAccountForThisResource = AccountService.getAllRetailerMaster_List_for_Resource();
        for(Account a:allAccountForThisResource)
        {
            retailerId.add(a.id);
            system.debug('internal'+a.ivybase__Internal_Id__c);
        }
        system.debug('retailerId'+retailerId);
        system.debug('retailerId-size'+retailerId.size());
        Set<Id> top20SkuProductIdSet = ProductGroupService.getAllProductBasedOnGroupRecordType('Top20sku');
        system.debug('top20SkuProductIdSet'+top20SkuProductIdSet);

        Map<String,Map<String,Decimal>> mapForNetSales = Top20SKUService.get_NetSales_Top20_Product_Netsale_For_Retailer(retailerId,top20SkuProductIdSet);
        Map<String,Map<String,Decimal>> mapForYTDSales = Top20SKUService.get_YTD_Top20_Product_Netsale_For_Retailer(retailerId,top20SkuProductIdSet);
        Map<String,Map<String,Decimal>> mapForLYTDSales = Top20SKUService.get_LYTD_Top20_Product_Netsale_For_Retailer(retailerId,top20SkuProductIdSet);
        
        Top20Response=Top20SKUTranslator.objectToTop20ProductList(mapForNetSales,mapForYTDSales,mapForLYTDSales,null);

        return Top20Response;
    }
}