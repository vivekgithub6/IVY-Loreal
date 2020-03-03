public class BestSellerTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToBestSeller(map<decimal,list<BestsellerService.productwrap>>  BestsellerPrdMap,string errorcode){
        RExAPIResponseDomain.ResponseInfo BestSellerResponse = new RExAPIResponseDomain.ResponseInfo();
        BestSellerResponse.Master='ProductBestSeller';
        BestSellerResponse.Field = new List<String>{'Pid','Rid'};
            BestSellerResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        BestSellerResponse.Next = '0';
        
        List<List<String>> bestSellerRecords = new List<List<String>>();
        system.debug('Test Exc'+BestsellerPrdMap);
        if(BestsellerPrdMap !=Null){
            //iterating the list of records which are passing from service class
            system.debug('Test Exc'+BestsellerPrdMap);
            map<string,Decimal> AccPrdidmap=new map<String,Decimal>();
            for(Decimal rid :BestsellerPrdMap.keyset() ){
                for(BestsellerService.productwrap prdwp:BestsellerPrdMap.get(rid)){    
                    AccPrdidmap.put(string.valueOf(prdwp.productid)+','+string.valueOf(rid),rid);
                }
            }
            system.debug('AccPrdidmap.keyset()'+AccPrdidmap.keyset());
            for(string pid :AccPrdidmap.keyset()){
                List<String> bstSlr= new List<String>();
                string[] prodid=pid.split(',');
                //adding pid
                if(pid!=null){
                    bstSlr.add(prodid[0]);
                }else{
                    bstSlr.add('');
                }
                //adding rid
                if(pid!=null && AccPrdidmap.containskey(pid) && AccPrdidmap.get(pid)!=null){
                    bstSlr.add(string.valueof((AccPrdidmap.get(pid))));
                }else {
                    bstSlr.add(''); 
                }
                bestSellerRecords.add(bstSlr);  
                
            }   
        }
        BestSellerResponse.Data=bestSellerRecords;
        return BestSellerResponse;
    }
}