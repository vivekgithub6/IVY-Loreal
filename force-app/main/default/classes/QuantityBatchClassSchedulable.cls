global class QuantityBatchClassSchedulable implements Schedulable {
   global void execute(SchedulableContext sc) {
      QuantityBatchClass b = new QuantityBatchClass(); 
      database.executebatch(b);
   }
}