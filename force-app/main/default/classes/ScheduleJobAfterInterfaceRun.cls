global class ScheduleJobAfterInterfaceRun implements Schedulable {
    public Set<string> countryCode=new Set<string>() ;
    public ScheduleJobAfterInterfaceRun(set<String> code)
    {
        countryCode.addAll(code);
    }
    global void execute(SchedulableContext SC) {
        HandlingInactivatedRecordsInAccountBatch acntBtch = new HandlingInactivatedRecordsInAccountBatch(countryCode);
        database.executeBatch(acntBtch);
        system.debug('scheduled');
    }
}