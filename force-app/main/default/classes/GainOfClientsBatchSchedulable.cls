global class GainOfClientsBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        GainOfClientsBatch b = new GainOfClientsBatch(); 
        database.executebatch(b);
    }

}