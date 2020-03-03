global class AverageTurnoverPerRepBatch implements Database.Batchable<AggregateResult> {
    // The batch job starts
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        string query='Select sum(SaleAmount__c)amt,Product_Master__r.Division__c pdiv from SKU_SaloonSale__c where Product_Master__r.Division__c!=null AND InvoiceDate__c=today group by Product_Master__r.Division__c';
        return new AggregateResultIterable(query);
    } 
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<AggregateResult> AverageTurnOverPerRep){ 
      /*  List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c from Target_Actual__c 
                                         where  Month__c=:date.today().month()
                                         AND Parameter_type__c='Average Turnover per Rep'];
        System.debug('targets:: '+targets);
        
        Map<id,decimal> divIdValueMap = new Map<id,decimal>();
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        Map<id,decimal> DivResourceeMap = new Map<id,decimal>();
        if(AverageTurnOverPerRep.size()>0){  
            for(AggregateResult agg:AverageTurnOverPerRep){
                if((id)agg.get('pdiv')!=null){
                    divIdValueMap.put((id)agg.get('pdiv'),(decimal)agg.get('amt'));    
                }
            }
        }
        list<DivisionLocation__c> divlocation= [select Division__c,Location_Hierarchy__r.ivybase__Primary_Resource__c from DivisionLocation__c where Division__c IN:divIdValueMap.keyset()];
        
        AggregateResult[]  Aggdivlocation= [select Division__c,count(Location_Hierarchy__c) cnt from DivisionLocation__c where Division__c IN:divIdValueMap.keyset() group by division__c];
        for(AggregateResult ag:Aggdivlocation)
            DivResourceeMap.put((id)ag.get('Division__c'),divIdValueMap.get((id)ag.get('Division__c'))/(Decimal)ag.get('cnt'));
        
        for(DivisionLocation__c divresource:divlocation)
            resIdValueMap.put(divresource.Location_Hierarchy__r.ivybase__Primary_Resource__c,divIdValueMap.get(divresource.Division__c));
        
        for(Target_Actual__c targetactual:targets){
            System.debug('resIdValueMap.get(targetactual.Resource__c)::'+resIdValueMap.get(targetactual.Resource__c));
            if(resIdValueMap.keyset().contains(targetactual.Resource__c) && resIdValueMap.get(targetactual.Resource__c) != null){
                targetactual.Actual__c= ((resIdValueMap.get(targetactual.Resource__c)).setScale(2));
            }
        }
        update targets;*/
    }
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('AverageTurnOverPerClientBatch') && vMapNameCustomSett.get('AverageTurnOverPerClientBatch').SwitchOff__c==false){
          AverageTurnOverPerClientBatch batch = new AverageTurnOverPerClientBatch();
        Database.executeBatch(batch); 
        }
        
    }
}