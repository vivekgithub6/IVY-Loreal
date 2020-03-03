/**
 * This scheduler is used to delete the Pricing Stage 2 and Pricing Stage 3 Records from the System
*/
global class DeletePricingStageScheduler implements Schedulable {

    public Set<String> countryCodeSet = new Set<String>() ;
    public DeletePricingStageScheduler(Set<String> code)
    {
        countryCodeSet.addAll(code);
    }
    
    global void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchDeletePricingStage2(countryCodeSet), 10000);
   }
}