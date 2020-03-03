global class SalesTargetCalculatingBatchSchedulable implements Schedulable {
   global void execute(SchedulableContext sc) {
      SalesTargetCalculatingBatch b = new SalesTargetCalculatingBatch(); 
      database.executebatch(b);
   }
}