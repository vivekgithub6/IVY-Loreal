global class QuantityBatchClass implements Database.Batchable<sObject>{
    global String query;
    global Id resId = ResourceService.getLoginSellerId();
    DateTime TDate = System.now();
    Date todayDate = Date.newinstance(TDate.year(), TDate.month(), TDate.day());
    date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
    Integer month = date.Today().month();
    Integer year= date.Today().year();
    global Database.QueryLocator start(Database.BatchableContext BC){
        string query='Select Resource__c,Actual__c,Product_Hierarchy__c,Year__c from Target_Actual__c  where Resource__c!=null AND Product_Hierarchy__c != null AND Month__c ='+ month +' AND Year__c ='+year+' and Recordtype.developername=\'Quantity\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<Target_Actual__c> scope){
        System.debug('execute method::'+scope);
        List<Target_Actual__c> updatedTargets = new List<Target_Actual__c>();
        Set<Id> BrandIds = new Set<Id>();
        Set<Id> SKUIds = new Set<Id>();
        Map<String,Decimal> skuQuantity = new Map<String,Decimal>();
        map<string,Decimal> TargetResourceMap=new map<string,Decimal>();
        map<string,Decimal> TargetResourceBrandMap=new map<string,Decimal>();
        Date todayDate1 = date.Today();
        string tdydate1=string.valueOf(todayDate);//'2018-10-31';
        Date Monthtodate1=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        
        System.debug('System.today()::: '+System.today());
        try{
            AggregateResult[]  SKUSaloons = [Select Product_Master__c,Resource__c,SUM(Quantity__c) sum from SKU_SaloonSale__c 
                                             where Resource__c!=null AND Quantity__c!=null
                                             AND CreatedDate =today AND InvoiceDate__c >=:Monthtodate1 AND InvoiceDate__c <=:todayDate1
                                             Group By Resource__c,Product_Master__c];
            System.debug('SKUSaloons:: '+SKUSaloons);
            for(AggregateResult SKUSaloon : SKUSaloons){
                SKUIds.add((String)SKUSaloon.get('Product_Master__c'));
                if(skuQuantity.containskey((String)SKUSaloon.get('Product_Master__c')) && skuQuantity.get((String)SKUSaloon.get('Product_Master__c'))!=null){
                    decimal sum=skuQuantity.get((String)SKUSaloon.get('Product_Master__c')) + (Decimal)SKUSaloon.get('sum');
                    skuQuantity.put((String)SKUSaloon.get('Product_Master__c'),sum); 
                }else{
                    skuQuantity.put((String)SKUSaloon.get('Product_Master__c'),(Decimal)SKUSaloon.get('sum'));
                }
                if(TargetResourceMap.containskey((String)SKUSaloon.get('Resource__c')+'.'+(String)SKUSaloon.get('Product_Master__c')) && TargetResourceMap.get((String)SKUSaloon.get('Resource__c')+'.'+(String)SKUSaloon.get('Product_Master__c'))!=null){
                    decimal sum=TargetResourceMap.get((String)SKUSaloon.get('Resource__c')+'.'+(String)SKUSaloon.get('Product_Master__c'))+(Decimal)SKUSaloon.get('sum');
                    TargetResourceMap.put((String)SKUSaloon.get('Resource__c')+'.'+(String)SKUSaloon.get('Product_Master__c'),sum);
                }else{
                    TargetResourceMap.put((String)SKUSaloon.get('Resource__c')+'.'+(String)SKUSaloon.get('Product_Master__c'),(Decimal)SKUSaloon.get('sum'));
                }
                system.debug('TargetResourceMap1'+TargetResourceMap);
            }
            system.debug('TargetResourceMap'+TargetResourceMap);
            system.debug('SKUIds'+SKUIds);
            map<string,string> SKUBrandMap=  ProductHierarchyService.getAllProductHierarchy_MAP_For_The_SKU(SKUIds, 'brand');
            system.debug('SKUBrandMap'+SKUBrandMap);
            for(string s:TargetResourceMap.keyset()){
                string resid=s.split('\\.')[0];
                string SKUid=s.split('\\.')[1];
                system.debug('TargetResourceBrandMap'+TargetResourceBrandMap);
                if(!TargetResourceBrandMap.containskey(resid+'.'+SKUBrandMap.get(SKUid)) )
                    TargetResourceBrandMap.put(resid+'.'+SKUBrandMap.get(SKUid),TargetResourceMap.get(s)) ;
                else{
                    system.debug('SKUBrandMap.get(SKUid)'+SKUBrandMap.get(SKUid));
                    system.debug('TargetResourceBrandMap'+TargetResourceBrandMap.get(resid+'.'+SKUBrandMap.get(SKUid)));
                    TargetResourceBrandMap.put(resid+'.'+SKUBrandMap.get(SKUid),TargetResourceMap.get(s)+TargetResourceBrandMap.get(resid+'.'+SKUBrandMap.get(SKUid))) ;
                }
            }
            System.debug('skuQuantity::: '+skuQuantity);
            for(Target_Actual__c target : scope){
                target.Actual__c=0;
                if(target.Actual__c == null || target.Actual__c ==0)
                    target.Actual__c = TargetResourceBrandMap.get((target.Resource__c+'.'+target.Product_Hierarchy__c)); 
                else if(skuQuantity.get(target.Product_Hierarchy__c) != null)
                    target.Actual__c = target.Actual__c + TargetResourceBrandMap.get((target.Resource__c+'.'+target.Product_Hierarchy__c));
                updatedTargets.add(target);
            }
            System.debug('updatedTargets::: '+updatedTargets);
            update updatedTargets;
        }
        Catch(Exception e){
            system.debug('erro'+e.getMessage()+'-'+e.getLineNumber());
        }
    }
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('SalesTargetCalculatingBatch') && vMapNameCustomSett.get('SalesTargetCalculatingBatch').SwitchOff__c==false){
            
            SalesTargetCalculatingBatch batch = new SalesTargetCalculatingBatch();
            Database.executeBatch(batch);
        }
        
    }
    
}