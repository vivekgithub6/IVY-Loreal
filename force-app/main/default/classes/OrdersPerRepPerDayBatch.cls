global class OrdersPerRepPerDayBatch implements Database.Batchable<AggregateResult> {
  // The batch job starts
  global Iterable<AggregateResult> start(Database.BatchableContext bc){
       Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
   string query='select count(id) cnt,ivydsd__Resource__c rs from ivydsd__Order__c where ivydsd__Order_Date__c>='+mtdate+' AND ivydsd__Order_Date__c<='+tdydate+' group by ivydsd__Resource__c';
  return new AggregateResultIterable(query);
  } 
  // The batch job executes and operates on one batch of records
  global void execute(Database.BatchableContext bc, List<AggregateResult> Ordersbyreprecs){ 
      system.debug('Ordersbyreprecs'+Ordersbyreprecs);
      date todayDate= date.today();
        date strtdate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
      
       List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c,Parameter_type__c,Month__c from Target_Actual__c 
                                                                            where  Month__c=:date.today().month()
                                                                            AND Parameter_type__c='Avg No Of Orders'];
        System.debug('targets:: '+targets);
     
  Map<id,decimal> resIdValueMap = new Map<id,decimal>();
          if(Ordersbyreprecs.size()>0){  
            for(AggregateResult agg:Ordersbyreprecs){
                if((id)agg.get('rs')!=null){
                   resIdValueMap.put((id)agg.get('rs'),(decimal)agg.get('cnt')); 
                }
            }
        }
      CalculateDaysDiffExcludingHoliday numberofdays= new CalculateDaysDiffExcludingHoliday();
        decimal numberDaysDue = decimal.valueof(numberofdays.CalculateWorkingDays(strtdate,todayDate));
        system.debug('numberDaysDue'+numberDaysDue);
        System.debug('resIdValueMap::'+resIdValueMap);
      for(Target_Actual__c targetactual:targets){
          if(resIdValueMap.keyset().contains(targetactual.Resource__c)){
              if(resIdValueMap.get(targetactual.Resource__c)!=null){
                  decimal tarActual=(resIdValueMap.get(targetactual.Resource__c))/numberDaysDue;
                 targetactual.Actual__c= tarActual.setScale(2) ; 
              }
            
          }
      }
   update targets;
  }
  // The batch job finishes
  global void finish(Database.BatchableContext bc){
      Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('VisitsPerRepPerDayBatch') && vMapNameCustomSett.get('VisitsPerRepPerDayBatch').SwitchOff__c==false){
           VisitsPerRepPerDayBatch batch = new VisitsPerRepPerDayBatch();
           Database.executeBatch(batch);
        }
      
  }
}