global class MonthActivationRateBatchSchedulable implements Schedulable{
    global void execute(SchedulableContext sc) {
        MonthActivationRateBatch b = new MonthActivationRateBatch(); 
        database.executebatch(b);
    }

}