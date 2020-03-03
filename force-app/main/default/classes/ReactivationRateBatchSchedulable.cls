global class ReactivationRateBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        ReactivationRateBatch b = new ReactivationRateBatch(); 
        database.executebatch(b);
    }

}