global class VisitsPerRepPerDayBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        VisitsPerRepPerDayBatch b = new VisitsPerRepPerDayBatch(); 
        database.executebatch(b);
    }
    
}