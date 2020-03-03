global class AverageStrikeRate_Batch implements Database.Batchable<AggregateResult> {
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        string query='select count(id) cnt,ivydsd__Resource__c rs from ivydsd__Order__c where ivydsd__Order_Date__c>='+mtdate+' AND ivydsd__Order_Date__c<= '+tdydate+' group by ivydsd__Resource__c';
        return new AggregateResultIterable(query);
    } 
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<AggregateResult> Ordersbyreprecs){ 
        system.debug('Ordersbyreprecs'+Ordersbyreprecs);
        
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(Ordersbyreprecs.size()>0){  
            for(AggregateResult agg:Ordersbyreprecs){
                if((id)agg.get('rs')!=null){
                    resIdValueMap.put((id)agg.get('rs'),(decimal)agg.get('cnt')); 
                    System.debug('resIdValueMap::'+resIdValueMap);
                }
            }
        }
        
        Date todayDate = date.Today();
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        system.debug('todayDate'+todayDate);
        system.debug('Monthtodate'+Monthtodate);//2018-09-01
        
        AggregateResult[] visitsbyreprecs =[select count(id) cnt,ivybase__Resource__c rs from ivybase__Visit__c where ivybase__Visit_Date__c>=:Monthtodate AND ivybase__Visit_Date__c<=:todayDate  AND ivybase__Status__c='Completed' group by ivybase__Resource__c];
        
        Map<id,decimal> visitresIdValueMap = new Map<id,decimal>();
        if(visitsbyreprecs.size()>0){  
            for(AggregateResult agg:visitsbyreprecs){
                if((id)agg.get('rs')!=null){
                    visitresIdValueMap.put((id)agg.get('rs'),(decimal)agg.get('cnt')); 
                    System.debug('visitresIdValueMap::'+visitresIdValueMap);
                }
            }
        }
        
        List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c,Month__c,Parameter_type__c from Target_Actual__c 
                                         where  Month__c=:date.today().month()
                                         AND Parameter_type__c='Average Strike rate'];
        
        system.debug('targets:: '+targets);
        
        for(Target_Actual__c targetactual:targets){
            decimal tarActual=0;
            if(resIdValueMap.keyset().contains(targetactual.Resource__c) && visitresIdValueMap.keyset().contains(targetactual.Resource__c) ){
                if(visitresIdValueMap.get(targetactual.Resource__c)!=null && resIdValueMap.get(targetactual.Resource__c)!=null ){
                    if(visitresIdValueMap.get(targetactual.Resource__c)!=0){
                        tarActual=(tarActual+(resIdValueMap.get(targetactual.Resource__c)/visitresIdValueMap.get(targetactual.Resource__c)))*100;
                    }
                    else{
                        tarActual=0;  
                    }
                    targetactual.Actual__c= tarActual.setScale(2) ; 
                }
                
            }
        }
        system.debug('targets'+targets);
        update targets;
    }
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('SalesTargetCalculation_SG') && vMapNameCustomSett.get('SalesTargetCalculation_SG').SwitchOff__c==false){
         SalesTargetCalculation_SG STSG= new SalesTargetCalculation_SG();
        database.executeBatch(STSG,1);  
        }
        
      /*  AdhocOrdersPerRepBatch Adhoc = new AdhocOrdersPerRepBatch(); 
        database.executebatch(Adhoc);*/
    }
}