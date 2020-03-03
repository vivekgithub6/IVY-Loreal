global class AverageTurnOverPerClientBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        AverageTurnOverPerClientBatch b = new AverageTurnOverPerClientBatch(); 
        database.executebatch(b);
    }
    
}