/**Last edited by Pranav @03-05-2019**/

global class VisitsPerRepPerDayBatch implements Database.Batchable<AggregateResult> ,Database.stateful {
    // The batch job starts
    // global  Date Monthtodate;
    // global Date todayDate;
    
    global Iterable<AggregateResult> start(Database.BatchableContext bc){
        
        Date todayDate = date.Today();
        string tdydate=string.valueOf(todayDate);
        Date Monthtodate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        string mtdate=string.valueOf(Monthtodate);
        system.debug('todayDate'+todayDate);
        system.debug('Monthtodate'+Monthtodate);//2018-09-01
        string query='select count(id) cnt,ivybase__Resource__c rs from ivybase__Visit__c where ivybase__Visit_Date__c>='+mtdate+' AND ivybase__Visit_Date__c<='+tdydate+'  AND ivybase__Status__c=\'Completed\' group by ivybase__Resource__c';
       
        return new AggregateResultIterable(query);
    } 
    // The batch job executes and operates on one batch of records
    global void execute(Database.BatchableContext bc, List<AggregateResult> visitsbyreprecs){ 
        system.debug('visitsbyreprecs'+visitsbyreprecs);
        date todayDate= date.today();
        date strtdate=Date.newInstance(todayDate.year(),todayDate.Month(),1);
        List<Target_Actual__c> targets =[Select id,Resource__c,Actual__c,Achievement__c,Month__c,Parameter_type__c from Target_Actual__c 
                                         where  Month__c=:date.today().month()
                                         AND Parameter_type__c='Avg No Of Visits'];
        system.debug('targets'+targets);
        Map<id,decimal> resIdValueMap = new Map<id,decimal>();
        if(visitsbyreprecs.size()>0){  
            for(AggregateResult agg:visitsbyreprecs){
                if((id)agg.get('rs')!=null){
                    resIdValueMap.put((id)agg.get('rs'),(decimal)agg.get('cnt')); 
                }
            }
        }
        system.debug('resIdValueMap'+resIdValueMap);
        CalculateDaysDiffExcludingHoliday numberofdays= new CalculateDaysDiffExcludingHoliday();
        decimal numberDaysDue = decimal.valueof(numberofdays.CalculateWorkingDays(strtdate,todayDate));
        system.debug('numberDaysDue'+numberDaysDue);
        for(Target_Actual__c targetactual:targets){
            if(resIdValueMap.keyset().contains(targetactual.Resource__c) ){
                if(resIdValueMap.get(targetactual.Resource__c)!=null){
                    decimal tarActual=(resIdValueMap.get(targetactual.Resource__c))/numberDaysDue;
                    system.debug('tarActual'+tarActual);
                    targetactual.Actual__c=  tarActual.setScale(2);
                }
            }
        }
        system.debug('targets'+targets);
        update targets;
    }
    // The batch job finishes
    global void finish(Database.BatchableContext bc){
        Map<String, Batch_SwitchOff__c> vMapNameCustomSett = Batch_SwitchOff__c.getAll();
        if(vMapNameCustomSett.containsKey('AverageTurnoverPerRepBatch') && vMapNameCustomSett.get('AverageTurnoverPerRepBatch').SwitchOff__c==false){
               AverageTurnoverPerRepBatch batch = new AverageTurnoverPerRepBatch();
        Database.executeBatch(batch); 
        }
    }
}