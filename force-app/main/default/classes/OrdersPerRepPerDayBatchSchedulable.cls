global class OrdersPerRepPerDayBatchSchedulable implements Schedulable{
   global void execute(SchedulableContext sc) {
      OrdersPerRepPerDayBatch b = new OrdersPerRepPerDayBatch(); 
      database.executebatch(b);
   }
}