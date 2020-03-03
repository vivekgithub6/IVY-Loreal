@RestResource(UrlMapping='/v1/LastVisitStock/Masters/')
global with sharing class RESTLastVisitStockManager {
    @httpGet
    global static RExAPIResponseDomain.ResponseInfo getLastVisitStockrecords(){

        RExAPIResponseDomain.ResponseInfo LastVisitStocResponce = new RExAPIResponseDomain.ResponseInfo();
        
        try{
            Id sellerId = ResourceService.getLoginSellerId();
            system.debug('sellerId'+sellerId);
            Map<String, Set<String>> hierarchyNamewithSetOfIdsMap = AccountService.getHierarchyIdsbysellerId_Map(sellerId);
            
            LastVisitStockService.LocationStockWrp locationRecords = LastVisitStockService.getLastVisitStock(hierarchyNamewithSetOfIdsMap);
            
             LastVisitStocResponce = LastVisitStockTranslator.objectToInvoiceLineItem(locationRecords,null);
            
        }catch(Exception ex){
            LastVisitStocResponce = LastVisitStockTranslator.objectToInvoiceLineItem(null,CommonUtility.mobileAppErrorCodesMap.get('INSUFFICIENT_PERMISSIONS'));    
        }
            
        return LastVisitStocResponce; 
    }

}