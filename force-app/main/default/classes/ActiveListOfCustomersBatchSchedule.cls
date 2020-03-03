global class ActiveListOfCustomersBatchSchedule implements Schedulable{
    global void execute(SchedulableContext sc) {
        ActiveListOfCustomersBatch b = new ActiveListOfCustomersBatch(); 
        database.executebatch(b);
    }


}