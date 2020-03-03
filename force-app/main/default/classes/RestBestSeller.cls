@RestResource(UrlMapping='/v1/BestSeller/Masters/')
global class RestBestSeller {
    @httpGet
    global static RExAPIResponseDomain.MultipleResponseInfo getBestSellerInfo(){
        RExAPIResponseDomain.MultipleResponseInfo BestSellerResponse = new RExAPIResponseDomain.MultipleResponseInfo();
        BestSellerResponse.Tables = new List<RExAPIResponseDomain.ResponseInfo>();
        RExAPIResponseDomain.ResponseInfo bestSeller = new RExAPIResponseDomain.ResponseInfo();
        map<decimal,list<BestsellerService.productwrap>> storePrdtqtyMap = BestsellerService.getBestSellingProducts();
         system.debug('STList'+storePrdtqtyMap);
         bestSeller=BestSellerTranslator.objectToBestSeller(storePrdtqtyMap,null);
         
         BestSellerResponse.Tables.add(bestSeller);
         return BestSellerResponse;
    }
}