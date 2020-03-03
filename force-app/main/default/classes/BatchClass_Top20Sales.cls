global class BatchClass_Top20Sales  implements Database.Batchable<Id> {
    
    global Iterable<Id> start(Database.BatchableContext BC){
        Set<Id> top20SkuProductIdSet = ProductGroupService.getAllProductBasedOnGroupRecordType('Top20sku');
        system.debug('top20SkuProductIdSet'+top20SkuProductIdSet);
        List<Id> top20ProductId = new List<Id>();
        top20ProductId.addAll(top20SkuProductIdSet);
        return top20ProductId;
    }
    
    global void execute(Database.BatchableContext BC, List<Id> top20ProductId){
        system.debug('Hi');
        try{
            
            Map<Id,Map<Id,Decimal>> mapForNetSales = new Map<Id,Map<Id,Decimal>>();
            Map<Id,Map<Id,Decimal>> mapForYTDSales = new Map<Id,Map<Id,Decimal>>();
            Map<Id,Map<Id,Decimal>> mapForLYTDSales = new Map<Id,Map<Id,Decimal>>();
            Date todayDate = date.Today();
            Date ThisYearStart = Date.newInstance(todayDate.year(),1,1);
            Date LastYearStart = Date.newInstance(todayDate.year()-1,1,1);
            Date LastYearToday = Date.newInstance(todayDate.year()-1,todayDate.month(),todayDate.day());
            //netSales
            AggregateResult[] groupedResults = [select Product_Master__c,
                                                sum(SaleAmount__c),
                                                Account__c  
                                                from SKU_SaloonSale__c
                                                where InvoiceDate__c >=: LastYearStart
                                                and InvoiceDate__c <: ThisYearStart
                                                and Product_Master__c=:top20ProductId
                                                group by Product_Master__c,Account__c];
            system.debug('groupedResults'+groupedResults);
            
            for (AggregateResult ar : groupedResults)  {
                if(mapForNetSales.containsKey((Id)ar.get('Account__c')))
                {
                    
                    mapForNetSales.get((Id)ar.get('Account__c')).put((Id)ar.get('Product_Master__c'),(Decimal)ar.get('expr0'));
                }
                else
                {
                    Map<Id,Decimal> productWithValue = new Map<Id,Decimal>();
                    productWithValue.put((Id)ar.get('Product_Master__c'),(Decimal)ar.get('expr0'));
                    mapForNetSales.put((Id)ar.get('Account__c'),productWithValue);
                }
                
            }
            
            //YTD
            groupedResults = [select Account__c,
                              sum(SaleAmount__c),
                              Product_Master__c  
                              from SKU_SaloonSale__c 
                              where InvoiceDate__c >=: ThisYearStart
                              and InvoiceDate__c <=: todayDate
                              and Product_Master__c=:top20ProductId
                              group by Account__c,Product_Master__c];
            
            system.debug('groupedResults'+groupedResults);
            for (AggregateResult ar : groupedResults)  {
                if(mapForYTDSales.containsKey((Id)ar.get('Account__c')))
                {
                    
                    mapForYTDSales.get((Id)ar.get('Account__c')).put((Id)ar.get('Product_Master__c'),(Decimal)ar.get('expr0'));
                }
                else
                {
                    Map<Id,Decimal> productWithValue = new Map<Id,Decimal>();
                    productWithValue.put((Id)ar.get('Product_Master__c'),(Decimal)ar.get('expr0'));
                    mapForYTDSales.put((Id)ar.get('Account__c'),productWithValue);
                }
                
            }
            //LYTD
            groupedResults = [select Account__c,
                              sum(SaleAmount__c),
                              Product_Master__c 
                              from SKU_SaloonSale__c 
                              where InvoiceDate__c >=: LastYearStart
                              and InvoiceDate__c <=: LastYearToday
                              and Product_Master__c=:top20ProductId
                              group by Account__c,Product_Master__c];
            
            system.debug('groupedResults'+groupedResults);
            for (AggregateResult ar : groupedResults)  {
                if(mapForLYTDSales.containsKey((Id)ar.get('Account__c')))
                {
                    
                    mapForLYTDSales.get((Id)ar.get('Account__c')).put((Id)ar.get('Product_Master__c'),(Decimal)ar.get('expr0'));
                }
                else
                {
                    Map<Id,Decimal> productWithValue = new Map<Id,Decimal>();
                    productWithValue.put((Id)ar.get('Product_Master__c'),(Decimal)ar.get('expr0'));
                    mapForLYTDSales.put((Id)ar.get('Account__c'),productWithValue);
                }             
            }
            
            Set<Id> productIdSet = new Set<Id>();
            Set<Id> accountIdSet = new Set<Id>();
            Map<Id,Set<Id>> accountAndProductIdSet = new Map<Id,Set<Id>>();
            for(Id accId:mapForYTDSales.keyset())
            {
                for(Id PId:mapForYTDSales.get(accId).keyset())
                {
                    if(accountAndProductIdSet.containsKey(accId))
                    {
                        accountAndProductIdSet.get(accId).add(PId);
                    }
                    else
                    {
                        Set<Id> pset = new Set<Id>();
                        pset.add(PId);
                        accountAndProductIdSet.put(accId,pset);
                    }
                }
                
            }
            for(Id accId:mapForLYTDSales.keyset())
            {
                for(Id PId:mapForLYTDSales.get(accId).keyset())
                {
                    if(accountAndProductIdSet.containsKey(accId))
                    {
                        accountAndProductIdSet.get(accId).add(PId);
                    }
                    else
                    {
                        Set<Id> pset = new Set<Id>();
                        pset.add(PId);
                        accountAndProductIdSet.put(accId,pset);
                    }
                }
                
            }
            for(Id accId:mapForNetSales.keyset())
            {
                for(Id PId:mapForNetSales.get(accId).keyset())
                {
                    if(accountAndProductIdSet.containsKey(accId))
                    {
                        accountAndProductIdSet.get(accId).add(PId);
                    }
                    else
                    {
                        Set<Id> pset = new Set<Id>();
                        pset.add(PId);
                        accountAndProductIdSet.put(accId,pset);
                    }
                }
                
            }
            system.debug('accountAndProductIdSet'+accountAndProductIdSet);
            List<Top20Account__c> top20AccountToInsert = new List<Top20Account__c>(); 
            Map<Id,Top20Account__c> Top20account =new Map<Id,Top20Account__c>([select Id,Name,Account__c from Top20Account__c]);
            Map<Id,Id> AccountVsTop20Id = new Map<Id,Id>();
            Set<Id> AccountIdPresent = new Set<Id>();
            for(Id top20Acc:Top20account.keySet())
            {
                AccountIdPresent.add(Top20account.get(top20Acc).Account__c);
                AccountVsTop20Id.put(Top20account.get(top20Acc).Account__c,top20Acc);
            }
            for(Id accId:accountAndProductIdSet.keySet())
            {
                if(!AccountVsTop20Id.containsKey(accId))
                {
                    Top20Account__c newTop20Account = new Top20Account__c(Account__c=accId);
                    top20AccountToInsert.add(newTop20Account);
                }
            }
            if(top20AccountToInsert.size()>0)
            {
                insert  top20AccountToInsert;
                for(Top20Account__c t:top20AccountToInsert)
                {
                    Top20account.put(t.id,t);
                    AccountVsTop20Id.put(t.Account__c,t.id);
                }
            }
            system.debug('Top20account'+Top20account);
                        system.debug('AccountVsTop20Id'+AccountVsTop20Id);
            Map<Id,Set<Id>> accountAndProductIdSetPresent = new Map<Id,Set<Id>>();
            Map<Id,Map<Id,Id>> acc_Product_TopId = new Map<Id,Map<Id,Id>>();
            Map<Id,Top20ProductDetail__c> top20ProductDetail = new Map<Id,Top20ProductDetail__c>([select id,name,Top20Account__c,Top20Account__r.Account__c,Product_Master__c,LastYearNetSales__c,YTD__c,LYTD__c from Top20ProductDetail__c where Top20Account__c=:Top20account.keySet()]);
            system.debug('top20ProductDetail'+top20ProductDetail);
            for(Id t:top20ProductDetail.keySet())
            {
                if(acc_Product_TopId.containsKey(top20ProductDetail.get(t).Top20Account__r.Account__c))
                {
                    acc_Product_TopId.get(top20ProductDetail.get(t).Top20Account__r.Account__c).put(top20ProductDetail.get(t).Product_Master__c,t);
                }
                else
                {
                    
                    Map<Id,Id> ProductVsTop20DetailId = new Map<Id,Id>();
                    ProductVsTop20DetailId.put(top20ProductDetail.get(t).Product_Master__c, t);
                    acc_Product_TopId.put(top20ProductDetail.get(t).Top20Account__r.Account__c,ProductVsTop20DetailId);
                    
                }
            }
            system.debug('acc_Product_TopId'+acc_Product_TopId);
            List<Top20ProductDetail__c> ListToUpdateProductDetail = new List<Top20ProductDetail__c>();
            Set<Id> ProductDetailIdUpdated = new Set<Id>();
            List<Top20ProductDetail__c> ListToInsertProductDetail = new List<Top20ProductDetail__c>();
            if(accountAndProductIdSet.keySet().size()>0){
                
                for(Id accId:accountAndProductIdSet.keySet())
                {
                    if(accountAndProductIdSet.get(accId).size()>0){
                        for(Id PId:accountAndProductIdSet.get(accId))
                        {  boolean boolToInsert=false;
                            if(acc_Product_TopId.containsKey(accId))
                            {
                                if(acc_Product_TopId.get(accId).containsKey(PId))
                                {
                                    if(top20ProductDetail.containsKey(acc_Product_TopId.get(accId).get(PId)))
                                    {
                                        ProductDetailIdUpdated.add(acc_Product_TopId.get(accId).get(PId));
                                        Top20ProductDetail__c  toUpdate= top20ProductDetail.get(acc_Product_TopId.get(accId).get(PId));
                                        if(mapForNetSales.containsKey(accId) && mapForNetSales.get(accId).containsKey(PId))
                                        {
                                            toUpdate.LastYearNetSales__c=mapForNetSales.get(accId).get(PId);
                                        }
                                        if(mapForLYTDSales.containsKey(accId) && mapForLYTDSales.get(accId).containsKey(PId))
                                        {
                                            toUpdate.LYTD__c=mapForLYTDSales.get(accId).get(PId);
                                        }
                                        if(mapForYTDSales.containsKey(accId) && mapForYTDSales.get(accId).containsKey(PId))
                                        {
                                            toUpdate.YTD__c=mapForYTDSales.get(accId).get(PId);
                                        }
                                        ListToUpdateProductDetail.add(toUpdate);
                                    }
                                    else{
                                        boolToInsert=true;
                                        system.debug('top20ProductDetail not there accid'+accId+'PId'+PId);
                                    }
                            	}
                                else
                                {
                                    boolToInsert=true;
			                        system.debug('acc_Product_TopId not there product  accid'+accId+'PId'+PId);
                                }
                            }
                            else{
                                  boolToInsert=True;     
                                   system.debug('acc_Product_TopId  no account accid'+accId+'PId'+PId);
                                }
                         if(boolToInsert==True)
                         {
                             Top20ProductDetail__c  toInsert= new Top20ProductDetail__c();
                                    if(AccountVsTop20Id.containsKey(accId))
                                    {
                                        toInsert.Top20Account__c=AccountVsTop20Id.get(accId);
                                    }
                                    toInsert.Product_Master__c=PId;
                                    if(mapForNetSales.containsKey(accId) && mapForNetSales.get(accId).containsKey(PId))
                                    {
                                        toInsert.LastYearNetSales__c=mapForNetSales.get(accId).get(PId);
                                    }
                                    if(mapForLYTDSales.containsKey(accId) && mapForLYTDSales.get(accId).containsKey(PId))
                                    {
                                        toInsert.LYTD__c=mapForLYTDSales.get(accId).get(PId);
                                    }
                                    if(mapForYTDSales.containsKey(accId) && mapForYTDSales.get(accId).containsKey(PId))
                                    {
                                        toInsert.YTD__c=mapForYTDSales.get(accId).get(PId);
                                    }
                                    ListToInsertProductDetail.add(toInsert); 
                         }
                        }
                    }
                }
            }
            system.debug('ProductDetailIdUpdated'+ProductDetailIdUpdated);
            Set<Id> ProductDetailToDelete = top20ProductDetail.keySet();
		    system.debug('ProductDetailToDelete'+ProductDetailToDelete);
            ProductDetailToDelete.removeAll(ProductDetailIdUpdated);
            system.debug('ProductDetailToDelete'+ProductDetailToDelete);
            List<Top20ProductDetail__c> ListToDeleteProductDetail = new List<Top20ProductDetail__c>();
            for(Id del:ProductDetailToDelete)
            {
            	if(top20ProductDetail.containsKey(del))
                {
                    ListToDeleteProductDetail.add(top20ProductDetail.get(del));
                }
            }
                        system.debug('ListToDeleteProductDetail'+ListToDeleteProductDetail);
                                    system.debug('ListToUpdateProductDetail'+ListToUpdateProductDetail);
                                                system.debug('ListToInsertProductDetail'+ListToInsertProductDetail);
            if(ListToDeleteProductDetail.size()>0)
            {
                delete ListToDeleteProductDetail;
            }
            if(ListToUpdateProductDetail.size()>0)
            {
				update  ListToUpdateProductDetail;               
            }
            if(ListToInsertProductDetail.size()>0)
            {
                insert ListToInsertProductDetail;
            }
           
            
            
            
            
            
            
            
            
        }
        Catch(Exception e){
            system.debug('errormessage'+e.getMessage());
        }
    }
    
    global void finish(Database.BatchableContext BC){
    }
}