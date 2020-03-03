global class OrdersInSFABatch implements Database.Batchable<AggregateResult> {
    // The batch job starts
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        //ivybase__Visit_Date__c>='+mtdate+' AND ivybase__Visit_Date__c<='+tdydate+'
        string query='select count(id) cnt,SUM(ivydsd__Invoice_Amount__c) ordervalue,ivydsd__Resource__c from ivydsd__Invoice__c where ivydsd__Invoice_Date__c>='+mtdate+' AND ivydsd__Invoice_Date__c<='+tdydate+' group by ivydsd__Resource__c';
        return new AggregateResultIterable(query);
    } 
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<AggregateResult> OrdersSFA){ 
        system.debug('OrdersSFA'+OrdersSFA);
        List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c,Month__c,Parameter_type__c from Target_Actual__c 
                                         where  Month__c=:date.today().month()
                                         AND Parameter_type__c='Average Turnover Per Order'];
        System.debug('targets:: '+targets);
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(OrdersSFA.size()>0){  
            for(AggregateResult agg:OrdersSFA){
                if((id)agg.get('ivydsd__Resource__c')!=null){
                    if((decimal)agg.get('cnt')!=0 &&(decimal)agg.get('cnt')!=null ){
                        decimal ordvalue=(decimal)agg.get('ordervalue')/(decimal)agg.get('cnt');
                        resIdValueMap.put((id)agg.get('ivydsd__Resource__c'),ordvalue);   
                    } 
                }
            }
        }
        system.debug('resIdValueMap'+resIdValueMap);
        list<Target_Actual__c> updateactuals= new list<Target_Actual__c>();
        for(Target_Actual__c targetactual:targets){
            if(resIdValueMap.keyset().contains(targetactual.Resource__c)){
                if(resIdValueMap.get(targetactual.Resource__c)!=null){
                    system.debug('');
                 targetactual.Actual__c=((resIdValueMap.get(targetactual.Resource__c)).setScale(2));  
                    system.debug('actual'+targetactual.Actual__c);
                    //updateactuals.add(targetactual);
                }  
            }
            
        }
        system.debug('targets'+targets);
        update targets;
    }
    // The batch job finishes
    global void finish(Database.BatchableContext bc){ 
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('OrdersPerRepPerDayBatch') && vMapNameCustomSett.get('OrdersPerRepPerDayBatch').SwitchOff__c==false){
            OrdersPerRepPerDayBatch batch = new OrdersPerRepPerDayBatch();
            Database.executeBatch(batch);
        }
    }
}