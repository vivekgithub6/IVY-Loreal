global class LossOfClientsBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        LossOfClientsBatch b = new LossOfClientsBatch(); 
        database.executebatch(b);
    }

}