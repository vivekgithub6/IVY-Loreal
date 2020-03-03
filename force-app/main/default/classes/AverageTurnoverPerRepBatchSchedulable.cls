global class AverageTurnoverPerRepBatchSchedulable implements Schedulable {
    global void execute(SchedulableContext sc) {
        AverageTurnoverPerRepBatch b = new AverageTurnoverPerRepBatch(); 
        database.executebatch(b);
    }
    
}