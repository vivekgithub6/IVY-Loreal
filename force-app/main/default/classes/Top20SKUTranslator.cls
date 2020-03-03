public class Top20SKUTranslator {
    public static RExAPIResponseDomain.ResponseInfo objectToTop20ProductList(Map<String,Map<String,Decimal>> mapForNetSales,Map<String,Map<String,Decimal>> mapForYTDSales,Map<String,Map<String,Decimal>> mapForLYTDSales,string errorcode){
        RExAPIResponseDomain.ResponseInfo top20skuResponse = new RExAPIResponseDomain.ResponseInfo();
        top20skuResponse.Master='Top20ProductList';
        top20skuResponse.Field = new List<String>{'pid','RetailerId','NetSales','LYTD','YTD'};
            top20skuResponse.ErrorCode  = errorCode == null ? '0' : errorCode;
        top20skuResponse.Next = '0';
        system.debug('mapForLYTDSales'+mapForLYTDSales);
        system.debug('mapForYTDSales'+mapForYTDSales);
        system.debug('mapForNetSales'+mapForNetSales);
        
		Set<String> productIdSet = new Set<String>();
        Set<String> accountIdSet = new Set<String>();
        Map<String,Set<String>> accountAndProductIdSet = new Map<String,Set<String>>();
        for(String accId:mapForYTDSales.keyset())
        {
            if(mapForYTDSales.containsKey(accId)){
            for(String PId:mapForYTDSales.get(accId).keyset())
            {
             if(accountAndProductIdSet.containsKey(accId))
           	{
               accountAndProductIdSet.get(accId).add(PId);
           	}
                else
                {
                  Set<String> pset = new Set<String>();
                    pset.add(PId);
                    accountAndProductIdSet.put(accId,pset);
                }
            }
            }
           
        }
        for(String accId:mapForLYTDSales.keyset())
        {
            if(mapForLYTDSales.containsKey(accId)){
            for(String PId:mapForLYTDSales.get(accId).keyset())
            {
             if(accountAndProductIdSet.containsKey(accId))
           	{
               accountAndProductIdSet.get(accId).add(PId);
           	}
                else
                {
                  Set<String> pset = new Set<String>();
                    pset.add(PId);
                    accountAndProductIdSet.put(accId,pset);
                }
            }
            }
           
        }
        for(String accId:mapForNetSales.keyset())
        {
            if(mapForNetSales.containsKey(accId)){
            for(String PId:mapForNetSales.get(accId).keyset())
            {
             if(accountAndProductIdSet.containsKey(accId))
           	{
               accountAndProductIdSet.get(accId).add(PId);
           	}
                else
                {
                  Set<String> pset = new Set<String>();
                    pset.add(PId);
                    accountAndProductIdSet.put(accId,pset);
                }
            }
            }
        }
        
        //used to holding the list of Journey plan records.
        List<List<String>> top20Records = new List<List<String>>();
        if(accountAndProductIdSet.keySet().size()>0){
            
            for(String accId:accountAndProductIdSet.keySet())
            {
                if(accountAndProductIdSet.get(accId).size()>0){
                    for(String PId:accountAndProductIdSet.get(accId))
                    {
                        List<String> top20RecordsInfo = new List<String>();
                        top20RecordsInfo.add(PId);
                        top20RecordsInfo.add(accId);
                        //NetSales
                        if(mapForNetSales.ContainsKey(accId) && mapForNetSales.get(accId).ContainsKey(PId))
                        {
                            top20RecordsInfo.add(String.valueOf(mapForNetSales.get(accId).get(PId)));
                        }
                        else{
                            top20RecordsInfo.add('');  
                        }
                        //LYTD
                        if(mapForLYTDSales.ContainsKey(accId) && mapForLYTDSales.get(accId).ContainsKey(PId))
                        {
                            top20RecordsInfo.add(String.valueOf(mapForLYTDSales.get(accId).get(PId)));
                        }
                        else{
                            top20RecordsInfo.add('');  
                        }
                        //YTD
                        if(mapForYTDSales.ContainsKey(accId) && mapForYTDSales.get(accId).ContainsKey(PId))
                        {
                            top20RecordsInfo.add(String.valueOf(mapForYTDSales.get(accId).get(PId)));
                        }
                        else{
                            top20RecordsInfo.add('');  
                        }
                     top20Records.add(top20RecordsInfo);   
                    }
                }
            }
        }
    top20skuResponse.Data=top20Records;
    
    return top20skuResponse;
}
}